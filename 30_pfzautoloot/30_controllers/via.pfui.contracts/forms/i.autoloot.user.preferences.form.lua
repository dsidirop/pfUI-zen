--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IAutolootUserPreferencesForm = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Controllers.ViaPfui.Contracts.Forms.IAutolootUserPreferencesForm" --[[@formatter:off]]

function IAutolootUserPreferencesForm:Initialize() end;
function IAutolootUserPreferencesForm:EventRequestingCurrentUserPreferences_Subscribe(handler, owner) end;
function IAutolootUserPreferencesForm:EventRequestingCurrentUserPreferences_Unsubscribe(handler) end;
