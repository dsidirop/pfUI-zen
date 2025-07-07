--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local SGreeniesGrouplootingAutomationMode = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryWriteable" -- @formatter:on


Fields(function(upcomingInstance)
    upcomingInstance._hasChanges = false
    upcomingInstance._userPreferencesEntity = nil

    return upcomingInstance
end)

function Class:New(dbcontext)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(dbcontext, "dbcontext")

    local instance = self:Instantiate()
    
    instance._hasChanges = false
    instance._userPreferencesEntity = dbcontext.Settings.UserPreferences
    
    return instance
end

function Class:HasChanges()
    Scopify(EScopes.Function, self)

    return _hasChanges
end

--- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateMode(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationMode, value, "value")
    
    if _userPreferencesEntity.GreeniesGrouplootingAutomation.Mode == value then
        return self
    end

    _hasChanges = true
    _userPreferencesEntity.GreeniesGrouplootingAutomation.Mode = value

    return self
end

--- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, value, "value")

    if _userPreferencesEntity.GreeniesGrouplootingAutomation.ActOnKeybind == value then
        return self
    end

    _hasChanges = true
    _userPreferencesEntity.GreeniesGrouplootingAutomation.ActOnKeybind = value

    return self
end
