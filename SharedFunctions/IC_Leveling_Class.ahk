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

    ; param champID, return maxLvl on success and "" on fail
    GetHeroMaxLvl(champID)
    {
        ;assuming active instance is always first entry, this may not be the case may have to compare address of each key to gameinstance.Item[0]
        upgrades := this.Heroes.Item[champID - 1].allUpgradesOrdered.Value[0]
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
                return reqLvl
            --index
        }
        return
    }

    ; param simple array of champID, return associative array champID:MaxLvl
    GetFormationMaxLvl(formation)
    {
        obj := {}
        count := formation.Count()
        loop %count%
        {
            champID := formation[A_Index]
            if (champID != -1)
                obj[champID] := this.GetHeroMaxLvl(champID)
        }
        return obj
    }

    ; param associative array champID:MaxLvl (use GetFormationMaxLvl to generate), return true or false
    AreHeroesUpgraded(maxLvlArray)
    {
        log := new _EventLog(A_ThisFunc, true)
        log.Add(new _DataPoint("Param: maxLvlArray", ArrFnc.GetDecFormattedAssocArrayString(maxLvlArray)))
        this.Heroes.SetAddress(true)
        for k, v in maxLvlArray
        {
            lvl := this.Heroes.Item[k-1].Level.GetValue()
            log.Add(new _DataPoint("ChampID " . k . " level", v))
            if (v > lvl)
            {
                log.Add(new _DataPoint("Return", "false"))
                log.Stop()
                g_Log.PopStack()
                return false
            }
        }
        log.Add(new _DataPoint("Return", "true"))
        log.Stop()
        return true
    }
}