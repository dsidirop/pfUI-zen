local _setfenv, _type, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _setfenv, _type, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Reflection = _importer("System.Reflection")
local TablesHelper = _importer("System.Helpers.Tables")

local EWowGamblingResponseType = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowGamblingResponseType") -- aka roll-mode

EWowGamblingResponseType.Pass = 0
EWowGamblingResponseType.Need = 1
EWowGamblingResponseType.Greed = 2
-- EWowGamblingResponseType.Disenchant = 3   --not supported in vanilla   introduced in wotlk patch 3.3 fall of the lich king

_setmetatable(EWowGamblingResponseType, { __index = TablesHelper.RawGetValue })

function EWowGamblingResponseType.IsValid(value)
    if not Reflection.IsNumber(value) then
        return false
    end

    return value >= EWowGamblingResponseType.Pass and value <= EWowGamblingResponseType.Greed
    
    -- or value == EWowGamblingResponseType.Disenchant  -- todo add support for this when we detect that the patch is wotlk or higher
end
