--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Reflection   = using "System.Reflection"

local Fields       = using "System.Classes.Fields"
local TablesHelper = using "System.Helpers.Tables"

local IPfuiZenDB   = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Db.IPfuiZenDB"

local Schema            = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Db.Schemas.SchemaV1"
local PfuiConfiguration = using "Pavilion.Warcraft.Addons.Bindings.Pfui.PfuiConfiguration"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Db.PfuiZenDB" { --[[@formatter:on]]
    "IPfuiZenDB", IPfuiZenDB
}

---  @return {
---      GreeniesGrouplootingAutomation = {
---          Mode         = <SGreeniesGrouplootingAutomationMode>,
---          ActOnKeybind = <SGreeniesGrouplootingAutomationActOnKeybind>,
---      }
---  }
function Class:TryLoadDocUserPreferences()
    Scopify(EScopes.Function, self)

    local rawAllAddonSettings = PfuiConfiguration[Schema.RootKeyname] or {} -- pfUI.env.C["zen.v1"]

    return { --@formatter:off
        GreeniesGrouplootingAutomation = {
            Mode         = Nils.Coalesce(rawAllAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname],         Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Default        ),
            ActOnKeybind = Nils.Coalesce(rawAllAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname], Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Default),
        }
    } --@formatter:on
end

function Class:UpdateDocUserPreferences(newUserPreferences)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsTable(newUserPreferences, "newUserPreferences")
    Guard.Assert.IsTable(newUserPreferences.GreeniesGrouplootingAutomation, "newUserPreferences.GreeniesGrouplootingAutomation")
    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationMode, newUserPreferences.GreeniesGrouplootingAutomation.Mode, "newUserPreferences.GreeniesGrouplootingAutomation.Mode")
    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, newUserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind, "newUserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind")

    local existingRawAddonSettings = PfuiConfiguration[Schema.RootKeyname] or {}
    
    existingRawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname] = newUserPreferences.GreeniesGrouplootingAutomation.Mode
    existingRawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname] = newUserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind
end
