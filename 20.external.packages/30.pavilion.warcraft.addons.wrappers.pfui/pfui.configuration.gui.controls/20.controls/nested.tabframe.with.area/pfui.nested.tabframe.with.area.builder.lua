--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local RawPfuiGui = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.NestedTabFrameWithArea.PfuiNestedTabFrameWithAreaBuilder" {
    "IPfuiNestedTabFrameWithAreaBuilder", using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.NestedTabFrameWithArea.IPfuiNestedTabFrameWithAreaBuilder",
}


Fields(function(upcomingInstance)
    upcomingInstance._nativePfuiControlFrame = nil

    upcomingInstance._rootTabFrameName = nil
    upcomingInstance._nestedTabFrameName = nil
    upcomingInstance._optionalAreaPopulatorWhenFirstShownFunc = nil

    return upcomingInstance
end)


function Class:ChainSet_RootTabFrameName(rootTabFrameName)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNonDudString(rootTabFrameName, "rootTabFrameName")

    _rootTabFrameName = rootTabFrameName

    return self
end

function Class:ChainSet_NestedTabFrameName(nestedTabFrameName)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(nestedTabFrameName, "nestedTabFrameName")

    _nestedTabFrameName = nestedTabFrameName

    return self
end

function Class:ChainSet_AreaPopulatorWhenFirstShownFunc(optionalAreaPopulatorWhenFirstShownFunc)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrFunction(optionalAreaPopulatorWhenFirstShownFunc, "optionalAreaPopulatorWhenFirstShownFunc")

    _optionalAreaPopulatorWhenFirstShownFunc = optionalAreaPopulatorWhenFirstShownFunc

    return self
end

function Class:Build()
    Scopify(EScopes.Function, self)
    
    Guard.Assert.Explained.IsTable(RawPfuiGui, "Cannot build - it seems that pfUI.gui is not a table as expected (has the pfui addon been loaded first?)")
    Guard.Assert.Explained.IsTable(RawPfuiGui.frames, "Cannot build - it seems that pfUI.gui.frames is not a table as expected (has the pfui addon been loaded first?)")
    Guard.Assert.Explained.IsFunction(RawPfuiGui.CreateGUIEntry, "Cannot build - it seems that pfUI.gui.CreateGUIEntry is not a function as expected (has the pfui addon been loaded first?)")

    Guard.Assert.IsNonDudString(_rootTabFrameName, "rootTabFrameName")
    Guard.Assert.IsNonDudString(_nestedTabFrameName, "nestedTabFrameName")
    Guard.Assert.IsNilOrFunction(_optionalAreaPopulatorWhenFirstShownFunc, "optionalAreaPopulatorWhenFirstShownFunc")    

    RawPfuiGui.CreateGUIEntry(
            _rootTabFrameName, --   _t:TryTranslate("Thirdparty")
            _nestedTabFrameName, -- _t:TryTranslate("Zen", "|cFF7FFFD4")
            _optionalAreaPopulatorWhenFirstShownFunc
    )

    local rootTabFrame = RawPfuiGui.frames[_rootTabFrameName] or {}
    local nestedTabFrame = rootTabFrame[_nestedTabFrameName]

    Guard.Assert.Explained.IsMereFrame(nestedTabFrame, "the creation of the desired nested-tab-frame succeeded but the resulting nestedTabFrame is not a simple frame as expected")
    Guard.Assert.Explained.IsMereFrame(nestedTabFrame.area, "the creation of the desired nested-tab-frame succeeded but the resulting nestedTabFrame.area is not a simple frame as expected")

    return nestedTabFrame, nestedTabFrame.area
end

-- todo   move these to a base class
--function Class:ChainSet_Visibility(showNotHide)
--    Scopify(EScopes.Function, self)
--
--    if showNotHide then
--        self:Show()
--    else
--        self:Hide()
--    end
--
--    return self
--end
--
--function Class:Show()
--    Scopify(EScopes.Function, self)
--
--    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control is not initialized - call Initialize() first")
--    
--    _nativePfuiControlFrame:Show()
--
--    return self
--end
--
--function Class:Hide()
--    Scopify(EScopes.Function, self)
--
--    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control is not initialized - call Initialize() first")
--
--    _nativePfuiControlFrame:Hide()
--
--    return self
--end
