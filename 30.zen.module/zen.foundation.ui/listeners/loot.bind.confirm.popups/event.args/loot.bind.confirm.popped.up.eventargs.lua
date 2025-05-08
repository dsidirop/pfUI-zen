local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Listeners.LootBindConfirmPopups.EventArgs.LootBindConfirmPoppedUpEventArgs"

Scopify(EScopes.Function, {})

function Class:New(lootSlotIndex)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInteger(lootSlotIndex, "lootSlotIndex")
    
    return self:Instantiate({ _lootSlotIndex = lootSlotIndex })
end

function Class:GetLootSlotIndex()
    Scopify(EScopes.Function, self)

    return _lootSlotIndex
end
