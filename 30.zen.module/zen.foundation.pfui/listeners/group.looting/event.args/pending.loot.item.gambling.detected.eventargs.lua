local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard" --@formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.PendingLootItemGamblingDetectedEventArgs" --@formatter:on

function Class:New(gamblingRequestId)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsPositiveIntegerOrZero(gamblingRequestId, "gamblingRequestId")

    return self:Instantiate({
        _gamblingRequestId = gamblingRequestId,
    })
end

function Class:GetGamblingId()
    return self._gamblingRequestId
end
