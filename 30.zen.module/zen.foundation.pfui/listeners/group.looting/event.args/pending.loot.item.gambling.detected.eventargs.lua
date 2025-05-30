local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.PendingLootItemGamblingDetectedEventArgs" --@formatter:on

Scopify(EScopes.Function, {})

Fields(function(upcomingInstance)
    upcomingInstance._gamblingRequestId = 0

    return upcomingInstance
end)

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
