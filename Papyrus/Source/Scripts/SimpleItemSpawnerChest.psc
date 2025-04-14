Scriptname SimpleItemSpawnerChest Extends ObjectReference
Import GameData
import JZCL_SISQFunctions

ObjectReference Property Chest Auto
Event OnItemRemoved(Form akBaseItem, int aiItemCount, ObjectReference akItemReference, ObjectReference akDestContainer)
	if akDestContainer as actor == Game.GetPlayer()
		Chest.RemoveAllItems()
		Input.TapKey(1)
		Game.GetPlayer().RemoveItem(akBaseItem, aiItemCount, true, self)
		ItemPickup(akBaseItem.GetName())
	Endif
EndEvent

SimpleItemSpawnerMCM Property SMISMCM Auto
SimpleItemSpawnerLoaderQuest Property SMISQ Auto
Function ItemPickup(string PluginName)
	Debug.Notification(PluginName)
	addItems(Chest, PluginName)
	
	SMISQ.FinishedProcess()
EndFunction
