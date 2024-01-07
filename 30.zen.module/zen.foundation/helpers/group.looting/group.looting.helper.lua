local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard        = using "System.Guard" --@formatter:off
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local WoWRollOnLoot            = using "Pavilion.Warcraft.Addons.Zen.Externals.WoW.RollOnLoot"
local WoWGetLootRollItemInfo   = using "Pavilion.Warcraft.Addons.Zen.Externals.WoW.GetLootRollItemInfo"

local GambledItemInfo          = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.GroupLooting.GambledItemInfo"
local EWowGamblingResponseType = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowGamblingResponseType" -- @formatter:off

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Helpers.GroupLooting.Helper"

Scopify(EScopes.Function, {})

function Class:New(rollOnLoot, getLootRollItemInfo)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrFunction(rollOnLoot, "rollOnLoot")
    Guard.Assert.IsNilOrFunction(getLootRollItemInfo, "getLootRollItemInfo")

    return self:Instantiate({ -- @formatter:off
        RollOnLoot_          = rollOnLoot          or WoWRollOnLoot, --          to help unit testing
        GetLootRollItemInfo_ = getLootRollItemInfo or WoWGetLootRollItemInfo, -- to help unit testing
    })
end -- @formatter:on

-- https://wowpedia.fandom.com/wiki/API_GetLootRollItemInfo
-- https://vanilla-wow-archive.fandom.com/wiki/API_GetLootRollItemInfo
function Class:GetGambledItemInfo(gamblingId)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveIntegerOrZero(gamblingId, "gamblingId")

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

    Guard.Assert.IsEnumValue(EWowGamblingResponseType, wowRollMode, "wowRollMode")
    Guard.Assert.IsPositiveIntegerOrZero(rollId, "rollId")

    self.RollOnLoot_(rollId, wowRollMode) --00

    -- 00 https://wowpedia.fandom.com/wiki/API_RollOnLoot   the rollid number increases with every
    --    roll you have in a party till how high it counts   is currently unknown   blizzard uses
    --    0 to pass 1 to need an item 2 to greed an item and 3 to disenchant an item in later expansions
end
