--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard = using "System.Guard"

-- local PfuiHeaderLabelBuilder         = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.Header.PfuiHeaderLabelBuilder"
local PfuiLabeledDropdownBuilder        = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.LabeledDropdown.PfuiLabeledDropdownBuilder"
local PfuiNestedTabFrameWithAreaBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.PfuiNestedTabFrameWithAreaBuilder"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.PfuiMainSettingsFormGuiFactory" { --[[@formatter:on]]
    "IPfuiMainSettingsFormGuiFactory", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiMainSettingsFormGuiFactory",
}


--- @return IPfuiNestedTabFrameWithAreaBuilder IPfuiNestedTabFrameWithAreaBuilder a builder for a nested-tab-frame-with-an-area-frame that will be automatically plugged into the pfui-config-form when build
function Class:SpawnNestedTabFrameWithAreaBuilder() -- pfUI.gui.frames[][*].area
    Scopify(EScopes.Function, self)

    return PfuiNestedTabFrameWithAreaBuilder:New()
end


--- @return IPfuiLabeledDropdownBuilder IPfuiLabeledDropdownBuilder a builder for a labeled dropdown control - upon being build it will get plugged into the pfui-config-form automatically
function Class:SpawnLabeledDropdownBuilder()
    Scopify(EScopes.Function, self)

    return PfuiLabeledDropdownBuilder:New()
end

--- @return IPfuiHeaderLabelBuilder IPfuiHeaderLabelBuilder a builder for a header-label control - upon being build it will get plugged into the pfui-config-form automatically
--function Class:SpawnHeaderLabelBuilder()
--    Scopify(EScopes.Function, self)
--
--    return PfuiHeaderLabelBuilder:New()
--end
