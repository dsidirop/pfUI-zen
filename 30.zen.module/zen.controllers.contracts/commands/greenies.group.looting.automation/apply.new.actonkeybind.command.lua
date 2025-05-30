local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Fields  = using "System.Classes.Fields"

local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewActOnKeybindCommand"

Fields(function(upcomingInstance)
    upcomingInstance._old = nil
    upcomingInstance._new = nil

    return upcomingInstance
end)

function Class:New()
    return self:Instantiate()
end

function Class:GetOldValue()
    Scopify(EScopes.Function, self)

    return _old
end

function Class:GetNewValue()
    Scopify(EScopes.Function, self)

    return _new
end

function Class:ChainSetOld(old)
    Scopify(EScopes.Function, self)

    _old = Guard.Assert.IsNilOrEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, old, "old")

    return self
end

function Class:ChainSetNew(new)
    Scopify(EScopes.Function, self)

    _new = Guard.Assert.IsNilOrEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, new, "new")

    return self
end
