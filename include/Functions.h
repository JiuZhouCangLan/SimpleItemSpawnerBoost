#pragma once

#include "Common.h"
#include <thread>

namespace Papyrus::Functions
{
	void ProcessModReader(STATIC_ARGS, RE::TESObjectREFR* chestRef, std::vector<RE::TESObjectMISC*> tokenRef);

	void addItems(STATIC_ARGS, RE::TESObjectREFR* chestRef, std::string modName);

	std::vector<std::string> getValidModNames(STATIC_ARGS);

	void Bind(VM& a_vm);
}
