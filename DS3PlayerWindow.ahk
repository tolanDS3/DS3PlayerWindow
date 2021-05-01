; DS3PlayerWindow v1.2

#NoEnv
#SingleInstance Force
#Include <ClassMemory>
SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Global PlayerOffsets := [0x38,0x70,0xA8,0xE0,0x118]
Global Player := []
Loop,5
    Player[A_Index] := {}
Global InvadeType := {0:"Host",1:"Phantom",2:"Dark Spirit (Red Summon)",3:"Dark Spirit (Invader)",4:"Mound-Maker (White Summon)",6:"Spear of the Church",7:"Blade of the Darkmoon",9:"Watchdog of Farron",10:"Aldrich Faithful",12:"Arena",14:"Warrior of Sunlight (White Summon)",15:"Warrior of Sunlight (Red Summon)",16:"Mound-Maker (Red Summon)",17:"Warrior of Sunlight (Invader)",18:"Mound-Maker (Invader)",21:"Blue Sentinel"}

; Read/writedefault settings from/to INI
Global Window := []
For Index, Element in {"X":1520,"Y":0,"Transparency":200,"Color":"000000","Font":"Calibri"}
{
    IniRead,Temp,DS3PlayerWindow.ini,Window,%Index%
    If(Temp="ERROR") {
        IniWrite,%Element%,DS3PlayerWindow.ini,Window,%Index%
        Window[Index] := Element
    } else {
        Window[Index] := Temp
    }
}
Global LabelColor := []
For Index, Element in {"Host":"00FF00","Phantom":"FFFFFF","Dark Spirit (Red Summon)":"FF0000","Dark Spirit (Invader)":"FF0000","Mound-Maker (White Summon)":"FF00FF","Spear of the Church":"8000FF","Blade of the Darkmoon":"0000FF","Watchdog of Farron":"8000FF","Aldrich Faithful":"8000FF","Arena":"FFFFFF","Warrior of Sunlight (White Summon)":"FFFF00","Warrior of Sunlight (Red Summon)":"FF8000","Mound-Maker (Red Summon)":"FF00FF","Warrior of Sunlight (Invader)":"FF8000","Mound-Maker (Invader)":"FF00FF","Blue Sentinel":"0000FF"}
{
    IniRead,Temp,DS3PlayerWindow.ini,LabelColor,%Index%
    If(Temp="ERROR") {
        IniWrite,%Element%,DS3PlayerWindow.ini,LabelColor,%Index%
        LabelColor[Index] := Element
    } else {
        LabelColor[Index] := Temp
    }    
}


; Cache
Global CacheFormat := ["Name","Level","MaxHP","MaxFP","MaxSP","Vigor","Attunement","Endurance","Vitality","Strength","Dexterity","Intelligence","Faith","Luck","Head","Chest","Hands","Legs","Ring1","Ring2","Ring3","Ring4","RightHand1","RightHand2","RightHand3","LeftHand1","LeftHand2","LeftHand3","SteamID","SteamName","Avatar","Country"]
Global ImageCache := []
Global Cache := []
Loop,Read,Players.dat
{
    Array := StrSplit(A_LoopReadLine,A_Tab)
    PlayerIdentifier := Array[1] . A_Tab . Array[29]
    ; Ignore column header
    if(PlayerIdentifier="Name" . A_Tab . "SteamID")
        Continue
    Cache[PlayerIdentifier] := {}
    OutputDebug, % "Created cache entry [" PlayerIdentifier "]`n"
    For Index,Element in CacheFormat
        Cache[PlayerIdentifier,Element] := Array[Index]
}


; Initialize OSD window
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
WinSet, Transparent, % Window["Transparency"]

; Done.
SetTimer,UpdateOSD,16
SetTimer,UpdateCacheFile,10000

Return

UpdateOSD:

	Game := new _ClassMemory("ahk_exe DarkSoulsIII.exe", "", hProcessCopy)
	if(!isObject(Game))
	{
		Gui,Show,Hide
		Return
	}
	BaseB := Game.BaseAddress + 0x4768E78

    ActivePlayers := []
	ActivePlayers := GetActivePlayers()
	if(!ActivePlayers.Count())
	{
		Gui,Show,Hide
		Return
	}
	Window["Height"] := ActivePlayers.Count()*80

	if(!WinActive("DARK SOULS III"))
		Gui,Show,Hide
    
    For Index,ActivePlayer in ActivePlayers
    {
        PlayerOffset := PlayerOffsets[ActivePlayer]

        Player[ActivePlayer].Name           := Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,PlayerOffset,0x1FA0,0x88)
        Player[ActivePlayer].Level          := Game.Read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x70)
        Player[ActivePlayer].SteamID        := GetSteamInfo("ID",Game.readString(BaseB,length:=32,encoding:="utf-16",0x40,PlayerOffset,0x1FA0,0x7D8))

        Player[ActivePlayer].HP             := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x18)
        Player[ActivePlayer].MaxHP          := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x1C)
        Player[ActivePlayer].MaxFP          := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x2C)
        Player[ActivePlayer].MaxSP          := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x3C)

        Player[ActivePlayer].Vigor          := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x44)
        Player[ActivePlayer].Attunement     := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x48)
        Player[ActivePlayer].Endurance      := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x4C)
        Player[ActivePlayer].Vitality       := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x6C)
        Player[ActivePlayer].Strength       := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x50)
        Player[ActivePlayer].Dexterity      := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x54)
        Player[ActivePlayer].Intelligence   := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x58)
        Player[ActivePlayer].Faith          := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x5C)
        Player[ActivePlayer].Luck           := Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x60)

        Player[ActivePlayer].RightHand1     := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x330))
        Player[ActivePlayer].RightHand2     := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x338))
        Player[ActivePlayer].RightHand3     := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x340))
        Player[ActivePlayer].LeftHand1      := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x32C))
        Player[ActivePlayer].LeftHand2      := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x334))
        Player[ActivePlayer].LeftHand3      := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x33C))
        Player[ActivePlayer].Chest          := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x360))
        Player[ActivePlayer].Hands          := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x364))
        Player[ActivePlayer].Legs           := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x368))
        Player[ActivePlayer].Head           := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x35C))
        Player[ActivePlayer].Ring1          := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x370))
        Player[ActivePlayer].Ring2          := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x374))
        Player[ActivePlayer].Ring3          := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x378))
        Player[ActivePlayer].Ring4          := GetItemName(Game.read(BaseB,"Int",0x40,PlayerOffset,0x1FA0,0x37C))

        Player[ActivePlayer].InvadeType     := InvadeType[Game.read(BaseB,"Char",0x40,PlayerOffset,0x1FA0,0xFC)]

        Player[ActivePlayer].SteamName      := GetSteamInfo("Name",Player[ActivePlayer].SteamID)
        Player[ActivePlayer].Avatar         := GetSteamInfo("Avatar",Player[ActivePlayer].SteamID)
        Player[ActivePlayer].Country        := GetSteamInfo("Country",Player[ActivePlayer].SteamID)

		GuiControlGet,Temp,,Name%Index%
		if(Player[ActivePlayer].Name<>Temp)
		{
			GuiControl,-Redraw,Name%Index%	
			if(LabelColor[Player[ActivePlayer].InvadeType])
				GuiControl,% "+c" . LabelColor[Player[ActivePlayer].InvadeType],Name%A_Index%
			else
				GuiControl,+cFFFFFF,Name%A_Index%
			GuiControl,,Name%Index%,% Player[ActivePlayer].Name
			GuiControl,+Redraw,Name%Index%
		}

		GuiControlGet,Temp,,Steam%Index%
		if(Player[ActivePlayer].SteamName<>Temp)
		{
			GuiControl,-Redraw,Steam%Index%
			GuiControl,,Steam%Index%,% Player[ActivePlayer].SteamName
			GuiControl,+Redraw,Steam%Index%
		}        

		GuiControlGet,Temp,,Level%Index%
		if("Lv." . Player[ActivePlayer].Level<>Temp)
		{
			GuiControl,-Redraw,Level%Index%
			GuiControl,,Level%Index%,% "Lv." . Player[ActivePlayer].Level
			GuiControl,+Redraw,Level%Index%
		}

		GuiControlGet,Temp,,Bar%Index%
		if(Player[ActivePlayer].HP<>Temp)
		{
			GuiControl,-Redraw,Bar%Index%
			Temp := Player[ActivePlayer].MaxHP
			GuiControl,+Range0-%Temp%,Bar%Index%
			GuiControl,,Bar%Index%,% Player[ActivePlayer].HP
			GuiControl,+Redraw,Bar%Index%
		}
		
		GuiControlGet,Temp,,HP%Index%
		if(Player[ActivePlayer].HP . " / " . Player[ActivePlayer].MaxHP <> Temp)
		{
			GuiControl,-Redraw,HP%Index%
			GuiControl,,HP%Index%,% Player[ActivePlayer].HP . " / " . Player[ActivePlayer].MaxHP
			GuiControl,+Redraw,HP%Index%
		}

		FlagPath := ""
		if(Player[ActivePlayer].Country<>-1)
			FlagPath := A_ScriptDir . "\Images\Flags\" . Player[ActivePlayer].Country ".gif"
		if(FlagPath<>ImageCache["Flag" . Index])
		{
			GuiControl,-Redraw,Flag%Index%
			GuiControl,,Flag%Index%,% FlagPath
			ImageCache["Flag" . Index] := FlagPath
			GuiControl,Move,Flag%Index%,w16 h11
			GuiControl,+Redraw,Flag%Index%
		}

        AvatarPath := ""
        if(Player[ActivePlayer].Avatar="fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb") {
            AvatarPath := A_ScriptDir . "\Images\Avatars\Default.jpg"
        } else {
            AvatarLocation := A_ScriptDir . "\Images\Avatars\" . Player[ActivePlayer].SteamID . ".jpg"
            if(FileExist(AvatarLocation)) {
                AvatarPath := AvatarLocation
            } else {
                URL := "https://cdn.akamai.steamstatic.com/steamcommunity/public/images/avatars/" . Player[ActivePlayer].Avatar . "_full.jpg"
                OutputDebug, % "Downloading avatar from Steam/" Player[ActivePlayer].Avatar "`n"
                StartTime := A_TickCount
                UrlDownloadToFile, % URL,% AvatarLocation
                if(ErrorLevel=0) {
                    OutputDebug, % "Download image completed in " (A_TickCount-StartTime) "ms.`n"
                    AvatarPath := AvatarLocation        
                }
            }
        }
        if(AvatarPath<>ImageCache["Avatar" . Index])
		{
			GuiControl,-Redraw,Pic%Index%
			GuiControl,,Pic%Index%,% AvatarPath
			ImageCache["Avatar" . Index] := AvatarPath
			GuiControl,Move,Pic%Index%,w64 h64
			GuiControl,+Redraw,Pic%Index%
		}

        UpdateCache(ActivePlayer)
    }

    Game := ""
	if(WinActive("DARK SOULS III"))
		Gui Show, % "w400 h" . Window["Height"] . " x" . Window["X"] . " y" . Window["Y"] . " NoActivate"

Return

UpdateCache(PlayerNumber)
{
    PlayerIdentifier := Player[PlayerNumber].Name . A_Tab . Player[PlayerNumber].SteamID
    if(PlayerIdentifier = A_Tab)
        Return
        
    if (!Cache[PlayerIdentifier])
    {
        OutputDebug, % PlayerIdentifier " not found in cache, creating new cache entry.`n"
        Cache[PlayerIdentifier] := {}
        For Index,Element in CacheFormat
        {
            if(Player[PlayerNumber,Element])
                Cache[PlayerIdentifier,Element] := Player[PlayerNumber,Element]
        }
    }
    Else
    {
        ;OutputDebug, % "Found cache entry [" PlayerIdentifier "]`n"
        For Index,Element in CacheFormat
        {
            if(Element="Name" || Element="SteamID" || Element="SteamName" || Element="Avatar" || Element="Country")
                Continue

            CurrentValue := Player[PlayerNumber,Element]
            if(!CurrentValue)
                Continue

            ;OutputDebug, % "Setting CurrentValue of " Element " to " Player[PlayerNumber,Element] "`n"

            if(!Cache[PlayerIdentifier,Element])
            {
                ;OutputDebug, % "Found a match vs empty cache, updating cache. " CurrentValue
                Cache[PlayerIdentifier,Element] := CurrentValue
            }
            Else
            {
                KnownValues := StrSplit(Cache[PlayerIdentifier,Element],";")
                MatchFound := False
                CacheType := Element
                For Index,Element in KnownValues
                {
                    ;OutputDebug, % "Comparing " Element " and " CurrentValue "`n"
                    if(Element=CurrentValue)
                        MatchFound := True
                }
                if(!MatchFound)
                    Cache[PlayerIdentifier,CacheType] := Cache[PlayerIdentifier,CacheType] . ";" . CurrentValue
            }
        }
    }
}

UpdateCacheFile:
	FileDelete,Players.dat
    FileHeader := ""
    For Index,Element in CacheFormat
        FileHeader := FileHeader . Element . A_Tab
    FileAppend,% FileHeader . "`n",Players.dat,UTF-16
	PlayerData := ""
	For Entry in Cache
	{
        For Index,Element in CacheFormat
            PlayerData := PlayerData . Cache[Entry,Element] . A_Tab

        PlayerData := PlayerData . "`n"
	}
	FileAppend,% PlayerData,Players.dat,UTF-16
Return