local _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _importer, _namespacer
end)()

_setfenv(1, {}) -- @formatter:off

local Scopify  = _importer("System.Scopify")
local EScopes  = _importer("System.EScopes")
local Classify = _importer("System.Class.Classify")

local Guard                  = _importer("System.Guard")
local WoWRollOnLoot          = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.RollOnLoot")
local WoWGetLootRollItemInfo = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.GetLootRollItemInfo")

local GambledItemInfo          = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.GroupLooting.GambledItemInfo")
local EWowGamblingResponseType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowGamblingResponseType")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Helpers.GroupLooting.Helper")

function Class:New(rollOnLoot, getLootRollItemInfo)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsOptionallyFunction(rollOnLoot)
    Guard.Assert.IsOptionallyFunction(getLootRollItemInfo)

    return Classify(self, {
        RollOnLoot_          = rollOnLoot          or WoWRollOnLoot, --          to help unit testing
        GetLootRollItemInfo_ = getLootRollItemInfo or WoWGetLootRollItemInfo, -- to help unit testing
    })
end -- @formatter:on

-- https://wowpedia.fandom.com/wiki/API_GetLootRollItemInfo
-- https://vanilla-wow-archive.fandom.com/wiki/API_GetLootRollItemInfo
function Class:GetGambledItemInfo(gamblingId)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveIntegerOrZero(gamblingId)

    local
    textureFilepath,
    name,
    count,
    itemQuality,
    isBindOnPickUp,
    isNeedable,
    isGreedable,
    isDisenchantable,
    needInelligibilityReasonType,
    greedInelligibilityReasonType,
    disenchantInelligibilityReasonType,
    enchantingLevelRequiredToDEItem,
    isTransmogrifiable = self.GetLootRollItemInfo_(gamblingId)

    return GambledItemInfo:New {
        Name = name,
        GamblingId = gamblingId,
        ItemQuality = itemQuality,
        
        IsNeedable = isNeedable,
        IsGreedable = isGreedable,
        IsBindOnPickUp = isBindOnPickUp,
        IsDisenchantable = isDisenchantable,
        IsTransmogrifiable = isTransmogrifiable,

        Count = count,
        TextureFilepath = textureFilepath,
        EnchantingLevelRequiredToDEItem = enchantingLevelRequiredToDEItem,
        
        NeedInelligibilityReasonType = needInelligibilityReasonType,
        GreedInelligibilityReasonType = greedInelligibilityReasonType,
        DisenchantInelligibilityReasonType = disenchantInelligibilityReasonType,
    }
end

function Class:SubmitResponseToItemGamblingRequest(rollId, wowRollMode)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(EWowGamblingResponseType, wowRollMode)
    Guard.Assert.IsPositiveIntegerOrZero(rollId)

    self.RollOnLoot_(rollId, wowRollMode) --00

    -- 00 https://wowpedia.fandom.com/wiki/API_RollOnLoot   the rollid number increases with every roll you have in a party till how high it counts
    --    is currently unknown   blizzard uses 0 to pass 1 to need an item 2 to greed an item and 3 to disenchant an item in later expansions
end
