--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IPfuiQuicklaunchDBContextUntrackable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.EntityFramework.IPfuiQuicklaunchDBContextUntrackable"

function IPfuiQuicklaunchDBContextUntrackable:LoadUntracked_Settings(asTracking) end;
function IPfuiQuicklaunchDBContextUntrackable:LoadUntracked_Settings_UserPreferences(asTracking) end;
