--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard   = using "System.Guard"
local Fields  = using "System.Classes.Fields"

local UserPreferencesUnitOfWork  = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Settings.UserPreferences.UnitOfWork"
local IUserPreferencesUnitOfWork = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Settings.UserPreferences.IUnitOfWork"

local PfuiQuicklaunchDBContext   = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.EntityFramework.PfuiQuicklaunchDBContext"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Services.AddonSettings.UserPreferences.UpdateableService" { -- @formatter:on
    "IUpdateableService", using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Services.AddonSettings.UserPreferences.IServiceUpdateable"
}


Fields(function(upcomingInstance)
    upcomingInstance._userPreferencesUnitOfWork = nil

    return upcomingInstance
end)

function Class:New(userPreferencesUnitOfWork)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(userPreferencesUnitOfWork, IUserPreferencesUnitOfWork, "userPreferencesUnitOfWork")
    
    local instance = self:Instantiate()
    
    instance._userPreferencesUnitOfWork = userPreferencesUnitOfWork or UserPreferencesUnitOfWork:New(PfuiQuicklaunchDBContext:New()) --todo   refactor this later on so that this gets injected through DI

    return instance
end

function Class:UpdateEnabled(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(value, "value")

    _userPreferencesUnitOfWork:GetUserPreferencesRepository()
                              :ChainUpdateEnabled(value)

    return _userPreferencesUnitOfWork:SaveChanges()
end

function Class:UpdateCustomAssociations(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(value, "value")

    _userPreferencesUnitOfWork:GetUserPreferencesRepository()
                              :ChainUpdateCustomAssociations(value)

    return _userPreferencesUnitOfWork:SaveChanges()
end
