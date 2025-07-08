--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local SWoWAddonNotLoadableReason = using "[declare] [enum]" "Pavilion.Warcraft.Foundation.Enums.SWoWAddonNotLoadableReason" -- aka roll-mode

SWoWAddonNotLoadableReason.Banned            = "BANNED" -- @formatter:off
SWoWAddonNotLoadableReason.Corrupt           = "CORRUPT"
SWoWAddonNotLoadableReason.Missing           = "MISSING"
SWoWAddonNotLoadableReason.Disabled          = "DISABLED"
SWoWAddonNotLoadableReason.Incompatible      = "INCOMPATIBLE"
SWoWAddonNotLoadableReason.DemandLoaded      = "DEMAND_LOADED"
SWoWAddonNotLoadableReason.InterfaceVersion  = "INTERFACE_VERSION" -- @formatter:on
