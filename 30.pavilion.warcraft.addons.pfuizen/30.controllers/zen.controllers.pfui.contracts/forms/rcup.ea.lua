--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Pfui.Contracts.Forms.Events.RequestingCurrentUserPreferencesEventArgs"


Fields(function(upcomingInstance)
    upcomingInstance.Response = {
        UserPreferences = nil -- type: UserPreferencesDto
    }

    return upcomingInstance
end)
