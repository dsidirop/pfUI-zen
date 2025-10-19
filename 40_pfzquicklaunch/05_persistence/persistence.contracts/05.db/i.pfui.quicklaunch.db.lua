--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IPfuiQuicklaunchDB = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Db.IPfuiQuicklaunchDB"

function IPfuiQuicklaunchDB:TryLoadDocUserPreferences() end;
function IPfuiQuicklaunchDB:UpdateDocUserPreferences(newUserPreferences) end;
