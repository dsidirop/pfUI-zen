--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local SWoWFrameStrataType = using "[declare] [enum]" "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Strenums.SWoWFrameStrataType" --@formatter:off

SWoWFrameStrataType.Low              = "LOW"
SWoWFrameStrataType.High             = "HIGH"
SWoWFrameStrataType.Parent           = "PARENT"
SWoWFrameStrataType.Medium           = "MEDIUM"
SWoWFrameStrataType.Dialog           = "DIALOG"
SWoWFrameStrataType.Tooltip          = "TOOLTIP"
SWoWFrameStrataType.Background       = "BACKGROUND"
SWoWFrameStrataType.Fullscreen       = "FULLSCREEN"
SWoWFrameStrataType.FullscreenDialog = "FULLSCREEN_DIALOG" --@formatter:on
