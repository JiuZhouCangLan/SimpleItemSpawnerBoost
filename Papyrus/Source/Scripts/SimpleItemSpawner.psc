Scriptname SimpleItemSpawner Extends ActiveMagicEffect
Import GameData
import JZCL_SISQFunctions

ObjectReference Property Chest Auto
MiscObject[] Property ItemSpawnerCoin Auto
SimpleItemSpawnerQuest Property SISQ Auto
SimpleItemSpawnerMCM Property SMISMCM Auto

Event OnEffectStart(Actor akTarget, Actor akCaster)
	ModReader()
EndEvent

Function ModReader()
	Chest.RemoveAllItems()
	addPlugins(Chest, SMISMCM.WithDLC)
EndFunction



