--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IRepositoryQueryable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.IRepositoryQueryable"

--- @return UserPreferencesDto
function IRepositoryQueryable:GetAllUserPreferences()
end
