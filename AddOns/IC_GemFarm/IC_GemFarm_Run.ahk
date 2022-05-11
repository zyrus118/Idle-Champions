#SingleInstance, force

#include %A_LineFile%\..\..\..\SharedFunctions\json.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\classVirtualKeyInputs.ahk
VirtualKeyInputs.Init( "ahk_exe IdleDragons.exe" )

#include %A_LineFile%\..\..\..\SharedFunctions\IC_SharedFunctions_Class.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\IC_SharedFunctions_Class_MV2.ahk
global g_SF := new IC_SharedFunctions_Class_MV2

#include %A_LineFile%\..\..\..\SharedFunctions\IC_Leveling_Class.ahk
global g_Level := new IC_Leveling_Class

#include %A_LineFile%\..\..\..\ServerCalls\IC_ServerCalls_Class.ahk

#include %A_LineFile%\..\..\..\Logging\IC_Log_Class.ahk
global g_Log := new _classLog("Gem Farm")

#include %A_LineFile%\..\..\..\SharedFunctions\MemoryRead2\IC_MemoryReader_Class.ahk
MemoryReader.Refresh()

#Include %A_LineFile%\..\IC_GemFarm_Functions.ahk
global g_GemFarm := new IC_GemFarm_Functions

;load settings
global g_GemFarmSettings := g_SF.LoadObjectFromJSON( A_LineFile . "\..\Settings.json" )
;check settings load
If !IsObject( g_GemFarmSettings )
{
    msgbox, Failed to Load Settings, exiting app
    ExitApp
}
g_GemFarm.Settings := g_GemFarmSettings

g_GemFarm.GemFarm()