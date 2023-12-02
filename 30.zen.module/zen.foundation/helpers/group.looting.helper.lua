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

local RollOnLoot = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.RollOnLoot")
local GetLootRollItemInfo = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.GetLootRollItemInfo")

local EWowGamblingResponseType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowGamblingResponseType")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Helpers.GroupLootingHelper")

function Class:New()
    _setfenv(1, self)

    local instance = {
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

-- https://wowpedia.fandom.com/wiki/API_GetLootRollItemInfo
-- https://vanilla-wow-archive.fandom.com/wiki/API_GetLootRollItemInfo
function Class:GetGambledItemInfo(rollId)
    _setfenv(1, self)

    local
    texture,
    name,
    count,
    quality,
    bindOnPickUp,
    canNeed,
    canGreed,
    canDisenchant,
    reasonNeed,
    reasonGreed,
    reasonDisenchant,
    deSkillRequired,
    canTransmog = GetLootRollItemInfo(rollId)

    return GambledItemInfo:New(
            rollId,
            texture,
            name,
            count,
            quality,
            bindOnPickUp,
            canNeed,
            canGreed,
            canDisenchant,
            reasonNeed,
            reasonGreed,
            reasonDisenchant,
            deSkillRequired,
            canTransmog
    )
end

function Class:SubmitResponseToItemGamblingRequest(rollID, wowRollMode)
    _setfenv(1, self)

    _assert(EWowGamblingResponseType.Validate(wowRollMode))

    RollOnLoot(rollID, wowRollMode) --00

    -- 00 the rollid number increases with every roll you have in a party - till how high it counts is currently unknown
    --    blizzard uses 0 to pass 1 to need an item 2 to greed an item and 3 to disenchant an item in later expansions
end
