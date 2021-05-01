#Include <ClassMemory>

GetActivePlayers()
{
	Game := new _ClassMemory("ahk_exe DarkSoulsIII.exe", "", hProcessCopy)
	if(!isObject(Game))
		Return 0
		
	BaseB := Game.BaseAddress + 0x4768E78

	ActivePlayers := []
	For Index, Offset in [0x38,0x70,0xA8,0xE0,0x118]
	{
		if(Game.Read(BaseB,"Int",0x40,Offset,0x1FA0,0x70))
		{
			PlayerCount += 1
			ActivePlayers[PlayerCount] := A_Index
		}
	}
	
    Game := ""

	if(ActivePlayers[1])
		Return ActivePlayers
	
	Return 0
}