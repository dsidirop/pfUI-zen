--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IUserPreferencesRepositoryQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.IRepositoryQueryable"
local IUserPreferencesRepositoryUpdateable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.IRepositoryUpdateable"

local IUserPreferencesRepository = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.IRepository" {
    "IUserPreferencesRepositoryQueryable", IUserPreferencesRepositoryQueryable,
    "IUserPreferencesRepositoryUpdateable", IUserPreferencesRepositoryUpdateable,
}

-- @return UserPreferencesDto
-- function IUserPreferencesRepository:GetAllUserPreferences()
-- end

-- function IUserPreferencesRepository:HasChanges()
-- end

-- @return self
-- function IUserPreferencesRepository:GreeniesGrouplootingAutomation_ChainUpdateMode(value)
-- end

-- @return self
-- function IUserPreferencesRepository:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)
-- end
