local _setfenv, _type, _rawget, _tostring, _error, _setmetatable, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _error = _assert(_g.error)
    local _rawget = _assert(_g.rawget)
    local _tostring = _assert(_g.tostring)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _setfenv, _type, _rawget, _tostring, _error, _setmetatable, _namespacer
end)()

_setfenv(1, {})

local STypes = _namespacer("System.Reflection.STypes")

STypes.Nil = "nil"
STypes.Table = "table"
STypes.Number = "number"
STypes.String = "string"
STypes.Function = "function"

_setmetatable(STypes, {
    __index = function(table, key)
        if _rawget(table, key) == nil then
            _error("STypes doesn't contain any member named '" .. _tostring(key) .. "'", 2)
        end
    end
})

function STypes.IsValid(value)
    if _type(value) ~= "string" then
        return false
    end

    return value == STypes.Nil
            or value == STypes.Table
            or value == STypes.Number
            or value == STypes.String
            or value == STypes.Function
end
