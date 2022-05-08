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
        this.Log.CreateEvent("Startup")
        this.Log.AddData("Settings", JSON.Stringify(this.Settings))

        MemoryReader.Refresh()

        ;read in formations
        formationModron := g_SF.Memory.GetActiveModronFormation()
        this.Log.AddData("Modron Formation", ArrFnc.GetDecFormattedArrayString(formationModron))
        ;these are just to troubleshoot
        formationQ := g_SF.FindChampIDinSavedFormation( 1, "Speed", 1, 58 )
        this.Log.AddData("Q Formation", ArrFnc.GetDecFormattedArrayString(formationQ))
        formationW := g_SF.FindChampIDinSavedFormation( 2, "Stack Farm", 1, 58 )
        this.Log.AddData("W Formation", ArrFnc.GetDecFormattedArrayString(formationW))
        formationE := g_SF.FindChampIDinSavedFormation( 3, "Speed No Briv", 0, 58 )
        this.Log.AddData("E Formation", ArrFnc.GetDecFormattedArrayString(formationE))

        ;build fkey input data
        if (this.Settings.UseFkeys)
        {
            g_Level.NewFormation(formationModron)
            this.Log.AddData("Formation Data", JSON.Stringify(g_Level.Formation))
            ;this.FormationMaxLvl := g_Level.GetFormationMaxLvl(formationModron)
            ;this.Log.AddData("Modron Formation Max Lvl", ArrFnc.GetDecFormattedAssocArrayString(this.FormationMaxLvl))
            ;this.FormationFKeys := g_Level.GetFormationFkeys(formationModron)
            ;this.Log.AddData("Modron Formation FKeys", ArrFnc.GetAlphaNumericArrayString(this.FormationFKeys))
        }

        ;set up shandie
        if (this.Settings.DashWait)
        {
            this.DashHandler := new TimeScaleWhenNotAttackedHandler
        }

        ;adds start up to log file
        this.Log.LogStack()
        ;start new log event
        this.Log.CreateEvent("Gem Farm-Partial")

        loop
        {
            ;to be nested in another function, not sure where yet, probably before a restart?
            if (this.ReloadTime < A_TickCount)
                Reload

            this.CheckDoZoneOne()

            

            
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
            return
        g_SF.ToggleAutoProgress(0)
        if (this.Settings.DashWait)
        {
            ;level shandie to unlock Dash
            g_Level.LevelChampByID(47, 120,, "q")
            ;level briv to unlock MetalBorn
            g_Level.LevelChampByID(58, 170,, "q")
            this.CheckDoDashWait()
        }
        else 
            ;level briv to unlock MetalBorn
            g_Level.LevelChampByID(58, 170,, "q")
        ;finish zone one spamming inputs, so we don't end up just back in this function
        ;could use some toggle, but game screws up so toggle won't get flipped
        g_SF.FinishZone(30000, this.Settings.UseFkeys, "q")
        g_SF.ToggleAutoProgress(1)
        ;call briv swap
    }

    CheckDoDashWait()
    {
        if (this.Settings.DashWait AND !(this.DashHandler.scaleActive.GetValue()))
        {
            this.DoDashWait()
        }
    }

    DoDashWait()
    {
        startTime := A_TickCount
        while ( !(this.DashHandler.scaleActive.GetValue()) AND elapsedTime < ((60000 / this.IdleGameManager.TimeScale.GetValue()) * 1.2))
        {
            ;spam fkeys to level champs and work out any kinks in the virtual key inputs
            if (this.Settings.UseFkeys)
                g_Level.LevelFormationSmart("q")
            else
                sleep, 250
            elapsedTime := A_TickCount - startTime
        }
    }
}