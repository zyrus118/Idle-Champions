#SingleInstance, force

#Include %A_LineFile%\..\IC_GemFarm_Functions.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\json.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\IC_SharedFunctions_Class.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\IC_Leveling_Class.ahk
#include %A_LineFile%\..\..\..\ServerCalls\IC_ServerCalls_Class.ahk
#include %A_LineFile%\..\..\..\Logging\IC_Log_Class.ahk
#include %A_LineFile%\..\..\..\SharedFunctions\MemoryRead2\IC_MemoryReader_Class.ahk

global g_Log := new _classLog("Gem Farm")
global g_GemFarm := new IC_GemFarm_Functions
g_GemFarm.Log := g_Log

g_GemFarm.GemFarm()