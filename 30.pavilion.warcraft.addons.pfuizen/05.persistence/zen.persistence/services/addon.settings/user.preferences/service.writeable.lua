--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard   = using "System.Guard"
local Fields  = using "System.Classes.Fields"

local PfuiZenDbContext                            = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.PfuiZen.DBContext"
local UserPreferencesUnitOfWork                   = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.UnitOfWork"
local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Services.AddonSettings.UserPreferences.WriteableService" { -- @formatter:on
    "IWriteableService", using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IServiceWriteable"
}


Fields(function(upcomingInstance)
    upcomingInstance._userPreferencesUnitOfWork = nil

    return upcomingInstance
end)

function Class:New(userPreferencesUnitOfWork)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(userPreferencesUnitOfWork, "userPreferencesUnitOfWork")
    
    local instance = self:Instantiate()
    
    instance._userPreferencesUnitOfWork = userPreferencesUnitOfWork or UserPreferencesUnitOfWork:New(PfuiZenDbContext:New()) --todo   refactor this later on so that this gets injected through DI

    return instance
end

function Class:GreeniesGrouplootingAutomation_UpdateMode(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationMode, value, "value")

    _userPreferencesUnitOfWork:GetUserPreferencesRepository()
                              :GreeniesGrouplootingAutomation_ChainUpdateMode(value)

    return _userPreferencesUnitOfWork:SaveChanges()
end

function Class:GreeniesGrouplootingAutomation_UpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, value, "value")

    _userPreferencesUnitOfWork:GetUserPreferencesRepository()
                              :GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)

    return _userPreferencesUnitOfWork:SaveChanges()
end
