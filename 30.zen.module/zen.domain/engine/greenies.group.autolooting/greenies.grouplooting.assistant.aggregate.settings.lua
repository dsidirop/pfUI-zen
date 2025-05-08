local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard        = using "System.Guard" -- @formatter:off
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind" --@formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGroupAutolooting.AssistantAggregateSettings"

Scopify(EScopes.Function, {})

function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate({
        _mode = nil,
        _actOnKeybind = nil,
    })
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

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationMode, value, "value")

    _mode = value

    return self
end

function Class:ChainSetActOnKeybind(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, value, "value")

    _actOnKeybind = value

    return self
end