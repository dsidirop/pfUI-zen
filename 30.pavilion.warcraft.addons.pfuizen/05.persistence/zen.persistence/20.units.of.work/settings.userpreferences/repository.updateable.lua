--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils   = using "System.Nils"
local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local IUserPreferencesRepositoryUpdateable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.IRepositoryUpdateable"

local PfuiZenDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.PfuiZen.PfuiZenDBContext"
local IPfuiZenDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.EntityFramework.PfuiZen.IPfuiZenDBContext"

local SGreeniesGrouplootingAutomationMode = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.RepositoryUpdateable" {
    "IUserPreferencesRepositoryUpdateable", IUserPreferencesRepositoryUpdateable
} -- @formatter:on


Fields(function(upcomingInstance)
    upcomingInstance._dbcontext = nil
    upcomingInstance._hasChanges = false

    return upcomingInstance
end)

function Class:New(dbcontext)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(dbcontext, IPfuiZenDBContext, "dbcontext") -- todo  remove this later on in favour of DI

    local instance = self:Instantiate()

    instance._dbcontext = Nils.Coalesce(dbcontext, PfuiZenDBContext:New())
    instance._hasChanges = false
    
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
    
    local userPreferences = _dbcontext.Settings.UserPreferences.LoadTracked()
    
    if userPreferences.GreeniesGrouplootingAutomation.Mode == value then
        return self
    end

    _hasChanges = true
    userPreferences.GreeniesGrouplootingAutomation.Mode = value

    return self
end

--- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, value, "value")

    local userPreferences = _dbcontext.Settings.UserPreferences.LoadTracked()

    if userPreferences.GreeniesGrouplootingAutomation.ActOnKeybind == value then
        return self
    end

    _hasChanges = true
    userPreferences.GreeniesGrouplootingAutomation.ActOnKeybind = value

    return self
end
