#include "Functions.h"

#define CHECK_FORM()

using namespace RE;

namespace Papyrus::Functions
{
	static std::vector<std::string_view>                              SortedMods;
	static std::unordered_set<std::string_view>                       CachedMods;
	static std::unordered_map<std::string, std::vector<RE::TESForm*>> CachedItems;  // pluginName, items
	static std::unordered_map<std::string_view, TESForm*>             CoinMap;      // pluginName, CoinForm

	std::string tolower(std::string_view str)
	{
		std::string lowerString(str);

		std::transform(lowerString.begin(), lowerString.end(), lowerString.begin(),
			[](unsigned char c) { return std::tolower(c); });
		return lowerString;
	}

	template <class T>
	void loadItems(RE::TESDataHandler* a_data)
	{
		for (RE::TESForm* form : a_data->GetFormArray<T>()) {
			if (form->GetFormFlags() & TESForm::RecordFlags::kPlayable)
			{
				continue;
			}

			const RE::TESFile* mod = form->GetFile(0);
			if (!mod)
				continue;

			const auto modName = mod->GetFilename();

			CachedItems[tolower(modName)].push_back(form);
			CachedMods.insert(modName);
		}
	}

	void init()
	{
		static std::once_flag flag;
		std::call_once(flag, []() {
			const auto begin = std::chrono::high_resolution_clock::now();
			auto       dataHandler = RE::TESDataHandler::GetSingleton();
			loadItems<RE::TESObjectARMO>(dataHandler);
			loadItems<RE::TESObjectBOOK>(dataHandler);
			loadItems<RE::TESObjectWEAP>(dataHandler);
			loadItems<RE::TESObjectMISC>(dataHandler);
			loadItems<RE::TESAmmo>(dataHandler);
			loadItems<RE::AlchemyItem>(dataHandler);
			loadItems<RE::IngredientItem>(dataHandler);
			loadItems<RE::TESKey>(dataHandler);
			loadItems<RE::ScrollItem>(dataHandler);

			// remove SimpleItemSpawner.esp
			CachedMods.erase("SimpleItemSpawner.esp");
			CachedItems.erase(tolower("SimpleItemSpawner.esp"sv));

			SortedMods = std::vector<std::string_view>(CachedMods.begin(), CachedMods.end());
			std::sort(SortedMods.begin(), SortedMods.end(), [](const std::string_view& e1, const std::string_view& e2) -> bool {
				const static std::unordered_map<std::string_view, int> mainAndDlc = {
					{ "Skyrim.esm"sv, 0 },
					{ "Update.esm"sv, 1 },
					{ "Dawnguard.esm"sv, 2 },
					{ "HearthFires.esm"sv, 3 },
					{ "Dragonborn.esm"sv, 4 }
				};
				const auto it1 = mainAndDlc.find(e1);
				const auto it2 = mainAndDlc.find(e2);
				const auto index1 = it1 == mainAndDlc.end() ? 9999 : it1->second;
				const auto index2 = it2 == mainAndDlc.end() ? 9999 : it2->second;
				return index1 < index2;
			});

			const auto end = std::chrono::high_resolution_clock::now();
			logger::info("init finish in {} us", (end - begin).count() / 1000);
		});
	}

	void addItem(TESObjectREFR* container, TESForm* form, const int32_t count = 1, const std::string& rename = "")
	{
		if (container == nullptr) {
			logger::error("{}: container is null", __FUNCTION__);
			return;
		}
		if (form == nullptr) {
			logger::error("{}: form is null", __FUNCTION__);
			return;
		}

		auto* inventoryChanges = container->GetInventoryChanges();
		if (inventoryChanges == nullptr) {
			logger::error("invalid inventoryChanges");
			return;
		}

		const auto obj = form->As<TESBoundObject>();
		if (obj == nullptr) {
			logger::error("{}: convert to BoundObject fail", __FUNCTION__);
			return;
		}
		auto entryData = new InventoryEntryData(obj, count);
		if (!rename.empty()) {
			auto* extraDataList = new ExtraDataList();
			auto* displayData = new ExtraTextDisplayData();
			displayData->SetName(rename.c_str());
			extraDataList->Add(displayData);
			entryData->AddExtraList(extraDataList);
		}
		inventoryChanges->AddEntryData(entryData);
	}

	void addPluginItem(RE::TESObjectREFR* chestRef, TESForm* baseForm, const std::string_view& name)
	{
		TESForm* pluginForm = nullptr;

		const auto iterator = CoinMap.find(name);
		if (iterator != CoinMap.end()) {
			pluginForm = iterator->second;
		} else {
			pluginForm = baseForm->CreateDuplicateForm(false, nullptr);
			if (!pluginForm) {
				logger::info("Failed to create new plugin item.");
				return;
			}
			auto fullName = pluginForm->As<TESFullName>();
			fullName->SetFullName(std::string(name).c_str());
			TESDataHandler::GetSingleton()->AddFormToDataHandler(pluginForm);
			CoinMap[name] = pluginForm;
		}

		addItem(chestRef, pluginForm);
	}

	void addItemTask(RE::TESObjectREFR* chestRef, const std::vector<TESForm*>& items, size_t begin, size_t end)
	{
		for (size_t i = begin; i < end; ++i) {
			addItem(chestRef, items.at(i));
		}
	}

	void addItems(STATIC_ARGS, RE::TESObjectREFR* chestRef, std::string modName)
	{
		constexpr auto   threadCount = 16;
		constexpr size_t minBlockSize = 128;

		const auto iterator = CachedItems.find(tolower(modName));
		if (iterator == CachedItems.end()) {
			logger::warn("no items in {}", modName);
			return;
		}
		auto& items = iterator->second;

		std::vector<std::thread> threads;
		const auto               itemCount = items.size();
		size_t                   blockSize = std::max(minBlockSize, itemCount / threadCount);
		for (size_t i = 0; i < itemCount; i += blockSize) {
			size_t blockEnd = std::min(i + blockSize, itemCount);
			threads.push_back(std::thread(addItemTask, chestRef, items, i, blockEnd));
		}

		for (auto& thread : threads) {
			thread.join();
		}
	}

	void addPlugins(STATIC_ARGS, RE::TESObjectREFR* chestRef, int ignoreCount)
	{
		init();

		size_t index = ignoreCount;
		auto*  pluginCoin = TESForm::LookupByEditorID("000ItemSpawnerCoin");
		if (pluginCoin == nullptr) {
			logger::error("can not find placeholder coin, Native EditorID Fix may not install");
			return;
		}
		for (const size_t count = SortedMods.size(); index < count; ++index) {
			addPluginItem(chestRef, pluginCoin, SortedMods.at(index));
		}
	}

	void Bind(VM& a_vm)
	{
		BIND(addPlugins);
		BIND(addItems);

		logger::info("{} Registered functions"sv, Version::PROJECT);
	}
}
