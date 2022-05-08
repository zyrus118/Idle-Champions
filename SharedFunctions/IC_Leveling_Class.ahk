#include %A_LineFile%\..\MemoryRead\IC_MemoryReader_Class.ahk
#include %A_LineFile%\..\MemoryRead\IC_Structure_IdleGameManager.ahk

class IC_Leveling_Class
{
    __new()
    {
        gamemanager := new IdleGameManager
        this.Heroes := gamemanager.game.gameinstances.Item[0].HeroHandler.parent.heroes
        return this
    }

    NewFormation(formation)
    {
        this.Formation := {}
        size := formation.Count()
        this.Heroes.SetAddress(true)
        loop, &size%
        {
            champID := formation[A_Index]
            ;empty slots are defined as -1
            if (champID > 0)
                hero := this.Heroes.Item[champID-1]
            else
                continue
            this.Formation.Push(new IC_Leveling_Class.ChampDef(hero, champID))
        }
        this.Heroes.SetAddress(false)
    }

    class ChampDef
    {
        __new(hero, id)
        {
            this.ID := id
            hero.SetAddress(true)
            maxLvl := this.GetHeroMaxLvl(hero)
            if !maxLvl
                maxLvl := 9999
            this.MaxLvl := maxLvl
            seat := hero.def.SeatID.GetValue()
            if (seat < 0 AND seat > 13)
                seat := 5 ;just keep leveling briv I guess if something goes wrong, better than nothing
            this.SeatID := seat
            this.FKey := "{F" . seat . "}"
            this.Hero := hero
            hero.SetAddress(false)
            return this
        }
    }

    ;levels each champion in the saved array, returns 0 if max level, otherwise 1 (can be used to toggle a bool to stop calling)
    LevelFormationSmart(inputs*)
    {
        fKeys := {}
        size := this.Formation.Count()
        this.Heroes.SetAddress(true)
        loop %size%
        {
            champ := this.Formation[A_Index]
            lvl := champ.Hero.Level.GetValue()
            if (lvl < champ.MaxLvl)
                fKeys.Push(champ.FKey)
        }
        this.Heroes.SetAddress(false)
        if (fKeys.Count())
            VirtualKeyInputs.Priority(fKeys*)
        else
            return 0
        VirtualKeyInputs.Priority(inputs*)
        return 1
    }

    ; Takes an array of champion IDs and creates a list of FKeys for their appropriate seat slots.
    GetFormationFKeys(formation)
    {
        Fkeys := {}
        size := formation.Count()
        this.Heroes.SetAddress(true)
        loop %size%
        {
            seat := 0
            champID := formation[A_index]
            ;empty slots are defined as -1
            if (champID > 0)
                seat := this.Heroes.Item[champID-1].def.SeatID.GetValue()
            ;make sure it is a valid seat
            if (seat > 0 AND seat < 13)
                Fkeys.Push("{F" . seat . "}")
        }
        this.Heroes.SetAddress(false)
        return Fkeys
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

    ; param hero (memory object), return maxLvl on success and "" on fail
    GetHeroMaxLvl(hero)
    {
        ;assuming active instance is always first entry, this may not be the case may have to compare address of each key to gameinstance.Item[0]
        upgrades := hero.allUpgradesOrdered.Value[0]
        ;assume address of upgrades list won't change during this look up.
        upgrades.SetAddress(true)
        _size := upgrades.Size()
        index := _size - 1
        ;assume _items won't change during this look up.
        upgrades._items.SetAddress(true)
        ;start at end of list and look for first upgrade with req lvl less than 9999
        while (index >= 0)
        {
            reqLvl := upgrades.Item[index].RequiredLevel.GetValue()
            if (reqLvl < 9999)
            {
                upgrades := ""
                return reqLvl
            }
            --index
        }
        upgrades := ""
        return
    }
}