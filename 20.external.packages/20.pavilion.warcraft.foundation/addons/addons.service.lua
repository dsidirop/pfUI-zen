--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard             = using "System.Guard"
local AddonInfoDto      = using "Pavilion.Warcraft.Addons.Contracts.AddonInfoDto"
local WoWGetAddonInfo   = using "Pavilion.Warcraft.Foundation.Natives.GetAddonInfo"

local SWoWAddonNotLoadableReason = using "Pavilion.Warcraft.Foundation.Enums.SWoWAddonNotLoadableReason" -- @formatter:on

local Service = using "[declare]" "Pavilion.Warcraft.Foundation.Addons.AddonsService"


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
