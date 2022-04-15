#include %A_LineFile%\..\IC_MemoryReader_Class.ahk
#include %A_LineFile%\..\IC_MemoryObjects_Class.ahk
;so we can pick the Steam or EGS offset on initialization of script.
MemoryReader.CheckICactive()
MemoryReader.Refresh()

class IdleGameManager_Parent extends System.StaticBase
{
    static Offset := MemoryReader.Reader.Is64Bit ? 0x0 : 0x3A0574
}

;instance := new IdleGameManager
class IdleGameManager extends GameManager
{
    ;FB-IdleGameManager
    game := new CrusadersGame.Game(0xA0, 0x00, this)
    ;FE
    
    __new()
    {
        this.Offset := MemoryReader.Reader.Is64Bit ? 0x0 : 0x658
        this.GetAddress := this.variableGetAddress
        this.ParentObj := IdleGameManager_Parent
        return this
    }
}

;base class UnityEngine.MonoBehaviour
class GameManager extends System.Object
{
    ;FB-GameManager
    TimeScale := new System.Single(0x48, 0x0, this)
    ;FE
}

class CrusadersGame
{
    ;base object is System.Object
    class ChampionsGameInstance extends System.Object
    {
        ;FB-CrusadersGame.ChampionsGameInstance
        ;screen may be superflous with screenController also in Game
        Screen := new CrusadersGame.GameScreen.CrusadersGameScreen(0x8, 0x0, this)
        Controller := new CrusadersGame.GameScreen.CrusadersGameController(0xC, 0x0, this)
        ActiveCampaignData := new CrusadersGame.GameScreen.ActiveCampaignData(0x10, 0x0, this)
        HeroHandler := new CrusadersGame.User.Instance.UserInstanceHeroHandler(0x14, 0x00, this)
        ResetHandler := new CrusadersGame.User.Instance.UserInstanceResetHandler(0x1C, 0x0, this)
        PatronHandler := new CrusadersGame.User.Instance.UserInstancePatronHandler(0x28, 0x0, this)
        FormationSaveHandler := new CrusadersGame.User.UserInstanceFormationSaveHandler(0x30, 0x0, this)
        offlineProgressHandler := new OfflineProgressHandler(0x40, 0x0, this)
        ResetsSinceLastManual := new System.Int32(0x84, 0x0, this)
        instanceLoadTimeSinceLastSave := new System.Int32(0x8C, 0x0, this)
        ClickLevel := new System.Int32(0x98, 0x0, this)
        ;FE
    }

    class Defs
    {
        class AdventureDef extends UnityGameEngine.Data.DataDef
        {
            ;inherits id
        }

        class AttackDef extends UnityGameEngine.Data.DataDef
        {
            CooldownTimer := new System.Single(0x74, 0xAC, this)
        }

        class EffectDef extends UnityGameEngine.Data.DataDef
        {
            ;inherits id
        }

        class HeroDef extends UnityGameEngine.Data.DataDef
        {
            ;CrusadersGame.Defs.HeroDef-FIELDS
            name := new System.String(0x18, 0x0, this)
            SeatID := new System.Int32(0xF8, 0, this)
        }

        class FormationSaveV2Def extends UnityGameEngine.Data.DataDef
        {
            Formation := new System.List(0xC, 0, this, System.Int32)
            SaveID := new System.Int32(0x1C, 0, this)
            Name := new System.String(0x18, 0, this)
            Favorite := new System.Int32(0x24, 0, this)
        }

        class PatronDef extends UnityGameEngine.Data.DataDef
        {
            Tier := new System.Int32(0x70, 0, this)
        }

        class UpgradeDef extends UnityGameEngine.Data.DataDef
        {
            SpecializationName := new System.String(0x20, 0, this)
            RequiredLevel := new System.Int32(0x4C, 0, this)
            RequiredUpgradeID := new System.Int32(0x54, 0, this)
            SpecializationGraphic := new System.Int32(0x58, 0, this)
        }
    }

    class Effects
    {
        ;base object is System.Object
        class ActiveEffectKeyHandler extends System.Object
        {

        }

        ;base object is System.Object
        class Effect extends System.Object
        {
            def := new CrusadersGame.Defs.EffectDef(0x8, 0, this)
            effectKeyHandlers := new System.List(0x1C, 0x0, this, CrusadersGame.Effects.EffectKeyHandler)
        }

        ;base object is System.Object
        class EffectKey extends System.Object
        {
            parentEffectKeyHandler := new CrusadersGame.Effects.EffectKeyHandler(0x8, 0, this)
        }

        ;base object is System.Object
        class EffectKeyCollection extends System.Object
        {
            effectKeysByKeyName := new System.Dictionary(0x2C, 0, this, System.String, [System.List, CrusadersGame.Effects.EffectKey])
        }

        ;base object is System.Object
        class EffectKeyHandler extends System.Object
        {
            parent := new CrusadersGame.Effects.Effect(0x8, 0, this)
            activeEffectHandlers := new System.List(0x94, 0x0, this, CrusadersGame.Effects.ActiveEffectKeyHandler)
        }

        ;base object is System.Object
        class EffectStacks extends System.Object
        {
            stackCount := new System.Double(0x58, 0, this)
        }
    }

    class Game extends UnityGameEngine.GameBase
    {
        ;CrusadersGame.Game-FIELDS
        gameUser := new UnityGameEngine.UserLogin.GameUser(0x54, 0x0, this)
        gameInstances := new System.List(0x58, 0x00, this, CrusadersGame.ChampionsGameInstance)
        gameStarted := new System.Boolean(0x7C, 0x0, this)
    }

    class GameScreen
    {
        class ActiveCampaignData extends System.Object
        {
            currentObjective := new CrusadersGame.Defs.AdventureDef(0xC, 0, this)
            currentArea := new CrusadersGame.GameScreen.AreaLevel(0x14, 0, this)
            currentAreaID := new System.Int32(0x44, 0, this)
            highestAvailableAreaID := new System.Int32(0x4C, 0, this)
            ;override Engine.Value.Quad type
            gold := new System.Int64(0x210, 0, this)
        }

        class Area extends System.Object
        {
            activeMonsters := new System.List(0x24, 0, this, CrusadersGame.GameScreen.Monster)
            Active := new System.Boolean(0xF4, 0, this)
            secondsSinceStarted := new System.Single(0x114, 0, this)
            basicMonstersSapwnedThisArea := new System.Int32(0x150, 0, this)
        }

        class AreaLevel extends System.Object
        {
            level := new System.Int32(0x28, 0, this)
            QuestRemaining := new System.Int32(0x30, 0, this)
        }

        class AreaTransitioner extends System.Object
        {
            ;k__BackingField
            IsTransitioning := new System.Boolean(0x1C, 0, this)
            transitionDirection := new CrusadersGame.GameScreen.AreaTransitioner.AreaTransitionDirection(0x20, 0, this)

            class AreaTransitionDirection extends System.Enum
            {
                Type := "System.Int32"
                Enum := {0:"Forward", 1:"Backward", 2:"Static"}
            }
        }

        class CrusadersGameController extends System.Object
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

        class Formation extends System.Object
        {
            slots := new System.List(0xC, 0, this, CrusadersGame.GameScreen.FormationSlot)
            transitionOverrides := new System.Dictionary(0x54, 0, this, CrusadersGame.GameScreen.Formations.FormationSlotRunHandler.TransitionDirection, [System.List, System.Action])
            transitionDir := new CrusadersGame.GameScreen.Formations.FormationSlotRunHandler.TransitionDirection(0xE0, 0, this)
            inAreaTransition := new System.Boolean(0xE4, 0, this)
            numAttackingMonstersReached := new System.Int32(0xEC, 0, this)
            numRangedAttackingMonsters := new System.Int32(0xF0, 0, this)
        }

        class Formations
        {
            class FormationSlotRunHandler
            {
                class TransitionDirection extends System.Enum
                {
                    Type := "System.Int32"
                    Enum := {0:"OnFromLeft", 1:"OnFromRight", 2:"OffToLeft", 3:"OffToRight"}
                }
            }
        }

        class FormationSlot extends System.Object
        {
            hero := new CrusadersGame.GameScreen.Hero(0x14, 0, this)
            heroAlive := new System.Boolean(0x151, 0, this)
        }

        ;base object is System.Object
        class Hero extends System.Object
        {
            ;CrusadersGame.GameScreen.Hero-FIELDS
            def := new CrusadersGame.Defs.HeroDef(0xC, 0x00, this)
            effects := new CrusadersGame.Effects.EffectKeyCollection(0x40, 0, this)
            allUpgradesOrdered := new System.Dictionary(0x10C, 0, this, CrusadersGame.ChampionsGameInstance, [System.List, CrusadersGame.Defs.UpgradeDef])
            effectsByUpgradeId := new System.Dictionary(0x11C, 0x0, this, System.Int32, [System.List, CrusadersGame.Effects.Effect])
            Owned := new System.Boolean(0x180, 0, this)
            slotID := new System.Int32(0x184, 0x00, this)
            Benched := new System.Boolean(0x190, 0, this)
            ;k__Backingfield
            Level := new System.Int32(0x1AC, 0x00, this)
            health := new System.Double(0x1E0, 0, this)
        }

        class Monster extends UnityGameEngine.Display.Drawable
        {
            active := new System.Boolean(0x73D, 0, this)
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
                    ultimateItems := new System.List(0x260, 0, this, CrusadersGame.GameScreen.UIComponents.UltimatesBar.UltimatesBarItem)
                }

                class UltimatesBarItem extends UnityGameEngine.Display.Drawable
                {
                    hero := new CrusadersGame.GameScreen.Hero(0x258, 0, this)
                }
            }
        }

        ;base object is System.Object
        class UIController extends System.Object
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
            class UserInstanceDataHandler extends System.Object
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
                resetting := new System.Boolean(0x1C, 0, this)
                tries := new System.Int32(0x20, 0, this)
            }
        }

        class UserData extends System.Object
        {
            HeroHandler := new CrusadersGame.User.UserHeroHandler(0x8, 0, this)
            StatHandler := new CrusadersGame.User.UserStatHandler(0x18, 0, this)
            ModronHandler := new CrusadersGame.User.UserModronHandler(0x6C, 0, this)
            redRubies := new System.Int32(0x134, 0, this)
            redRubiesSpent := new System.Int32(0x138, 0, this)
            inited := new System.Boolean(0x150, 0, this)
            ActiveUserGameInstance := new System.Int32(0x164, 0, this)
        }

        ;base object only includes parent (User), so recursive... maybe
        class UserHeroHandler extends System.Object
        {
            ;CrusadersGame.User.UserHeroHandler-FIELDS
            heroes := new System.List(0xC, 0x00, this, CrusadersGame.GameScreen.Hero)
        }
        
        class UserDataHandler extends System.Object
        {

        }

        class UserInstanceFormationSaveHandler extends CrusadersGame.User.UserDataHandler
        {
            formationSavesV2 := new System.List(0x18, 0, this, CrusadersGame.Defs.FormationSaveV2Def)
            formationCampaignID := new System.Int32(0x40, 0, this)
        }

        class UserModronHandler extends CrusadersGame.User.UserDataHandler
        {
            modronSaves := new System.List(0x10, 0, this, CrusadersGame.User.UserModronHandler.ModronCoreData)

            class ModronCoreData extends System.Object
            {
                ;ahk: CrusadersGame.User.UserModronHandler.ModronCoreData
                ;mono: CrusadersGame.User.UserModronHandler+ModronCoreData
                FormationSaves := new System.Dictionary(0xC, 0, this, System.Int32, System.Int32)
                CoreID := new System.Int32(0x24, 0, this)
                InstanceID := new System.Int32(0x28, 0, this)
                ExpTotal := new System.Int32(0x2C, 0, this)
                targetArea := new System.Int32(0x30, 0, this)
            }
        }

        class UserStatHandler extends CrusadersGame.User.UserDataHandler
        {
            BlackViperTotalGems := new System.Int32(0x268, 0, this)
            BrivSteelbonesStacks := new System.Int32(0x2C8, 0, this)
            BrivSprintStacks := new System.Int32(0x2CC, 0, this)
        }
    }
}

class OfflineProgressHandler extends System.Object
{
    modronSave := new CrusadersGame.User.UserModronHandler.ModronCoreData(0x20, 0, this)
    monstersSpawnedThisArea := new System.Int32(0xA0, 0, this)
    inGameNumSecondsToProcess := new System.Int32(0xB4, 0, this)
    finishedOfflineProgressType := new OfflineProgressHandler.OfflineCompleteType(0x10C, 0, this)

    class OfflineCompleteType extends System.Enum
    {
        Type := "System.Int32"
        Enum := {0:"Canceled", 1:"FinishedFullTime", 2:"FinishedPartialTimeWithReset"}
    }
}

class UnityGameEngine
{
    class Data
    {
        ;base object is System.Object
        class DataDef extends System.Object
        {
            ;UnityGameEngine.Data.DataDef-FIELDS
            ID := new System.Int32(0x8, 0x00, this)
        }
    }

    class Display
    {
        
        class DrawableButton extends UnityGameEngine.Display.Drawable
        {
            toggled := new System.Boolean(0x27A, 0, this)
        }

        ;base object is System.Object
        class Drawable extends System.Object
        {

        }
    }

    ;base object is System.Object
    class GameBase extends System.Object
    {
        ;UnityGameEngine.GameBase-FIELDS
        screenController := new UnityGameEngine.GameScreenController.ScreenController(0x8, 0x0, this)
    }

    class GameScreenController
    {
        class GameScreen extends System.Object
        {
            currentScreenWidth := new System.Int32(0x23C, 0x0, this)
            currentScreenHeight := new System.Int32(0x240, 0x0, this)
        }

        ;need to figure out how to have this also look at crusadersGameScreen class to get uiController and other items
        class ScreenController extends System.Object
        {
            activeScreen := new UnityGameEngine.GameScreenController.GameScreen(0xC, 0x0, this)
        }
    }

    class UserLogin
    {
        class GameUser extends System.Object
        {
            Hash := new System.String(0x10, 0, this)
            ID := new System.Int32(0x30, 0, this)
        }
    }
}