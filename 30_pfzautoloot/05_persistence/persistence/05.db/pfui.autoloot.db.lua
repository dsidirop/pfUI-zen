--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Console      = using "System.Console"
local Reflection   = using "System.Reflection"

local Fields       = using "System.Classes.Fields"
local TablesHelper = using "System.Helpers.Tables"

local IPfuiAutolootDB   = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Contracts.Db.IPfuiAutolootDB"

local Schema               = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Db.Schemas.SchemaV1"
local PfuiEnvConfiguration = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiEnvConfiguration"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Db.PfuiAutolootDB" { --[[@formatter:on]]
    "IPfuiAutolootDB", IPfuiAutolootDB
}

---  @return {
---      GreeniesGrouplootingAutomation = {
---          Mode         = <SGreeniesGrouplootingAutomationMode>,
---          ActOnKeybind = <SGreeniesGrouplootingAutomationActOnKeybind>,
---      }
---  }
function Class:TryLoadDocUserPreferences()
    Scopify(EScopes.Function, self)

    local rawAllAddonSettings = PfuiEnvConfiguration[Schema.RootKeyname] or {} -- pfUI.env.C['zen.autoloot.v1']

    -- Console.Out:WriteFormatted("[PADB.TLDUP.010] Loading autoloot-user-preferences in pfUI.env.C['%s'] (PfuiEnvConfiguration[Schema.RootKeyname]=%s)", Schema.RootKeyname, PfuiEnvConfiguration[Schema.RootKeyname])
    -- Console.Out:WriteFormatted("[PADB.TLDUP.015] rawAllAddonSettings[%s]='%s'", Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname, rawAllAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname])
    -- Console.Out:WriteFormatted("[PADB.TLDUP.016] rawAllAddonSettings[%s]='%s'", Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname, rawAllAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname])

    return { --@formatter:off
        GreeniesGrouplootingAutomation = { -- deepcloning   it is absolutely vital to return a deep-clone dto of the autoloot-settings (and only those) so as to leave no direct-pointers to the actual raw-db-table!
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

    local isVeryFirstSave = false
    local existingRawAddonSettings = PfuiEnvConfiguration[Schema.RootKeyname]
    if Reflection.IsNilOrTable(existingRawAddonSettings) then
        if existingRawAddonSettings ~= nil then
            Console.Error:WriteFormatted("[PADB.UDUP.010] The pfUI.env.C[%q] exists but is not nil or a table (it is a '%s' instead - how did this even happen?). Will auto-correct this in the db now but you should report report this incident and what you did you to cause it!", Schema.RootKeyname, Reflection.GetRawType(existingRawAddonSettings))
        else
            -- todo log   "[PADB.UDUP.005] This seems to be the very first save of autoloot-user-preferences; creating new PfuiEnvConfiguration[Schema.RootKeyname]"    
        end

        isVeryFirstSave = true
        existingRawAddonSettings = {}
    end

    existingRawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname] = newUserPreferences.GreeniesGrouplootingAutomation.Mode
    existingRawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname] = newUserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind

    if isVeryFirstSave then -- optimization to avoid overwriting the table-entry-pointer when it is not necessary
        PfuiEnvConfiguration[Schema.RootKeyname] = existingRawAddonSettings
    end

    -- Console.Out:WriteFormatted("[PADB.UDUP.012] Updating autoloot-user-preferences in pfUI.env.C['%s'] (PfuiEnvConfiguration[Schema.RootKeyname]=%s)", Schema.RootKeyname, PfuiEnvConfiguration[Schema.RootKeyname])
    -- Console.Out:WriteFormatted("[PADB.UDUP.015] [before] existingRawAddonSettings[%s]='%s'", Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname, existingRawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.Mode.Keyname])
    -- Console.Out:WriteFormatted("[PADB.UDUP.016] [before] existingRawAddonSettings[%s]='%s'", Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname, existingRawAddonSettings[Schema.Settings.UserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind.Keyname])
    -- Console.Out:WriteFormatted("[PADB.UDUP.017] [new settings] newUserPreferences.GreeniesGrouplootingAutomation.Mode         = '%s'", newUserPreferences.GreeniesGrouplootingAutomation.Mode)
    -- Console.Out:WriteFormatted("[PADB.UDUP.018] [new settings] newUserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind = '%s'", newUserPreferences.GreeniesGrouplootingAutomation.ActOnKeybind)
end
