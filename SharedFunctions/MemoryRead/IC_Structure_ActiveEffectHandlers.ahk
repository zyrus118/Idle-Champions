#include %A_LineFile%\..\IC_Structure_IdleGameManager.ahk

class BrivUnnaturalHasteHandler extends System.EffectKey
{
    ChampID := 58
    UpgradeID := 3452
    EffectID := 569
    effectKey := new CrusadersGame.Effects.EffectKey(0x14, 0, this)
    sprintStacks := new CrusadersGame.Effects.EffectStacks(0x18, 0, this)
    areaSkipChance := new System.Single(0x34, 0, this)
    areaSkipAmount := new System.Int32(0x38, 0, this)
    stacksToConsume := new System.Int32(0x40, 0, this)
}

class TimeScaleWhenNotAttackedHandler extends System.EffectKey
{
    ChampID := 47
    UpgradeID := 2774
    EffectID := 432
    effectKey := new CrusadersGame.Effects.EffectKey(0x14, 0, this)
    scaleActive := new System.Boolean(0xD0, 0x108, this)
    effectTime := new System.Boolean(0xD8, 0x110, this)
}

class HavilarImpHandler extends System.EffectKey
{
    ChampID := 56
    UpgradeID := 3431
    EffectID := 541
    effectKey := new CrusadersGame.Effects.EffectKey(0x14, 0, this)
    activeImps := new System.List(0x34, 0x68, this, System.Int32, "System.Int32")
    currentOtherImpIndex := new System.Int32(0x120, 0x1A8, this)
    summonImptUltimate := new CrusadersGame.Defs.AttackDef(0x58, 0xB0, this)
    sacrificeImpUltimate := new CrusadersGame.Defs.AttackDef(0x5C, 0xB8, this)
}

class OminContractualObligationsHandler extends System.EffectKey
{
    ChampID := 65
    UpgradeID := 4110
    EffectID := 649
    effectKey := new CrusadersGame.Effects.EffectKey(0x18, 0x30, this)
    numContractsFufilled := new System.Int32(0x38, 0x70, this)
    secondsOnGoldFind := new System.Single(0x5C, 0x94, this)
}

class NerdWagonHandler extends System.EffectKey
{
    ChampID := 87
    UpgradeID := 6152
    EffectID := 921
    ;k__BackingField
    effectKey := new CrusadersGame.Effects.EffectKey(0x14, 0, this)
    nerd0 := new NerdWagonHandler.Nerd(0x20, 0x40, this)
    nerd1 := new NerdWagonHandler.Nerd(0x24, 0x48, this)
    nerd2 := new NerdWagonHandler.Nerd(0x28, 0x50, this)

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