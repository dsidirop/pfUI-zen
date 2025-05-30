local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto" --@formatter:on

Scopify(EScopes.Function, {})

Fields(function(upcomingInstance)
    upcomingInstance._greeniesGrouplootingAutomation = {
        mode         = SGreeniesGrouplootingAutomationMode.LetUserChoose,
        actOnKeybind = SGreeniesGrouplootingAutomationActOnKeybind.Automatic,
    }
    
    -- ... more user-preferences sections can be added here in the future ...

    return upcomingInstance
end)

function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate()
end

function Class:Get_GreeniesGrouplootingAutomation_Mode()
    Scopify(EScopes.Function, self)

    return _greeniesGrouplootingAutomation.mode
end

function Class:Get_GreeniesGrouplootingAutomation_ActOnKeybind()
    Scopify(EScopes.Function, self)

    return _greeniesGrouplootingAutomation.actOnKeybind
end

function Class:ChainSet_GreeniesGrouplootingAutomation_Mode(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationMode, value, "value")

    _greeniesGrouplootingAutomation.mode = value

    return self
end

function Class:ChainSet_GreeniesGrouplootingAutomation_ActOnKeybind(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, value, "value")

    _greeniesGrouplootingAutomation.actOnKeybind = value

    return self
end
