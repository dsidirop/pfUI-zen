--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IPfuiQuicklaunchDBContextTrackable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.EntityFramework.IPfuiQuicklaunchDBContextTrackable"

function IPfuiQuicklaunchDBContextTrackable:SaveChanges() end;
function IPfuiQuicklaunchDBContextTrackable:LoadTracked_Settings(asTracking) end;
function IPfuiQuicklaunchDBContextTrackable:LoadTracked_Settings_UserPreferences(asTracking) end;
