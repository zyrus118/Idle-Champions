; A class to manage and make available instances of class Memory
; TODO add error handling, allow for multiple isntances, allow for instances of different exe names, allow for instances of differe module base addresses

class _ClassMemoryManager
{
    static exeName := "IdleDragons.exe"
    baseAddress := {}

    classMemory[]
    {
        get
        {
            if !(_ClassMemoryManager.isInstantiated)
            {
                _ClassMemoryManager.Refresh()
            }
            return _ClassMemoryManager.instance
        }
    }

    Refresh()
    {
        _ClassMemoryManager.isInstantiated := false
        _ClassMemoryManager.instance := new _ClassMemory("ahk_exe " . _ClassMemoryManager.exeName, "", _ClassMemoryManager.handle)
        if IsObject(_ClassMemoryManager.instance)
        {
            _ClassMemoryManager.isInstantiated := true
        }
        else
        {
            return false
        }
        _ClassMemoryManager.baseAddress["mono-2.0-bdwgc.dll"] := _ClassMemoryManager.instance.getModuleBaseAddress("mono-2.0-bdwgc.dll")
        return true
    }
}