class IC_Leveling_Class
{
    __new()
    {
        this.Heroes := MemoryReader.InitHeroes()
        return this
    }

    SetFormation(formation)
    {
        this.Formation := {}
        size := formation.Count()
        this.Heroes.SetAddress(true)
        loop, &size%
        {
            champID := formation[A_Index]
            ;empty slots are defined as -1
            if (champID > 0)
                hero := new IC_HeroHandler_Class(champID)
            else
                continue
            hero.SetMaxLvl()
            this.Formation.Push(hero)
        }
        this.Heroes.SetAddress(false)
    }

    ;levels all champions in this.Formation once time if not max level use SetFormation(formation) to define this.Formation
    LevelFormationSmart()
    {
        size := this.Formation.Count()
        if !size
            return
        this.Heroes.SetAddress(true)
        loop %size%
        {
            hero := this.Formation[A_Index]
            if (hero.Level < hero.MaxLvl)
                VirtualKeyInputs.Priority(hero.FKey)
        }
        this.Heroes.SetAddress(false)
        return
    }

    LevelChampByID(ChampID := 1, Lvl := 0, timeout := 5000, keys*)
    {
        StartTime := A_TickCount
        ElapsedTime := 0
        counter := 0
        sleepTime := 34
        hero := this.Heroes.Item[ChampID-1]
        hero.SetAddress(true)
        seat := hero.def.SeatID.GetValue()
        if ( seat < 0 OR seat == "")
            return
        var := ["{F" . seat . "}"]
        size := keys.Count()
        loop %size%
            var.Push(keys[A_Index])
        VirtualKeyInputs.Generic(var*)
        while ( hero.Level.GetValue() < Lvl AND ElapsedTime < timeout )
        {
            VirtualKeyInputs.Generic(var*)
            ElapsedTime := A_TickCount - StartTime
        }
        return
    }
}