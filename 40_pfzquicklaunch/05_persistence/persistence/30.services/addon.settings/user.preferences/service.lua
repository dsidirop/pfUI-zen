--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local PfuiQuicklaunchDBContext           = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.EntityFramework.PfuiQuicklaunchDBContext"
local IPfuiQuicklaunchDBContext          = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.EntityFramework.IPfuiQuicklaunchDBContext"

local UserPreferencesUnitOfWork          = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Settings.UserPreferences.UnitOfWork"
local UserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Settings.UserPreferences.RepositoryQueryable"

local UserPreferencesQueryableService    = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Services.AddonSettings.UserPreferences.QueryableService"
local UserPreferencesUpdateableService   = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Services.AddonSettings.UserPreferences.UpdateableService"

local IUserPreferencesService = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Services.AddonSettings.UserPreferences.IService"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Services.AddonSettings.UserPreferences.Service" {
    "UserPreferencesQueryableService", UserPreferencesQueryableService,
    "UserPreferencesUpdateableService", UserPreferencesUpdateableService,

    "IUserPreferencesService", IUserPreferencesService,
}

function Class:NewWithDBContext(optionalDbContext) -- todo  get rid of this once we get DI going
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceImplementing(optionalDbContext, IPfuiQuicklaunchDBContext, "optionalDbContext")

    optionalDbContext = optionalDbContext or PfuiQuicklaunchDBContext:New()

    return Class:New(
        UserPreferencesUnitOfWork:New(optionalDbContext),
        UserPreferencesRepositoryQueryable:New(optionalDbContext)
    )
end

function Class:New(userPreferencesUnitOfWork, userPreferencesRepositoryQueryable)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(userPreferencesUnitOfWork, UserPreferencesUnitOfWork, "userPreferencesUnitOfWork")
    Guard.Assert.IsInstanceOf(userPreferencesRepositoryQueryable, UserPreferencesRepositoryQueryable, "userPreferencesRepositoryQueryable")

    local instance = self:Instantiate()

    instance = Class.asBase.UserPreferencesUpdateableService.New(instance, userPreferencesUnitOfWork)
    instance = Class.asBase.UserPreferencesQueryableService.New(instance, userPreferencesRepositoryQueryable)

    return instance
end

-- provided by the base classes
--
-- function Class:Update*()
-- function Class:GetAllUserPreferences()
