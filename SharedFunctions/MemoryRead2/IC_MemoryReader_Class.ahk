#Include, IC_MemoryObjects_Class.ahk
#Include, \Structures\IdleGameManager.ahk
#Include, \Structures\ActiveEffectHandler.ahk

class MemoryReader
{
    Structures := {}
    StructuresDictionary := {}

    Refresh()
    {
        ;create new instance of reader
        this.Reader := new _ClassMemory("ahk_exe IdleDragons.exe", "", hProcessCopy)
        this.ModuleBaseAddress := this.Reader.getModuleBaseAddress("mono-2.0-bdwgc.dll")
        ;clear static addresses
        size := this.Structures.Count()
        loop %size%
        {
            this.Structures[A_Index].SetAddress(false)
        }
    }

    CheckForIC()
    {
        while (Not WinExist( "ahk_exe IdleDragons.exe" ))
        {
            MsgBox, 5, Error, The script cannot detect Idle Champions game client. Restart Idle Champions and press retry or press cancel to exit the script.
            IfMsgBox, Retry
            {
                MemoryReader.Refresh()
                sleep, 500
            }
            else
                ExitApp
        }
    }

    AddToStructures(key, value)
    {
        this.Structures.Push(value)
        this.StructuresDictionary[key] := this.Structures.Count()
    }

    RemoveFromStructures(key)
    {
        if this.StructuresDictionary.HasKey(key)
            this.Structures.RemoveAt(this.StructuresDictionary.Delete(key))
    }

    InitIdleGameManager()
    {
        if IsObject(this.IdleGameManager)
            return this.IdleGameManager
        this.IdleGameManager := new IdleGameManager
        this.AddToStructures("IdleGameManager", this.IdleGameManager)
        return this.IdleGameManager
    }

    InitGameInstance()
    {
        if IsObject(this.GameInstance)
            return this.GameInstance
        if !(this.StructuresDictionary.HasKey("IdleGameManager"))
            this.InitIdleGameManager()
        this.GameInstance := this.IdleGameManager.game.gameInstances.Item[0]
        this.AddToStructures("GameInstance", this.GameInstance)
        return this.GameInstance
    }

    DestroyInstance(key)
    {
        this[key] := ""
        this.RemoveFromStructures(key)
    }
}