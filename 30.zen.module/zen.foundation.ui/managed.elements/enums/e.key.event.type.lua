--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local EKeyEventType = using "[declare] [enum]" "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Enums.EKeyEventType" --@formatter:off

EKeyEventType.KeyDown  = 1
EKeyEventType.KeyUp    = 2 
EKeyEventType.KeyPress = 3 --@formatter:on
