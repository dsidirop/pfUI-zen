--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard   = using "System.Guard" -- @formatter:off

local Fields = using "System.Classes.Fields"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind" --@formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.GreeniesGrouplootingAssistant.AggregateSettings"


Fields(function(upcomingInstance)
    upcomingInstance._mode = nil --         SGreeniesGrouplootingAutomationMode
    upcomingInstance._actOnKeybind = nil -- SGreeniesGrouplootingAutomationActOnKeybind

    return upcomingInstance
end)

function Class:New()
    return self:Instantiate()
end

function Class:GetMode()
    Scopify(EScopes.Function, self)

    return self._mode
end

function Class:GetActOnKeybind()
    Scopify(EScopes.Function, self)

    return self._actOnKeybind
end

function Class:ChainSetMode(value)
    Scopify(EScopes.Function, self)

    _mode = Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationMode, value, "value")

    return self
end

function Class:ChainSetActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _actOnKeybind = Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, value, "value")

    return self
end