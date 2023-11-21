local _assert, _setfenv, _type, _, _, _, _, _, _, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Enum = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Enums.EGreenItemsAutolootingMode")

function Enum:New(value)
    _setfenv(1, self)

    local instance = {
        _value = _assert(_type(value) == "number")
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Enum:Ordinal()
    _setfenv(1, self)
    
    return _value
end

function Enum:__tostring()
    _setfenv(1, self)

    if _value == Enum.RollNeed then
        return "roll_need"
    end

    if _value == Enum.RollGreed then
        return "roll_greed"
    end

    if _value == Enum.JustPass then
        return "just_pass"
    end

    if _value == Enum.LetUserChoose then
        return "let_user_choose"
    end
    
    return "" .. _value
end

Enum.RollNeed = Enum:New(1)
Enum.RollGreed = Enum:New(2)
Enum.JustPass = Enum:New(3)
Enum.LetUserChoose = Enum:New(4)
