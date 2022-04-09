#include %A_LineFile%\..\IC_MemoryReader_Class.ahk
#include %A_LineFile%\..\IC_MemoryObjects_Class.ahk
;so we can pick the Steam or EGS offset on initialization of script.
MemoryReader.CheckICactive()
MemoryReader.Refresh()

class Static_Base_IdleGameManager extends _MemoryObjects.StaticBase
{
    static Offset := MemoryReader.Reader.Is64Bit ? 0x0 : 0x3A0574
}

;instance := new IdleGameManager
class IdleGameManager extends GameManager
{
    ;IdleGameManager-FIELDS
    game := new CrusadersGame.Game(0xA0, 0x00, this)

    __new()
    {
        this.Offset := MemoryReader.Reader.Is64Bit ? 0x0 : 0x658
        this.GetAddress := this.variableGetAddress
        this.ParentObj := Static_Base_IdleGameManager
        return this
    }
}

;base class UnityEngine.MonoBehaviour
class GameManager extends _MemoryObjects.Reference
{
    TimeScale := new _MemoryObjects.Value(0x48, 0x0, this, "System.Single")
}

class CrusadersGame
{
    ;base object is System.Object
    class ChampionsGameInstance extends _MemoryObjects.Reference
    {
        ;CrusadersGame.ChampionsGameInstance-FIELDS
        ;screen may be superflous with screenController also in Game
        Screen := new CrusadersGame.GameScreen.CrusadersGameScreen(0x8, 0x0, this)
        Controller := new CrusadersGame.GameScreen.CrusadersGameController(0xC, 0x0, this)
        ActiveCampaignData := new CrusadersGame.GameScreen.ActiveCampaignData(0x10, 0x0, this)
        HeroHandler := new CrusadersGame.User.Instance.UserInstanceHeroHandler(0x14, 0x00, this)
        ResetHandler := new CrusadersGame.User.Instance.UserInstanceResetHandler(0x1C, 0x0, this)
        PatronHandler := new CrusadersGame.User.Instance.UserInstancePatronHandler(0x28, 0x0, this)
        FormationSaveHandler := new CrusadersGame.User.UserInstanceFormationSaveHandler(0x30, 0x0, this)
        offlineProgressHandler := new OfflineProgressHandler(0x40, 0x0, this)
        ResetsSinceLastManual := new _MemoryObjects.Value(0x84, 0x0, this, "System.Int32")
        instanceLoadTimeSinceLastSave := new _MemoryObjects.Value(0x8C, 0x0, this, "System.Int32")
        ClickLevel := new _MemoryObjects.Value(0x98, 0x0, this, "System.Int32")

        ;notes
        ;it appears timescales is no longer being used, so omttied for now.
        ;not sure what instanceloadtimesincelastsave is used for, maybe not anymore
    }

    class Defs
    {
        class AdventureDef extends UnityGameEngine.Data.DataDef
        {
            ;inherits id
        }

        class AttackDef extends UnityGameEngine.Data.DataDef
        {
            CooldownTimer := new _MemoryObjects.Value(0x74, 0xAC, this, "System.Single")
        }

        class EffectDef extends UnityGameEngine.Data.DataDef
        {
            ;inherits id
        }

        class HeroDef extends UnityGameEngine.Data.DataDef
        {
            ;CrusadersGame.Defs.HeroDef-FIELDS
            name := new _MemoryObjects.String(0x18, 0x0, this)
            SeatID := new _MemoryObjects.Value(0xF8, 0, this, "System.Int32")
        }

        class FormationSaveV2Def extends UnityGameEngine.Data.DataDef
        {
            Formation := new _MemoryObjects.List(0xC, 0, this, _MemoryObjects.Value, "System.Int32")
            SaveID := new _MemoryObjects.Value(0x1C, 0, this, "System.Int32")
            Name := new _MemoryObjects.String(0x18, 0, this)
            Favorite := new _MemoryObjects.Value(0x24, 0, this, "System.Int32")
        }

        class PatronDef extends UnityGameEngine.Data.DataDef
        {
            Tier := new _MemoryObjects.Value(0x70, 0, this, "System.Int32")
        }

        class UpgradeDef extends UnityGameEngine.Data.DataDef
        {
            SpecializationName := new _MemoryObjects.String(0x20, 0, this)
            RequiredLevel := new _MemoryObjects.Value(0x4C, 0, this, "System.Int32")
            RequiredUpgradeID := new _MemoryObjects.Value(0x54, 0, this, "System.Int32")
            SpecializationGraphic := new _MemoryObjects.Value(0x58, 0, this, "System.Int32")
        }
    }

    class Effects
    {
        ;base object is System.Object
        class ActiveEffectKeyHandler extends _MemoryObjects.Reference
        {

        }

        ;base object is System.Object
        class Effect extends _MemoryObjects.Reference
        {
            def := new CrusadersGame.Defs.EffectDef(0x8, 0, this)
            effectKeyHandlers := new _MemoryObjects.List(0x1C, 0x0, this, _MemoryObjects.Reference, CrusadersGame.Effects.EffectKeyHandler)
        }

        ;base object is System.Object
        class EffectKey extends _MemoryObjects.Reference
        {
            parentEffectKeyHandler := new CrusadersGame.Effects.EffectKeyHandler(0x8, 0, this)
        }

        ;base object is System.Object
        class EffectKeyCollection extends _MemoryObjects.Reference
        {
            effectKeysByKeyName := new _MemoryObjects.Dictionary(0x2C, 0, this, _MemoryObjects.String, "System.String", _MemoryObjects.List, {"Base":_MemoryObjects.Reference, "Type":CrusadersGame.Effects.EffectKey})
        }

        ;base object is System.Object
        class EffectKeyHandler extends _MemoryObjects.Reference
        {
            parent := new CrusadersGame.Effects.Effect(0x8, 0, this)
            activeEffectHandlers := new _MemoryObjects.List(0x94, 0x0, this, _MemoryObjects.Reference, CrusadersGame.Effects.ActiveEffectKeyHandler)
        }

        ;base object is System.Object
        class EffectStacks extends _MemoryObjects.Reference
        {
            stackCount := new _MemoryObjects.Value(0x58, 0, this, "System.Double")
        }
    }

    class Game extends UnityGameEngine.GameBase
    {
        ;CrusadersGame.Game-FIELDS
        gameUser := new UnityGameEngine.UserLogin.GameUser(0x54, 0x0, this)
        gameInstances := new _MemoryObjects.List(0x58, 0x00, this, _MemoryObjects.Reference, CrusadersGame.ChampionsGameInstance)
        gameStarted := new _MemoryObjects.Value(0x7C, 0x0, this, "System.Boolean")
    }

    class GameScreen
    {
        class ActiveCampaignData extends _MemoryObjects.Reference
        {
            currentObjective := new CrusadersGame.Defs.AdventureDef(0xC, 0, this)
            currentArea := new CrusadersGame.GameScreen.AreaLevel(0x14, 0, this)
            currentAreaID := new _MemoryObjects.Value(0x44, 0, this, "System.Int32")
            highestAvailableAreaID := new _MemoryObjects.Value(0x4C, 0, this, "System.Int32")
            ;override Engine.Value.Quad type
            gold := new _MemoryObjects.Value(0x210, 0, this, "System.Int64")
        }

        class Area extends _MemoryObjects.Reference
        {
            activeMonsters := new _MemoryObjects.List(0x24, 0, this, _MemoryObjects.Reference, CrusadersGame.GameScreen.Monster)
            Active := new _MemoryObjects.Value(0xF4, 0, this, "System.Boolean")
            secondsSinceStarted := new _MemoryObjects.Value(0x114, 0, this, "System.Single")
            basicMonstersSapwnedThisArea := new _MemoryObjects.Value(0x150, 0, this, "System.Int32")
        }

        class AreaLevel extends _MemoryObjects.Reference
        {
            level := new _MemoryObjects.Value(0x28, 0, this, "System.Int32")
            QuestRemaining := new _MemoryObjects.Value(0x30, 0, this, "System.Int32")
        }

        class AreaTransitioner extends _MemoryObjects.Reference
        {
            ;k__BackingField
            IsTransitioning := new _MemoryObjects.Value(0x1C, 0, this, "System.Boolean")
            transitionDirection := new CrusadersGame.GameScreen.AreaTransitioner.AreaTransitionDirection(0x20, 0, this)

            class AreaTransitionDirection extends _MemoryObjects.Enum
            {
                Type := "System.Int32"
                Enum := {0:"Forward", 1:"Backward", 2:"Static"}
            }
        }

        class CrusadersGameController extends _MemoryObjects.Reference
        {
            ;CrusadersGame.GameScreen.CrusadersGameController-FIELDS
            area := new CrusadersGame.GameScreen.Area(0xC, 0x0, this)
            formation := new CrusadersGame.GameScreen.Formation(0x14, 0x0, this)
            areaTransitioner := new CrusadersGame.GameScreen.AreaTransitioner(0x20, 0x0, this)
            userData := new CrusadersGame.User.UserData(0x50, 0x0, this)
        }

        class CrusadersGameScreen extends UnityGameEngine.GameScreenController.GameScreen
        {
            uiController := new CrusadersGame.GameScreen.UIController(0x270, 0x0, this)
        }

        class Formation extends _MemoryObjects.Reference
        {
            slots := new _MemoryObjects.List(0xC, 0, this, _MemoryObjects.Reference, CrusadersGame.GameScreen.FormationSlot)
            transitionOverrides := new _MemoryObjects.Dictionary(0x54, 0, this, _MemoryObjects.Enum, CrusadersGame.GameScreen.Formations.FormationSlotRunHandler.TransitionDirection, _MemoryObjects.List, System.Action)
            transitionDir := new CrusadersGame.GameScreen.Formations.FormationSlotRunHandler.TransitionDirection(0xE0, 0, this)
            inAreaTransition := new _MemoryObjects.Value(0xE4, 0, this, "System.Boolean")
            numAttackingMonstersReached := new _MemoryObjects.Value(0xEC, 0, this, "System.Int32")
            numRangedAttackingMonsters := new _MemoryObjects.Value(0xF0, 0, this, "System.Int32")
        }

        class Formations
        {
            class FormationSlotRunHandler
            {
                class TransitionDirection extends _MemoryObjects.Enum
                {
                    Type := "System.Int32"
                    Enum := {0:"OnFromLeft", 1:"OnFromRight", 2:"OffToLeft", 3:"OffToRight"}
                }
            }
        }

        class FormationSlot extends _MemoryObjects.Reference
        {
            hero := new CrusadersGame.GameScreen.Hero(0x14, 0, this)
            heroAlive := new _MemoryObjects.Value(0x151, 0, this, "System.Boolean")
        }

        ;base object is System.Object
        class Hero extends _MemoryObjects.Reference
        {
            ;CrusadersGame.GameScreen.Hero-FIELDS
            def := new CrusadersGame.Defs.HeroDef(0xC, 0x00, this)
            effects := new CrusadersGame.Effects.EffectKeyCollection(0x40, 0, this)
            allUpgradesOrdered := new _MemoryObjects.Dictionary(0x10C, 0, this, _MemoryObjects.Reference, CrusadersGame.ChampionsGameInstance, _MemoryObjects.List, {"Base":_MemoryObjects.Reference, "Type":CrusadersGame.Defs.UpgradeDef})
            effectsByUpgradeId := new _MemoryObjects.Dictionary(0x11C, 0x0, this, _MemoryObjects.Value, "System.Int32", _MemoryObjects.List, {"Base":_MemoryObjects.Reference, "Type":CrusadersGame.Effects.Effect})
            Owned := new _MemoryObjects.Value(0x180, 0, this, "System.Boolean")
            slotID := new _MemoryObjects.Value(0x184, 0x00, this, "System.Int32")
            Benched := new _MemoryObjects.Value(0x190, 0, this, "System.Boolean")
            ;k__Backingfield
            Level := new _MemoryObjects.Value(0x1AC, 0x00, this, "System.Int32")
            health := new _MemoryObjects.Value(0x1E0, 0, this, "System.Double")
        }

        class Monster extends UnityGameEngine.Display.Drawable
        {
            active := new _MemoryObjects.Value(0x73D, 0, this, "System.Boolean")
        }

        class UIComponents
        {
            class TopBar
            {
                ;class ObjectiveProgress
                ;{
                    class AreaLevelBar extends UnityGameEngine.Display.Drawable
                    {
                        autoProgressButton := new UnityGameEngine.Display.DrawableButton(0x240, 0, this)
                    }

                    class ObjectiveProgressBox extends UnityGameEngine.Display.Drawable
                    {
                        areaBar := new CrusadersGame.GameScreen.UIComponents.TopBar.AreaLevelBar(0x258, 0, this) ;.ObjectiveProgress.AreaLevelBar(0x250, 0, this)
                    }
                ;}

                class TopBar extends UnityGameEngine.Display.Drawable
                {
                    objectiveProgressBox := new CrusadersGame.GameScreen.UIComponents.TopBar.ObjectiveProgressBox(0x24C, 0, this) ;ObjectiveProgress.ObjectiveProgressBox(0x234, 0, this)
                }
            }

            class UltimatesBar
            {
                class UltimatesBar extends UnityGameEngine.Display.Drawable
                {
                    ultimateItems := new _MemoryObjects.List(0x260, 0, this, _MemoryObjects.Reference, CrusadersGame.GameScreen.UIComponents.UltimatesBar.UltimatesBarItem)
                }

                class UltimatesBarItem extends UnityGameEngine.Display.Drawable
                {
                    hero := new CrusadersGame.GameScreen.Hero(0x258, 0, this)
                }
            }
        }

        ;base object is System.Object
        class UIController extends _MemoryObjects.Reference
        {
            topBar := new CrusadersGame.GameScreen.UIComponents.TopBar.TopBar(0xC, 0, this)
            ;will replace the need for this read
            ;bottomBar := new CrusadersGame.GameScreen.UIComponents.BottomBar.BottomBar(0x10, 0, this)
            ultimatesBar := new CrusadersGame.GameScreen.UIComponents.UltimatesBar.UltimatesBar(0x14, 0, this)
        }
    }

    class User
    {
        class Instance
        {
            class UserInstanceDataHandler extends _MemoryObjects.Reference
            {

            }

            class UserInstanceHeroHandler extends CrusadersGame.User.Instance.UserInstanceDataHandler
            {
                ;CrusadersGame.User.Instance.UserInstanceHeroHandler-FIELDS
                parent := new CrusadersGame.User.UserHeroHandler(0x24, 0x00, this)
            }

            class UserInstancePatronHandler extends CrusadersGame.User.Instance.UserInstanceDataHandler
            {
                ;k__BackingField
                ActivePatron := new CrusadersGame.Defs.PatronDef(0x10, 0, this)
            }

            class UserInstanceResetHandler extends CrusadersGame.User.Instance.UserInstanceDataHandler
            {
                resetting := new _MemoryObjects.Value(0x1C, 0, this, "System.Boolean")
                tries := new _MemoryObjects.Value(0x20, 0, this, "System.Int32")
            }
        }

        class UserData extends _MemoryObjects.Reference
        {
            HeroHandler := new CrusadersGame.User.UserHeroHandler(0x8, 0, this)
            StatHandler := new CrusadersGame.User.UserStatHandler(0x18, 0, this)
            ModronHandler := new CrusadersGame.User.UserModronHandler(0x6C, 0, this)
            redRubies := new _MemoryObjects.Value(0x134, 0, this, "System.Int32")
            redRubiesSpent := new _MemoryObjects.Value(0x138, 0, this, "System.Int32")
            inited := new _MemoryObjects.Value(0x150, 0, this, "System.Boolean")
            ActiveUserGameInstance := new _MemoryObjects.Value(0x164, 0, this, "System.Int32")
        }

        ;base object only includes parent (User), so recursive... maybe
        class UserHeroHandler extends _MemoryObjects.Reference
        {
            ;CrusadersGame.User.UserHeroHandler-FIELDS
            heroes := new _MemoryObjects.List(0xC, 0x00, this, _MemoryObjects.Reference, CrusadersGame.GameScreen.Hero)
        }
        
        class UserDataHandler extends _MemoryObjects.Reference
        {

        }

        class UserInstanceFormationSaveHandler extends CrusadersGame.User.UserDataHandler
        {
            formationSavesV2 := new _MemoryObjects.List(0x18, 0, this, _MemoryObjects.Reference, CrusadersGame.Defs.FormationSaveV2Def)
            formationCampaignID := new _MemoryObjects.Value(0x40, 0, this, "System.Int32")
        }

        class UserModronHandler extends CrusadersGame.User.UserDataHandler
        {
            modronSaves := new _MemoryObjects.List(0x10, 0, this, _MemoryObjects.Reference, CrusadersGame.User.UserModronHandler.ModronCoreData)

            class ModronCoreData extends _MemoryObjects.Reference
            {
                ;ahk: CrusadersGame.User.UserModronHandler.ModronCoreData
                ;mono: CrusadersGame.User.UserModronHandler+ModronCoreData
                FormationSaves := new _MemoryObjects.Dictionary(0xC, 0, this, _MemoryObjects.Value, "System.Int32", _MemoryObjects.Value, "System.Int32")
                CoreID := new _MemoryObjects.Value(0x24, 0, this, "System.Int32")
                InstanceID := new _MemoryObjects.Value(0x28, 0, this, "System.Int32")
                ExpTotal := new _MemoryObjects.Value(0x2C, 0, this, "System.Int32")
                targetArea := new _MemoryObjects.Value(0x30, 0, this, "System.Int32")
            }
        }

        class UserStatHandler extends CrusadersGame.User.UserDataHandler
        {
            BlackViperTotalGems := new _MemoryObjects.Value(0x268, 0, this, "System.Int32")
            BrivSteelbonesStacks := new _MemoryObjects.Value(0x2C8, 0, this, "System.Int32")
            BrivSprintStacks := new _MemoryObjects.Value(0x2CC, 0, this, "System.Int32")
        }
    }
}

class OfflineProgressHandler extends _MemoryObjects.Reference
{
    modronSave := new CrusadersGame.User.UserModronHandler.ModronCoreData(0x20, 0, this)
    monstersSpawnedThisArea := new _MemoryObjects.Value(0xA0, 0, this, "System.Int32")
    inGameNumSecondsToProcess := new _MemoryObjects.Value(0xB4, 0, this, "System.Int32")
    finishedOfflineProgressType := new OfflineProgressHandler.OfflineCompleteType(0x10C, 0, this)

    class OfflineCompleteType extends _MemoryObjects.Enum
    {
        Type := "System.Int32"
        Enum := {0:"Canceled", 1:"FinishedFullTime", 2:"FinishedPartialTimeWithReset"}
    }
}

class System
{
    class Action extends _MemoryObjects.Reference
    {
        
    }
}

class UnityGameEngine
{
    class Data
    {
        ;base object is System.Object
        class DataDef extends _MemoryObjects.Reference
        {
            ;UnityGameEngine.Data.DataDef-FIELDS
            ID := new _MemoryObjects.Value(0x8, 0x00, this, "System.Int32")
        }
    }

    class Display
    {
        
        class DrawableButton extends UnityGameEngine.Display.Drawable
        {
            toggled := new _MemoryObjects.Value(0x27A, 0, this, "System.Boolean")
        }

        ;base object is System.Object
        class Drawable extends _MemoryObjects.Reference
        {

        }
    }

    ;base object is System.Object
    class GameBase extends _MemoryObjects.Reference
    {
        ;UnityGameEngine.GameBase-FIELDS
        screenController := new UnityGameEngine.GameScreenController.ScreenController(0x8, 0x0, this)
    }

    class GameScreenController
    {
        class GameScreen extends _MemoryObjects.Reference
        {
            currentScreenWidth := new _MemoryObjects.Value(0x23C, 0x0, this, "System.Int32")
            currentScreenHeight := new _MemoryObjects.Value(0x240, 0x0, this, "System.Int32")
        }

        ;need to figure out how to have this also look at crusadersGameScreen class to get uiController and other items
        class ScreenController extends _MemoryObjects.Reference
        {
            activeScreen := new UnityGameEngine.GameScreenController.GameScreen(0xC, 0x0, this)
        }
    }

    class UserLogin
    {
        class GameUser extends _MemoryObjects.Reference
        {
            Hash := new _MemoryObjects.String(0x10, 0, this)
            ID := new _MemoryObjects.Value(0x30, 0, this, "System.Int32")
        }
    }
}