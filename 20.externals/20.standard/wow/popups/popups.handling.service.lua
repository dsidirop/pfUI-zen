local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Guard        = using "System.Guard"
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local WoWConfirmLootRoll   = using "Pavilion.Warcraft.Popups.BuiltIns.ConfirmLootRoll"
local WoWConfirmLootSlot   = using "Pavilion.Warcraft.Popups.BuiltIns.ConfirmLootSlot"
local WoWHideStaticPopup   = using "Pavilion.Warcraft.Popups.BuiltIns.HideStaticPopup"

local EWowGamblingResponseType = using "Pavilion.Warcraft.Enums.EWowGamblingResponseType"

local Service = using "[declare]" "Pavilion.Warcraft.Popups.PopupsHandlingService"

Scopify(EScopes.Function, {})

function Service:New(confirmLootRoll, confirmLootSlot, hideStaticPopup)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrFunction(confirmLootRoll, "confirmLootRoll")
    Guard.Assert.IsNilOrFunction(confirmLootSlot, "confirmLootSlot")
    Guard.Assert.IsNilOrFunction(hideStaticPopup, "hideStaticPopup")

    return self:Instantiate({
        ConfirmLootRoll_ = confirmLootRoll or WoWConfirmLootRoll, -- to help unit testing
        ConfirmLootSlot_ = confirmLootSlot or WoWConfirmLootSlot, -- to help unit testing
        HideStaticPopup_ = hideStaticPopup or WoWHideStaticPopup, -- to help unit testing
    })
end -- @formatter:on

function Service:HandlePopupGamblingIntent(gamblingRequestId, intendedGamblingType)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveIntegerOrZero(gamblingRequestId, "gamblingRequestId")
    Guard.Assert.IsEnumValue(EWowGamblingResponseType, intendedGamblingType, "intendedGamblingType")

    if self.ConfirmLootRoll_(gamblingRequestId, intendedGamblingType) ~= false then
        self:HidePopupConfirmLootRoll_()
    end
end

function Service:HandlePopupItemWillBindToYou(lootSlotIndex)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveIntegerOrZero(lootSlotIndex, "lootSlotIndex")

    -- todo   refactor this drawing inspiration from pfui to have it work with wow 1.12
    if self.ConfirmLootSlot_(lootSlotIndex) ~= false then -- 00
        self:HidePopupItemWillBindToYou_()
    end
    
    -- 00   confirmlootslot() is not available in vanilla wow 1.12
end



-- private space

function Service:HidePopupConfirmLootRoll_()
    Scopify(EScopes.Function, self)

    HideStaticPopup_("CONFIRM_LOOT_ROLL")
end

function Service:HidePopupItemWillBindToYou_()
    Scopify(EScopes.Function, self)

    HideStaticPopup_("LOOT_BIND")
end
