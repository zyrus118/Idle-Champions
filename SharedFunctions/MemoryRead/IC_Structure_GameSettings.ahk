#include %A_LineFile%\..\IC_MemoryReader_Class.ahk
#include %A_LineFile%\..\IC_MemoryObjects_Class.ahk
;so we can pick the Steam or EGS offset on initialization of script.
MemoryReader.CheckICactive()
MemoryReader.Refresh()

class Static_Base_GameSettings extends System.StaticBase
{
    static Offset := MemoryReader.Reader.Is64Bit ? 0x493E40 : 0x3AB064
}

class GameSettings extends System.Object
{
    __new()
    {
        this.Offset := MemoryReader.Reader.Is64Bit ? 0x820 : 0x408
        this.GetAddress := this.variableGetAddress
        this.ParentObj := Static_Base_GameSettings
        this.StaticOffset := MemoryReader.Reader.Is64Bit ? 0xA80 : 0xE00
        this.UserID := new System.Int32(this.StaticOffset + 0x20, this.StaticOffset + 0x40, this)
        this.Hash := new System.String(this.StaticOffset + 0x28, this.StaticOffset + 0x48, this)
        this.Platform := new System.Int32(this.StaticOffset + 0x44, this.StaticOffset + 0x70, this)
        this.MobileClientVersion := new System.Int32(this.StaticOffset + 0x4C, this.StaticOffset + 0x80, this)
        this.PostFix := new System.String(this.StaticOffset + 0x50, this.StaticOffset + 0x88, this)
        this.Instance := new GameSettings._Instance(this.StaticOffset, this.StaticOffset, this)
        return this
    }

    class _Instance extends System.Object
    {
        instanceID := new System.Int64(0x10, 0, this)
    }
}
