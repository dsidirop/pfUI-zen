--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IPfuiAutolootDBContextTrackable = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Contracts.EntityFramework.IPfuiAutolootDBContextTrackable" --[[@formatter:on]]

-- todo   enhance interfaces so that they will also support setting properties
--
-- IPfuiAutolootDBContextTrackable.Settings = { --public entity-properties
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


function IPfuiAutolootDBContextTrackable:LoadTracked_Settings(asTracking)
end

function IPfuiAutolootDBContextTrackable:LoadTracked_Settings_UserPreferences(asTracking)
end

function IPfuiAutolootDBContextTrackable:SaveChanges()
end
