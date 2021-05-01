
; Type can be one of ID, HTML, Name, Avatar, Country
GetSteamInfo(Type,ID)
{
    Static aHTML:=[],aName:=[],aAvatar:=[],aCountry:=[],FirstRun
    if(!FirstRun)
    {
        Loop,Read,Players.dat
        {
            Array := StrSplit(A_LoopReadLine,A_Tab)
            PlayerIdentifier := Array[29]
            ; Ignore column header
            if(PlayerIdentifier="SteamID")
                Continue

            aName[PlayerIdentifier] := Array[30]
            aAvatar[PlayerIdentifier] := Array[31]
            aCountry[PlayerIdentifier] := Array[32]
        }
        FirstRun := 1
    }
    
    if(!ID || !Type)
        Return

    Switch Type
    {
        Case "ID":
            if(ID="PyreProteccAC")
                Return ID
            Return hex2int(ID)
        Case "HTML":
            if(ID="PyreProteccAC")
                Return -1
            if(aHTML[ID])
                Return aHTML[ID]
            StartTime := A_TickCount
            OutputDebug, % "Downloading HTML from Steam/" ID "`n"
            whr := ComObjCreate("WinHttp.WinHttpRequest.5.1")
            URL := "https://steamcommunity.com/profiles/" . ID
            whr.Open("GET",URL, true)
            whr.Send()
            whr.WaitForResponse()
            OutputDebug, % "Download completed in " (A_TickCount-StartTime) "ms.`n"
            aHTML[ID] := whr.ResponseText
            Return aHTML[ID]
		Case "Name":
            if(ID="PyreProteccAC")
                Return "Hidden by PyreProtecc"        
			if(aName[ID])
				Return aName[ID]
			HTML := GetSteamInfo("HTML",ID)
			Loop,Parse,HTML,`n,`r
			{
				if(InStr(A_LoopField,"Steam Community :: "))
				{
					Array := StrSplit(A_LoopField,[" :: ","<",">"])
					For Index,Element in Array
					{
						if(Element="Steam Community")
						{
							aName[ID] := ReplaceHTMLEntities(Array[Index+1])
							Return aName[ID]
						}
					}
				}
			}
			Return -1
		Case "Avatar":
            if(ID="PyreProteccAC")
                Return "fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb"        
			if(aAvatar[ID])
				Return aAvatar[ID]
			HTML := GetSteamInfo("HTML",ID)
			Loop,Parse,HTML,`n,`r
			{
				if(InStr(A_LoopField,"full.jpg"))
				{
					Array := StrSplit(A_LoopField,"""")
					For Index,Element in Array
					{
						if(InStr(Element,"full.jpg"))
						{
							aAvatar[ID] := SubStr(Element,73,43)
							Return aAvatar[ID]
						}
					}
				}
			}
            Return "fe/fef49e7fa7e1997310d705b2a6158ff8dc1cdfeb"
		Case "Country":
            if(ID="PyreProteccAC")
                Return -1
			if(aCountry[ID])
				Return aCountry[ID]
			HTML := GetSteamInfo("HTML",ID)
			Loop,Parse,HTML,`n,`r
			{
				if(InStr(A_LoopField,"countryflags"))
				{
					Array := StrSplit(A_LoopField,"""")
					For Index,Element in Array
					{
						if(InStr(Element,"countryflags"))
						{
							aCountry[ID] := SubStr(Element,69,2)
                            ;StringUpper,aCountry[ID],aCountry[ID]
							Return aCountry[ID]
						}
					}
				}
			}
			Return -1
    }
}

ReplaceHTMLEntities(String)
{
    HTMLEntities := {"&quot;":"""","&amp;":"&","&lt;":"<","&gt;":">","&OElig;":"Œ","&oelig;":"œ","&Scaron;":"Š","&scaron;":"š","&Yuml;":"Ÿ","&circ;":"ˆ","&tilde;":"˜","&ndash;":"–","&mdash;":"—","&lsquo;":"‘","&rsquo;":"’","&sbquo;":"‚","&ldquo;":"“","&rdquo;":"”","&bdquo;":"„","&dagger;":"†","&Dagger;":"‡","&permil;":"‰","&lsaquo;":"‹","&rsaquo;":"›","&euro;":"€"}
    For Index,Element in HTMLEntities
        String := StrReplace(String,Index,Element)
    Return String
}