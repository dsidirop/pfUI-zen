--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IPfuiZenDBContextUntrackable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.EntityFramework.PfuiZen.IPfuiZenDBContextUntrackable" --[[@formatter:on]]


function IPfuiZenDBContextUntrackable:LoadUntracked_Settings(asTracking)
end

function IPfuiZenDBContextUntrackable:LoadUntracked_Settings_UserPreferences(asTracking)
end
