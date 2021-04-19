#NoEnv
#SingleInstance Force
#Include .\Include\ClassMemory.ahk
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Global Window 	:= []
Global LabelColor	:= []
if(FileExist("DS3PlayerWindow.ini"))
{
	IniRead,Temp,DS3PlayerWindow.ini,Window
	Loop, Parse, Temp, `n, `r
	{
		Array := StrSplit(A_LoopField,"=")
		Window[Array[1]] := Array[2]	
	}
} else {
	For Index, Element in {"X":1520,"Y":0,"Transparency":200,"Color":"000000","Font":"Calibri"}
	{
		IniWrite,%Element%,DS3PlayerWindow.ini,Window,%Index%
		Window[Index] := Element
	}
}

Global Player := []
Loop,5
	Player[A_Index] := {}

Global FlagList := []
Global ImageList := []

Global Cache := []

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Gui Color, % Window["Color"]
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow

Gui Add, Picture, vPic1 x8 y8 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic2 x8 y88 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic3 x8 y168 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic4 x8 y248 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic5 x8 y328 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg

Gui Font, s13 c0xFFFFFF, % Window["Font"]
Gui Add, Text, vName1 x80 y8 w250 h20, Player 1
Gui Add, Text, vName2 x80 y88 w250 h20, Player 2
Gui Add, Text, vName3 x80 y168 w250 h20, Player 3
Gui Add, Text, vName4 x80 y248 w250 h20, Player 4
Gui Add, Text, vName5 x80 y328 w250 h20, Player 5

Gui Font, s12 c0xFFFFFF, % Window["Font"]
Gui Add, Text, vLevel1 x340 y8 w50 h20 +Right, Lv.999
Gui Add, Text, vLevel2 x340 y88 w50 h20 +Right, Lv.999
Gui Add, Text, vLevel3 x340 y168 w50 h20 +Right, Lv.999
Gui Add, Text, vLevel4 x340 y248 w50 h20 +Right, Lv.999
Gui Add, Text, vLevel5 x340 y328 w50 h20 +Right, Lv.999

Gui Add, Text, vSteam1 x80 y30 w312 h20 +0x200, Steam 1
Gui Add, Text, vSteam2 x80 y110 w312 h20 +0x200, Steam 2
Gui Add, Text, vSteam3 x80 y190 w312 h20 +0x200, Steam 3
Gui Add, Text, vSteam4 x80 y270 w312 h20 +0x200, Steam 4
Gui Add, Text, vSteam5 x80 y350 w312 h20 +0x200, Steam 5

Gui Add, Progress, vBar1 x80 y57 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33
Gui Add, Progress, vBar2 x80 y137 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33
Gui Add, Progress, vBar3 x80 y217 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33
Gui Add, Progress, vBar4 x80 y297 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33d
Gui Add, Progress, vBar5 x80 y377 w312 h15 -Smooth +Border +Background0x191919 +C0x9B0004, 33

Gui Font, s8 c0xFFFFFF, % Window["Font"]
Gui Add, Text, vHP1 x80 y57 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000
Gui Add, Text, vHP2 x80 y137 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000
Gui Add, Text, vHP3 x80 y217 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000
Gui Add, Text, vHP4 x80 y297 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000
Gui Add, Text, vHP5 x80 y377 w312 h15 +0x200 +BackgroundTrans +0x1, 1000 / 1000

Gui Add, Picture, vFlag1 x374 y35 w16 h11 +0x2
Gui Add, Picture, vFlag2 x374 y115 w16 h11 +0x2
Gui Add, Picture, vFlag3 x374 y195 w16 h11 +0x2
Gui Add, Picture, vFlag4 x374 y275 w16 h11 +0x2
Gui Add, Picture, vFlag5 x374 y355 w16 h11 +0x2

WinSet, Transparent, % Window.Transparency

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

SetTimer,UpdateOSD,16
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

UpdateOSD:

	if(!WinActive("DARK SOULS III"))
	{
		;Gui,Show,Hide
		;Return
	}

	Game := new _ClassMemory("ahk_exe DarkSoulsIII.exe", "", hProcessCopy)
	if(!isObject(Game))
	{
		Gui,Show,Hide
		Return
	}
	
	if(!GetActivePlayers()[1])
	{
		Gui,Show,Hide
		Return	
	}
	
	BaseB := Game.BaseAddress + 0x4768E78
	For Index, Element in [0x38,0x70,0xA8,0xE0,0x118]
	{
		Player[Index].Level := Game.Read(BaseB,"Int",0x40,Element,0x1FA0,0x70)
		Player[Index].Name := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,Element,0x1FA0,0x88)
		Player[Index].HP := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x18)	
		Player[Index].HPMax := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x1C)	
		Player[Index].FPMax := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x2C)
		Player[Index].StaminaMax := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x3C)
		Player[Index].SteamIDHex := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,Element,0x1FA0,0x7D8)
		Player[Index].Vigor := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x44)
		Player[Index].Attunement := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x48)
		Player[Index].Endurance := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x4C)
		Player[Index].Vitality := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x6C)
		Player[Index].Strength := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x50)
		Player[Index].Luck := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x60)
		Player[Index].Dexterity := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x54)
		Player[Index].Intelligence := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x58)
		Player[Index].Faith := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x5C)
		Player[Index].RightHand1 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x330)
		Player[Index].RightHand2 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x338)
		Player[Index].RightHand3 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x340)
		Player[Index].LeftHand1 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x32C)
		Player[Index].LeftHand2 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x334)
		Player[Index].LeftHand3 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x33C)
		Player[Index].Chest := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x360)
		Player[Index].Hands := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x364)
		Player[Index].Legs := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x368)
		Player[Index].Head := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x35C)
		Player[Index].Ring1 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x370)
		Player[Index].Ring2 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x374)
		Player[Index].Ring3 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x378)
		Player[Index].Ring4 := Game.read(BaseB,"Int",0x40,Element,0x1FA0,0x37C)
		Player[Index].TeamType := Game.read(BaseB,"Int",0x40,Element,0x74)
		Player[Index].Covenant := Game.read(BaseB,"Char",0x40,Element,0x1FA0,0xF7)
		Player[Index].CharacterType := Game.read(BaseB,"Int",0x40,Element,0x70)
		Player[Index].InvadeType := Game.read(BaseB,"Char",0x40,Element,0x1FA0,0xFC)
		Player[Index].SteamHTML := GetSteamHTML(Player[Index].SteamIDHex)
		Player[Index].SteamName := GetSteamName(Player[Index].SteamIDHex)
		Player[Index].SteamAvatarURL := GetSteamAvatarURL(Player[Index].SteamIDHex)
		Player[Index].SteamFlagURL := GetSteamFlagURL(Player[Index].SteamIDHex)
		Player[Index].ImagePath := GetImagePath(Player[Index].SteamIDHex)
		Player[Index].FlagPath := GetFlagPath(Player[Index].SteamIDHex)
	}
	
	For Index, ActivePlayerNumber in GetActivePlayers()
	{
		if(Player[ActivePlayerNumber].FlagPath<>FlagList[Index])
		{
			GuiControl,-Redraw,Flag%Index%
			GuiControl,,Flag%Index%,% Player[ActivePlayerNumber].FlagPath
			FlagList[Index] := Player[ActivePlayerNumber].FlagPath
			GuiControl,Move,Flag%Index%,w16 h11
			GuiControl,+Redraw,Flag%Index%
		}
		
		if(Player[ActivePlayerNumber].ImagePath<>ImageList[Index])
		{
			GuiControl,-Redraw,Pic%Index%
			GuiControl,,Pic%Index%,% Player[ActivePlayerNumber].ImagePath
			ImageList[Index] := Player[ActivePlayerNumber].ImagePath
			GuiControl,Move,Pic%Index%,w64 h64
			GuiControl,+Redraw,Pic%Index%
		}

		GuiControlGet,Temp,,Name%Index%
		if(Player[ActivePlayerNumber].Name<>Temp)
		{
			GuiControl,-Redraw,Name%Index%
			GuiControl,,Name%Index%,% Player[ActivePlayerNumber].Name
			GuiControl,+Redraw,Name%Index%
		}

		; Begin debug
		
		;GuiControlGet,Temp,,Steam%Index%
		;if(Player[ActivePlayerNumber].SteamName<>Temp)
		;{
		;	GuiControl,-Redraw,Steam%Index%
		;	GuiControl,,Steam%Index%,% Player[ActivePlayerNumber].SteamName
		;	GuiControl,+Redraw,Steam%Index%
		;}	

		GuiControlGet,Temp,,Steam%Index%
		if(GetInvaderType(Player[ActivePlayerNumber].InvadeType)<>Temp)
		{
			GuiControl,-Redraw,Level%Index%
			GuiControl,,Steam%Index%,% GetInvaderType(Player[ActivePlayerNumber].InvadeType)
			GuiControl,+Redraw,Level%Index%
		}
		
		;GuiControlGet,Temp,,Level%Index%
		;if("Lv." . Player[ActivePlayerNumber].Level<>Temp)
		;{
		;	GuiControl,-Redraw,Level%Index%
		;	GuiControl,,Level%Index%,% "Lv." . Player[ActivePlayerNumber].Level
		;	GuiControl,+Redraw,Level%Index%
		;}
		
		; End debug
		
		GuiControlGet,Temp,,Bar%Index%
		if(Player[ActivePlayerNumber].HP<>Temp)
		{
			GuiControl,-Redraw,Bar%Index%
			Temp := Player[ActivePlayerNumber].HPMax
			GuiControl,+Range0-%Temp%,Bar%Index%
			GuiControl,,Bar%Index%,% Player[ActivePlayerNumber].HP
			GuiControl,+Redraw,Bar%Index%
		}
		
		GuiControlGet,Temp,,HP%Index%
		if(Player[ActivePlayerNumber].HP . " / " . Player[ActivePlayerNumber].HPMax <> Temp)
		{
			GuiControl,-Redraw,HP%Index%
			GuiControl,,HP%Index%,% Player[ActivePlayerNumber].HP . " / " . Player[ActivePlayerNumber].HPMax
			GuiControl,+Redraw,HP%Index%
		}
	}


	Window["Height"] := (GetActivePlayers().Count()*80)
	if(!Window["Height"])
	{
		Gui,Show,Hide
		Return
	}

	Gui Show, % "w400 h" . Window["Height"] . " x" . Window["X"] . " y" . Window["Y"] . " NoActivate"
Return

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

GetActivePlayers()
{
	Game := new _ClassMemory("ahk_exe DarkSoulsIII.exe", "", hProcessCopy)
	if(!isObject(Game))
		Return 0
		
	BaseB := Game.BaseAddress + 0x4768E78

	ActivePlayers := []
	For Index, Element in [0x38,0x70,0xA8,0xE0,0x118]
	{
		if(Game.Read(BaseB,"Int",0x40,Element,0x1FA0,0x70))
		{
			NumPlayers += 1
			ActivePlayers[NumPlayers] := A_Index
		}
	}
	
	if(ActivePlayers[1])
		Return ActivePlayers
	
	Return 0
}

GetInvaderType(Int)
{
	switch Int
	{
		case 0:		Return "Host"
		case 1:		Return "Phantom"
		case 2:		Return "Dark Spirit (Summoned)"
		case 3:		Return "Dark Spirit (Invader)"
		case 4:		Return "Mad Dark Spirit (Summoned)"
		case 7:		Return "Blue Sentinel"
		case 10:	Return "Aldrich Faithful"
		case 15:	Return "Warrior of Sunlight (Red)"
		case 16:	Return "Mad Spirit (Summoned)"
		case 18:	Return "Mad Spirit (Invader)"
		case 21:	Return "Blade of the Darkmoon"
	}
	Return Int
}

GetSteamHTML(SteamIDHex)
{
	if(!SteamIDHex || SteamIDHex="PyreProteccAC")
		Return
		
	if(Cache[SteamIDHex].HTML)
		Return Cache[SteamIDHex].HTML

	if(!Cache[SteamIDHex].Count())
		Cache[SteamIDHex] := {}
	
	whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
	URL := "https://steamcommunity.com/profiles/" . HexToInt(SteamIDHex)
	whr.Open("GET",URL, true)
	whr.Send()
	whr.WaitForResponse()
	Cache[SteamIDHex].HTML := whr.ResponseText
	Return Cache[SteamIDHex].HTML
}


GetSteamName(SteamIDHex)
{
	if(!SteamIDHex)
		Return

	if(Cache[SteamIDHex].Name)
		Return Cache[SteamIDHex].Name

	if(SteamIDHex="PyreProteccAC")
		Return "Hidden by PyreProtecc"

	if(!Cache[SteamIDHex].Count())
		Cache[SteamIDHex] := {}

	HTML := GetSteamHTML(SteamIDHex)
	Loop,Parse,HTML,`n,`r
	{
		if(InStr(A_LoopField,"Steam Community :: "))
		{
			Temp := A_LoopField
			Loop,25
			{
				if InStr(StrSplit(Temp,[" :: ","<"])[A_Index],"Steam Community")
				{
					Cache[SteamIDHex].Name := StrSplit(Temp,[" :: ","<"])[A_Index+1]
					Return Cache[SteamIDHex].Name
				}
			}
		}
	}
	Return 0
}

GetSteamAvatarURL(SteamIDHex)
{
	if(!SteamIDHex)
		Return

	if(Cache[SteamIDHex].AvatarURL)
		Return Cache[SteamIDHex].AvatarURL
		
	if(SteamIDHex="PyreProteccAC")
		Return "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg"

	if(!Cache[SteamIDHex].Count())
		Cache[SteamIDHex] := {}
	
	HTML := GetSteamHTML(SteamIDHex)
	Loop,Parse,HTML,`n,`r
	{	
		if(InStr(A_LoopField,"full.jpg"))
		{
			Temp := A_LoopField
			Loop,25
			{
				If(InStr(StrSplit(Temp,"""")[A_Index],"full.jpg"))
				{
					Cache[SteamIDHex].AvatarURL := StrSplit(Temp,"""")[A_Index]
					Return Cache[SteamIDHex].AvatarURL
				}
			}
		}
	}
	Return
}

GetSteamFlagURL(SteamIDHex)
{
	if(!SteamIDHex || SteamIDHex="PyreProteccAC")
		Return

	if(Cache[SteamIDHex].FlagURL)
		Return Cache[SteamIDHex].FlagURL

	if(!Cache[SteamIDHex].Count())
		Cache[SteamIDHex] := {}

	HTML := GetSteamHTML(SteamIDHex)
	Loop,Parse,HTML,`n,`r
	{
		if(InStr(A_LoopField,"countryflags"))
		{
			Temp := A_LoopField
			Loop,25
			{
				if(InStr(StrSplit(Temp,"""")[A_Index],"countryflags"))
				{
					Cache[SteamIDHex].FlagURL := StrSplit(Temp,"""")[A_Index]
					Return Cache[SteamIDHex].FlagURL
				}
			}
		}
	}
	Return
}

GetImagePath(SteamIDHex)
{
	ImageDir := A_ScriptDir . "\Images\Profile Pictures"
	IfNotExist,%ImageDir%
		FileCreateDir,%ImageDir%

	DefaultImage := ImageDir . "\Default.jpg"
	if(!FileExist(DefaultImage))
		UrlDownloadToFile,% "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg",% DefaultImage
	
	if(Cache[SteamIDHex].ImagePath)
		Return Cache[SteamIDHex].ImagePath

	if(!SteamIDHex || SteamIDHex="PyreProteccAC" || !GetSteamAvatarURL(SteamIDHex) || GetSteamAvatarURL(SteamIDHex)="https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg")
		Return DefaultImage

	if(!Cache[SteamIDHex].Count())
		Cache[SteamIDHex] := {}	
	
	UrlDownloadToFile, % GetSteamAvatarURL(SteamIDHex),% ImageDir . "\" . HexToInt(SteamIDHex) . ".jpg"
	if(ErrorLevel=0)
	{
		Cache[SteamIDHex].ImagePath := ImageDir . "\" . HexToInt(SteamIDHex) . ".jpg"
		Return Cache[SteamIDHex].ImagePath
	}
	
}

GetFlagPath(SteamIDHex)
{
	ImageDir := A_ScriptDir . "\Images\Flags"
	IfNotExist,%ImageDir%
		FileCreateDir,%ImageDir%

	if(!SteamIDHex || SteamIDHex="PyreProteccAC")
		Return
		
	if(Cache[SteamIDHex].FlagPath)
		Return Cache[SteamIDHex].FlagPath
	
	Loop,25
	{
		if(InStr(StrSplit(GetSteamFlagURL(SteamIDHex),["""","/"])[A_Index],".gif"))
			FlagName := StrSplit(GetSteamFlagURL(SteamIDHex),["""","/"])[A_Index]
	}
	
	if(FileExist(ImageDir . "\" . FlagName))
	{
		Cache[SteamIDHex].FlagPath := ImageDir . "\" . FlagName
		Return Cache[SteamIDHex].FlagPath
	}
	
	UrlDownloadToFile, % GetSteamFlagURL(SteamIDHex), % ImageDir . "\" . FlagName
	if(ErrorLevel=0)
	{
		Cache[SteamIDHex].FlagPath := ImageDir . "\" . FlagName
		Return Cache[SteamIDHex].FlagPath
	}
	
	Return
}
