#include %A_LineFile%\..\IC_MemoryReader_Class.ahk
#include %A_LineFile%\..\IC_MemoryObjects_Class.ahk
;so we can pick the Steam or EGS offset on initialization of script.
MemoryReader.CheckICactive()
MemoryReader.Refresh()

class Static_Base_CoreEngineSettings extends System.StaticBase
{
    static Offset := MemoryReader.Reader.Is64Bit ? 0x493DC8 : 0x3A1C54
}

class CoreEngineSettings extends System.Object
{
    __new()
    {
        this.Offset := MemoryReader.Reader.Is64Bit ? 0x30 : 0x1C
        this.GetAddress := this.variableGetAddress
        this.ParentObj := Static_Base_CoreEngineSettings
        this.StaticOffset := MemoryReader.Reader.Is64Bit ? 0xF60 : 0xF88
        this.WebRoot := new System.String(this.StaticOffset + 0x8, this.StaticOffset + 0x10, this)
        return this
    }
}
