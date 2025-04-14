Scriptname SimpleItemSpawnerOpen Extends ActiveMagicEffect

ObjectReference Property Chest Auto
Event OnEffectStart(Actor akTarget, Actor akCaster)
	Chest.activate(game.GetPlayer())
EndEvent