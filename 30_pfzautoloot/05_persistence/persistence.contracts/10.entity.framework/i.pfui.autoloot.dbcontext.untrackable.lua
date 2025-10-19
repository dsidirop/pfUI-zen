--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IPfuiAutolootDBContextUntrackable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Contracts.EntityFramework.IPfuiAutolootDBContextUntrackable" --[[@formatter:on]]


function IPfuiAutolootDBContextUntrackable:LoadUntracked_Settings(asTracking)
end

function IPfuiAutolootDBContextUntrackable:LoadUntracked_Settings_UserPreferences(asTracking)
end
