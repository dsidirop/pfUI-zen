--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local RawPfuiGui = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui" -- todo   employ    using "[lazy]" "xyz"    here

local IPfuiMainSettingsFormGuiFactory = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Gui.IPfuiMainSettingsFormGuiFactory"

--- A managed wrapper-gui-factory over 'pfUI.gui' 
---
--- @class Pavilion.Warcraft.Addons.Wrappers.Pfui.PfuiMainSettingsFormGuiFactory
---
local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Gui.PfuiMainSettingsFormGuiFactory" {
    "IPfuiMainSettingsFormGuiFactory", IPfuiMainSettingsFormGuiFactory
}


--- Creates and plugs-in a new nested-tab-frame with an area-frame for it based on the optional area-populator function.<br/><br/>
--- If the nested-tab-frame already exists then nothing happens and entire call gets ignored.<br/>
---
--- @note The hierarchy of the frames is as follows:
--- @note
--- @note    __ pfConfigGUI root-form _________________________________ ( pfUI.gui ________________________________________________ )
--- @note    _______ pfUI root-tab-frames _____________________________ ( pfUI.gui.frames[*] _________ p.e. "Thirdparty" __________ )
--- @note    __________ pfUI area-frames of root-tab-frames ___________ ( pfUI.gui.frames[*].area ____ p.e. config-ui-controls-area )     
--- @note    __________ pfUI nested-tab-frames ________________________ ( pfUI.gui.frames[][*] _______ p.e. "Zen" _________________ )
--- @note    ______________ pfUI area-frame of nested-tab-frame _______ ( pfUI.gui.frames[][*].area __ p.e. zen-config ui-controls_ )
--- <br/>
--- @param rootTabFrameName string The name of the root tab frame to which the new nested tab frame will be added.
--- @param nestedTabFrameName string The name of the nested tab frame to be created.
--- @param optionalAreaPopulatorWhenFirstShownFunc function|nil An optional function that is meant to populate the area-frame with controls when it is first shown.
--- <br/>
--- @return frame   @may returns the frame of the area-frame of the nested-tab-frame.
--- <br/>
function Class:TrySpawnNewNestedTabFrameWithArea(rootTabFrameName, nestedTabFrameName, optionalAreaPopulatorWhenFirstShownFunc)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.Explained.IsTable(RawPfuiGui, "Cannot comply - it seems that pfUI.gui is not a table as expected (has the pfui addon been loaded first?)")
    Guard.Assert.Explained.IsTable(RawPfuiGui.frames, "Cannot comply - it seems that pfUI.gui.frames is not a table as expected (has the pfui addon been loaded first?)")
    Guard.Assert.Explained.IsFunction(RawPfuiGui.CreateGUIEntry, "Cannot comply - it seems that pfUI.gui.CreateGUIEntry is not a function as expected (has the pfui addon been loaded first?)")
    
    Guard.Assert.IsNonDudString(rootTabFrameName, "rootTabFrameName")
    Guard.Assert.IsNonDudString(nestedTabFrameName, "nestedTabFrameName")
    Guard.Assert.IsNilOrFunction(optionalAreaPopulatorWhenFirstShownFunc, "optionalAreaPopulatorWhenFirstShownFunc")    

    RawPfuiGui.CreateGUIEntry(
            rootTabFrameName, --   _t:TryTranslate("Thirdparty")
            nestedTabFrameName, -- _t:TryTranslate("Zen", "|cFF7FFFD4")
            optionalAreaPopulatorWhenFirstShownFunc
    )
    
    local nestedTabFrame = RawPfuiGui.frames[rootTabFrameName][nestedTabFrameName]
    
    Guard.Assert.Explained.IsMereFrame(nestedTabFrame, "the creation of the desired nested-tab-frame succeeded but the resulting nestedTabFrame is not a simple frame as expected")
    Guard.Assert.Explained.IsMereFrame(nestedTabFrame.area, "the creation of the desired nested-tab-frame succeeded but the resulting nestedTabFrame.area is not a simple frame as expected")
    
    return nestedTabFrame, nestedTabFrame.area
end
