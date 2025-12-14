--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Reflection   = using "System.Reflection"

local Fields       = using "System.Classes.Fields"
local TablesHelper = using "System.Helpers.Tables"

local IPfuiQuicklaunchDB   = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Db.IPfuiQuicklaunchDB"

local Schema               = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Db.Schemas.SchemaV1"
local PfuiEnvConfiguration = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiEnvConfiguration"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Db.PfuiQuicklaunchDB" { --[[@formatter:on]]
    "IPfuiQuicklaunchDB", IPfuiQuicklaunchDB
}

---  @return {
---      IsFirstLoading     = <boolean>,
---      Enabled            = <boolean>,
---      CustomAssociations = <string>,
---  }
function Class:TryLoadDocUserPreferences()
    Scopify(EScopes.Function, self)

    local rawAllAddonSettings = PfuiEnvConfiguration[Schema.RootKeyname] or {} -- pfUI.env.C["zen.quicklaunch.v1"]

    return { --@formatter:off
        Enabled            = Nils.Coalesce(rawAllAddonSettings[Schema.Settings.UserPreferences.Enabled],            Schema.Settings.UserPreferences.Enabled.Default           ),
        IsFirstLoading     = Nils.Coalesce(rawAllAddonSettings[Schema.Settings.UserPreferences.IsFirstLoading],     Schema.Settings.UserPreferences.IsFirstLoading.Default    ),
        CustomAssociations = Nils.Coalesce(rawAllAddonSettings[Schema.Settings.UserPreferences.CustomAssociations], Schema.Settings.UserPreferences.CustomAssociations.Default),
    } --@formatter:on
end

function Class:UpdateDocUserPreferences(newUserPreferences)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsTable(newUserPreferences, "newUserPreferences")
    Guard.Assert.IsString(newUserPreferences.CustomAssociations, "newUserPreferences.CustomAssociations")
    Guard.Assert.IsBoolean(newUserPreferences.Enabled, "newUserPreferences.Enabled")
    -- Guard.Assert.IsBoolean(newUserPreferences.IsFirstLoading, "newUserPreferences.IsFirstLoading") -- no need

    local isVeryFirstSave = false
    local existingRawAddonSettings = PfuiEnvConfiguration[Schema.RootKeyname]
    if not Reflection.IsNilOrTable(existingRawAddonSettings) then
        if existingRawAddonSettings ~= nil then
            Console.Error:WriteFormatted("[PQDB.UDUP.010] The pfUI.env.C[%q] exists but is not nil or a table (it is a '%s' instead - how did this even happen?). Will auto-correct this in the db now but you should report report this incident and what you did you to cause it!", Schema.RootKeyname, Reflection.GetRawType(existingRawAddonSettings))
        else
            -- todo log   "[PQDB.UDUP.005] This seems to be the very first save of autoloot-user-preferences; creating new PfuiEnvConfiguration[Schema.RootKeyname]"    
        end

        isVeryFirstSave = true
        existingRawAddonSettings = {}
    end

    existingRawAddonSettings[Schema.Settings.UserPreferences.Enabled.Keyname] = newUserPreferences.Enabled
    existingRawAddonSettings[Schema.Settings.UserPreferences.IsFirstLoading.Keyname] = false -- if we are updating it is no longer the first loading
    existingRawAddonSettings[Schema.Settings.UserPreferences.CustomAssociations.Keyname] = newUserPreferences.CustomAssociations

    if isVeryFirstSave then -- optimization to avoid overwriting the table-entry-pointer when it is not necessary
        PfuiEnvConfiguration[Schema.RootKeyname] = existingRawAddonSettings
    end

    -- Console.Out:WriteFormatted("[PQDB.UDUP.012] Updating autoloot-user-preferences in pfUI.env.C['%s'] (PfuiEnvConfiguration[Schema.RootKeyname]=%s)", Schema.RootKeyname, PfuiEnvConfiguration[Schema.RootKeyname])
    -- 
    -- Console.Out:WriteFormatted("[PQDB.UDUP.015] [before] existingRawAddonSettings[%s]='%s'", Schema.Settings.UserPreferences.Enabled.Keyname, existingRawAddonSettings[Schema.Settings.UserPreferences.Enabled.Keyname])
    -- Console.Out:WriteFormatted("[PQDB.UDUP.016] [before] existingRawAddonSettings[%s]='%s'", Schema.Settings.UserPreferences.IsFirstLoading.Keyname, existingRawAddonSettings[Schema.Settings.UserPreferences.IsFirstLoading.Keyname])
    -- Console.Out:WriteFormatted("[PQDB.UDUP.016] [before] existingRawAddonSettings[%s]='%s'", Schema.Settings.UserPreferences.CustomAssociations.Keyname, existingRawAddonSettings[Schema.Settings.UserPreferences.CustomAssociations.Keyname])
    -- 
    -- Console.Out:WriteFormatted("[PQDB.UDUP.017] [new settings] newUserPreferences.Enabled            = '%s'", newUserPreferences.Enabled)
    -- Console.Out:WriteFormatted("[PQDB.UDUP.018] [new settings] newUserPreferences.CustomAssociations = '%s'", newUserPreferences.CustomAssociations)
end
