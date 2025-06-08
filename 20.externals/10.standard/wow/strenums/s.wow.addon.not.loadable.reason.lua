local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local SWoWAddonNotLoadableReason = using "[declare] [enum]" "Pavilion.Warcraft.Strenums.SWoWAddonNotLoadableReason" -- aka roll-mode

SWoWAddonNotLoadableReason.Banned            = "BANNED" -- @formatter:off
SWoWAddonNotLoadableReason.Corrupt           = "CORRUPT"
SWoWAddonNotLoadableReason.Missing           = "MISSING"
SWoWAddonNotLoadableReason.Disabled          = "DISABLED"
SWoWAddonNotLoadableReason.Incompatible      = "INCOMPATIBLE"
SWoWAddonNotLoadableReason.DemandLoaded      = "DEMAND_LOADED"
SWoWAddonNotLoadableReason.InterfaceVersion  = "INTERFACE_VERSION" -- @formatter:on
