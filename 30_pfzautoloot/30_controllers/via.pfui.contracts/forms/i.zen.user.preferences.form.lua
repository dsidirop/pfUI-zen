--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IUserPreferencesForm = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Controllers.ViaPfui.Contracts.Forms.IUserPreferencesForm" --[[@formatter:off]]

function IUserPreferencesForm:Initialize() end;
function IUserPreferencesForm:EventRequestingCurrentUserPreferences_Subscribe(handler, owner) end;
function IUserPreferencesForm:EventRequestingCurrentUserPreferences_Unsubscribe(handler) end;
