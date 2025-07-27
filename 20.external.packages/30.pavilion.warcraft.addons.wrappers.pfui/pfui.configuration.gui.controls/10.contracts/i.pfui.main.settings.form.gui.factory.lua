--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

--- A managed wrapper-gui-factory over 'pfUI.gui' 
---
--- @class Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Gui.IPfuiMainSettingsFormGuiFactory
---
local IPfuiMainSettingsFormGuiFactory = using "[declare] [interface]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiMainSettingsFormGuiFactory"

--- @return IPfuiHeaderBuilder IPfuiHeaderBuilder a builder for a header-label control - upon being build it will get plugged into the pfui-config-form automatically
function IPfuiMainSettingsFormGuiFactory:SpawnHeaderBuilder()
end

--- @return IPfuiLabeledDropdownBuilder IPfuiLabeledDropdownBuilder a builder for a labeled dropdown control - upon being build it will get plugged into the pfui-config-form automatically
function IPfuiMainSettingsFormGuiFactory:SpawnLabeledDropdownBuilder()
end

--- Creates a builder for {nested-tab-frame + area-frame} that will be automatically get plugged into the pfui-config-form when build.<br/>
---
--- @return IPfuiNestedTabFrameWithAreaBuilder IPfuiNestedTabFrameWithAreaBuilder a builder of type `Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Gui.Controls.IPfuiNestedTabFrameWithAreaBuilder`
function IPfuiMainSettingsFormGuiFactory:SpawnNestedTabFrameWithAreaBuilder() -- pfUI.gui.frames[][*].area
end
