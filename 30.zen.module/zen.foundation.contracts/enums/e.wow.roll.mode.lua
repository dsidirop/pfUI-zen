local _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
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

local EWowRollMode = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowRollMode")

EWowRollMode.Pass = 0
EWowRollMode.Need = 1
EWowRollMode.Greed = 2
-- EWowRollMode.Disenchant = 3   --not supported in vanilla   introduced in wotlk patch 3.3 fall of the lich king

function EWowRollMode.Validate(value)
    if _type(value) ~= "number" then
        return false
    end

    return value >= EWowRollMode.Pass and value <= EWowRollMode.Greed
    
    -- or value == EWowRollMode.Disenchant  -- todo add support for this when we detect that the patch is wotlk or higher
end
