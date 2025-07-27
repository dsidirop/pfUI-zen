--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

--- Creates and plugs-in a new nested-tab-frame with an area-frame for it based on the optional area-populator function.<br/><br/>
--- If the nested-tab-frame already exists then nothing happens and entire call gets ignored.<br/>
---
--- @note The hierarchy of the frames is as follows:
--- @note
--- @note    __ pfConfigGUI root-form _________________________________ ( pfUI.gui ________________________________________________ )
--- @note    _______ pfUI root-tab-frames _____________________________ ( pfUI.gui.frames[*] _________ p.e. "Thirdparty" __________ )
--- @note    __________ pfUI area-frames of root-tab-frames ___________ ( pfUI.gui.frames[*].area ____ p.e. config-ui-controls-area )     
--- @note  **__________ pfUI nested-tab-frames ___________________ ( pfUI.gui.frames[][*] _______ p.e. "Zen" ______ )  <-- you get this one**
--- @note    ______________ pfUI area-frame of nested-tab-frame _______ ( pfUI.gui.frames[][*].area __ p.e. zen-config ui-controls_ )
--- <br/>
local Class = using "[declare] [interface] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.NestedTabFrameWithArea.IPfuiNestedTabFrameWithAreaBuilder" {
    "IPfuiGuiControlBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiGuiControlBuilder",
}

--- @param rootTabFrameName string The name of the root tab frame to which the new nested tab frame will be added.
function Class:ChainSet_RootTabFrameName(rootTabFrameName)
end

--- @param nestedTabFrameName string The name of the nested tab frame to be created.
function Class:ChainSet_NestedTabFrameName(nestedTabFrameName)
end

--- @param optionalAreaPopulatorWhenFirstShownFunc function|nil An optional function that is meant to populate the area-frame with controls when it is first shown.
function Class:ChainSet_AreaPopulatorWhenFirstShownFunc(optionalAreaPopulatorWhenFirstShownFunc)
end
