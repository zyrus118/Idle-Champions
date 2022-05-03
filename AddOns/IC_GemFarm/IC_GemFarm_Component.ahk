GUIFunctions.AddTab("Gem Farm")

Gui, ICScriptHub:Tab, Gem Farm
Gui, ICScriptHub:Add, Button, x15 y+15 w160 gGemFarm_Run, Launch Gem Farm
string := "Gem Farm:"
string .= "`nA script to automate gem farming. Requires Modron Automation and Briv.`n"
string .= "`nInstructions:"
string .= "`n1. Enter settings below."
string .= "`n2. Press save."
string .= "`n3. Press Launch Gem Farm."
string .= "`n4. A separate script will launch and begin farming gems. Only close this script when you are done gem farming."
string .= "`n5. A selection of statistics will update approximately ever 5 seconds."
Gui, ICScriptHub:Add, Text, x15 y+15 w450, % string

Gui, ICScriptHub:Add, Text, x15 y+15 w450, Settings:

Gui, ICScriptHub:Add, Text, x15 y+15 w200 vGemFarmStats, Stats: OFF
Gui, ICScriptHub:Add, Text, x15 y+10 w200 vGemFarmBPH, BPH:
Gui, ICScriptHub:Add, Text, x15 y+5 w200 vGemFarmGPH, GPH:
Gui, ICScriptHub:Add, Text, x15 y+5 w200 vGemFarmRunTime,

Gui, ICScriptHub:Add, Button, x15 y+15 w160 gGemFarm_ResetStats, Reset Stats

Gui, ICScriptHub:Add, Button, x15 y+15 w160 gGemFarm_EndStats, Toggle Stats On/Off

global g_GemFarmStats

GemFarm_Run()
{
    ;Run, %A_LineFile%\..\GemFarm.ahk
    g_GemFarmStats := new IC_GemFarm_Component
    g_GemFarmStats.UpdateStats()
}

GemFarm_ResetStats()
{
    g_GemFarmStats.gemsStart := g_GemFarmStats.Gems
    g_GemFarmStats.coreXPstart := g_GemFarmStats.CoreXP
    g_GemFarmStats.startTickCount := A_TickCount
}

GemFarm_EndStats()
{
    if (g_GemFarmStats.Update)
        g_GemFarmStats.Update := false
    else
        g_GemFarmStats.UpdateStats()
}

class IC_GemFarm_Component
{
    __new()
    {
        MemoryReader.CheckForIC()
        MemoryReader.Refresh()
        this.gameInstance := MemoryReader.InitGameInstance()
        this.gemsStart := this.Gems
        this.coreXPstart := this.CoreXP
        this.startTickCount := A_TickCount
        return this
    }

    UpdateStats()
    {
        this.Update := true
        GuiControl, ICScriptHub:, GemFarmStats, Stats: ON
        while (this.Update)
        {
            MemoryReader.Refresh()
            GuiControl, ICScriptHub:, GemFarmBPH, % "Bosses Per Hour: " . this.BPH
            GuiControl, ICScriptHub:, GemFarmGPH, % "Gems Per Hour: " . this.GPH
            GuiControl, ICScriptHub:, GemFarmRunTime, % "Run Time (Hours): " Round(this.RunTime, 2)
            sleep, 5000
        }
        GuiControl, ICScriptHub:, GemFarmStats, Stats: OFF
    }

    RunTime[]
    {
        get
        {
            return (A_TickCount - this.startTickCount) / 3600000
        }
    }

    GPH[]
    {
        get
        {
            return Round( (this.Gems - this.gemsStart) / this.RunTime, 2)
        }
    }

    BPH[]
    {
        get
        {
            return Round( ( (this.CoreXP - this.coreXPStart) / this.RunTime ) / 5, 2)
        }
    }

    Gems[]
    {
        get
        {
            return this.gameInstance.Controller.userData.redRubies.GetValue()
        }
    }

    ActiveGameInstance[]
    {
        get
        {
            return this.gameInstance.Controller.userData.ActiveUserGameInstance.GetValue()
        }
    }

    CoreXP[]
    {
        get
        {
            modronHandler := this.gameInstance.Controller.userData.ModronHandler
            _size := modronHandler.modronSaves.Size()
            loop %_size%
            {
                core := modronHandler.modronSaves.Item[A_Index - 1]
                if (core.InstanceID.GetValue() == this.ActiveGameInstance)
                    return core.ExpTotal.GetValue()
            }
            return ""
        }
    }
}