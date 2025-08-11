--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IServiceQueryable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IServiceQueryable"
local IServiceUpdateable = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IServiceUpdateable"

local IService = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IService" { --@formatter:on
    "IServiceQueryable", IServiceQueryable,
    "IServiceUpdateable", IServiceUpdateable,
}
