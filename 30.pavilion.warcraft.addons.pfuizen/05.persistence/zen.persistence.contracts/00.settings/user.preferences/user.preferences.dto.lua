--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})


local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto" --@formatter:on


Fields(function(upcomingInstance)
    upcomingInstance._greeniesGrouplootingAutomation = {
        mode         = SGreeniesGrouplootingAutomationMode.LetUserChoose,
        actOnKeybind = SGreeniesGrouplootingAutomationActOnKeybind.Automatic,
    }
    
    -- ... more user-preferences sections can be added here in the future ...

    return upcomingInstance
end)

-- GETTERS

function Class:Get_GreeniesGrouplootingAutomation_Mode()
    Scopify(EScopes.Function, self)

    return _greeniesGrouplootingAutomation.mode
end

function Class:Get_GreeniesGrouplootingAutomation_ActOnKeybind()
    Scopify(EScopes.Function, self)

    return _greeniesGrouplootingAutomation.actOnKeybind
end

-- SETTERS

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
