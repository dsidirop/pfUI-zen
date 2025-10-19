--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IRepositoryUpdateable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Settings.UserPreferences.IRepositoryUpdateable"

--- @return boolean
function IRepositoryUpdateable:HasChanges() end;

--- @return self
function IRepositoryUpdateable:ChainUpdateEnabled(value) end;

--- @return self
function IRepositoryUpdateable:ChainUpdateCustomAssociations(value) end;
