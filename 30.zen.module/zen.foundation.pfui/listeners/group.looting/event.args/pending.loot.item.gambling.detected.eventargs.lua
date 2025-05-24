local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Guard = using "System.Guard"

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.PendingLootItemGamblingDetectedEventArgs" --@formatter:on

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._gamblingRequestId = 0

    return upcomingInstance
end

function Class:New(gamblingRequestId)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsPositiveIntegerOrZero(gamblingRequestId, "gamblingRequestId")
    
    local instance = self:Instantiate()
    
    instance._gamblingRequestId = gamblingRequestId

    return instance
end

function Class:GetGamblingId()
    return self._gamblingRequestId
end
