--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IPfuiZenDBContextTrackable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.EntityFramework.PfuiZen.IPfuiZenDBContextTrackable" --[[@formatter:on]]

-- todo   enhance interfaces so that they will also support setting properties
--
-- IPfuiZenDBContextTrackable.Settings = { --public entity-properties
--      LoadTracked   = function() end,
--      LoadUntracked = function() end,
--      
--      UserPreferences = {
--          LoadTracked   = function() end,
--          LoadUntracked = function() end,
--          GreeniesGrouplootingAutomation = {
--              Mode         = nil,
--              ActOnKeybind = nil,
--          },
--      },
-- } --@formatter:on


function IPfuiZenDBContextTrackable:LoadTracked_Settings(asTracking)
end

function IPfuiZenDBContextTrackable:LoadTracked_Settings_UserPreferences(asTracking)
end

function IPfuiZenDBContextTrackable:SaveChanges()
end
