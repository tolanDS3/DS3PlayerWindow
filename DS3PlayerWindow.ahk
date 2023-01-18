#NoEnv
#Persistent
#SingleInstance Force
#Include <ClassMemory>

SetWorkingDir %A_ScriptDir%
SetBatchLines -1

Global Player := []
Loop,5
    Player[A_Index] := {}

Global ImageCache := []
Global AvatarCache := []
Global NameCache := []

Gui Color, 000000
Gui +LastFound +AlwaysOnTop -Caption +ToolWindow
Gui Add, Picture, vPic1 x8 y8 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic2 x8 y88 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic3 x8 y168 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic4 x8 y248 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Add, Picture, vPic5 x8 y328 w64 h64 +0x2, .\Images\Profile Pictures\Default.jpg
Gui Font, s13 c0xFFFFFF, Calibri
Gui Add, Text, vName1 x80 y8 w250 h20
Gui Add, Text, vName2 x80 y88 w250 h20
Gui Add, Text, vName3 x80 y168 w250 h20
Gui Add, Text, vName4 x80 y248 w250 h20
Gui Add, Text, vName5 x80 y328 w250 h20
Gui Font, s12 c0xFFFFFF, Calibri
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
Gui Font, s8 c0xFFFFFF, Calibri
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
WinSet, Transparent, 200

SetTimer,UpdateOSD,16
Return

UpdateOSD:
	Game := new _ClassMemory("ahk_exe DarkSoulsIII.exe", "", hProcessCopy)
	if(!isObject(Game))
	{
		Gui,Show,Hide
		Return
	}
    
    if(!WinActive("DARK SOULS III"))
		Gui,Show,Hide

    WorldChrMan := Game.BaseAddress + 0x477FDB8
    GameDataMan := Game.BaseAddress + 0x47572B8

    PlayerCount := 0
    Loop,5
    {
        Offset := "0x" . Format("{:x}",A_Index * 0x38)
        Player[A_Index].Name := Game.readString(WorldChrMan,length:=32,encoding:="utf-16",0x40,Offset,0x1FA0,0x88)
        Player[A_Index].SteamID := Format("{:i}", "0x" . Game.readString(WorldChrMan,length:=32,encoding:="utf-16",0x40,Offset,0x1FA0,0x7D8))
        Player[A_Index].SteamName := GetSteamName(Player[A_Index].SteamID)
        Player[A_Index].SteamAvatar := GetSteamAvatar(Player[A_Index].SteamID)
        Player[A_Index].HP := Game.read(WorldChrMan,"Int",0x40,Offset,0x1FA0,0x18)
        Player[A_Index].MaxHP := Game.read(WorldChrMan,"Int",0x40,Offset,0x1FA0,0x1C)
        Player[A_Index].Level := Game.read(WorldChrMan,"Int",0x40,Offset,0x1FA0,0x70)

        if(Player[A_Index].Level)
        {
            PlayerCount++

            GuiControlGet,Temp,,Name%PlayerCount%
            if(Player[A_Index].Name<>Temp)
            {
                GuiControl,-Redraw,Name%PlayerCount%	
                if(LabelColor[Player[A_Index].InvadeType])
                    GuiControl,% "+c" . LabelColor[Player[A_Index].InvadeType],Name%PlayerCount%
                else
                    GuiControl,+cFFFFFF,Name%PlayerCount%
                GuiControl,,Name%PlayerCount%,% Player[A_Index].Name
                GuiControl,+Redraw,Name%PlayerCount%
            }

            GuiControlGet,Temp,,Steam%PlayerCount%
            if(Player[A_Index].SteamName<>Temp)
            {
                GuiControl,-Redraw,Steam%PlayerCount%
                GuiControl,,Steam%PlayerCount%,% Player[A_Index].SteamName
                GuiControl,+Redraw,Steam%PlayerCount%
            }        

            GuiControlGet,Temp,,Level%PlayerCount%
            if("Lv." . Player[A_Index].Level<>Temp)
            {
                GuiControl,-Redraw,Level%PlayerCount%
                GuiControl,,Level%PlayerCount%,% "Lv." . Player[A_Index].Level
                GuiControl,+Redraw,Level%PlayerCount%
            }

            GuiControlGet,Temp,,Bar%PlayerCount%
            if(Player[A_Index].HP<>Temp)
            {
                Temp := Player[A_Index].MaxHP
                GuiControl,-Redraw,Bar%PlayerCount%
                GuiControl,+Range0-%Temp%,Bar%PlayerCount%
                GuiControl,,Bar%PlayerCount%,% Player[A_Index].HP
                GuiControl,+Redraw,Bar%PlayerCount%
            }
            
            GuiControlGet,Temp,,HP%PlayerCount%
            if(Player[A_Index].HP . " / " . Player[A_Index].MaxHP <> Temp)
            {
                GuiControl,-Redraw,HP%PlayerCount%
                GuiControl,,HP%PlayerCount%,% Player[A_Index].HP . " / " . Player[A_Index].MaxHP
                GuiControl,+Redraw,HP%PlayerCount%
            }

            if(Player[A_Index].SteamAvatar <> ImageCache[PlayerCount])
            {
                GuiControl,-Redraw,Pic%PlayerCount%
                GuiControl,,Pic%PlayerCount%,% Player[A_Index].SteamAvatar
                ImageCache[PlayerCount] := Player[A_Index].SteamAvatar
                GuiControl,Move,Pic%PlayerCount%,w64 h64
                GuiControl,+Redraw,Pic%PlayerCount%
            }


        }
    }

    if(!PlayerCount)
    {
		Gui,Show,Hide
		Return           
    }
    WindowHeight := PlayerCount * 80

	if(WinActive("DARK SOULS III"))
		Gui Show, % "w400 h" . WindowHeight . " x1520 y0 NoActivate"

Return

GetSteamName(SteamID)
{
    if(StrLen(SteamID)<>17 || SubStr(SteamID,1,4)<>"7656")
        Return -1
    if(NameCache[SteamID])
        Return NameCache[SteamID]
    
    XMLPath := A_ScriptDir . "\XML\" . SteamID . ".xml"
    if(!FileExist(XMLPath))
    {
        URL := "https://steamcommunity.com/profiles/" . SteamID . "/?xml=1"
        UrlDownloadToFile, % URL, % XMLPath
    }

    if(FileExist(XMLPath))
    {
        FileEncoding, UTF-8
        Loop,Read,% XMLPath
        {
            if(InStr(A_LoopReadLine,"<steamID><![CDATA["))
            {
                SteamName := StrReplace(StrReplace(StrReplace(A_LoopReadLine,A_Tab),"<steamID><![CDATA["),"]]></steamID>")
                NameCache[SteamID] := SteamName
                Return SteamName
            }            
        }
    }

    Return ""
}

GetSteamAvatar(SteamID)
{
    if(StrLen(SteamID)<>17 || SubStr(SteamID,1,4)<>"7656")
        Return -1
    if(AvatarCache[SteamID])
        Return AvatarCache[SteamID]

    AvatarPath := A_ScriptDir . "\Images\Profile Pictures\" . SteamID . ".jpg"
    if(FileExist(AvatarPath))
    {
        AvatarCache[SteamID] := AvatarPath
        Return AvatarPath
    }

    XMLPath := A_ScriptDir . "\XML\" . SteamID . ".xml"
    if(!FileExist(XMLPath))
    {
        URL := "https://steamcommunity.com/profiles/" . SteamID . "/?xml=1"
        UrlDownloadToFile, % URL, % XMLPath
    }

    if(FileExist(XMLPath))
    {
        FileEncoding, UTF-8
        Loop,Read,% XMLPath
        {
            if(InStr(A_LoopReadLine,"<avatarFull><![CDATA["))
            {
                URL := StrReplace(StrReplace(StrReplace(A_LoopReadLine,A_Tab),"<avatarFull><![CDATA["),"]]></avatarFull>")
                If(Instr(URL,"fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb_full.jpg"))
                {
                    AvatarPath := A_ScriptDir . "\Images\Profile Pictures\Default.jpg"
                    AvatarCache[SteamID] := AvatarPath
                    Return AvatarPath
                }
                UrlDownloadToFile, % URL, % AvatarPath
            }            
        }
    }

    if(FileExist(AvatarPath))
    {
        AvatarCache[SteamID] := AvatarPath
        Return AvatarPath
    }    

    AvatarPath := A_ScriptDir . "\Images\Profile Pictures\Default.jpg"
    AvatarCache[SteamID] := AvatarPath
    Return AvatarPath   
}
