--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local Fields = using "System.Classes.Fields"
local SGreeniesGrouplootingAutomationMode = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewModeCommand"

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
    
    _old = Guard.Assert.IsNilOrEnumValue(SGreeniesGrouplootingAutomationMode, old, "old")

    return self
end

function Class:ChainSetNew(new)
    Scopify(EScopes.Function, self)

    _new = Guard.Assert.IsNilOrEnumValue(SGreeniesGrouplootingAutomationMode, new, "new")

    return self
end
