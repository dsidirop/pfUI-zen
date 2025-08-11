--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IUserPreferencesForm = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Pfui.Contracts.Forms.IUserPreferencesForm"


function IUserPreferencesForm:EventRequestingCurrentUserPreferences_Subscribe(handler, owner)
end

function IUserPreferencesForm:EventRequestingCurrentUserPreferences_Unsubscribe(handler)
end

function IUserPreferencesForm:Initialize()
end
