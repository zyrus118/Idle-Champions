class IdleGameManager_Parent extends System.StaticBase
{
    static Offset := MemoryReader.Reader.Is64Bit ? 0x0 : 0x3A0574
}

;instance := new IdleGameManager
class IdleGameManager extends GameManager
{
    ;FB-IdleGameManager
    game := new CrusadersGame.Game(160, 0x00, this)
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
    TimeScale := new System.Single(72, 0x0, this)
    ;FE
}

class CrusadersGame
{
    class ChampionsGameInstance extends System.Object
    {
        ;FB-CrusadersGame.ChampionsGameInstance
        Screen := new CrusadersGame.GameScreen.CrusadersGameScreen(8, 0x0, this)
        Controller := new CrusadersGame.GameScreen.CrusadersGameController(12, 0x0, this)
        ActiveCampaignData := new CrusadersGame.GameScreen.ActiveCampaignData(16, 0x0, this)
        HeroHandler := new CrusadersGame.User.Instance.UserInstanceHeroHandler(20, 0x00, this)
        ResetHandler := new CrusadersGame.User.Instance.UserInstanceResetHandler(28, 0x0, this)
        PatronHandler := new CrusadersGame.User.Instance.UserInstancePatronHandler(40, 0x0, this)
        FormationSaveHandler := new CrusadersGame.User.UserInstanceFormationSaveHandler(48, 0x0, this)
        offlineProgressHandler := new OfflineProgressHandler(64, 0x0, this)
        ResetsSinceLastManual := new System.Int32(136, 0x0, this)
        instanceLoadTimeSinceLastSave := new System.Int32(144, 0x0, this)
        ClickLevel := new System.Int32(156, 0x0, this)
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
            ;FB-CrusadersGame.Defs.AttackDef
            CooldownTimer := new System.Single(120, 0xAC, this)
            ;FE
        }

        class EffectDef extends UnityGameEngine.Data.DataDef
        {
            ;inherits id
        }

        class HeroDef extends UnityGameEngine.Data.DataDef
        {
            ;FB-CrusadersGame.Defs.HeroDef
            name := new System.String(24, 0x0, this)
            SeatID := new System.Int32(248, 0, this)
            ;FE
        }

        class FormationSaveV2Def extends UnityGameEngine.Data.DataDef
        {
            ;FB-CrusadersGame.Defs.FormationSaveV2Def
            Formation := new System.List(12, 0, this, System.Int32)
            SaveID := new System.Int32(28, 0, this)
            Name := new System.String(24, 0, this)
            Favorite := new System.Int32(36, 0, this)
            ;FE
        }

        class PatronDef extends UnityGameEngine.Data.DataDef
        {
            ;FB-CrusadersGame.Defs.PatronDef
            Tier := new System.Int32(112, 0, this)
            ;FE
        }

        class UpgradeDef extends UnityGameEngine.Data.DataDef
        {
            ;FB-CrusadersGame.Defs.UpgradeDef
            SpecializationName := new System.String(32, 0, this)
            RequiredLevel := new System.Int32(76, 0, this)
            RequiredUpgradeID := new System.Int32(84, 0, this)
            SpecializationGraphic := new System.Int32(88, 0, this)
            ;FE
        }
    }

    class Effects
    {
        class ActiveEffectKeyHandler extends System.Object
        {

        }


        class Effect extends System.Object
        {
            ;FB-CrusadersGame.Effects.Effect
            def := new CrusadersGame.Defs.EffectDef(8, 0, this)
            effectKeyHandlers := new System.List(28, 0x0, this, CrusadersGame.Effects.EffectKeyHandler)
            ;FE
        }


        class EffectKey extends System.Object
        {
            ;FB-CrusadersGame.Effects.EffectKey
            parentEffectKeyHandler := new CrusadersGame.Effects.EffectKeyHandler(8, 0, this)
            ;FE
        }


        class EffectKeyCollection extends System.Object
        {
            ;FB-CrusadersGame.Effects.EffectKeyCollection
            effectKeysByKeyName := new System.Dictionary(44, 0, this, System.String, [System.List, CrusadersGame.Effects.EffectKey])
            ;FE
        }


        class EffectKeyHandler extends System.Object
        {
            ;FB-CrusadersGame.Effects.EffectKeyHandler
            parent := new CrusadersGame.Effects.Effect(8, 0, this)
            activeEffectHandlers := new System.List(148, 0x0, this, CrusadersGame.Effects.ActiveEffectKeyHandler)
            ;FE
        }


        class EffectStacks extends System.Object
        {
            ;FB-CrusadersGame.Effects.EffectStacks
            stackCount := new System.Double(88, 0, this)
            ;FE
        }
    }

    class Game extends UnityGameEngine.GameBase
    {
        ;FB-CrusadersGame.Game
        gameUser := new UnityGameEngine.UserLogin.GameUser(84, 0x0, this)
        gameInstances := new System.List(88, 0x00, this, CrusadersGame.ChampionsGameInstance)
        gameStarted := new System.Boolean(124, 0x0, this)
        ;FE
    }

    class GameScreen
    {
        class ActiveCampaignData extends System.Object
        {
            ;FB-CrusadersGame.GameScreen.ActiveCampaignData
            currentObjective := new CrusadersGame.Defs.AdventureDef(12, 0, this)
            currentArea := new CrusadersGame.GameScreen.AreaLevel(20, 0, this)
            currentAreaID := new System.Int32(68, 0, this)
            highestAvailableAreaID := new System.Int32(76, 0, this)
            gold := new System.Int64(528, 0, this) ;OR-TYPE
            ;FE
        }

        class Area extends System.Object
        {
            ;FB-CrusadersGame.GameScreen.Area
            activeMonsters := new System.List(36, 0, this, CrusadersGame.GameScreen.Monster)
            Active := new System.Boolean(244, 0, this)
            secondsSinceStarted := new System.Single(276, 0, this)
            basicMonstersSpawnedThisArea := new System.Int32(336, 0, this)
            ;FE
        }

        class AreaLevel extends System.Object
        {
            ;FB-CrusadersGame.GameScreen.AreaLevel
            level := new System.Int32(40, 0, this)
            QuestRemaining := new System.Int32(48, 0, this)
            ;FE
        }

        class AreaTransitioner extends System.Object
        {
            ;FB-CrusadersGame.GameScreen.AreaTransitioner
            IsTransitioning := new System.Boolean(28, 0, this)
            transitionDirection := new CrusadersGame.GameScreen.AreaTransitioner.AreaTransitionDirection(32, 0, this)
            ;FE

            class AreaTransitionDirection extends System.Enum
            {
                Type := "System.Int32"
                Enum := {0:"Forward", 1:"Backward", 2:"Static"}
            }
        }

        class CrusadersGameController extends System.Object
        {
            ;FB-CrusadersGame.GameScreen.CrusadersGameController
            area := new CrusadersGame.GameScreen.Area(12, 0x0, this)
            formation := new CrusadersGame.GameScreen.Formation(20, 0x0, this)
            areaTransitioner := new CrusadersGame.GameScreen.AreaTransitioner(32, 0x0, this)
            userData := new CrusadersGame.User.UserData(80, 0x0, this)
            ;FE
        }

        class CrusadersGameScreen extends UnityGameEngine.GameScreenController.GameScreen
        {
            ;FB-CrusadersGame.GameScreen.CrusadersGameScreen
            uiController := new CrusadersGame.GameScreen.UIController(624, 0x0, this)
            ;FE
        }

        class Formation extends System.Object
        {
            ;FB-CrusadersGame.GameScreen.Formation
            slots := new System.List(12, 0, this, CrusadersGame.GameScreen.FormationSlot)
            transitionOverrides := new System.Dictionary(84, 0, this, CrusadersGame.GameScreen.Formations.FormationSlotRunHandler.TransitionDirection, [System.ListSystem.Action<System.Action])
            transitionDir := new CrusadersGame.GameScreen.Formations.FormationSlotRunHandler.TransitionDirection(224, 0, this)
            inAreaTransition := new System.Boolean(228, 0, this)
            numAttackingMonstersReached := new System.Int32(236, 0, this)
            numRangedAttackingMonsters := new System.Int32(240, 0, this)
            ;FE
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
            ;FB-CrusadersGame.GameScreen.FormationSlot
            hero := new CrusadersGame.GameScreen.Hero(20, 0, this)
            heroAlive := new System.Boolean(337, 0, this)
            ;FE
        }


        class Hero extends System.Object
        {
            ;FB-CrusadersGame.GameScreen.Hero
            def := new CrusadersGame.Defs.HeroDef(12, 0x00, this)
            effects := new CrusadersGame.Effects.EffectKeyCollection(64, 0, this)
            allUpgradesOrdered := new System.Dictionary(268, 0, this, CrusadersGame.ChampionsGameInstance, [System.List, CrusadersGame.Defs.UpgradeDef])
            effectsByUpgradeId := new System.Dictionary(284, 0x0, this, System.Int32, [System.List, CrusadersGame.Effects.Effect])
            Owned := new System.Boolean(384, 0, this)
            slotID := new System.Int32(388, 0x00, this)
            Benched := new System.Boolean(400, 0, this)
            Level := new System.Int32(428, 0x00, this)
            health := new System.Double(480, 0, this)
            ;FE
        }

        class Monster extends UnityGameEngine.Display.Drawable
        {
            ;FB-CrusadersGame.GameScreen.Monster
            active := new System.Boolean(1865, 0, this)
            ;FE
        }

        class UIComponents
        {
            class TopBar
            {
                ;class ObjectiveProgress
                ;{
                    class AreaLevelBar extends UnityGameEngine.Display.Drawable
                    {
                        ;FB-CrusadersGame.GameScreen.UIComponents.TopBar.ObjectiveProgress.AreaLevelBar
                        autoProgressButton := new UnityGameEngine.Display.DrawableButton(576, 0, this)
                        ;FE
                    }

                    class ObjectiveProgressBox extends UnityGameEngine.Display.Drawable
                    {
                        ;FB-CrusadersGame.GameScreen.UIComponents.TopBar.ObjectiveProgress.ObjectiveProgressBox
                        areaBar := new CrusadersGame.GameScreen.UIComponents.TopBar.AreaLevelBar(600, 0, this) ;OR-TYPE
                        ;FE
                    }
                ;}

                class TopBar extends UnityGameEngine.Display.Drawable
                {
                    ;FB-CrusadersGame.GameScreen.UIComponents.TopBar.TopBar
                    objectiveProgressBox := new CrusadersGame.GameScreen.UIComponents.TopBar.ObjectiveProgressBox(572, 0, this) ;OR-TYPE
                    ;FE
                }
            }

            class UltimatesBar
            {
                class UltimatesBar extends UnityGameEngine.Display.Drawable
                {
                    ;FB-CrusadersGame.GameScreen.UIComponents.UltimatesBar.UltimatesBar
                    ultimateItems := new System.List(608, 0, this, CrusadersGame.GameScreen.UIComponents.UltimatesBar.UltimatesBarItem)
                    ;FE
                }

                class UltimatesBarItem extends UnityGameEngine.Display.Drawable
                {
                    ;FB-CrusadersGame.GameScreen.UIComponents.UltimatesBar.UltimatesBarItem
                    hero := new CrusadersGame.GameScreen.Hero(600, 0, this)
                    ;FE
                }
            }
        }


        class UIController extends System.Object
        {
            ;FB-CrusadersGame.GameScreen.UIController
            topBar := new CrusadersGame.GameScreen.UIComponents.TopBar.TopBar(12, 0, this)
            ultimatesBar := new CrusadersGame.GameScreen.UIComponents.UltimatesBar.UltimatesBar(20, 0, this)
            ;FE
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
                ;FB-CrusadersGame.User.Instance.UserInstanceHeroHandler
                parent := new CrusadersGame.User.UserHeroHandler(36, 0x00, this)
                ;FE
            }

            class UserInstancePatronHandler extends CrusadersGame.User.Instance.UserInstanceDataHandler
            {
                ;FB-CrusadersGame.User.Instance.UserInstancePatronHandler
                ActivePatron := new CrusadersGame.Defs.PatronDef(16, 0, this)
                ;FE
            }

            class UserInstanceResetHandler extends CrusadersGame.User.Instance.UserInstanceDataHandler
            {
                ;FB-CrusadersGame.User.Instance.UserInstanceResetHandler
                resetting := new System.Boolean(28, 0, this)
                tries := new System.Int32(32, 0, this)
                ;FE
            }
        }

        class UserData extends System.Object
        {
            ;FB-CrusadersGame.User.UserData
            HeroHandler := new CrusadersGame.User.UserHeroHandler(8, 0, this)
            StatHandler := new CrusadersGame.User.UserStatHandler(24, 0, this)
            ModronHandler := new CrusadersGame.User.UserModronHandler(108, 0, this)
            redRubies := new System.Int32(308, 0, this)
            redRubiesSpent := new System.Int32(312, 0, this)
            inited := new System.Boolean(336, 0, this)
            ActiveUserGameInstance := new System.Int32(356, 0, this)
            ;FE
        }

        ;base object only includes parent (User), so recursive... maybe
        class UserHeroHandler extends System.Object
        {
            ;FB-CrusadersGame.User.UserHeroHandler
            heroes := new System.List(12, 0x00, this, CrusadersGame.GameScreen.Hero)
            ;FE
        }
        
        class UserDataHandler extends System.Object
        {

        }

        class UserInstanceFormationSaveHandler extends CrusadersGame.User.UserDataHandler
        {
            ;FB-CrusadersGame.User.UserInstanceFormationSaveHandler
            formationSavesV2 := new System.List(24, 0, this, CrusadersGame.Defs.FormationSaveV2Def)
            formationCampaignID := new System.Int32(64, 0, this)
            ;FE
        }

        class UserModronHandler extends CrusadersGame.User.UserDataHandler
        {
            ;FB-CrusadersGame.User.UserModronHandler
            modronSaves := new System.List(16, 0, this, CrusadersGame.User.UserModronHandler.ModronCoreData)
            ;FE

            class ModronCoreData extends System.Object
            {
                ;FB-CrusadersGame.User.UserModronHandler+ModronCoreData
                FormationSaves := new System.Dictionary(12, 0, this, System.Int32, System.Int32)
                CoreID := new System.Int32(36, 0, this)
                InstanceID := new System.Int32(40, 0, this)
                ExpTotal := new System.Int32(44, 0, this)
                targetArea := new System.Int32(48, 0, this)
                ;FE
            }
        }

        class UserStatHandler extends CrusadersGame.User.UserDataHandler
        {
            ;FB-CrusadersGame.User.UserStatHandler
            BlackViperTotalGems := new System.Int32(616, 0, this)
            BrivSteelbonesStacks := new System.Int32(712, 0, this)
            BrivSprintStacks := new System.Int32(716, 0, this)
            ;FE
        }
    }
}

class OfflineProgressHandler extends System.Object
{
    ;FB-OfflineProgressHandler
    modronSave := new CrusadersGame.User.UserModronHandler.ModronCoreData(32, 0, this)
    monstersSpawnedThisArea := new System.Int32(160, 0, this)
    inGameNumSecondsToProcess := new System.Int32(180, 0, this)
    finishedOfflineProgressType := new OfflineProgressHandler.OfflineCompleteType(268, 0, this)
    ;FE

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
        class DataDef extends System.Object
        {
            ;FB-UnityGameEngine.Data.DataDef
            ID := new System.Int32(8, 0x00, this)
            ;FE
        }
    }

    class Display
    {
        class DrawableButton extends UnityGameEngine.Display.Drawable
        {
            ;FB-UnityGameEngine.Display.DrawableButton
            toggled := new System.Boolean(634, 0, this)
            ;FE
        }


        class Drawable extends System.Object
        {

        }
    }

    class GameBase extends System.Object
    {
        ;FB-UnityGameEngine.GameBase
        screenController := new UnityGameEngine.GameScreenController.ScreenController(8, 0x0, this)
        ;FE
    }

    class GameScreenController
    {
        class GameScreen extends System.Object
        {
            ;FB-UnityGameEngine.GameScreenController.GameScreen
            currentScreenWidth := new System.Int32(572, 0x0, this)
            currentScreenHeight := new System.Int32(576, 0x0, this)
            ;FE
        }

        class ScreenController extends System.Object
        {
            ;FB-UnityGameEngine.GameScreenController.ScreenController
            activeScreen := new CrusadersGame.GameScreen.CrusadersGameScreen(12, 0x0, this)  ;OR-TYPE
            ;FE
        }
    }

    class UserLogin
    {
        class GameUser extends System.Object
        {
            ;FB-UnityGameEngine.UserLogin.GameUser
            Hash := new System.String(16, 0, this)
            ID := new System.Int32(48, 0, this)
            ;FE
        }
    }
}