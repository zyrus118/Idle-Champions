class IC_SharedFunctions_Class_MV2 extends IC_SharedFunctions_Class
{
    ;i want to re evaluate the autoprogress togled prop
    ; IsToggled be 0 for off or 1 for on. ForceToggle always hits G. ForceState will press G until AutoProgress is read as on (<5s).
    ToggleAutoProgress( isToggled := 1, forceToggle := false, forceState := false )
    {
        startTime := A_TickCount
        if ( forceToggle )
            VirtualKeyInputs.Priority("g")
        if ( this.AutoProgressToggled != isToggled )
            VirtualKeyInputs.Priority("g")
        while ( forceState AND this.AutoProgressToggled != isToggled AND (A_TickCount - startTime) < 5001 )
            VirtualKeyInputs.Priority("g")
    }

    ; waitTime: max time in ms will wait to finish zone, lvlFormation: bool to call method, inputs: variadic param of inputs
    FinishZone(waitTime, lvlFormation, inputs*)
    {
        startTime := A_TickCount
        elapsedTime := 0
        isTransitioning := MemoryReader.GameInstance.Controller.areaTransitioner.IsTransitioning.GetValue()
        while (elapsedTime < waitTime AND !isTransitioning)
        {
            if lvlFormation
                lvlFormation := g_Level.LevelFormationSmart(inputs*)
            else if (inputs.Count())
                VirtualKeyInputs.Priority(inputs*)
            else
                sleep, 100
            elapsedTime := A_TickCount-startTime
            isTransitioning := MemoryReader.GameInstance.Controller.areaTransitioner.IsTransitioning.GetValue()
        }
        return
    }
}