--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local IPfuiAutolootDB = using "[declare] [interface]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Contracts.Db.IPfuiAutolootDB"

---  @return {
---      GreeniesGrouplootingAutomation = {
---          Mode         = <SGreeniesGrouplootingAutomationMode>,
---          ActOnKeybind = <SGreeniesGrouplootingAutomationActOnKeybind>,
---      }
---  }
function IPfuiAutolootDB:TryLoadDocUserPreferences() end;
function IPfuiAutolootDB:UpdateDocUserPreferences(newUserPreferences) end;
