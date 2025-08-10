--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Pfui.Listeners.GroupLootingListener.Contracts.PendingLootItemGamblingDetectedEventArgs" --@formatter:on


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
