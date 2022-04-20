class BrivUnnaturalHasteHandler extends ActiveEffectKeyHandler
{
    ChampID := 58
    UpgradeID := 3452
    EffectID := 569
    ;FB-CrusadersGame.Effects.BrivUnnaturalHasteHandler
    effectKey := new CrusadersGame.Effects.EffectKey(20, 40, this)
    sprintStacks := new CrusadersGame.Effects.EffectStacks(24, 48, this)
    areaSkipChance := new System.Single(52, 96, this)
    areaSkipAmount := new System.Int32(56, 100, this)
    stacksToConsume := new System.Int32(64, 108, this)
    ;FE
}

class HavilarImpHandler extends ActiveEffectKeyHandler
{
    ChampID := 56
    UpgradeID := 3431
    EffectID := 541
    ;FB-CrusadersGame.Effects.HavilarImpHandler
    effectKey := new CrusadersGame.Effects.EffectKey(20, 40, this)
    activeImps := new System.List(52, 104, this, System.Int32)
    currentOtherImpIndex := new System.Int32(288, 424, this)
    summonImpUltimate := new CrusadersGame.Defs.AttackDef(88, 176, this)
    sacrificeImpUltimate := new CrusadersGame.Defs.AttackDef(92, 184, this)
    ;FE
}

class OminContractualObligationsHandler extends ActiveEffectKeyHandler
{
    ChampID := 65
    UpgradeID := 4110
    EffectID := 649
    ;FB-CrusadersGame.Effects.OminContractualObligationsHandler
    effectKey := new CrusadersGame.Effects.EffectKey(24, 48, this)
    numContractsFufilled := new System.Int32(56, 112, this)
    secondsOnGoldFind := new System.Single(92, 148, this)
    ;FE
}

class NerdWagonHandler extends ActiveEffectKeyHandler
{
    ChampID := 87
    UpgradeID := 6152
    EffectID := 921
    ;FB-CrusadersGame.Effects.NerdWagonHandler
    effectKey := new CrusadersGame.Effects.EffectKey(20, 40, this)
    nerd0 := new CrusadersGame.Effects.NerdWagonHandler.Nerd(32, 64, this)
    nerd1 := new CrusadersGame.Effects.NerdWagonHandler.Nerd(36, 72, this)
    nerd2 := new CrusadersGame.Effects.NerdWagonHandler.Nerd(40, 80, this)
    ;FE

    class Nerd extends System.Object
    {
        type := new NerdWagonHandler.NerdType(0x10, 0x20, this)
    }

    class NerdType extends System.Enum
    {
        Type := "System.Int32"
        Enum := {0:"None", 1:"Fighter_Orange", 2:"Ranger_Red", 3:"Bard_Green", 4:"Cleric_Yellow", 5:"Rogue_Pink", 6:"Wizard_Purple"}
    }
}

class TimeScaleWhenNotAttackedHandler extends ActiveEffectKeyHandler
{
    ChampID := 47
    UpgradeID := 2774
    EffectID := 432
    ;FB-TimeScaleWhenNotAttackedHandler
    effectKey := new CrusadersGame.Effects.EffectKey(20, 40, this)
    scaleActive := new System.Boolean(208, 264, this)
    effectTime := new System.Double(216, 272, this)
    ;FE
}

class ActiveEffectKeyHandler extends System.Object
{
    __new()
    {
        this.Offset := 0
        this.GetAddress := this.variableGetAddress
        this.ParentObj := new ActiveEffectKeyHandler_Parent(new IdleGameManager, this.ChampID, this.UpgradeID, this.EffectID, this)
        return this
    }
    
    SetAddress(setStatic, address)
    {
        if setStatic
        {
            if setStatic
        {
            this.Address := address
            this.GetAddress := this.staticGetAddress
        }
        else
            this.GetAddress := this.variableGetAddress
        }
    }
}

class ActiveEffectKeyHandler_Parent extends System.Object
{
    __new(gameManager, champID, upgradeID, effectID, child)
    {
        this.Hero := gameManager.game.gameInstances.Item[0].HeroHandler.parent.heroes.Item[champID - 1]
        this.UpgradeID := upgradeID
        this.EffectID := effectID
        this.Child := child
        this.GetAddress := this.variableGetAddress
        return this
    }

    variableGetAddress()
    {
        ;will read hero's address once then reuse that address for subsequent reads. this should probably be applied at each loop.
        this.Hero.SetAddress(true)
        ;effectKeysByKeyName is Dict<string,List<CrusadersGame.Effects.EffectKey>>
        effectKeysByKeyName := this.Hero.effects.effectKeysByKeyName
        count := effectKeysByKeyname.count.GetValue()
        index := 0
        loop %count%
        {
            ;effectKeys is a list of EffectKey
            effectKeys := effectKeysByKeyName.Value[index]
            EK_size := effectKeys.Size()
            EK_index := 0
            loop %EK_size%
            {
                if (effectKeys.Item[EK_index].parentEffectKeyHandler.parent.def.ID := this.EffectID)
                {
                    ;activeEffecthandlers is list of CrusadersGame.Effects.ActiveEffectKeyHandler
                    ;these are the base type of our desired handlers, usually.
                    activeEffectHandlers := effectKeys.Item[EK_index].parentEffectKeyHandler.activeEffectHandlers
                    AEH_size := activeEffectHandlers.Size()
                    AEH_index := 0
                    loop %AEH_size%
                    {
                        ;this effect key isnt in active effect handlers need to pass in effect handler to get these
                        activeEffectHandlerAddress := activeEffectHandlers.Item[AEH_index].GetAddress()
                        this.Child.SetAddress(true, activeEffectHandlerAddress)
                        id := this.Child.effectKey.parentEffectKeyHandler.parent.def.ID.GetValue()
                        if (id == this.EffectID)
                        {
                            this.Hero.SetAddress(false)
                            this.Child.Offset := activeEffectHandlers.Item[AEH_index].Offset
                            return activeEffectHandlers._items.GetAddress()
                        }
                        ++AEH_index
                    }
                }
                ++EK_index
            }
            ++index
        }
        this.Hero.SetAddress(false)
        return ""
    }
}