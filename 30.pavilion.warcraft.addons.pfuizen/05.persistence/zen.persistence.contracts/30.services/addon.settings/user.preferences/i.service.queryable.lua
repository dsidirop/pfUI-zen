--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IServiceQueryable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IServiceQueryable"

function IServiceQueryable:GetAllUserPreferences()
end
