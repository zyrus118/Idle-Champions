class IC_ShandieHandler_Class extends IC_HeroHandler_Class
{
    Reset()
    {
        this.ResetPrevValues()
        this.InitShandieHander()
        this.ResetShandiePrevValues()
    }

    InitShandieHandler()
    {
        this.DashHandler := new TimeScaleWhenNotAttackedHandler
    }

    ResetShandiePrevValues()
    {
        this.IsDashActivePrev := ""
        this.DashTimePrev := ""
    }

    DoDashWait(formationInput, useFkeys)
    {
        g_Log.CreateEvent(A_ThisFunc)
        startTime := A_TickCount
        elapsedTime := 0
        while (!(this.IsDashActive) AND elapsedTime < ((60000 / MemoryReader.IdleGameManager.TimeScale.GetValue()) * 1.2))
        {
            if formationInput
                VirtualKeyInputs.Generic(formationInput)
            if useFkeys
                g_Level.LevelFormationSmart()
            else
                sleep, 250
            elapsedTime := A_TickCount - startTime
        }
        g_Log.EndEvent()
        return
    }

    IsDashActive[]
    {
        get
        {
            value := this.DashHandler.scaleActive.GetValue()
            if (value != this.IsDashActivePrev)
            {
                g_Log.AddData(this.name . ".IsDashActive", value)
                this.IsDashActivePrev := value
            }
            return value
        }
    }

    DashTime[]
    {
        get
        {
            value := this.DashHandler.effectTime.GetValue()
            if (value != this.DashTimePrev)
            {
                g_Log.AddData(this.name . ".DashTime", value)
                this.DashTimePrev := value
            }
            return value
        }
    }
}