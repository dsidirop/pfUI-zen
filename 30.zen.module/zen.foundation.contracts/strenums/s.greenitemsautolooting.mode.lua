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

local SGreenItemsAutolootingMode = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Strenums.SGreenItemsAutolootingMode")

SGreenItemsAutolootingMode.JustPass = "just_pass"
SGreenItemsAutolootingMode.RollNeed = "roll_need"
SGreenItemsAutolootingMode.RollGreed = "roll_greed"
SGreenItemsAutolootingMode.LetUserChoose = "let_user_choose"

function SGreenItemsAutolootingMode.Validate(value)
    if _type(value) ~= "string" then
        return false
    end

    return value == SGreenItemsAutolootingMode.AutoLoot
            or value == SGreenItemsAutolootingMode.JustPass
            or value == SGreenItemsAutolootingMode.RollNeed
            or value == SGreenItemsAutolootingMode.RollGreed
            or value == SGreenItemsAutolootingMode.LetUserChoose
end
