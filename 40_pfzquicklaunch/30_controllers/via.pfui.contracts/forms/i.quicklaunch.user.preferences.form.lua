--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IQuicklaunchUserPreferencesForm = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.ViaPfui.Contracts.Forms.IQuicklaunchUserPreferencesForm" --[[@formatter:off]]

function IQuicklaunchUserPreferencesForm:Initialize() end;
function IQuicklaunchUserPreferencesForm:EventRequestingCurrentUserPreferences_Subscribe(handler, owner) end;
function IQuicklaunchUserPreferencesForm:EventRequestingCurrentUserPreferences_Unsubscribe(handler) end;
