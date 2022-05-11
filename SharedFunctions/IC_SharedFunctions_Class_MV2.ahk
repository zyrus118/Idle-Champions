class IC_SharedFunctions_Class_MV2 extends IC_SharedFunctions_Class
{
    ;i want to re evaluate the autoprogress togled prop
    ; IsToggled be 0 for off or 1 for on. ForceToggle always hits G. ForceState will press G until AutoProgress is read as on (<5s).
    ToggleAutoProgress( isToggled := 1, forceToggle := false, forceState := false )
    {
        startTime := A_TickCount
        if ( forceToggle )
            VirtualKeyInputs.Priority("g")
        if ( this.AutoProgressToggled != isToggled )
            VirtualKeyInputs.Priority("g")
        while ( forceState AND this.AutoProgressToggled != isToggled AND (A_TickCount - startTime) < 5001 )
            VirtualKeyInputs.Priority("g")
    }

    ; waitTime: max time in ms will wait to finish zone, lvlFormation: bool to call method, inputs: variadic param of inputs
    FinishZone(waitTime, lvlFormation, inputs*)
    {
        startTime := A_TickCount
        elapsedTime := 0
        isTransitioning := MemoryReader.GameInstance.Controller.areaTransitioner.IsTransitioning.GetValue()
        while (elapsedTime < waitTime AND !isTransitioning)
        {
            if lvlFormation
                lvlFormation := g_Level.LevelFormationSmart(inputs*)
            else if (inputs.Count())
                VirtualKeyInputs.Priority(inputs*)
            else
                sleep, 100
            elapsedTime := A_TickCount-startTime
            isTransitioning := MemoryReader.GameInstance.Controller.areaTransitioner.IsTransitioning.GetValue()
        }
        return
    }

    ; checks if idle champions is open, but limits the check to once every 5 seconds unless forceCheck param set to true
    SafetyCheck(forceCheck := false)
    {
        static lastRan := 0
        if (forceCheck OR (lastRan + 5000 < A_TickCount))
        {
            if (Not WinExist( "ahk_exe IdleDragons.exe" ))
                return false
        }
        return true
    }

    OpenIC(installPath)
    {
        file := installPath . "IdleDragons.exe"
        Run, %file%

        startTime := A_TickCount
        elapsedTime := 0
        sleep, 1000
        While (Not WinExist("ahk_exe IdleDragons.exe") AND elapsedTime < 9000)
        {
            sleep, 1000
            elapsedTime := A_TickCount - startTime
        }

        if (elapsedTime > 9000)
        {
            return false
        }

        this.LoadGame()
        return true
    }

    class Loader
    {
        __new()
        {
            MemoryReader.Refresh()
            this.game := MemoryReader.IdleGameManager.game
            this.gameStartedPrev := ""
            this.gameUser := this.game.gameUser
            this.userLoadedPrev := ""
            this.loadingScreen := this.game.loadingScreen
            this.loadingDefinitionsPrev := ""
            this.loadingGameUserPrev := ""
            this.loadingProgressPrev := ""
            this.loadingTextPrev := ""
            this.socialUserAuthenticationDonePrev := ""
        }

        gameStarted[]
        {
            get
            {
                value := this.game.gameStarted.GetValue()
                if (value != this.gameStartedPrev)
                {
                    g_Log.AddData("gameStarted", value)
                    this.gameStartedPrev := value
                }
                return value
            }
        }

        userLoaded[]
        {
            get
            {
                value := this.gameUser.Loaded.GetValue()
                if (value != this.userLoadedPrev)
                {
                    g_Log.AddData("gameUser.Loaded", value)
                    this.userLoadedPrev := value
                }
                return value
            }
        }

        loadingDefinitions[]
        {
            get
            {
                value := this.loadingScreen.loadingDefinitions.GetValue()
                if (value != this.loadingDefinitionsPrev)
                {
                    g_Log.AddData("loadingDefinitions", value)
                    this.loadingDefinitionsPrev := value
                }
                return value
            }
        }

        loadingGameUser[]
        {
            get
            {
                value := this.loadingScreen.loadingGameUser.GetValue()
                if (value != this.loadingGameUserPrev)
                {
                    g_Log.AddData("loadingGameUser", value)
                    this.loadingGameUserPrev := value
                }
                return value
            }
        }

        loadingProgress[]
        {
            get
            {
                value := this.loadingScreen.loadingProgress.GetValue()
                if (value != this.loadingProgressPrev)
                {
                    g_Log.AddData("loadingProgress", value)
                    this.loadingProgressPrev := value
                }
                return value
            }
        }

        loadingText[]
        {
            get
            {
                value := this.loadingScreen.loadingText.lastSetText.GetValue()
                if (value != this.loadingTextPrev)
                {
                    g_Log.AddData("loadingText", value)
                    this.loadingTextPrev := value
                }
                return value
            }
        }

        socialUserAuthenticationDone[]
        {
            get
            {
                value := this.loadingScreen.socialUserAuthenticationDone.GetValue()
                if (value != this.socialUserAuthenticationDonePrev)
                {
                    g_Log.AddData("socialUserAuthenticationDone", value)
                    this.socialUserAuthenticationDonePrev := value
                }
                return value
            }
        }
    }

    LoadGame()
    {
        g_Log.CreateEvent(A_ThisFunc)
        loader := new IC_SharedFunctions_Class_MV2.Loader
        startTime := A_TickCount
        elapsedTime := 0
        while (!loader.gameStarted AND elapsedTime < 60000)
        {
            if (this.SafetyCheck())
            {
                this.OpenIC()
                return
            }
            loader.userLoaded
            loader.loadingDefinitions
            loader.loadingGameUser
            loader.loadingProgress
            loader.loadingText
            loader.socialUserAuthenticationDone
            sleep, 100
            elapsedTime := A_TickCount - startTime
        }
        loader := ""
        if (elapsedTime > 60000)
        {
            this.CloseIC()
            this.OpenIC()
            return
        }
        return

        /*  game.LoadingScreen.BeginLoading() is called
                various checks for console/mobile platforms
                this.LoadGraphics() called
            
            which just calls this.LoadDefinitions()
                this.loadingDefinitions = true;
                this.SetLoadingText(this.selectingServerString);
                    will set this.loadingText.lastSetText = this.selectServerString = "Selecting Play Server"
                loads local and connects to network
                attempts 5 times before giving up, no instance of this class is created to read attempts :(
                    maybe look up how long each request will take does seem it can be stuck indefinitely here though
            
            uses call back this.ContinueDefinitions()
                this.SetLoadingText(this.loadingDefinitionsString);
                    loadingDefinitionsString = "Loading Game Definitions $prog";
                loads definitions with the whole progress bar thing, replacing $prog

            uses call back this.LoadGameUser()
                OfflineProgressHandler.SetupOfflineProgressionRules();
                this.loadUserReady = true;
                this.loadingGameUser = true;
                this.SetLoadingText(CrusadersGameDataSet.Instance.GetTextDefineByKey("connecting_to_server", "Connecting to Server"));
            
            appears to call this.UserLoggedIn(), maybe multiple times
                this.loadingGameUser = false;
                multiple try/catch
                if this.gameuser.loaded = false pops dialog box could not connect to platform

            appears to call this.LoadUser()
                this.loadingDefinitionsProgress = 40f;
                this.loadingDefinitions = false;
                string textDefineByKey = CrusadersGameDataSet.Instance.GetTextDefineByKey("loading_user_account", "Loading User Account");
                this.SetLoadingText(textDefineByKey);
                this.loadingProgress += 10;

            this.PreloadGraphics()
                this.SetLoadingText(CrusadersGameDataSet.Instance.GetTextDefineByKey("loading_background_graphics", "Loading: Background Graphics"));
			    this.loadingProgress += 10;

            this.PreloadNextGraphic()
                appears to call itself over and over if (this.preloadGraphicIDs.Count > 0)
                removing graphic at 0
                string text = this.graphicNames[0];
				this.loadingProgress += 10;
				this.SetLoadingText(CrusadersGameDataSet.Instance.GetTextDefineByKey("loading", "Loading") + ": " + text);
                checks to complete from splash screen or complete, splash screen waits then fades out and calls this.Complete()

            this.Complete
                this.SetLoadingText(CrusadersGameDataSet.Instance.GetTextDefineByKey("starting_game", "Starting Game!"));
                this.loadingProgress += 10;
                new SimpleTimer(0.5f, new SimpleTimerTick(this.MakeCallback), false, false);

                finally checks for terms of service.
        */
    }

    ;need to add safety check for monsters attacking and stopping formation loading
    ; a function to confirm an adventure is loaded and accepting inputs, param == instance of IC_HeroHandler_Class
    LoadAdventure(hero)
    {
        g_Log.CreateEvent(A_ThisFunc)
        starTime := A_TickCount
        elapsedTime := 0
        VirtualKeyInputs.Generic("e", hero.Fkey)
        while (!hero.Benched AND elapsedTime < 60000)
        {
            VirtualKeyInputs.Generic("e", hero.Fkey)
            sleep, 100
            elapsedTime := A_TickCount - startTime
        }
        if (elapsedTime > 60000)
        {
            g_SF.CloseIC()
            g_Log.AddData("elapsedTime: Benching", elapsedTime)
            g_Log.EndEvent()
            return
        }
        startTime := A_TickCount
        elapsedTime := 0
        VirtualKeyInputs.Generic("w", hero.Fkey)
        while (hero.Benched AND elapsedTime < 60000)
        {
            VirtualKeyInputs.Generic("w", hero.Fkey)
            sleep, 100
            elapsedTime := A_TickCount - startTime
        }
        if (elapsedTime > 60000)
        {
            g_SF.CloseIC()
            g_Log.AddData("elapsedTime: unBenching", elapsedTime)
            g_Log.EndEvent()
            return
        }
        g_Log.EndEvent()
        return
    }

    ;A function that closes IC. If IC takes longer than 60 seconds to save and close then the script will force it closed.
    CloseIC( string := "" )
    {
        g_Log.CreateEvent(A_ThisFunc)
        g_Log.AddData("string", string)
        if WinExist( "ahk_exe IdleDragons.exe" )
            SendMessage, 0x112, 0xF060,,, ahk_exe IdleDragons.exe,,,, 10000 ; WinClose
        StartTime := A_TickCount
        ElapsedTime := 0
        while ( WinExist( "ahk_exe IdleDragons.exe" ) AND ElapsedTime < 10000 )
            ElapsedTime := A_TickCount - StartTime
        while ( WinExist( "ahk_exe IdleDragons.exe" ) ) ; Kill after 10 seconds.
            WinKill
        g_Log.EndEvent()
        return
    }

    IsCurrentFormation(formation)
    {
        g_Log.CreateEvent(A_ThisFunc)
        if(!IsObject(formation))
        {
            g_Log.AddData("formation", formation)
            g_Log.EndEvent()
            return false
        }
        slots := MemoryReader.GameInstance.Controller.formation.slots
        slots.SetAddress(true)
        loop, % formation.Count()
        {
            if(formation[A_Index] != slots.Item[A_Index - 1].hero.def.ID.GetValue())
            {
                g_Log.AddData("match", false)
                g_Log.EndEvent()
                return false
            }
        }
        g_Log.AddData("match", true)
        g_Log.EndEvent()
        return true
    }
}