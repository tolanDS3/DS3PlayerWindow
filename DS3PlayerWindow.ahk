; DS3PlayerWindow.ahk v1.1

#NoEnv
#SingleInstance Force
#Include .\Include\ClassMemory.ahk
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Global Window := []
Global LabelColor := []
if(FileExist("DS3PlayerWindow.ini"))
{
	IniRead,Temp,DS3PlayerWindow.ini,Window
	Loop,Parse,Temp,`n,`r
		Window[StrSplit(A_LoopField,"=")[1]] := StrSplit(A_LoopField,"=")[2]
	IniRead,Temp,DS3PlayerWindow.ini,LabelColor
	Loop,Parse,Temp,`n,`r
		LabelColor[StrSplit(A_LoopField,"=")[1]] := StrSplit(A_LoopField,"=")[2]
} else {
	For Index, Element in				{"X"									:1520
							,"Y"									:0
							,"Transparency"								:200
							,"Color"								:"000000"
							,"Font"									:"Calibri"}
	{
		IniWrite,%Element%,DS3PlayerWindow.ini,Window,%Index%
		Window[Index] := Element
	}
	For Index, Element in				{"Host"									:"00FF00"
							,"Phantom"								:"FFFFFF"
							,"Dark Spirit (Red Summon)"						:"FF0000"
							,"Dark Spirit (Invader)"						:"FF0000"
							,"Mound-Maker (White Summon)"						:"FF00FF"
							,"Spear of the Church"							:"8000FF"
							,"Blade of the Darkmoon"						:"0000FF"
							,"Watchdog of Farron"							:"8000FF"
							,"Aldrich Faithful"							:"8000FF"
							,"Arena"								:"FFFFFF"
							,"Warrior of Sunlight (White Summon)"					:"FFFF00"
							,"Warrior of Sunlight (Red Summon)"					:"FF8000"
							,"Mound-Maker (Red Summon)"						:"FF00FF"
							,"Warrior of Sunlight (Invader)"					:"FF8000"
							,"Mound-Maker (Invader)"						:"FF00FF"
							,"Blue Sentinel"							:"0000FF"}
	{
		IniWrite,%Element%,DS3PlayerWindow.ini,LabelColor,%Index%
		LabelColor[Index] := Element
	}
}

Global Cache := []
Loop,Read,Players.dat
{
	SteamID := StrSplit(A_LoopReadLine,A_Tab)[1]
	Cache[SteamID] := {}
	Cache[SteamID].Name 		:= StrSplit(A_LoopReadLine,A_Tab)[2]
	Cache[SteamID].AvatarURL 	:= StrSplit(A_LoopReadLine,A_Tab)[3]
	Cache[SteamID].FlagURL	 	:= StrSplit(A_LoopReadLine,A_Tab)[4]
}

Global ItemName := []
Loop,Read,Items.dat
	ItemName[StrSplit(A_LoopReadLine,A_Tab)[1]] := StrSplit(A_LoopReadLine,A_Tab)[2]

Global Player := []
Loop,5
	Player[A_Index] := {}

Gui Color, % Window["Color"]
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow

Gui Add, Picture, vPic1 x8 y8 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic2 x8 y88 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic3 x8 y168 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic4 x8 y248 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic5 x8 y328 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg

Gui Font, s13 c0xFFFFFF, % Window["Font"]
Gui Add, Text, vName1 x80 y8 w250 h20
Gui Add, Text, vName2 x80 y88 w250 h20
Gui Add, Text, vName3 x80 y168 w250 h20
Gui Add, Text, vName4 x80 y248 w250 h20
Gui Add, Text, vName5 x80 y328 w250 h20

Gui Font, s12 c0xFFFFFF, % Window["Font"]
Gui Add, Text, vLevel1 x340 y8 w50 h20 +Right
Gui Add, Text, vLevel2 x340 y88 w50 h20 +Right
Gui Add, Text, vLevel3 x340 y168 w50 h20 +Right
Gui Add, Text, vLevel4 x340 y248 w50 h20 +Right
Gui Add, Text, vLevel5 x340 y328 w50 h20 +Right

Gui Add, Text, vSteam1 x80 y30 w312 h20 +0x200
Gui Add, Text, vSteam2 x80 y110 w312 h20 +0x200
Gui Add, Text, vSteam3 x80 y190 w312 h20 +0x200
Gui Add, Text, vSteam4 x80 y270 w312 h20 +0x200
Gui Add, Text, vSteam5 x80 y350 w312 h20 +0x200

Gui Add, Progress, vBar1 x80 y57 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 0
Gui Add, Progress, vBar2 x80 y137 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004,0
Gui Add, Progress, vBar3 x80 y217 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004,0
Gui Add, Progress, vBar4 x80 y297 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004,0
Gui Add, Progress, vBar5 x80 y377 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004,0

Gui Font, s8 c0xFFFFFF, % Window["Font"]
Gui Add, Text, vHP1 x80 y57 w312 h15 +0x200 +BackgroundTrans +0x1
Gui Add, Text, vHP2 x80 y137 w312 h15 +0x200 +BackgroundTrans +0x1
Gui Add, Text, vHP3 x80 y217 w312 h15 +0x200 +BackgroundTrans +0x1
Gui Add, Text, vHP4 x80 y297 w312 h15 +0x200 +BackgroundTrans +0x1
Gui Add, Text, vHP5 x80 y377 w312 h15 +0x200 +BackgroundTrans +0x1

Gui Add, Picture, vFlag1 x374 y35 w16 h11 +0x2
Gui Add, Picture, vFlag2 x374 y115 w16 h11 +0x2
Gui Add, Picture, vFlag3 x374 y195 w16 h11 +0x2
Gui Add, Picture, vFlag4 x374 y275 w16 h11 +0x2
Gui Add, Picture, vFlag5 x374 y355 w16 h11 +0x2

WinSet, Transparent, % Window.Transparency

SetTimer,UpdateOSD,16
SetTimer,UpdateCacheFile,30000

Return

UpdateOSD:
	Game := new _ClassMemory("ahk_exe DarkSoulsIII.exe", "", hProcessCopy)
	if(!isObject(Game))
	{
		Gui,Show,Hide
		Return
	}
	
	if(!WinActive("DARK SOULS III"))
	{
		Gui,Show,Hide
		Return
	}
	
	ActivePlayers := []
	ActivePlayers := GetActivePlayers()
	if(!ActivePlayers[1])
	{
		Gui,Show,Hide
		Return
	}
	Window["Height"] := (ActivePlayers.Count()*80)
	
	BaseB := Game.BaseAddress + 0x4768E78
	
	For Index, Offset in [0x38,0x70,0xA8,0xE0,0x118]
	{
		Player[Index].Name 				:= Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,Offset,0x1FA0,0x88)
		Player[Index].Level				:= Game.Read(BaseB,"Int",0x40,Offset,0x1FA0,0x70)
		Player[Index].SteamID	 			:= GetSteamID(Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,Offset,0x1FA0,0x7D8))
		
		Player[Index].HP 				:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x18)	
		Player[Index].MaxHP 				:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x1C)	
		Player[Index].MaxFP 				:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x2C)
		Player[Index].MaxStamina			:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x3C)
		
		Player[Index].Vigor 				:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x44)
		Player[Index].Attunement 			:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x48)
		Player[Index].Endurance 			:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x4C)
		Player[Index].Vitality 				:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x6C)
		Player[Index].Strength 				:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x50)
		Player[Index].Dexterity 			:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x54)
		Player[Index].Intelligence 			:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x58)
		Player[Index].Faith 				:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x5C)
		Player[Index].Luck 				:= Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x60)		
		
		Player[Index].RightHand1 			:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x330))
		Player[Index].RightHand2 			:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x338))
		Player[Index].RightHand3 			:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x340))
		Player[Index].LeftHand1 			:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x32C))
		Player[Index].LeftHand2 			:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x334))
		Player[Index].LeftHand3 			:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x33C))
		Player[Index].Chest 				:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x360))
		Player[Index].Hands				:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x364))
		Player[Index].Legs 				:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x368))
		Player[Index].Head 				:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x35C))
		Player[Index].Ring1				:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x370))
		Player[Index].Ring2				:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x374))
		Player[Index].Ring3				:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x378))
		Player[Index].Ring4				:= GetItemName(Game.read(BaseB,"Int",0x40,Offset,0x1FA0,0x37C))
		
		Player[Index].InvadeType			:= GetInvadeType(Game.read(BaseB,"Char",0x40,Offset,0x1FA0,0xFC))	
	}
	
	For Index, ActivePlayerNumber in ActivePlayers
	{
		GuiControlGet,Temp,,Name%Index%
		if(Player[ActivePlayerNumber].Name<>Temp)
		{
			GuiControl,-Redraw,Name%Index%	
			if(LabelColor[Player[ActivePlayerNumber].InvadeType])
				GuiControl,% "+c" . LabelColor[Player[ActivePlayerNumber].InvadeType],Name%A_Index%
			else
				GuiControl,+cFFFFFF,Name%A_Index%
			GuiControl,,Name%Index%,% Player[ActivePlayerNumber].Name
			GuiControl,+Redraw,Name%Index%
		}
		
		GuiControlGet,Temp,,Level%Index%
		if("Lv." . Player[ActivePlayerNumber].Level<>Temp)
		{
			GuiControl,-Redraw,Level%Index%
			GuiControl,,Level%Index%,% "Lv." . Player[ActivePlayerNumber].Level
			GuiControl,+Redraw,Level%Index%
		}
		
		GuiControlGet,Temp,,Bar%Index%
		if(Player[ActivePlayerNumber].HP<>Temp)
		{
			GuiControl,-Redraw,Bar%Index%
			Temp := Player[ActivePlayerNumber].MaxHP
			GuiControl,+Range0-%Temp%,Bar%Index%
			GuiControl,,Bar%Index%,% Player[ActivePlayerNumber].HP
			GuiControl,+Redraw,Bar%Index%
		}
		
		GuiControlGet,Temp,,HP%Index%
		if(Player[ActivePlayerNumber].HP . " / " . Player[ActivePlayerNumber].MaxHP <> Temp)
		{
			GuiControl,-Redraw,HP%Index%
			GuiControl,,HP%Index%,% Player[ActivePlayerNumber].HP . " / " . Player[ActivePlayerNumber].MaxHP
			GuiControl,+Redraw,HP%Index%
		}
	}

	For Index, ActivePlayerNumber in ActivePlayers
	{
		Player[ActivePlayerNumber].SteamName := GetSteamName(Player[ActivePlayerNumber].SteamID)
		GuiControlGet,Temp,,Steam%Index%
		if(Player[ActivePlayerNumber].SteamName<>Temp)
		{
			GuiControl,-Redraw,Steam%Index%
			GuiControl,,Steam%Index%,% Player[ActivePlayerNumber].SteamName
			GuiControl,+Redraw,Steam%Index%
		}
		
		Player[ActivePlayerNumber].FlagURL := GetFlagURL(Player[ActivePlayerNumber].SteamID)
		Player[ActivePlayerNumber].FlagPath := GetFlagPath(Player[ActivePlayerNumber].SteamID)
		if(Player[ActivePlayerNumber].FlagPath<>Cache["Flag" . Index])
		{
			GuiControl,-Redraw,Flag%Index%
			GuiControl,,Flag%Index%,% Player[ActivePlayerNumber].FlagPath
			Cache["Flag" . Index] := Player[ActivePlayerNumber].FlagPath
			GuiControl,Move,Flag%Index%,w16 h11
			GuiControl,+Redraw,Flag%Index%
		}
		

		Player[ActivePlayerNumber].AvatarURL := GetAvatarURL(Player[ActivePlayerNumber].SteamID)
		Player[ActivePlayerNumber].AvatarPath := GetAvatarPath(Player[ActivePlayerNumber].SteamID)
		if(Player[ActivePlayerNumber].AvatarPath<>Cache["Avatar" . Index])
		{
			GuiControl,-Redraw,Pic%Index%
			GuiControl,,Pic%Index%,% Player[ActivePlayerNumber].AvatarPath
			Cache["Avatar" . Index] := Player[ActivePlayerNumber].AvatarPath
			GuiControl,Move,Pic%Index%,w64 h64
			GuiControl,+Redraw,Pic%Index%
		}				
	}

	Gui Show, % "w400 h" . Window["Height"] . " x" . Window["X"] . " y" . Window["Y"] . " NoActivate"
	
Return

UpdateCacheFile:
	FileDelete,% A_ScriptDir . "\Players.dat"
	PlayerData := ""
	For Element in Cache
	{
		if(!InStr(Element,"Flag") && !InStr(Element,"Avatar"))
			PlayerData := PlayerData . Element . A_Tab . Cache[Element].Name . A_Tab . Cache[Element].AvatarURL . A_Tab . Cache[Element].FlagURL . "`n"
	}
	FileAppend,% PlayerData,% A_ScriptDir . "\Players.dat",UTF-16
Return

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
			NumPlayers += 1
			ActivePlayers[NumPlayers] := A_Index
		}
	}
	
	if(ActivePlayers[1])
		Return ActivePlayers
	
	Return 0
}

GetSteamID(Hex)
{
	if(!Hex)
		Return
	if(Hex="PyreProteccAC")
		Return Hex
	SteamID := HexToInt(Hex)
	if(!Cache[SteamID].Count())
		Cache[SteamID] := {}
	Return SteamID
}

GetItemName(Int)
{
	if(ItemName[IntToHex(Int)])
		Return ItemName[IntToHex(Int)]
	Return IntToHex(Int)
}

GetInvadeType(Int)
{
	Switch Int
	{
		Case 0:		Return "Host"
		Case 1:		Return "Phantom"
		Case 2:		Return "Dark Spirit (Red Summon)"
		Case 3:		Return "Dark Spirit (Invader)"
		Case 4:		Return "Mound-Maker (White Summon)"
		Case 6:		Return "Spear of the Church"
		Case 7:		Return "Blade of the Darkmoon"
		Case 9:		Return "Watchdog of Farron"
		Case 10:	Return "Aldrich Faithful"
		Case 12:	Return "Arena"
		Case 14:	Return "Warrior of Sunlight (White Summon)"
		Case 15:	Return "Warrior of Sunlight (Red Summon)"
		Case 16:	Return "Mound-Maker (Red Summon)"
		Case 17:	Return "Warrior of Sunlight (Invader)"
		Case 18:	Return "Mound-Maker (Invader)"
		Case 21:	Return "Blue Sentinel"
	}
	Return
}

GetSteamHTML(SteamID)
{
	if(!SteamID || SteamID="PyreProteccAC")
		Return
		
	if(Cache[SteamID].HTML)
		Return Cache[SteamID].HTML
	
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	URL := "https://steamcommunity.com/profiles/" . SteamID
	whr.Open("GET",URL, true)
	whr.Send()
	whr.WaitForResponse()
	Cache[SteamID].HTML := whr.ResponseText
	Return Cache[SteamID].HTML
}

GetSteamName(SteamID)
{
	if(!SteamID)
		Return
	
	if(SteamID="PyreProteccAC")
		Return "Hidden by PyreProtecc"

	if(Cache[SteamID].Name)
		Return Cache[SteamID].Name

	HTML := GetSteamHTML(SteamID)
	Loop,Parse,HTML,`n,`r
	{
		if(InStr(A_LoopField,"Steam Community :: "))
		{
			Temp := A_LoopField
			Loop,25
			{
				if InStr(StrSplit(Temp,[" :: ","<"])[A_Index],"Steam Community")
				{
					Cache[SteamID].Name := StrSplit(Temp,[" :: ","<"])[A_Index+1]
					Return Cache[SteamID].Name
				}
			}
		}
	}
	
	Return
}

GetAvatarURL(SteamID)
{
	if(!SteamID)
		Return

	if(SteamID="PyreProteccAC")
		Return "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg"

	if(Cache[SteamID].AvatarURL)
		Return Cache[SteamID].AvatarURL
	
	HTML := GetSteamHTML(SteamID)
	Loop,Parse,HTML,`n,`r
	{	
		if(InStr(A_LoopField,"full.jpg"))
		{
			Temp := A_LoopField
			Loop,25
			{
				If(InStr(StrSplit(Temp,"""")[A_Index],"full.jpg"))
				{
					Cache[SteamID].AvatarURL := StrSplit(Temp,"""")[A_Index]
					Return Cache[SteamID].AvatarURL
				}
			}
		}
	}
	Return
}

GetAvatarPath(SteamID)
{
	ImageDir := A_ScriptDir . "\Images\Profile Pictures"
	IfNotExist,%ImageDir%
		FileCreateDir,%ImageDir%

	DefaultImage := ImageDir . "\Default.jpg"
	if(!FileExist(DefaultImage))
		UrlDownloadToFile,% "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg",% DefaultImage

	if(!SteamID || SteamID="PyreProteccAC")
		Return DefaultImage

	if(Cache[SteamID].AvatarPath)
		Return Cache[SteamID].AvatarPath

	if(FileExist(ImageDir . "\" . SteamID . ".jpg"))
	{
		Cache[SteamID].AvatarPath := ImageDir . "\" . SteamID . ".jpg"
		Return Cache[SteamID].AvatarPath
	}

	URL := GetAvatarURL(SteamID)
	if(!URL || URL="https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg")
		Return DefaultImage

	UrlDownloadToFile, % URL,% ImageDir . "\" . SteamID . ".jpg"
	if(ErrorLevel=0)
	{
		Cache[SteamID].AvatarPath := ImageDir . "\" . SteamID . ".jpg"
		Return Cache[SteamID].AvatarPath
	}
	
	Return DefaultImage
}

GetFlagURL(SteamID)
{
	if(!SteamID || SteamID="PyreProteccAC")
		Return

	if(Cache[SteamID].FlagURL)
		Return Cache[SteamID].FlagURL

	HTML := GetSteamHTML(SteamID)
	Loop,Parse,HTML,`n,`r
	{
		if(InStr(A_LoopField,"countryflags"))
		{
			Temp := A_LoopField
			Loop,25
			{
				if(InStr(StrSplit(Temp,"""")[A_Index],"countryflags"))
				{
					Cache[SteamID].FlagURL := StrSplit(Temp,"""")[A_Index]
					Return Cache[SteamID].FlagURL
				}
			}
		}
	}
	Return
}

GetFlagPath(SteamID)
{
	ImageDir := A_ScriptDir . "\Images\Flags"
	IfNotExist,%ImageDir%
		FileCreateDir,%ImageDir%

	if(!SteamID || SteamID="PyreProteccAC")
		Return
		
	if(Cache[SteamID].FlagPath)
		Return Cache[SteamID].FlagPath
	
	Loop,25
	{
		if(InStr(StrSplit(GetFlagURL(SteamID),["""","/"])[A_Index],".gif"))
			FlagName := StrSplit(GetFlagURL(SteamID),["""","/"])[A_Index]
	}
	
	if(!FlagName)
		Return
	
	if(FileExist(ImageDir . "\" . FlagName))
	{
		Cache[SteamID].FlagPath := ImageDir . "\" . FlagName
		Return Cache[SteamID].FlagPath
	}
	
	UrlDownloadToFile, % GetFlagURL(SteamID), % ImageDir . "\" . FlagName
	if(ErrorLevel=0)
	{
		Cache[SteamID].FlagPath := ImageDir . "\" . FlagName
		Return Cache[SteamID].FlagPath
	}
	
	Return
}


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
