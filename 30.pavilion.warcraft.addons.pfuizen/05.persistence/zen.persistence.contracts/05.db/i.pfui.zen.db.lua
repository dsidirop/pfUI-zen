--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local IPfuiZenDB = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Db.IPfuiZenDB"

---  @return {
---      GreeniesGrouplootingAutomation = {
---          Mode         = <SGreeniesGrouplootingAutomationMode>,
---          ActOnKeybind = <SGreeniesGrouplootingAutomationActOnKeybind>,
---      }
---  }
function IPfuiZenDB:TryLoadDocUserPreferences()
end

function IPfuiZenDB:UpdateDocUserPreferences(newUserPreferences)
end
