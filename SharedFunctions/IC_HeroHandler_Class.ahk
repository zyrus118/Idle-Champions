class IC_HeroHandler_Class
{
    __new(champID)
    {
        MemoryReader.Refresh()
        heroes := MemoryReader.InitHeroes()
        this.hero := heroes.Item[champID - 1]
        this.hero.SetAddress(true)
        this.Name := this.hero.def.name.GetValue()
        this.Seat := this.hero.def.SeatID.GetValue()
        this.FKey := "{F" . this.Seat . "}"
        this.hero.SetAddress(false)
        this.Reset()
    }

    Reset()
    {
        this.ResetPrevValues()
    }

    ResetPrevValues()
    {
        this.BenchedPrev := ""
        this.LevelPrev := ""
    }

    SetMaxLvl()
    {
        ;assuming active instance is always first entry, this may not be the case, may have to compare address of each key to gameinstance.Item[0]
        upgrades := this.hero.allUpgradesOrdered.Value[0]
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
                this.MaxLvl := reqLvl
                return
            }
            --index
        }
        upgrades := ""
        this.MaxLvl := 9999
        return
    }

    Benched[]
    {
        get
        {
            value := this.hero.Benched.GetValue()
            if (value != this.BenchedPrev)
            {
                g_Log.AddData(this.name . ".Benched", value)
                this.BenchedPrev := value
            }
            return value
        }
    }

    Level[]
    {
        get
        {
            value := this.hero.Level.GetValue()
            if (value != this.LevelPrev)
            {
                g_Log.AddData(this.name . ".Level", value)
                this.LevelPrev := value
            }
            return value
        }
    }
}