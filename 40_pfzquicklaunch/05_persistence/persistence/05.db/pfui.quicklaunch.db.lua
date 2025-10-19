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

    local existingRawAddonSettings = PfuiEnvConfiguration[Schema.RootKeyname] or {}

    existingRawAddonSettings[Schema.Settings.UserPreferences.Enabled.Keyname] = newUserPreferences.Enabled
    existingRawAddonSettings[Schema.Settings.UserPreferences.IsFirstLoading.Keyname] = false -- if we are updating it is no longer the first loading
    existingRawAddonSettings[Schema.Settings.UserPreferences.CustomAssociations.Keyname] = newUserPreferences.CustomAssociations
end
