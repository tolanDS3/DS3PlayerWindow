GetItemName(Int)
{
    Static ItemName := []
    if(!ItemName.Count())
    {
        Loop,Read,Items.dat
        {
            if(InStr(A_LoopReadLine,"###"))
            {
                Category := StrSplit(A_LoopReadLine," ")[2]
                Continue
            }
            If(!InStr(A_LoopReadLine,"|"))
                Continue
            Array := StrSplit(A_LoopReadLine,["|","("])
            IDHex := Trim(Array[1])
            if(IDHex="Id" || IDHex="--------")
                Continue
            ID := hex2int(IDHex)
            Name := Trim(Array[2])
            ItemName[IDHex] := Name
            if(Category="Weapons")
            {
                Loop,10
                {
                    UpgradeName := Name . "+" . A_Index
                    UpgradeID := ID + A_Index
                    ItemName[int2hex(UpgradeID)] := UpgradeName
                }
            }
        }
    }
    
    if(Int<1 || Int=110000 || Int=900000 || Int=901000 || Int=902000 || Int=903000)
        Return

    IDHex := int2hex(Int)
    if(ItemName[IDHex])
        Return ItemName[IDHex]
    Return IDHex

}