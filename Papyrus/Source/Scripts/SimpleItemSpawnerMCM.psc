Scriptname SimpleItemSpawnerMCM Extends SKI_ConfigBase

Event OnConfigInit()
	Reinitilase()
EndEvent

State STFixMCM
	Event OnSelectST()
		Reinitilase()
	EndEvent
	Event OnHighlightST()
		SetInfoText("Click if not all pages are shown")
	EndEvent
EndState

Function Reinitilase()
	Pages = new String[2]
	Pages[0] = "Item Spawner"
	Pages[1] = "Searchpage"
	
	Player = Game.GetPlayer()
EndFunction

actor Player
Spell Property OpenContainer Auto
int PlayerSpell
int OpenMenu
int WithDLCToggle
int ShowAllPlug

int KeyCodeSET
int Property MultipleItems = 1 Auto Hidden
int Property MultipleItemsNotCons = 1 Auto Hidden
int Property FixDeactiveESP = 0 Auto Hidden
int Property WithDLC = 5 Auto Hidden

Event onPageReset(string page)
	if page == ""  || CurrentPage == "Item Spawner"
		StartPage()
	elseif page == "Searchpage"	
		ItemsSearchSide()
	Endif
EndEvent

Function StartPage()
		PlayerSpell = AddToggleOption("Add spell ", Player.HasSpell(OpenContainer))
		OpenMenu = AddTextOption("Open the mod overview after closing all menus", "")
		AddKeyMapOptionST("PushOption", "On push of a key", KeyCodeSET)
		AddEmptyOption()
		AddEmptyOption()
		AddEmptyOption()
		AddSliderOptionST("ItemMultiplyer", "Multiple Items for consumables", MultipleItems)
		AddSliderOptionST("ItemMultiplyerNotCons", "Multiple Items for non consumables", MultipleItemsNotCons)
		AddEmptyOption()
		AddEmptyOption()
		ADDTextOption("Fixes for issues:", "")
		AddEmptyOption()
		AddSliderOptionST("FixESPDeactive", "Fixes wrong esp itemload", FixDeactiveESP)
		if WithDLC == 5
			WithDLCToggle = AddToggleOption("Show DLC and main .esm", false)
		Else
			WithDLCToggle = AddToggleOption("Show DLC and main .esm", true)
		Endif	
		ShowAllPlug = AddToggleOption("Show all plugins", SISQ.ShowAll)
		AddTextOptionST("STFixMCM", "Reset MCM Pages", "")
		AddEmptyOption()
		AddEmptyOption()
		AddTextOption("Search function options:", "")
		AddEmptyOption()
		AddToggleOptionST("STSOLight","Light Plugins",vbLightPlugin)
		AddToggleOptionST("STSOonlyOne","Only on specific plugin",vbSpecificMod)
		if vbSpecificMod
			AddSliderOptionST("SOintSpecificMod", "Plugin Index: ", intSpecificMod)
			if vbLightPlugin
				AddTextOption(Game.GetLightModName(intSpecificMod), "")
			Else
				AddTextOption(Game.GetModName(intSpecificMod), "")
			Endif
		Else
			AddSliderOptionST("SOintFromInMod", "From Index: ", intFromInMod)
			AddSliderOptionST("SOintToInMod", "To Index: ", intToInMod)
			AddTextOption("Only coose a few or it takes way to long to search", "")
		Endif
EndFunction

Event OnOptionSelect(int option)
	if CurrentPage == "" || CurrentPage == "Item Spawner"	
		if option == PlayerSpell
			if !Player.HasSpell(OpenContainer)
				Player.AddSpell(OpenContainer)
				SetToggleOptionValue(PlayerSpell, true)
			Else
				Player.RemoveSpell(OpenContainer)
				SetToggleOptionValue(PlayerSpell, false)
			Endif
		Elseif option == OpenMenu
			Player.DoCombatSpellApply(OpenContainer, player)
		elseif option == WithDLCToggle
			if WithDLC == 5
				WithDLC = 0
				SetToggleOptionValue(WithDLCToggle, true)
				SISQ.ModReader(Game.GetPlayer())
			Else
				WithDLC = 5
				SetToggleOptionValue(WithDLCToggle, false)
				SISQ.ModReader(Game.GetPlayer())
			Endif
		elseif option == ShowAllPlug
			if SISQ.ShowAll
				SISQ.ShowAll = false
				SISQ.ModReader(Game.GetPlayer())
			Else
				SISQ.ShowAll = true
				SISQ.ModReader(Game.GetPlayer())
			Endif
			SetToggleOptionValue(ShowAllPlug, SISQ.ShowAll)
		Endif
	elseif CurrentPage == "Searchpage"	
		if option == Searcher
			Chest.RemoveAllItems()
		Else
			CheckItemSelection(option)
		Endif
	Endif
EndEvent

SimpleItemSpawnerQuest Property SISQ Auto
event OnKeyMapChangeST(int a_keyCode, string a_conflictControl, string a_conflictName)
	KeyCodeSET = a_keyCode
	SetKeyMapOptionValueST(KeyCodeSET, a_stateName = "PushOption")
	SISQ.RegisterforKeyMenu(KeyCodeSET)
EndEvent


state ItemMultiplyer ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 999)
		SetSliderDialogStartValue(MultipleItems)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		MultipleItems = value as int
		SetSliderOptionValueST(MultipleItems)		
	endEvent

	event OnDefaultST()
		MultipleItems = 1
		SetSliderOptionValueST(MultipleItems)
	endEvent

	event OnHighlightST()
		SetInfoText("A slider to set the itemcount for ammo, incrediants, potions and scrolls")
	endEvent
endState

state ItemMultiplyerNotCons ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogDefaultValue(1)
		SetSliderDialogRange(1, 999)
		SetSliderDialogStartValue(MultipleItemsNotCons)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		MultipleItemsNotCons = value as int
		SetSliderOptionValueST(MultipleItemsNotCons)		
	endEvent

	event OnDefaultST()
		MultipleItemsNotCons = 1
		SetSliderOptionValueST(MultipleItemsNotCons)
	endEvent

	event OnHighlightST()
		SetInfoText("A slider to set the itemcount for armors, weapons, books and clutter")
	endEvent
endState

state FixESPDeactive ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogDefaultValue(0)
		SetSliderDialogRange(0, 999)
		SetSliderDialogStartValue(FixDeactiveESP)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		FixDeactiveESP = value as int
		SetSliderOptionValueST(FixDeactiveESP)		
	endEvent

	event OnDefaultST()
		FixDeactiveESP = 1
		SetSliderOptionValueST(FixDeactiveESP)
	endEvent

	event OnHighlightST()
		SetInfoText("A slider to fix the wrong items, if you don't have a problem leave it at 0")
	endEvent
endState

bool OpenUpContainer
int Searcher
SimpleItemSpawnerLoaderItemSearch Property SISLIS Auto

Function ItemsSearchSide()
	OpenUpContainer = false
	AddinputOptionST("ItemsSearchField", "Search:", "")
	Searcher = ADDTextOption("Clear Container", "Click me")
	RefreshSearchPage()
EndFunction

state ItemsSearchField
	event oninputacceptST(string value)
		setinputOptionValueST(value)
		AddTextOption("You can exit the menus now.", "")
		SetInfoText("Exit and look in the left upper corner for status")
		SISLIS.ItemsFindCollector(value, vbSpecificMod, vbLightPlugin, intSpecificMod, intFromInMod, intToInMod)
		ForcePageReset()
	EndEvent
EndState

int[] ItemSelectionTrigger
Function RefreshSearchPage()
	int i = 0
	ItemSelectionTrigger = new int [128]
	while SISLIS.ItemsColectionName[i] != ""
		ItemSelectionTrigger[i] = AddTextOption(SISLIS.ItemsColectionName[i],"")
		i +=1
	endwhile
EndFunction

ObjectReference Property Chest Auto
Function CheckItemSelection(int Option)
	int i = 0
	while SISLIS.ItemsColectionName[i] != ""
		if ItemSelectionTrigger[i] == Option 
			chest.Additem(SISLIS.ItemsColection[i])
			if !OpenUpContainer
				chest.Activate(Game.getplayer())
			Endif
		Endif
		i +=1
	endwhile
EndFunction

bool Property vbLightPlugin = true Auto Hidden
State STSOLight
	event OnSelectST()
		vbLightPlugin = !vbLightPlugin
		SetToggleOptionValueST(vbLightPlugin, true, "STSOLight")
		ForcePageReset()
	EndEvent

	event OnHighlightST()
		SetInfoText("Toggle option to search throw light or normal plugins")
	EndEvent
EndState

bool Property vbSpecificMod = true Auto Hidden
State STSOonlyOne
	event OnSelectST()
		vbSpecificMod = !vbSpecificMod
		SetToggleOptionValueST(vbSpecificMod, true, "STSOonlyOne")
		ForcePageReset()
	EndEvent

	event OnHighlightST()
		SetInfoText("Toggle option to search throw only a Specific Plugin")
	EndEvent
EndState

int Property intSpecificMod = 1 Auto Hidden
state SOintSpecificMod ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogDefaultValue(1)
		if vbLightPlugin
			SetSliderDialogRange(0, 4096)
		Else
			SetSliderDialogRange(0, 255)
		Endif
		SetSliderDialogStartValue(intSpecificMod)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		intSpecificMod = value as int
		SetSliderOptionValueST(intSpecificMod)		
		ForcePageReset()
	endEvent

	event OnDefaultST()
		intSpecificMod = 1
		SetSliderOptionValueST(intSpecificMod)
	endEvent

	event OnHighlightST()
		SetInfoText("Index in your loadorder of the plugin")
	endEvent
endState

int Property intFromInMod = 10 Auto Hidden
state SOintFromInMod ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogDefaultValue(1)
		if vbLightPlugin
			SetSliderDialogRange(0, 4096)
		Else
			SetSliderDialogRange(0, 255)
		Endif
		SetSliderDialogStartValue(intFromInMod)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		intFromInMod = value as int
		SetSliderOptionValueST(intFromInMod)		
	endEvent

	event OnDefaultST()
		intFromInMod = 1
		SetSliderOptionValueST(intFromInMod)
	endEvent

	event OnHighlightST()
		SetInfoText("Index in your loadorder of the plugin")
	endEvent
endState

int Property intToInMod = 15 Auto Hidden
state SOintToInMod ; SLIDER
	event OnSliderOpenST()
		SetSliderDialogDefaultValue(1)
		if vbLightPlugin
			SetSliderDialogRange(0, 4096)
		Else
			SetSliderDialogRange(0, 255)
		Endif
		SetSliderDialogStartValue(intToInMod)
		SetSliderDialogInterval(1)
	endEvent

	event OnSliderAcceptST(float value)
		intToInMod = value as int
		SetSliderOptionValueST(intToInMod)		
	endEvent

	event OnDefaultST()
		intToInMod = 1
		SetSliderOptionValueST(intToInMod)
	endEvent

	event OnHighlightST()
		SetInfoText("Index in your loadorder of the plugin")
	endEvent
endState
