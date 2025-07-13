--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Class = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IServiceUpdateable" -- @formatter:on

--- @return boolean
function Class:GreeniesGrouplootingAutomation_UpdateMode(value)
end

--- @return boolean
function Class:GreeniesGrouplootingAutomation_UpdateActOnKeybind(value)
end
