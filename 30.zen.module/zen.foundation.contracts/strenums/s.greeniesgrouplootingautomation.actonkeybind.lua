local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local SGreeniesGrouplootingAutomationActOnKeybind = using "[declare:enum]" "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

-- dont change the casing lightheartedly from "Alt" to "alt" here   it affects settings persistence and it must also match the casing of
--
--                   Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.EventArgs.KeyEventArgs:ToString()
--

SGreeniesGrouplootingAutomationActOnKeybind.Automatic    = "automatic" --@formatter:off
SGreeniesGrouplootingAutomationActOnKeybind.Alt          = "Alt"
SGreeniesGrouplootingAutomationActOnKeybind.Ctrl         = "Ctrl"
SGreeniesGrouplootingAutomationActOnKeybind.Shift        = "Shift"
SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt      = "Ctrl+Alt"
SGreeniesGrouplootingAutomationActOnKeybind.AltShift     = "Alt+Shift"
SGreeniesGrouplootingAutomationActOnKeybind.CtrlShift    = "Ctrl+Shift"
SGreeniesGrouplootingAutomationActOnKeybind.CtrlAltShift = "Ctrl+Alt+Shift" --@formatter:on
