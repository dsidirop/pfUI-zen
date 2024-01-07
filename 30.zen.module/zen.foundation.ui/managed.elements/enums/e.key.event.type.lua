local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local EKeyEventType = using "[declare:enum]" "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Enums.EKeyEventType" --@formatter:off

EKeyEventType.KeyDown  = 1
EKeyEventType.KeyUp    = 2 
EKeyEventType.KeyPress = 3 --@formatter:on
