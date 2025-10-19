--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IServiceUpdateable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Services.AddonSettings.UserPreferences.IServiceUpdateable"

--- @return boolean
function IServiceUpdateable:UpdateEnabled(value) end;

--- @return boolean
function IServiceUpdateable:UpdateCustomAssociations(value) end;
