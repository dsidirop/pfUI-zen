--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.Contracts.Commands.EngineControl.TweakEnabledStateOnEngineCommand"

Fields(function(upcomingInstance)
    upcomingInstance._newDesiredState = nil

    return upcomingInstance
end)

function Class:New()
    return self:Instantiate()
end

function Class:GetDesiredNewState()
    Scopify(EScopes.Function, self)

    return _newDesiredState
end

function Class:ChainSet_DesiredNewState(newDesiredEnabledState)
    Scopify(EScopes.Function, self)

    _newDesiredState = Guard.Assert.IsBoolean(newDesiredEnabledState, "newDesiredEnabledState")

    return self
end
