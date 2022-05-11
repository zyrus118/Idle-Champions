class IC_BrivHandler_Class extends IC_HeroHandler_Class
{
    Reset()
    {
        this.ResetPrevValues()
        this.InitBrivHander()
        this.ResetBrivPrevValues()
    }

    InitBrivHandler()
    {
        this.UnnaturalHasteHandler := new BrivUnnaturalHasteHandler
        gameInstance := MemoryReader.InitGameInstance()
        this.BrivSteelbonesStacks := gameInstance.Controller.userData.StatHandler.BrivSteelBonesStacks
    }

    ResetBrivPrevValues()
    {
        this.HasteStacksPrev := ""
        this.SBStacksPrev := ""
    }

    StackFarm(settings)
    {
        if settings.RestartStackTime
            this.StackRestart(settings)
        else
            this.StackNormal(settings)
    }

    StackRestart(settings)
    {
        g_Log.CreateEvent(A_ThisFunc)
        i := 0
        while (this.Stacks < settings.TargetStacks AND i < 10)
        {
            g_Log.CreateEvent("Stack Restart Attempt: " . ++i)
            this.StackFarmSetup(settings)
            sleep, 1000
            g_SF.CloseIC(A_ThisFunc)
            startTime := A_TickCount
            elapsedTime := 0
            if settings.DoChests
            {
                ;code to buy/open chests
            }
            elapsedTime := A_TickCount - startTime
            while ( elapsedTime < settings.RestartStackTime)
            {
                sleep, 100
                elapsedTime := A_TickCount - startTime
            }
            g_SF.OpenIC(settings.InstallPath)
            g_SF.LoadAdventure(this)
            g_Log.AddData("HasteStacks", this.HasteStacks)
            g_Log.AddData("SBStacks", this.SBStacks)
            currentZone := MemoryReader.GameInstance.ActiveCampaignData.currentAreaID.GetValue()
            if (currentZone < settings.StackZone)
            {
                g_Log.AddData("currentZone", currentZone)
                g_Log.EndEvent()
                g_Log.EndEvent()
                return
            }
            g_Log.AddData("currentZone", currentZone)
            g_Log.EndEvent()
        }
        VirtualKeyInputs.Priority("q")
        g_SF.ToggleAutoProgress(1)
        g_Log.EndEvent()
        return
    }

    StackNormal(settings)
    {
        return
    }

    StackFarmSetup(settings)
    {
        g_Log.CreateEvent(A_ThisFunc)
        VirtualKeyInputs.Priority("w")
        g_SF.WaitForTransition("w")
        g_SF.ToggleAutoProgress(0)
        g_SF.FallBackFromBossZone("w")
        startTime := A_TickCount
        elapsedTime := 0
        while(g_SF.IsCurrentFormation(settings.StackFormation) AND elapsedTime < 5000)
        {
            VirtualKeyInputs.Priority("w")
            sleep, 100
            elapsedTime := A_TickCount - startTime
        }
        g_Log.EndEvent()
    }

    HasteStacks[]
    {
        get
        {
            value := this.UnnaturalHasteHandler.sprintStacks.stackCount.GetValue()
            if (value != this.HasteStacksPrev)
            {
                g_Log.AddData(this.name . ".HasteStacks", value)
                this.HasteStacksPrev := value
            }
            return value
        }
    }

    SBStacks[]
    {
        get
        {
            value := this.BrivSteelbonesStacks.GetValue()
            if (value != this.SBStacksPrev)
            {
                g_Log.AddData(this.name . ".SBStacks", value)
                this.SBStacksPrev := value
            }
            return value
        }
    }

    Stacks[]
    {
        get
        {
            return this.HasteStacks + this.SBStacks
        }
    }
}