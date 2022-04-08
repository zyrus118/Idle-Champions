class MemoryReader
{
    Refresh()
    {
        this.Reader := new _ClassMemory("ahk_exe IdleDragons.exe", "", hProcessCopy)
        this.ModuleBaseAddress := this.Reader.getModuleBaseAddress("mono-2.0-bdwgc.dll")
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
}