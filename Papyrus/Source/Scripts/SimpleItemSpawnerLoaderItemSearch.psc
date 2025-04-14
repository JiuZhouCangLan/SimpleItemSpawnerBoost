Scriptname SimpleItemSpawnerLoaderItemSearch extends Quest
import GameData

Form[] Property ItemsColection Auto Hidden
String[] Property ItemsColectionName Auto Hidden

SimpleItemSpawnerMCM Property SISMCM Auto

int finder

Function ItemsFindCollector(string Keystring, bool vbSpecificMod, bool vbLightPlugin, int intSpecificMod, int intFromInMod, int intToInMod)
	ItemsColection = new Form[128]
	ItemsColectionName = new string[128]
	finder = 0
	Debug.Notification("Started searching.")
		int iLc = 0
		int iLc2 = 0
		string ModNameZs
		int ModCount = intToInMod
		if vbLightPlugin
			if intToInMod > Game.GetLightModCount()
				ModCount = Game.GetLightModCount()
			Endif
		Else
			if intToInMod > Game.GetModCount()
				ModCount = Game.GetModCount()
			Endif
		Endif
		if vbSpecificMod
			if !vbLightPlugin
					ModNameZs = Game.GetModName(intSpecificMod)
					Checkforitem(ModNameZs, Keystring)
					Debug.Notification("Searched: " + ModNameZs)
					if finder > 127
						Return
					Endif
			Else
					ModNameZs = Game.GetLightModName(intSpecificMod)
					Checkforitem(ModNameZs, Keystring)
					Debug.Notification("Searched: " + ModNameZs)
					if finder > 127
						Return
					Endif	
			Endif
		Else
			if !vbLightPlugin
				while iLc + intFromInMod < ModCount
					ModNameZs = Game.GetModName(iLc+ intFromInMod)
					Checkforitem(ModNameZs, Keystring)
					Debug.Notification("Searched: " + ModNameZs)
					if finder > 127
						Return
					Endif
				iLc +=1
				EndWhile
			Else
				while iLc2 + intFromInMod < ModCount
					ModNameZs = Game.GetLightModName(iLc2 + intFromInMod)
					Checkforitem(ModNameZs, Keystring)
					Debug.Notification("Searched: " + ModNameZs)
					if finder > 127
						Return
					Endif
				iLc2 +=1
				EndWhile	
			Endif
		Endif
		Debug.Notification("Finished searching")
EndFunction	

Function Checkforitem(string PluginName, string Keystring)
	Keyword[] Keywords
	int i = 0
	Form[] Weapons = GetAllWeapons(PluginName, Keywords, ignoreTemplates = false, ignoreEnchantments = false)
	while i < Weapons.Length
		if stringUtil.Find(Weapons[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = Weapons[i]
			ItemsColectionName[finder] = Weapons[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
	i = 0
	Form[] Armors = GetAllArmor(PluginName, Keywords, ignoreTemplates = false, ignoreEnchantments = false)
	while i < Armors.Length
		if stringUtil.Find(Armors[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = Armors[i]
			ItemsColectionName[finder] = Armors[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
	i = 0
	Form[] Ammos = GetAllAmmo(PluginName, Keywords)
	while i < Ammos.Length
		if stringUtil.Find(Ammos[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = Ammos[i]
			ItemsColectionName[finder] = Ammos[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
	i = 0
	Form[] Books = GetAllBooks(PluginName, Keywords, spell = true, skill = true)
	while i < Books.Length
		if stringUtil.Find(Books[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = Books[i]
			ItemsColectionName[finder] = Books[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
	i = 0
	Form[] Potions = GetAllPotions(PluginName, Keywords, food = true, poison = true)
	while i < Potions.Length
		if stringUtil.Find(Potions[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = Potions[i]
			ItemsColectionName[finder] = Potions[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
	i = 0
	Form[] Ingedients = GetAllIngredients(PluginName, Keywords)
	while i < Ingedients.Length
		if stringUtil.Find(Ingedients[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = Ingedients[i]
			ItemsColectionName[finder] = Ingedients[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
	i = 0
	Form[] Scrolls = GetAllScrolls(PluginName, Keywords)
	while i < Scrolls.Length
		if stringUtil.Find(Scrolls[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = Scrolls[i]
			ItemsColectionName[finder] = Scrolls[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
	i = 0
	Form[] Keys = GetAllKeys(PluginName, Keywords)
	while i < Keys.Length
		if stringUtil.Find(Keys[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = Keys[i]
			ItemsColectionName[finder] = Keys[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
	i = 0
	Form[] MiscItems = GetAllMiscItems(PluginName, Keywords)
	while i < MiscItems.Length
		if stringUtil.Find(MiscItems[i].GetName() ,Keystring) >= 0
			ItemsColection[finder] = MiscItems[i]
			ItemsColectionName[finder] = MiscItems[i].GetName()
			finder += 1
			if finder > 127
				Return
			Endif
		Endif
		i += 1
	EndWhile
EndFunction
