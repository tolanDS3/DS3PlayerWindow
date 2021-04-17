; DS3PlayerWindow v1.0

#NoEnv
#SingleInstance Force
#Include .\Include\ClassMemory.ahk

SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Global ActivePlayers := 0
Global Player := []
Loop,5
	Player[A_Index] := {}
Global GUIImageList := []
Global FlagImageList := []
Loop,5
	GUIImageList[A_Index] := A_ScriptDir . "\Images\Profile Pictures\Default.jpg"
Global SteamHTML := []
Global ImagePath := []
Global FlagPath := []
Global ItemName := []
Loop,Read,Items.dat
	ItemName[StrSplit(A_LoopReadLine,A_Tab)[1]] := StrSplit(A_LoopReadLine,A_Tab)[2]

Menu Tray, Icon, .\Images\DS3PlayerWindow.ico

Gui Color, 0x000000
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui Add, Picture, gClickPic1 vPic1 x8 y8 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, gClickPic2 vPic2 x8 y88 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, gClickPic3 vPic3 x8 y168 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, gClickPic4 vPic4 x8 y248 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, gClickPic5 vPic5 x8 y328 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Font, s14 c0xFFFFFF, Calibri
Gui Add, Text, gDragwin vName1 x80 y8 w152 h20 +0x200, Player 1
Gui Add, Text, gDragwin vName2 x80 y88 w152 h20 +0x200, Player 2
Gui Add, Text, gDragwin vName3 x80 y168 w152 h20 +0x200, Player 3
Gui Add, Text, gDragwin vName4 x80 y248 w152 h20 +0x200, Player 4
Gui Add, Text, gDragwin vName5 x80 y328 w152 h20 +0x200, Player 5
Gui Add, Progress, vBar1 x80 y57 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33
Gui Add, Progress, vBar2 x80 y137 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33
Gui Add, Progress, vBar3 x80 y217 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33
Gui Add, Progress, vBar4 x80 y297 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33d
Gui Add, Progress, vBar5 x80 y377 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33
Gui Font, s12 c0xFFFFFF
Gui Add, Text, vSteam1 x80 y30 w312 h20 +0x200, Steam 1
Gui Add, Text, vSteam2 x80 y110 w312 h20 +0x200, Steam 2
Gui Add, Text, vSteam3 x80 y190 w312 h20 +0x200, Steam 3
Gui Add, Text, vSteam4 x80 y270 w312 h20 +0x200, Steam 4
Gui Add, Text, vSteam5 x80 y350 w312 h20 +0x200, Steam 5
Gui Font, s12 c0xFFFFFF, Calibri
Gui Add, Text, vLevel1 x240 y8 w152 h20 +0x200 +0x2, Lv.1
Gui Add, Text, vLevel2 x240 y88 w152 h20 +0x200 +0x2, Lv.1
Gui Add, Text, vLevel3 x240 y168 w152 h20 +0x200 +0x2, Lv.1
Gui Add, Text, vLevel4 x240 y248 w152 h20 +0x200 +0x2, Lv.1
Gui Add, Text, vLevel5 x240 y328 w152 h20 +0x200 +0x2, Lv.1

Gui Font, s8 c0xFFFFFF, Calibri
Gui Add, Text, vHP1 x80 y57 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000
Gui Add, Text, vHP2 x80 y137 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000
Gui Add, Text, vHP3 x80 y217 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000
Gui Add, Text, vHP4 x80 y297 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000
Gui Add, Text, vHP5 x80 y377 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000

;;;;;
Gui Add, Picture, vFlag1 x374 y35 w16 h11 +0x2
Gui Add, Picture, vFlag2 x374 y115 w16 h11 +0x2
Gui Add, Picture, vFlag3 x374 y195 w16 h11 +0x2
Gui Add, Picture, vFlag4 x374 y275 w16 h11 +0x2
Gui Add, Picture, vFlag5 x374 y355 w16 h11 +0x2
;;;;

WinSet, Transparent, 200
Gui Show,x1520 y0 w400 h80 NoActivate

SetTimer,UpdateOSD,16
Gosub,UpdateOSD
Return

ClickPic1:
	ShowWinInfo(1)
Return

ClickPic2:
	ShowWinInfo(2)
Return

ClickPic3:
	ShowWinInfo(3)
Return

ClickPic4:
	ShowWinInfo(4)
Return

ClickPic5:
	ShowWinInfo(5)
Return

WinInfoGuiEscape:
	Gui,Destroy
Return

DragWin:
	PostMessage, 0xA1, 2,,, A
Return

UpdateOSD:
	
	;Tooltip,% Player[1].FlagURL . "`n" . Player[1].FlagPath
	
	if(!WinActive("DARK SOULS III"))
	{
		Gui,Show,Hide
		Return
	}

	Game := new _ClassMemory("ahk_exe DarkSoulsIII.exe", "", hProcessCopy)
	if(!isObject(Game))
	{
		Gui,Show,Hide
		Return
	}
			
	BaseB := Game.BaseAddress + 0x4768E78
	
	Player[1].Level := Game.Read(BaseB,"Int",0x40,0x38,0x1FA0,0x70)
	Player[2].Level := Game.Read(BaseB,"Int",0x40,0x70,0x1FA0,0x70)
	Player[3].Level := Game.Read(BaseB,"Int",0x40,0xA8,0x1FA0,0x70)
	Player[4].Level := Game.Read(BaseB,"Int",0x40,0xE0,0x1FA0,0x70)
	Player[5].Level := Game.Read(BaseB,"Int",0x40,0x118,0x1FA0,0x70)
	
	ActivePlayers := ""
	Loop,5
	{
		if(Player[A_Index].Level)
			ActivePlayers := ActivePlayers . A_Index . ","
	}
	if(ActivePlayers)
		ActivePlayers := SubStr(ActivePlayers,1,-1)
	else
	{
		Gui,Show,Hide
		Return
	}

	Player[1].Name := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0x38,0x1FA0,0x88)
	Player[2].Name := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0x70,0x1FA0,0x88)
	Player[3].Name := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0xA8,0x1FA0,0x88)
	Player[4].Name := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0xE0,0x1FA0,0x88)
	Player[5].Name := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0x118,0x1FA0,0x88)

	Player[1].HP := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x18)	
	Player[2].HP := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x18)
	Player[3].HP := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x18)	
	Player[4].HP := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x18)
	Player[5].HP := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x18)
	
	Player[1].HPMax := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x1C)	
	Player[2].HPMax := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x1C)
	Player[3].HPMax := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x1C)
	Player[4].HPMax := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x1C)
	Player[5].HPMax := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x1C)
	
	Player[1].FPMax := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x2C)
	Player[2].FPMax := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x2C)
	Player[3].FPMax := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x2C)
	Player[4].FPMax := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x2C)
	Player[5].FPMax := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x2C)

	Player[1].StaminaMax := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x3C)
	Player[2].StaminaMax := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x3C)
	Player[3].StaminaMax := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x3C)
	Player[4].StaminaMax := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x3C)
	Player[5].StaminaMax := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x3C)
	
	Player[1].SteamIDHex := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0x38,0x1FA0,0x7D8)
	Player[2].SteamIDHex := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0x70,0x1FA0,0x7D8)
	Player[3].SteamIDHex := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0xA8,0x1FA0,0x7D8)
	Player[4].SteamIDHex := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0xE0,0x1FA0,0x7D8)
	Player[5].SteamIDHex := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,0x118,0x1FA0,0x7D8)
	
	Player[1].SteamHTML := GetSteamHTML(Player[1].SteamIDHex)
	Player[2].SteamHTML := GetSteamHTML(Player[2].SteamIDHex)
	Player[3].SteamHTML := GetSteamHTML(Player[3].SteamIDHex)
	Player[4].SteamHTML := GetSteamHTML(Player[4].SteamIDHex)
	Player[5].SteamHTML := GetSteamHTML(Player[5].SteamIDHex)
	
	Player[1].SteamName := GetSteamName(Player[1].SteamHTML)
	Player[2].SteamName := GetSteamName(Player[2].SteamHTML)
	Player[3].SteamName := GetSteamName(Player[3].SteamHTML)
	Player[4].SteamName := GetSteamName(Player[4].SteamHTML)
	Player[5].SteamName := GetSteamName(Player[5].SteamHTML)
	
	Player[1].ImageURL := GetImageURL(Player[1].SteamHTML)
	Player[2].ImageURL := GetImageURL(Player[2].SteamHTML)
	Player[3].ImageURL := GetImageURL(Player[3].SteamHTML)
	Player[4].ImageURL := GetImageURL(Player[4].SteamHTML)
	Player[5].ImageURL := GetImageURL(Player[5].SteamHTML)
	
	Player[1].ImagePath := GetImagePath(Player[1].SteamIDHex,Player[1].ImageURL)
	Player[2].ImagePath := GetImagePath(Player[2].SteamIDHex,Player[2].ImageURL)
	Player[3].ImagePath := GetImagePath(Player[3].SteamIDHex,Player[3].ImageURL)
	Player[4].ImagePath := GetImagePath(Player[4].SteamIDHex,Player[4].ImageURL)
	Player[5].ImagePath := GetImagePath(Player[5].SteamIDHex,Player[5].ImageURL)
	
	Player[1].FlagURL := GetFlagURL(Player[1].SteamHTML)
	Player[2].FlagURL := GetFlagURL(Player[2].SteamHTML)	
	Player[3].FlagURL := GetFlagURL(Player[3].SteamHTML)
	Player[4].FlagURL := GetFlagURL(Player[4].SteamHTML)
	Player[5].FlagURL := GetFlagURL(Player[5].SteamHTML)	

	Player[1].FlagPath := GetFlagPath(Player[1].SteamIDHex,Player[1].FlagURL)
	Player[2].FlagPath := GetFlagPath(Player[2].SteamIDHex,Player[2].FlagURL)
	Player[3].FlagPath := GetFlagPath(Player[3].SteamIDHex,Player[3].FlagURL)
	Player[4].FlagPath := GetFlagPath(Player[4].SteamIDHex,Player[4].FlagURL)
	Player[5].FlagPath := GetFlagPath(Player[5].SteamIDHex,Player[5].FlagURL)	
	


	Player[1].Vigor := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x44)
	Player[2].Vigor := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x44)
	Player[3].Vigor := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x44)
	Player[4].Vigor := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x44)
	Player[5].Vigor := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x44)

	Player[1].Attunement := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x48)
	Player[2].Attunement := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x48)
	Player[3].Attunement := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x48)
	Player[4].Attunement := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x48)
	Player[5].Attunement := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x48)

	Player[1].Endurance := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x4C)
	Player[2].Endurance := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x4C)
	Player[3].Endurance := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x4C)
	Player[4].Endurance := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x4C)
	Player[5].Endurance := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x4C)

	Player[1].Vitality := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x6C)
	Player[2].Vitality := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x6C)
	Player[3].Vitality := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x6C)
	Player[4].Vitality := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x6C)
	Player[5].Vitality := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x6C)

	Player[1].Strength := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x50)
	Player[2].Strength := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x50)
	Player[3].Strength := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x50)
	Player[4].Strength := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x50)
	Player[5].Strength := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x50)

	Player[1].Luck := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x60)
	Player[2].Luck := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x60)
	Player[3].Luck := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x60)
	Player[4].Luck := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x60)
	Player[5].Luck := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x60)

	Player[1].Dexterity := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x54)
	Player[2].Dexterity := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x54)
	Player[3].Dexterity := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x54)
	Player[4].Dexterity := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x54)
	Player[5].Dexterity := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x54)

	Player[1].Intelligence := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x58)
	Player[2].Intelligence := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x58)
	Player[3].Intelligence := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x58)
	Player[4].Intelligence := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x58)
	Player[5].Intelligence := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x58)

	Player[1].Faith := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x5C)
	Player[2].Faith := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x5C)
	Player[3].Faith := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x5C)
	Player[4].Faith := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x5C)
	Player[5].Faith := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x5C)

	Player[1].RightHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x330))]
	Player[2].RightHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x330))]
	Player[3].RightHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x330))]
	Player[4].RightHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x330))]
	Player[5].RightHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x330))]

	Player[1].RightHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x338))]
	Player[2].RightHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x338))]
	Player[3].RightHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x338))]
	Player[4].RightHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x338))]
	Player[5].RightHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x338))]

	Player[1].RightHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x340))]
	Player[2].RightHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x340))]
	Player[3].RightHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x340))]
	Player[4].RightHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x340))]
	Player[5].RightHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x340))]

	Player[1].LeftHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x32C))]
	Player[2].LeftHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x32C))]
	Player[3].LeftHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x32C))]
	Player[4].LeftHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x32C))]
	Player[5].LeftHand1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x32C))]

	Player[1].LeftHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x334))]
	Player[2].LeftHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x334))]
	Player[3].LeftHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x334))]
	Player[4].LeftHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x334))]
	Player[5].LeftHand2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x334))]

	Player[1].LeftHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x33C))]
	Player[2].LeftHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x33C))]
	Player[3].LeftHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x33C))]
	Player[4].LeftHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x33C))]
	Player[5].LeftHand3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x33C))]

	Player[1].Chest := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x360))]
	Player[2].Chest := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x360))]
	Player[3].Chest := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x360))]
	Player[4].Chest := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x360))]
	Player[5].Chest := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x360))]

	Player[1].Hands := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x364))]
	Player[2].Hands := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x364))]
	Player[3].Hands := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x364))]
	Player[4].Hands := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x364))]
	Player[5].Hands := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x364))]

	Player[1].Legs := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x368))]
	Player[2].Legs := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x368))]
	Player[3].Legs := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x368))]
	Player[4].Legs := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x368))]
	Player[5].Legs := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x368))]
	



	Player[1].Head := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x35C))]
	Player[2].Head := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x35C))]
	Player[3].Head := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x35C))]
	Player[4].Head := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x35C))]
	Player[5].Head := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x35C))]


	Player[1].Ring1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x370))]
	Player[2].Ring1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x370))]
	Player[3].Ring1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x370))]
	Player[4].Ring1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x370))]
	Player[5].Ring1 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x370))]


	Player[1].Ring2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x374))]
	Player[2].Ring2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x374))]
	Player[3].Ring2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x374))]
	Player[4].Ring2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x374))]
	Player[5].Ring2 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x374))]
 
	Player[1].Ring3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x378))]
	Player[2].Ring3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x378))]
	Player[3].Ring3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x378))]
	Player[4].Ring3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x378))]
	Player[5].Ring3 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x378))]
 
 
	Player[1].Ring4 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0x37C))]
	Player[2].Ring4 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0x37C))]
	Player[3].Ring4 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0x37C))]
	Player[4].Ring4 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0x37C))]
	Player[5].Ring4 := ItemName[IntToHex(Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0x37C))]
 
	Player[1].TeamType := Game.read(BaseB,"Int",0x40,0x38,0x74)
	Player[2].TeamType := Game.read(BaseB,"Int",0x40,0x70,0x74)
	Player[3].TeamType := Game.read(BaseB,"Int",0x40,0xA8,0x74)
	Player[4].TeamType := Game.read(BaseB,"Int",0x40,0xE0,0x74)
	Player[5].TeamType := Game.read(BaseB,"Int",0x40,0x118,0x74)

	Player[1].Covenant := Game.read(BaseB,"Char",0x40,0x38,0x1FA0,0xF7)
	Player[2].Covenant := Game.read(BaseB,"Char",0x40,0x70,0x1FA0,0xF7) 
	Player[3].Covenant := Game.read(BaseB,"Char",0x40,0xA8,0x1FA0,0xF7) 
	Player[4].Covenant := Game.read(BaseB,"Char",0x40,0xE0,0x1FA0,0xF7) 
	Player[5].Covenant := Game.read(BaseB,"Char",0x40,0x118,0x1FA0,0xF7) 
 
	Player[1].MultiplayCount  := Game.read(BaseB,"Int",0x40,0x38,0x1FA0,0xB4)
	Player[2].MultiplayCount  := Game.read(BaseB,"Int",0x40,0x70,0x1FA0,0xB4)
	Player[3].MultiplayCount  := Game.read(BaseB,"Int",0x40,0xA8,0x1FA0,0xB4)
	Player[4].MultiplayCount  := Game.read(BaseB,"Int",0x40,0xE0,0x1FA0,0xB4)
	Player[5].MultiplayCount  := Game.read(BaseB,"Int",0x40,0x118,0x1FA0,0xB4)
	
	Loop,5
	{
		if(A_Index>StrSplit(ActivePlayers,",").MaxIndex())
			Break
		
		ActivePlayerNumber := StrSplit(ActivePlayers,",")[A_Index]
		
		if(Player[ActivePlayerNumber].FlagPath<>FlagImageList[A_Index])
		{
			GuiControl,-Redraw,Flag%A_Index%
			GuiControl,,Flag%A_Index%,% Player[ActivePlayerNumber].FlagPath
			FlagImageList[A_Index] := Player[ActivePlayerNumber].FlagPath
			GuiControl,Move,Flag%A_Index%,w16 h11
			GuiControl,+Redraw,Flag%A_Index%
		}
		
		
		
		if(Player[ActivePlayerNumber].ImagePath<>GUIImageList[A_Index])
		{
			GuiControl,-Redraw,Pic%A_Index%
			GuiControl,,Pic%A_Index%,% Player[ActivePlayerNumber].ImagePath
			GUIImageList[A_Index] := Player[ActivePlayerNumber].ImagePath
			GuiControl,Move,Pic%A_Index%,w64 h64
			GuiControl,+Redraw,Pic%A_Index%
		}

		GuiControlGet,Temp,,Name%A_Index%
		if(Player[ActivePlayerNumber].Name<>Temp)
		{
			GuiControl,-Redraw,Name%A_Index%
			; Set label color
			; Host
			if(Player[ActivePlayerNumber].TeamType=1 || Player[ActivePlayerNumber].TeamType=4)
				GuiControl,+c44FF00,Name%A_Index%
			
			; Phantom
			if(Player[ActivePlayerNumber].TeamType=2)
			{
				if(Player[ActivePlayerNumber].Covenant=1)
					GuiControl,+c0000FF,Name%A_Index%
				else if(Player[ActivePlayerNumber].Covenant=2)
					GuiControl,+cFFFF00,Name%A_Index%
				else if(Player[ActivePlayerNumber].Covenant=9)
					GuiControl,+cFFFF00,Name%A_Index%				
				else
					GuiControl,+cFFFFFF,Name%A_Index%
			}
	
			; Dark spirit
			if(Player[ActivePlayerNumber].TeamType=16)
			{
				; Dark sunbro
				if(Player[ActivePlayerNumber].Covenant=2)	
					GuiControl,+cFF7D00,Name%A_Index%
				else
					GuiControl,+cFF0000,Name%A_Index%
			}
			
			; Watchdog of Farron
			if(Player[ActivePlayerNumber].TeamType=17)
				GuiControl,+c7D19C8,Name%A_Index%			
			
			; Aldrich faithful
			if(Player[ActivePlayerNumber].TeamType=18)
				GuiControl,+c7D19C8,Name%A_Index%
				
			; Mad dark spirit
			if(Player[ActivePlayerNumber].TeamType=32)
				GuiControl,+cC864C8,Name%A_Index%

			GuiControl,,Name%A_Index%,% Player[ActivePlayerNumber].Name
			GuiControl,+Redraw,Name%A_Index%
		}
		
		GuiControlGet,Temp,,Steam%A_Index%
		if(Player[ActivePlayerNumber].SteamName<>Temp)
		{
			GuiControl,-Redraw,Steam%A_Index%
			GuiControl,,Steam%A_Index%,% Player[ActivePlayerNumber].SteamName
			GuiControl,+Redraw,Steam%A_Index%
		}
		

		;GuiControlGet,Temp,,Level%A_Index%
		;if(Player[ActivePlayerNumber].TeamType<>Temp)
		;{
		;	GuiControl,-Redraw,Level%A_Index%
		;	GuiControl,,Level%A_Index%,% Player[ActivePlayerNumber].TeamType . "," . Player[ActivePlayerNumber].Covenant
		;	GuiControl,+Redraw,Level%A_Index%
		;}		
		
		GuiControlGet,Temp,,Level%A_Index%
		if("Lv." . Player[ActivePlayerNumber].Level<>Temp)
		{
			GuiControl,-Redraw,Level%A_Index%
			GuiControl,,Level%A_Index%,% "Lv." . Player[ActivePlayerNumber].Level
			GuiControl,+Redraw,Level%A_Index%
		}

		;GuiControlGet,Temp,,Level%A_Index%
		;if(Player[ActivePlayerNumber].MultiplayCount<>Temp)
		;{
		;	GuiControl,-Redraw,Level%A_Index%
		;	GuiControl,,Level%A_Index%,% Player[ActivePlayerNumber].MultiplayCount
		;	GuiControl,+Redraw,Level%A_Index%
		;}
		
		GuiControlGet,Temp,,Bar%A_Index%
		if(Player[ActivePlayerNumber].HP<>Temp)
		{
			GuiControl,-Redraw,Bar%A_Index%
			Temp := Player[ActivePlayerNumber].HPMax
			GuiControl,+Range0-%Temp%,Bar%A_Index%
			GuiControl,,Bar%A_Index%,% Player[ActivePlayerNumber].HP
			GuiControl,+Redraw,Bar%A_Index%
		}
		
		GuiControlGet,Temp,,HP%A_Index%
		if(Player[ActivePlayerNumber].HP . " / " . Player[ActivePlayerNumber].HPMax <> Temp)
		{
			GuiControl,-Redraw,HP%A_Index%
			GuiControl,,HP%A_Index%,% Player[ActivePlayerNumber].HP . " / " . Player[ActivePlayerNumber].HPMax
			GuiControl,+Redraw,HP%A_Index%
		}		
		
		
	}
	
	WindowHeight := StrSplit(ActivePlayers,",").MaxIndex()*80
	if(WindowHeight=0)
		WindowHeight := 80
	;Gui Show,x1520 y0 w400 h%WindowHeight% NoActivate
	Gui Show,w400 h%WindowHeight% NoActivate
	
Return

HexToInt(Hex)
{
	if (InStr(Hex, "0x") != 1)
		Hex := "0x" Hex
	return, Hex + 0
}

IntToHex(Int)
{
    HEX_INT := 8
    while (HEX_INT--)
    {
        n := (int >> (HEX_INT * 4)) & 0xf
        h .= n > 9 ? chr(0x37 + n) : n
        if (HEX_INT == 0 && HEX_INT//2 == 0)
            h .= " "
    }
    h := StrReplace(h,A_Space)
	return h
}

ShowWinInfo(PlayerIndex)
{
	Global
	PlayerNum := StrSplit(ActivePlayers,",")[PlayerIndex]
	Gui WinInfo:New, +LastFound +AlwaysOnTop +ToolWindow
	Gui Add, Picture, x10 y10 w66 h66 0x6 +Border, % Player[PlayerNum].ImagePath
	Gui Font, s12 Bold, Calibri
	Gui Add, Text, x84 y10 w206 h20, % Player[PlayerNum].Name
	Gui Font
	Gui Font, s10, Calibri
	SteamName := Player[PlayerNum].SteamName
	SteamURL := "https://steamcommunity.com/profiles/" . HexToInt(Player[PlayerNum].SteamIDHex)
	Gui Add, Link, x84 y30 w206 h20, <a href="%SteamURL%">%SteamName%</a>
	Gui Add, Text, x84 y50 w206 h20, % "Lv." . Player[PlayerNum].Level
	Gui Add, Text, x10 y84 w280 h2 0x10
	Gui Add, Text, x10 y146 w135 h20, Vigor
	Gui Add, Text, x10 y166 w135 h20, Attunement
	Gui Add, Text, x10 y186 w135 h20, Endurance
	Gui Add, Text, x10 y206 w135 h20, Vitality
	Gui Add, Text, x10 y226 w135 h20, Luck
	Gui Add, Text, x145 y146 w135 h20, Strength
	Gui Add, Text, x145 y166 w135 h20, Dexterity
	Gui Add, Text, x145 y186 w135 h20, Intelligence
	Gui Add, Text, x145 y206 w135 h20, Faith
	Gui Add, Text, x110 y146 w25 h20 +Center, % Player[PlayerNum].Vigor
	Gui Add, Text, x110 y166 w25 h20 +Center, % Player[PlayerNum].Attunement
	Gui Add, Text, x110 y186 w25 h20 +Center, % Player[PlayerNum].Endurance
	Gui Add, Text, x110 y206 w25 h20 +Center, % Player[PlayerNum].Vitality
	Gui Add, Text, x110 y226 w25 h20 +Center, % Player[PlayerNum].Luck
	Gui Add, Text, x265 y146 w25 h20 +Center, % Player[PlayerNum].Strength
	Gui Add, Text, x265 y166 w25 h20 +Center, % Player[PlayerNum].Dexterity
	Gui Add, Text, x265 y186 w25 h20 +Center, % Player[PlayerNum].Intelligence
	Gui Add, Text, x265 y206 w25 h20 +Center, % Player[PlayerNum].Faith

	ItemList := ""
	For Index, Element in [Player[PlayerNum].RightHand1,Player[PlayerNum].RightHand2,Player[PlayerNum].RightHand3
	,Player[PlayerNum].LeftHand1,Player[PlayerNum].LeftHand2,Player[PlayerNum].LeftHand3
	,Player[PlayerNum].Head,Player[PlayerNum].Chest,Player[PlayerNum].Hands,Player[PlayerNum].Legs
	,Player[PlayerNum].Ring1,Player[PlayerNum].Ring2,Player[PlayerNum].Ring3,Player[PlayerNum].Ring4]
	{
		if(Element && Element<>"Fists")
			ItemList := ItemList . Element . "|"
	}

	Gui Add, ListBox, x10 y261 w280 h160, % ItemList
	Gui Add, Text, x10 y92 w135 h20, HP
	Gui Add, Text, x10 y112 w135 h20, FP
	Gui Add, Text, x145 y92 w135 h20, Stamina
	Gui Add, Text, x85 y92 w50 h20 +Center, % Player[PlayerNum].HPMax
	Gui Add, Text, x85 y112 w50 h20 +Center, % Player[PlayerNum].FPMax
	Gui Add, Text, x260 y92 w30 h20 +Center, % Player[PlayerNum].StaminaMax
	Gui Add, Text, x10 y254 w278 h2 0x10
	Gui Add, Text, x10 y138 w278 h2 0x10
	if(Player[PlayerNum].FlagPath)
		Gui Add, Picture, x11 y67 w16 h11, % Player[PlayerNum].FlagPath

	Gui Show, w300 h430, % Player[PlayerNum].Name . " (" . Player[PlayerNum].SteamName . ")"
}

GetSteamHTML(SteamIDHex)
{
	if(!SteamIDHex)
		Return ""
	if(SteamIDHex="PyreProteccAC")
		Return "PyreProteccAC"
	if(SteamHTML[SteamIDHex])
		Return SteamHTML[SteamIDHex]

	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	URL := "https://steamcommunity.com/profiles/" . HexToInt(SteamIDHex)
	whr.Open("GET",URL, true)
	whr.Send()
	; Using 'true' above and the call below allows the script to remain responsive.
	whr.WaitForResponse()
	SteamHTML[SteamIDHex] := whr.ResponseText
	Return SteamHTML[SteamIDHex]
}

GetClassFromInt(Int)
{
	switch Int
	{
		case 0: Return "Knight"
		case 1: Return "Mercenary"
		case 2: Return "Warrior"
		case 3: Return "Herald"
		case 4: Return "Thief"
		case 5: Return "Assassin"
		case 6: Return "Sorcerer"
		case 7: Return "Pyromancer"
		case 8: Return "Cleric"
		case 9: Return "Deprived"
	}
	Return 0
}

GetFlagPath(SteamIDHex,FlagURL)
{
	ImageDir := A_ScriptDir . "\Images\Flags"
	IfNotExist,%ImageDir%
		FileCreateDir,%ImageDir%

	if(!SteamIDHex)
		Return ""
	if(SteamIDHex="PyreProteccAC")
		Return ""
		
	if(FlagPath[SteamIDHex])
		Return FlagPath[SteamIDHex]
	
	FlagName := ""
	Loop,10
	{
		if(InStr(StrSplit(FlagURL,["""","/"])[A_Index],".gif"))
			FlagName := StrSplit(FlagURL,["""","/"])[A_Index]
	}
	;Tooltip,% FlagName
	
	if(FileExist(ImageDir . "\" . FlagName))
	{
		FlagPath[SteamIDHex] := ImageDir . "\" . FlagName
		Return FlagPath[SteamIDHex]	
	}
	
	UrlDownloadToFile, % FlagURL, % ImageDir . "\" . FlagName
	if(ErrorLevel=0)
	{
		FlagPath[SteamIDHex] := ImageDir . "\" . FlagName
		Return FlagPath[SteamIDHex]
	}
	
	Return ""
}

GetImagePath(SteamIDHex,ImageURL)
{
	ImageDir := A_ScriptDir . "\Images\Profile Pictures"
	IfNotExist,%ImageDir%
		FileCreateDir,%ImageDir%

	if(!FileExist(ImageDir . "\Default.jpg"))
		UrlDownloadToFile,% "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg",% ImageDir . "\Default.jpg"

	if(!FileExist(ImageDir . "\Default.jpg"))
	{
		if(!SteamIDHex)
			Return ""
		if(SteamIDHex="PyreProteccAC")
			Return ""
		if(ImageURL="https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg")
			Return ""
	}
	
	if(!SteamIDHex)
		Return ImageDir . "\Default.jpg"
	if(SteamIDHex="PyreProteccAC")
		Return ImageDir . "\Default.jpg"
	if(ImageURL="https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg")
		Return ImageDir . "\Default.jpg"
		
	if(ImagePath[SteamIDHex])
		Return ImagePath[SteamIDHex]
		
	UrlDownloadToFile, % ImageURL,% ImageDir . "\" . HexToInt(SteamIDHex) . ".jpg"
	if(ErrorLevel=0)
	{
		ImagePath[SteamIDHex] := ImageDir . "\" . HexToInt(SteamIDHex) . ".jpg"
		Return ImagePath[SteamIDHex]
	}	
	
	Return ImageDir . "\Default.jpg"
	
}

GetSteamName(HTML)
{
	if(!HTML)
		Return ""
	if(HTML="PyreProteccAC")
		Return "(SteamID hidden by PyreProtecc)"


	Loop,Parse,% HTML,`n,`r
	{
		if(InStr(A_LoopField,"Steam Community :: "))
		{
			Temp := A_LoopField
			Loop,5
			{
				if InStr(StrSplit(Temp,[">","<"," :: "])[A_Index],"Steam Community")
					Return StrSplit(Temp,[">","<"," :: "])[A_Index+1]
			}
		}
	}
	
	Return ""
}

GetFlagURL(HTML)
{
	if(!HTML or HTML="PyreProteccAC")
		Return ""
	
	Loop,Parse,HTML,`n,`r
	{
		if(InStr(A_LoopField,"countryflags"))
		{
			Temp := A_LoopField
			Loop,10
			{
				if(InStr(StrSplit(Temp,"""")[A_Index],"countryflags"))
					Return StrSplit(Temp,"""")[A_Index]
			}
		}
	}
}

GetImageURL(HTML)
{
	if(!HTML or HTML="PyreProteccAC")
		Return ""
	
	Loop,Parse,HTML,`n,`r
	{	
		if(InStr(A_LoopField,"full.jpg"))
		{
			Temp := A_LoopField
			Loop,5
			{
				AvatarURL := StrSplit(Temp,"""")[A_Index]
				If(InStr(AvatarURL,"full.jpg"))
					Return AvatarURL
			}
		}
	}
	
	Return ""
		
}