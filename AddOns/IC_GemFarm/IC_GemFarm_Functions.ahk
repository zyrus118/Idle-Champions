class IC_GemFarm_Functions
{
    __new()
    {
        ;1000 ms per sec, 60 sec per min, 60 min per hour, reload script every 12 hours
        ;reloading helps keep key inputs more reliable and faster
        this.ReloadTime := ( 1000 * 60 * 60 * 12 ) + A_TickCount
        MemoryReader.Refresh()
        this.IdleGameManager := MemoryReader.InitIdleGameManager()
        this.GameInstance := MemoryReader.InitGameInstance()
        this.Briv := new IC_BrivHandler_Class(58)
        this.Stats := this.GameInstance.Controller.userData.StatHandler
        return this
    }

    ;these should probably be handled differently
    CurrentZone[]
    {
        get
        {
            return this.GameInstance.ActiveCampaignData.currentAreaID.GetValue()
        }
    }


    GemFarm()
    {
        g_Log.CreateEvent("Startup")
        g_Log.AddData("Settings", JSON.Stringify(this.Settings))

        while !(g_SF.SafetyCheck(true))
        {
            g_SF.OpenIC(this.Settings.InstallPath)
            g_SF.LoadAdventure(this.Briv)
        }

        MemoryReader.Refresh()

        ;read in formations
        formationModron := g_SF.Memory.GetActiveModronFormation()
        g_Log.AddData("Modron Formation", ArrFnc.GetDecFormattedArrayString(formationModron))
        ;these are just to troubleshoot
        formationQ := g_SF.FindChampIDinSavedFormation( 1, "Speed", 1, 58 )
        g_Log.AddData("Q Formation", ArrFnc.GetDecFormattedArrayString(formationQ))
        formationW := g_SF.FindChampIDinSavedFormation( 2, "Stack Farm", 1, 58 )
        g_Log.AddData("W Formation", ArrFnc.GetDecFormattedArrayString(formationW))
        this.Settings.stackFormation := formationW
        formationE := g_SF.FindChampIDinSavedFormation( 3, "Speed No Briv", 0, 58 )
        g_Log.AddData("E Formation", ArrFnc.GetDecFormattedArrayString(formationE))

        ;build fkey input data
        if (this.Settings.UseFkeys)
        {
            g_Level.SetFormation(formationModron)
            g_Log.AddData("Formation Data", JSON.Stringify(g_Level.Formation))
        }

        ;set up shandie
        if (this.Settings.DashWait)
        {
            this.Shandie := new IC_ShandieHandler_Class(47)
        }

        ;adds start up to log file
        g_Log.LogStack()
        ;start new log event
        g_Log.CreateEvent("Gem Farm-Partial")

        loop
        {
            if !(g_SF.SafetyCheck())
            {
                g_SF.OpenIC(this.Settings.InstallPath)
                g_SF.LoadAdventure(this.Briv)
            }

            ;to be nested in another function, not sure where yet, probably before a restart?
            if (this.ReloadTime < A_TickCount)
                Reload

            this.CheckDoZoneOne()

            this.CheckStackFarm()

            if (this.Settings.UseFkeys)
                g_Level.LevelFormationSmart()
        }
    }

    CheckStackFarm()
    {
        if (this.CurrenZone > this.Settings.StackZone AND this.Briv.Stacks < this.Settings.TargetStacks)
        {
            this.Briv.StackFarm()
        }
        if (this.Briv.HasteStacks < 50 AND this.CurrentZone > this.Settings.MinStackZone AND this.Briv.Stacks < this.Settings.TargetStacks)
        {
            this.Briv.StackFarm()
        }
    }

    CheckDoZoneOne()
    {
        if (this.CurrentZone == 1)
        {
            this.PrevZone := 1
            this.DoZoneOne()
        }
    }

    DoZoneOne()
    {
        g_Log.CreateEvent(A_ThisFunc)
        ;make sure we can do something on zone 1, ie kill monster and get some gold
        startTime := A_TickCount
        elapsedTime := 0
        While (!MemoryReader.GameInstance.ActiveCampaignData.gold.GetValue() AND elapsedTime < 60000)
        {
            VirtualKeyInputs.Priority("q")
            sleep, 100
            elapsedTime := A_TickCount - startTime
        }
        ;if after 60s still no gold, leave this func
        if !MemoryReader.GameInstance.ActiveCampaignData.gold.GetValue()
        {
            g_Log.AddData("gold", MemoryReader.GameInstance.ActiveCampaignData.gold.GetValue())
            g_Log.EndEvent()
            return
        }
        ;level briv to unlock MetalBorn
        g_Level.LevelChampByID(58, 170,, "q")
        g_SF.ToggleAutoProgress(0)
        if (this.Settings.DashWait)
        {
            ;level shandie to unlock Dash
            g_Level.LevelChampByID(47, 120,, "q")
            this.CheckDoDashWait()
        }
        ;finish zone one spamming inputs, so we don't end up just back in this function
        ;could use some toggle, but game screws up so toggle won't get flipped
        g_SF.FinishZone(30000, this.Settings.UseFkeys, "q")
        g_SF.ToggleAutoProgress(1)
        ;call briv swap
        g_Log.EndEvent()
    }

    CheckDoDashWait()
    {
        if (this.Settings.DashWait AND !(this.Shandie.IsDashActive))
        {
            this.Shandie.DoDashWait("q", this.Settings.UseFkeys)
        }
    }   
}