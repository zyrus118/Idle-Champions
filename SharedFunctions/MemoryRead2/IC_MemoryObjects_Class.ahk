class System
{
    class Object
    {
        __new(offset32, offset64, parentObj)
        {
            this.Offset := MemoryReader.Reader.isTarget64bit ? offset64 : offset32
            this.GetAddress := this.variableGetAddress
            this.ParentObj := parentObj
            return this
        }

        variableGetAddress()
        {
            return MemoryReader.Reader.read(this.ParentObj.GetAddress() + this.Offset, MemoryReader.Reader.ptrType)
        }

        SetAddress(setStatic)
        {
            if setStatic
            {
                this.Address := this.variableGetAddress()
                this.GetAddress := this.staticGetAddress
            }
            else
                this.GetAddress := this.variableGetAddress
        }

        staticGetAddress()
        {
            return this.Address
        }
    }

    class Collection extends System.Object
    {
        NewChild(parent, type, offset)
        {
            if (type[1].__Class == "System.List")
                obj := new System.List(offset, offset, parent, type[2])
            else if (type[1].__Class == "System.DIctionary")
                obj := new System.Dictionary(offset, offset, parent, type[2], type[3])
            else
                obj := new type(offset, offset, parent)
            return obj
        }
    }

    ;item base is the memory class, and item type is the c# type
    class List extends System.Collection
    {
        __new(offset32, offset64, parentObject, itemType)
        {
            this.Offset := MemoryReader.Reader.isTarget64bit ? offset64 : offset32
            this.ParentObj := parentObject
            this.GetAddress := this.variableGetAddress
            this.List := new System.Object(offset32, offset64, parentObject)
            this._items := new System.Object(0x8, 0x10, this)
            this._size := new System.Int32(0xC, 0x18, this)
            this.ItemOffsetBase := MemoryReader.Reader.isTarget64bit ? 0x20 : 0x10
            this.ItemOffsetStep := MemoryReader.Reader.isTarget64bit ? 0x8 : 0x4
            this.ItemType := itemType
            return this 
        }
        
        Size()
        {
            return this._size.GetValue()
        }

        GetItemOffset(index)
        {
            return this.ItemOffsetBase + (index * this.ItemOffsetStep)
        }

        Item[index]
        {
            get
            {
                return this.NewChild(this._items, this.ItemType, this.GetItemOffset(index))
            }
        }
    }

    class Dictionary extends System.Collection
    {
        __new(offset32, offset64, parentObject, keyType, valueType)
        {
            this.Offset := MemoryReader.Reader.isTarget64bit ? offset64 : offset32
            this.ParentObj := parentObject
            this.GetAddress := this.variableGetAddress
            this.Dict := new System.Object(offset32, offset64, parentObject)
            this.entries := new System.Object(0xC, 0x10, this)
            this.count := new System.Int32(0x20, 0x18, this)
            this.KeyOffsetBase := MemoryReader.Reader.isTarget64bit ? 0x28 : 0x18
            this.ValueOffsetBase := MemoryReader.Reader.isTarget64bit ? 0x30 : 0x1C
            this.OffsetStep := MemoryReader.Reader.isTarget64bit ? 0x18 : 0x10
            this.KeyType := keyType
            this.ValueType := valueType
            return this
        }

        Key[index]
        {
            get
            {
                return this.NewChild(this.entries, this.KeyType, this.GetKeyOffset(index))
            }
        }

        Value[index]
        {
            get
            {
                return this.NewChild(this.entries, this.ValueType, this.GetValueOffset(index))
            }
        }

        GetKeyOffset(index)
        {
            return this.KeyOffsetBase + (index * this.OffsetStep)
        }

        GetValueOffset(index)
        {
            return this.ValueOffsetBase + (index * this.OffsetStep)
        }
    }

    class Value extends System.Object
    {
        GetValue()
        {
            return MemoryReader.Reader.read(this.ParentObj.GetAddress() + this.Offset, this.Type)
        }
    }

    class Byte extends System.Value
    {
        Type := "Char"
    }

    class UByte extends System.Value
    {
        Type := "UChar"
    }

    class Short extends System.Value
    {
        Type := "Short"
    }

    class UShort extends System.Value
    {
        Type := "UShort"
    }

    class Int32 extends System.Value
    {
        Type := "Int"
    }

    class UInt32 extends System.Value
    {
        Type := "UInt"
    }

    class Int64 extends System.Value
    {
        Type := "Int64"
    }

    class UInt64 extends System.Value
    {
        Type := "UInt64"
    }

    class Single extends System.Value
    {
        Type := "Float"
    }

    class USingle extends System.Value
    {
        Type := "UFloat"
    }

    class Double extends System.Value
    {
        Type := "Double"
    }

    class Boolean extends System.Value
    {
        Type := "Char"
    }

    class String extends System.Object
    {
        __new(offset32, offset64, parentObj)
        {
            this.Offset := MemoryReader.Reader.isTarget64bit ? offset64 : offset32
            this.GetAddress := this.variableGetAddress
            this.ParentObj := parentObj
            this.Length := new System.Int32(0x8, 0x10, this)
            this.Value := {}
            this.Value.Offset := MemoryReader.Reader.isTarget64bit ? 0x14 : 0xC
            return this
        }

        GetValue()
        {
            baseAddress := this.GetAddress()
            return MemoryReader.Reader.readstring(baseAddress + this.Value.Offset, 0, "UTF-16")
        }
    }

    class Enum extends System.Value
    {
        __new(offset32, offset64, parentObject)
        {
            this.isEnum := true ;this is hokey fix for tree view to differentiate enums from pointers, but I'm lazy right now.
            this.Offset := MemoryReader.Reader.isTarget64bit ? offset64 : offset32
            if !(System.valueTypeSize.HasKey(this.Type))
                ExceptionHandler.ThrowError("Value type parameter is invalid.`nInvalid Parameter: " . this.Type, -2)
            this.Type := System.valueTypeSize[this.Type]
            this.ParentObj := parentObject
            return this
        }

        GetEnumerable()
        {
            return this.Enum[this.GetValue()]
        }
    }

    class Action extends System.Object
    {

    }

    static valueTypeSize :=     {   "System.Byte": "Char",     "System.UByte": "UChar"
                                ,   "System.Short": "Short",   "System.UShort": "UShort"
                                ,   "System.Int32": "Int",     "System.UInt32": "UInt"
                                ,   "System.Int64": "Int64",   "System.UInt64": "UInt64"
                                ,   "System.Single": "Float",  "System.USingle": "UFloat"
                                ,   "System.Double": "Double", "System.Boolean": "Char"}

    class StaticBase
    {
        GetAddress()
        {
            return MemoryReader.Reader.read(MemoryReader.ModuleBaseAddress + this.Offset, MemoryReader.Reader.ptrType)
        }
    }
}