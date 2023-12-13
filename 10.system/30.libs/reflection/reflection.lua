local _type, _setfenv, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _type, _setfenv, _namespacer
end)()

_setfenv(1, {})

local Reflection = _namespacer("System.Reflection")

Reflection.Type = _type

function Reflection.IsTable(value)
    return _type(value) == "table"
end

function Reflection.IsTableOrNil(value)
    return value == nil or _type(value) == "table"
end
