local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard   = using "System.Guard" -- @formatter:off
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Fields = using "System.Classes.Fields"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind" --@formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGrouplootingAssistant.AggregateSettings"

Scopify(EScopes.Function, {})

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