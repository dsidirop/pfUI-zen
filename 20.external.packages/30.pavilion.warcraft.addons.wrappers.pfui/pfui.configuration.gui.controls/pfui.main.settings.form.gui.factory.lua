--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local PfuiNestedTabFrameWithAreaBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.PfuiNestedTabFrameWithAreaBuilder"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.PfuiMainSettingsFormGuiFactory" {
    "IPfuiMainSettingsFormGuiFactory", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiMainSettingsFormGuiFactory",
}

function Class:SpawnNestedTabFrameWithAreaBuilder() -- pfUI.gui.frames[][*].area
    Scopify(EScopes.Function, self)

    return PfuiNestedTabFrameWithAreaBuilder:New()
end
