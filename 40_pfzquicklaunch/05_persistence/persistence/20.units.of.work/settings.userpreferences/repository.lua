--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"

local IUserPreferencesRepository = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Settings.UserPreferences.IRepository"

local UserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Settings.UserPreferences.RepositoryQueryable"
local UserPreferencesRepositoryUpdateable = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Settings.UserPreferences.RepositoryUpdateable"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Settings.UserPreferences.Repository" {
    "IUserPreferencesRepository", IUserPreferencesRepository,
    
    "UserPreferencesRepositoryQueryable", UserPreferencesRepositoryQueryable,
    "UserPreferencesRepositoryUpdateable", UserPreferencesRepositoryUpdateable,
}


function Class:NewWithDBContext(pfuiZenDbContext)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(pfuiZenDbContext, "pfuiZenDbContext")

    local instance = self:Instantiate()

    instance = Class.asBase.UserPreferencesRepositoryQueryable.New(instance, pfuiZenDbContext)
    instance = Class.asBase.UserPreferencesRepositoryUpdateable.New(instance, pfuiZenDbContext)

    return instance
end

-- the rest methods are provided by the blended base classes