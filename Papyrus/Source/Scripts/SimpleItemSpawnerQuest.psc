Scriptname SimpleItemSpawnerQuest Extends Quest
import GameData

Bool Property ShowAll Auto Hidden

Spell Property ItemCollectorspell Auto
ObjectReference Property Chest Auto

Function ModReader(actor Player)
	Game.GetPlayer().Removespell(ItemCollectorspell)
	Player.DoCombatSpellApply(ItemCollectorspell, player)
	if KeyCodeSET != 0
		RegisterForKey(KeyCodeSET)
	Endif
EndFunction

int KeyCodeSET
Spell Property OpenContainer Auto
Function RegisterforKeyMenu(int KeyCode)
	UnregisterForKey(KeyCodeSET)
	KeyCodeSET = KeyCode
	RegisterForKey(KeyCodeSET)
Endfunction

Event OnKeyDown(Int KeyCode)
	If KeyCode == KeyCodeSET
		Game.GetPlayer().DoCombatSpellApply(OpenContainer, Game.GetPlayer())
	EndIf
EndEvent


