local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard        = using "System.Guard" --@formatter:off
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local AddonInfoDto      = using "Pavilion.Warcraft.Addons.Contracts.AddonInfoDto"
local WoWGetAddonInfo   = using "Pavilion.Warcraft.Addons.BuiltIns.GetAddonInfo"

local SWoWAddonNotLoadableReason = using "Pavilion.Warcraft.Strenums.SWoWAddonNotLoadableReason" -- @formatter:on

local Service = using "[declare]" "Pavilion.Warcraft.Addons.AddonsService"

Scopify(EScopes.Function, {})

function Service:New()
    return self:Instantiate()
end

-- https://wowpedia.fandom.com/wiki/API_GetAddOnInfo
function Service:TryGetAddonInfoByFolderName(addonFolderName)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(addonFolderName, "addonFolderName")

    local
    folderName,
    title,
    notes,
    isLoaded,
    isDynamicallyLoadable,
    notLoadedReason = WoWGetAddonInfo(addonFolderName)

    if isDynamicallyLoadable == nil or notLoadedReason == SWoWAddonNotLoadableReason.Missing then
        return nil
    end

    return AddonInfoDto:New {
        Title = title,
        IsLoaded = isLoaded,
        IsDynamicallyLoadable = isDynamicallyLoadable,

        Notes = notes,
        FolderName = folderName,
        NotLoadedReason = notLoadedReason,
    }
end
