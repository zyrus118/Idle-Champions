GUIFunctions.AddTab("Offset Updater")

Gui, ICScriptHub:Tab, Offset Updater
Gui, ICScriptHub:Add, Button, x15 y+15 w160 gOSUpdater_Steam, Update Steam Offsets
Gui, ICScriptHub:Add, Button, x15 y+15 w160 gOSUpdater_EGS, Update EGS Offsets
string := "Instructions:`n"
string .= "`nFirst Time Steps:"
string .= "`nA. Copy the file named ScriptHubExport.lua saved at: " 
string .= A_ScriptDir . "\AddOns\IC_Offset_Updater" . " to the autorun folder in your Cheat Engine install directory."
string .= "`nB. Copy the file named MonoDataCollector.frm saved at: "
string .= A_ScriptDir . "\AddOns\IC_Offset_Updater" . "\forms to the autorun\forms folder in your Cheat Engine install directory."
string .= "`nNOTE: The above two steps may require administrator privelages.`n"
string .= "`n1. Launch Cheat Engine and open the Idle Champions Process."
string .= "`n2. Select 'Activate mono features' from the 'Mono' pull down menu."
string .= "`n3. Select 'Dissect mono' from the 'Mono' pull down menu or press Ctrl+Alt+M."
string .= "`n4. From the mono dissector window, select 'Save Export for Script Hub' from the 'File' pull down menu."
string .= "`n5. In the 'Save file as' dialog pop up, browse to the following location: "
string .= A_ScriptDir . "\SharedFunctions\MemoryRead2\Structures"
string .= "`n6. In the 'File name:' edit box, enter '32-ScriptHubExport.json' for Steam or '64-ScriptHubExport.json' for EGS."
string .= "`n7. Press okay and be patient. Exporting the data may take several minutes."
string .= "`n8. Press the 'Update Steam Offsets' for Steam or 'Update EGS Offsets' for EGS on the Offset Updater tab of Script Hub."
string .= "`n9. Using your favorite code editor, compare the new files in the Structures folder noted in step 7 to their originals."
string .= "`n10. If there are no errors noted in the differential, back up the originals, rename the new files to match the originals, "
string .= "submit a pull request with the updated files, and notify the official discord."
string .= "`n11. If there are errors, please share the new files on the discord so we can debug."

Gui, ICScriptHub:Add, Text, x15 y+15 w475, % string

OSUpdater_Steam()
{
    test := new UpdateMemoryStructures("Steam")
    msgbox, Steam Offsets Updated
}

OSUpdater_EGS()
{
    test := new UpdateMemoryStructures("EGS")
    msgbox, EGS Offsets Updated
}

#include %A_LineFile%\..\IC_OffsetUpdater_Functions.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\classExceptionHandler.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\ObjRegisterActive.ahk