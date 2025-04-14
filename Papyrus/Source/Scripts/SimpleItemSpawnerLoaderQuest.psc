Scriptname SimpleItemSpawnerLoaderQuest extends Quest

SimpleItemSpawnerQuest Property SISQ Auto
Event oninit()
	SISQ.ModReader(Game.GetPlayer())
Endevent

ObjectReference Property Chest Auto
Function FinishedProcess()
	Chest.Activate(Game.GetPlayer())
EndFunction
