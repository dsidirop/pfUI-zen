--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local T = using "System.Helpers.Tables"

local Guard        = using "System.Guard"
local Fields       = using "System.Classes.Fields"

local WoWRollOnLoot            = using "Pavilion.Warcraft.GroupLooting.BuiltIns.RollOnLoot"
local WoWGetLootRollItemInfo   = using "Pavilion.Warcraft.GroupLooting.BuiltIns.GetLootRollItemInfo"

local GambledItemInfoDto       = using "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto"
local EWowGamblingResponseType = using "Pavilion.Warcraft.Enums.EWowGamblingResponseType" -- @formatter:on

local Service = using "[declare]" "Pavilion.Warcraft.GroupLooting.GroupLootGamblingService"


Fields(function(upcomingInstance)
    upcomingInstance.RollOnLootFunc_ = nil --          to help unit testing
    upcomingInstance.GetLootRollItemInfoFunc_ = nil -- to help unit testing

    return upcomingInstance
end)

function Service:New(rollOnLootFunc, getLootRollItemInfoFunc)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrFunction(rollOnLootFunc, "rollOnLoot")
    Guard.Assert.IsNilOrFunction(getLootRollItemInfoFunc, "getLootRollItemInfo")
    
    local instance = self:Instantiate() -- @formatter:off

    instance.RollOnLootFunc_          = rollOnLootFunc          or WoWRollOnLoot --          to help unit testing
    instance.GetLootRollItemInfoFunc_ = getLootRollItemInfoFunc or WoWGetLootRollItemInfo -- to help unit testing

    return instance
end -- @formatter:on

-- https://wowpedia.fandom.com/wiki/API_GetLootRollItemInfo
-- https://vanilla-wow-archive.fandom.com/wiki/API_GetLootRollItemInfo
function Service:GetGambledItemInfo(gamblingId)
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
    needIneligibilityReasonType,
    greedIneligibilityReasonType,
    disenchantIneligibilityReasonType,
    enchantingLevelRequiredToDEItem,
    isTransmogrifiable = self.GetLootRollItemInfoFunc_(gamblingId)

    return GambledItemInfoDto:New {
        Name                              = name,
        GamblingId                        = gamblingId,
        ItemQuality                       = itemQuality,

        IsNeedable                        = isNeedable,
        IsGreedable                       = isGreedable,
        IsBindOnPickUp                    = isBindOnPickUp,
        IsDisenchantable                  = isDisenchantable,
        IsTransmogrifiable                = isTransmogrifiable,

        Count                             = count,
        TextureFilepath                   = textureFilepath,
        EnchantingLevelRequiredToDEItem   = enchantingLevelRequiredToDEItem,

        NeedIneligibilityReasonType       = needIneligibilityReasonType,
        GreedIneligibilityReasonType      = greedIneligibilityReasonType,
        DisenchantIneligibilityReasonType = disenchantIneligibilityReasonType,
    }
end

function Service:SubmitSameResponseToAllItemGamblingRequests(gamblingRequestIdsArray, wowRollMode)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(gamblingRequestIdsArray, "gamblingRequestIdsArray")
    Guard.Assert.IsEnumValue(EWowGamblingResponseType, wowRollMode, "wowRollMode")

    for _, gamblingRequestId in T.GetIndexedPairs(gamblingRequestIdsArray) do
        self.RollOnLootFunc_(gamblingRequestId, wowRollMode)
    end
end

function Service:SubmitResponseToItemGamblingRequest(gamblingRequestId, wowRollMode)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(EWowGamblingResponseType, wowRollMode, "wowRollMode")
    Guard.Assert.IsPositiveIntegerOrZero(gamblingRequestId, "gamblingRequestId")

    self.RollOnLootFunc_(gamblingRequestId, wowRollMode) --00

    -- 00 https://wowpedia.fandom.com/wiki/API_RollOnLoot   the rollid number increases with every
    --    roll you have in a party till how high it counts   is currently unknown   blizzard uses
    --    0 to pass 1 to need an item 2 to greed an item and 3 to disenchant an item in later expansions
end
