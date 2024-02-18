local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local T = using "System.Helpers.Tables" --@formatter:off

local Guard        = using "System.Guard"
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local WoWRollOnLoot            = using "Pavilion.Warcraft.GroupLooting.BuiltIns.RollOnLoot"
local WoWGetLootRollItemInfo   = using "Pavilion.Warcraft.GroupLooting.BuiltIns.GetLootRollItemInfo"

local GambledItemInfoDto       = using "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto"
local EWowGamblingResponseType = using "Pavilion.Warcraft.Enums.EWowGamblingResponseType"

local Service = using "[declare]" "Pavilion.Warcraft.GroupLooting.GroupLootGamblingService"

Scopify(EScopes.Function, {})

function Service:New(rollOnLoot, getLootRollItemInfo)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrFunction(rollOnLoot, "rollOnLoot")
    Guard.Assert.IsNilOrFunction(getLootRollItemInfo, "getLootRollItemInfo")

    return self:Instantiate({
        RollOnLoot_             = rollOnLoot            or WoWRollOnLoot, --               to help unit testing
        GetLootRollItemInfo_    = getLootRollItemInfo   or WoWGetLootRollItemInfo, --      to help unit testing
    })
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
    needInelligibilityReasonType,
    greedInelligibilityReasonType,
    disenchantInelligibilityReasonType,
    enchantingLevelRequiredToDEItem,
    isTransmogrifiable = self.GetLootRollItemInfo_(gamblingId)

    return GambledItemInfoDto:New {
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

function Service:SubmitSameResponseToAllItemGamblingRequests(gamblingRequestIdsArray, wowRollMode)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(gamblingRequestIdsArray, "gamblingRequestIdsArray")
    Guard.Assert.IsEnumValue(EWowGamblingResponseType, wowRollMode, "wowRollMode")

    for _, gamblingRequestId in T.GetIndexedPairs(gamblingRequestIdsArray) do
        self.RollOnLoot_(gamblingRequestId, wowRollMode)
    end
    
    return self
end
