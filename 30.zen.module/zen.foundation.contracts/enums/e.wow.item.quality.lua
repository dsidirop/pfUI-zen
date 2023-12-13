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

local EWowItemQuality = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowItemQuality")

-- @formatter:off
-- https://wowwiki-archive.fandom.com/wiki/API_ITEM_QUALITY_COLORS
EWowItemQuality.Poor        = 0 --    grey
EWowItemQuality.Common      = 1 --    white
EWowItemQuality.Uncommon    = 2 --    green
EWowItemQuality.Rare        = 3 --    blue
EWowItemQuality.Epic        = 4 --    purple
EWowItemQuality.Legendary   = 5 --    orange   vanilla wow does have some artifacts like thunderfury sulfuras andonisus and atiesh
EWowItemQuality.Artifact    = 6 --    gold     this came in legion 7.0.3
-- EWowItemQuality.Heirloom = 7 --    this came in wotlk 3.0.2
-- EWowItemQuality.WoWToken = 8 --    this is out of scope for us

EWowItemQuality.Grey        = EWowItemQuality.Poor -- aliases
EWowItemQuality.White       = EWowItemQuality.Common
EWowItemQuality.Green       = EWowItemQuality.Uncommon
EWowItemQuality.Blue        = EWowItemQuality.Rare
EWowItemQuality.Purple      = EWowItemQuality.Epic
EWowItemQuality.Orange      = EWowItemQuality.Legendary
EWowItemQuality.Gold        = EWowItemQuality.Artifact
-- @formatter:on

function EWowItemQuality.IsValid(value)
    if _type(value) ~= "number" then
        return false
    end

    return value >= EWowItemQuality.Poor and value <= EWowItemQuality.Artifact

    -- or value == EWowItemQuality.Heirloom  -- todo add support for this when we detect that the patch is wotlk 3.0.2 or higher
end
