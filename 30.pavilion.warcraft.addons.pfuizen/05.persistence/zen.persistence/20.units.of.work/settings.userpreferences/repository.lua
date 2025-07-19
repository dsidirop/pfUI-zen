--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"

local IUserPreferencesRepository = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.IRepository"

local UserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.RepositoryQueryable"
local UserPreferencesRepositoryUpdateable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.RepositoryUpdateable"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.Repository" {
    "IUserPreferencesRepository", IUserPreferencesRepository,
    
    "UserPreferencesRepositoryQueryable", UserPreferencesRepositoryQueryable,
    "UserPreferencesRepositoryUpdateable", UserPreferencesRepositoryUpdateable,
}


function Class:NewWithDBContext(pfuiZenDbContext)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(pfuiZenDbContext, "pfuiZenDbContext")

    local instance = self:Instantiate()

    instance.asBase.UserPreferencesRepositoryQueryable.New(instance, pfuiZenDbContext)
    instance.asBase.UserPreferencesRepositoryUpdateable.New(instance, pfuiZenDbContext)

    return instance
end

-- @return UserPreferencesDto
-- function Class:GetAllUserPreferences()
-- end

-- function Class:HasChanges()
-- end

-- @return self
-- function Class:GreeniesGrouplootingAutomation_ChainUpdateMode(value)
-- end

-- @return self
-- function Class:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)
-- end
