local _type, _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _type, _setfenv, _importer, _namespacer
end)()

_setfenv(1, {})

local Math = _import("System.Math")

local Reflection = _namespacer("System.Reflection")

Reflection.Type = _type

function Reflection.IsTable(value)
    return _type(value) == "table"
end

function Reflection.IsTableOrNil(value)
    return value == nil or _type(value) == "table"
end

function Reflection.IsNumber(value)
    return _type(value) == "number"
end

function Reflection.IsNumberOrNil(value)
    return value == nil or _type(value) == "number"
end

function Reflection.IsInteger(value)
    return Reflection.IsNumber(value) and Math.floor(value) == value
end

function Reflection.IsIntegerOrNil(value)
    return value == nil or Reflection.IsInteger(value)
end

function Reflection.IsString(value)
    return _type(value) == "string"
end

function Reflection.IsStringOrNil(value)
    return value == nil or _type(value) == "string"
end
