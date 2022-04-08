#include %A_LineFile%\..\IC_Structure_IdleGameManager.ahk

class BrivUnnaturalHasteHandler extends _MemoryObjects.EffectKey
{
    ChampID := 58
    UpgradeID := 3452
    EffectID := 569
    effectKey := new CrusadersGame.Effects.EffectKey(0x14, 0, this)
    sprintStacks := new CrusadersGame.Effects.EffectStacks(0x18, 0, this)
    areaSkipChance := new _MemoryObjects.Value(0x34, 0, this, "System.Single")
    areaSkipAmount := new _MemoryObjects.Value(0x38, 0, this, "System.Int32")
    stacksToConsume := new _MemoryObjects.Value(0x40, 0, this, "System.Int32")
}

class TimeScaleWhenNotAttackedHandler extends _MemoryObjects.EffectKey
{
    ChampID := 47
    UpgradeID := 2774
    EffectID := 432
    effectKey := new CrusadersGame.Effects.EffectKey(0x14, 0, this)
    scaleActive := new _MemoryObjects.Value(0xD0, 0x108, this, "System.Boolean")
    effectTime := new _MemoryObjects.Value(0xD8, 0x110, this, "System.Double")
}

class HavilarImpHandler extends _MemoryObjects.EffectKey
{
    ChampID := 56
    UpgradeID := 3431
    EffectID := 541
    effectKey := new CrusadersGame.Effects.EffectKey(0x14, 0, this)
    activeImps := new _MemoryObjects.List(0x34, 0x68, this, _MemoryObjects.Value, "System.Int32")
    currentOtherImpIndex := new _MemoryObjects.Value(0x120, 0x1A8, this, "System.Int32")
    summonImptUltimate := new CrusadersGame.Defs.AttackDef(0x58, 0xB0, this)
    sacrificeImpUltimate := new CrusadersGame.Defs.AttackDef(0x5C, 0xB8, this)
}

class OminContractualObligationsHandler extends _MemoryObjects.EffectKey
{
    ChampID := 65
    UpgradeID := 4110
    EffectID := 649
    effectKey := new CrusadersGame.Effects.EffectKey(0x18, 0x30, this)
    numContractsFufilled := new _MemoryObjects.Value(0x38, 0x70, this, "System.Int32")
    secondsOnGoldFind := new _MemoryObjects.Value(0x5C, 0x94, this, "System.Single")
}

class NerdWagonHandler extends _MemoryObjects.EffectKey
{
    ChampID := 87
    UpgradeID := 6152
    EffectID := 921
    ;k__BackingField
    effectKey := new CrusadersGame.Effects.EffectKey(0x14, 0, this)
    nerd0 := new NerdWagonHandler.Nerd(0x20, 0x40, this)
    nerd1 := new NerdWagonHandler.Nerd(0x24, 0x48, this)
    nerd2 := new NerdWagonHandler.Nerd(0x28, 0x50, this)

    class Nerd extends _MemoryObjects.Reference
    {
        type := new NerdWagonHandler.NerdType(0x10, 0x20, this)
    }

    class NerdType extends _MemoryObjects.Enum
    {
        Type := "System.Int32"
        Enum := {0:"None", 1:"Fighter_Orange", 2:"Ranger_Red", 3:"Bard_Green", 4:"Cleric_Yellow", 5:"Rogue_Pink", 6:"Wizard_Purple"}
    }
}