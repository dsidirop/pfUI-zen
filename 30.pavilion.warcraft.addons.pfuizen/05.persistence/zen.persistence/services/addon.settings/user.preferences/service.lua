--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local PfuiZenDBContext                   = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.PfuiZen.PfuiZenDBContext"

local UserPreferencesUnitOfWork          = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.UnitOfWork"
local UserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.RepositoryQueryable"

local UserPreferencesQueryableService    = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Services.AddonSettings.UserPreferences.QueryableService"
local UserPreferencesUpdateableService    = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Services.AddonSettings.UserPreferences.UpdateableService"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Services.AddonSettings.UserPreferences.Service" { --@formatter:on
    "UserPreferencesQueryableService", UserPreferencesQueryableService,
    "UserPreferencesUpdateableService", UserPreferencesUpdateableService,

    "IUserPreferencesService", using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IService"
}

function Class:NewWithDBContext(optionalDbContext) -- todo  get rid of this once we get DI going
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceOf(optionalDbContext, PfuiZenDBContext, "optionalDbContext")

    optionalDbContext = optionalDbContext or PfuiZenDBContext:New()

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

    instance.asBase.UserPreferencesUpdateableService.New(instance, userPreferencesUnitOfWork)
    instance.asBase.UserPreferencesQueryableService.New(instance, userPreferencesRepositoryQueryable)

    return instance
end


-- provided by the base classes
--
-- function Class:GetAllUserPreferences()
-- end
-- 
-- function Class:GreeniesGrouplootingAutomation_UpdateMode(value)
-- end
-- 
-- function Class:GreeniesGrouplootingAutomation_UpdateActOnKeybind(value)
-- end
