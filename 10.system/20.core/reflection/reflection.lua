local _type, _setfenv, _importer, _namespacer, _namespacer_reflector = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _namespacer_reflector = _assert(_g.pvl_namespacer_reflect)

    return _type, _setfenv, _importer, _namespacer, _namespacer_reflector
end)()

_setfenv(1, {})

local Math = _importer("System.Math")
local STypes = _importer("System.Reflection.STypes")

local Reflection = _namespacer("System.Reflection")

Reflection.Type = _type

function Reflection.IsTable(value)
    return Reflection.Type(value) == STypes.Table
end

function Reflection.IsOptionallyTable(value)
    return value == nil or Reflection.Type(value) == STypes.Table
end

function Reflection.IsFunction(value)
    return Reflection.Type(value) == STypes.Function
end

function Reflection.IsOptionallyFunction(value)
    return value == nil or Reflection.Type(value) == STypes.Function
end

function Reflection.IsNumber(value)
    return Reflection.Type(value) == STypes.Number
end

function Reflection.IsOptionallyNumber(value)
    return value == nil or Reflection.Type(value) == STypes.Number
end

function Reflection.IsBoolean(value)
    return Reflection.Type(value) == STypes.Boolean
end

function Reflection.IsOptionallyBoolean(value)
    return value == nil or Reflection.Type(value) == STypes.Boolean
end

function Reflection.IsInteger(value)
    return Reflection.IsNumber(value) and Math.floor(value) == value
end

function Reflection.IsOptionallyInteger(value)
    return value == nil or Reflection.IsInteger(value)
end

function Reflection.IsString(value)
    return Reflection.Type(value) == STypes.String
end

function Reflection.IsOptionallyString(value)
    return value == nil or Reflection.Type(value) == STypes.String
end

function Reflection.IsTableOrString(value)
    return Reflection.Type(value) == STypes.Table or Reflection.Type(value) == STypes.String
end

function Reflection.IsOptionallyTableOrString(value)
    return value == nil or Reflection.IsTableOrString(value)
end

function Reflection.IsInstanceOf(object, desiredType)
    if object == nil then
        return false
    end

    return Reflection.GetNamespaceOfInstance(object) == Reflection.GetNamespaceOfType(desiredType)
end

function Reflection.GetNamespaceOfInstanceOrRawType(object)
    return Reflection.GetNamespaceOfInstance(object) or Reflection.Type(object)    
end

function Reflection.GetNamespaceOfInstance(object)
    if object == nil then
        return nil
    end
    
    return Reflection.GetNamespaceOfType(object.__index)
end

function Reflection.GetNamespaceOfType(typeOfObject)
    if typeOfObject == nil then
        return nil
    end
    
    return _namespacer_reflector(typeOfObject)
end

