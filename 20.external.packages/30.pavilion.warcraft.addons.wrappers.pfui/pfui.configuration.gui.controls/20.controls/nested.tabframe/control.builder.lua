--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard"
local Fields = using "System.Classes.Fields"

local RawPfuiGui                        = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"
local PfuiNestedTabFrameWithAreaControl = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.NestedTabFrameWithArea.PfuiNestedTabFrameWithAreaControl"

local PfuiGuiBaseControlBuilder                 = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.BaseBuilder.PfuiGuiBaseControlBuilder"
local IPfuiNestedTabFrameWithAreaControlBuilder = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.NestedTabFrameWithArea.IPfuiNestedTabFrameWithAreaControlBuilder"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.NestedTabFrameWithArea.PfuiNestedTabFrameWithAreaControlBuilder" { --[[@formatter:on]]
    "PfuiGuiBaseControlBuilder", PfuiGuiBaseControlBuilder,
    "IPfuiNestedTabFrameWithAreaControlBuilder", IPfuiNestedTabFrameWithAreaControlBuilder,
}


Fields(function(upcomingInstance)
    -- upcomingInstance._nestedTabFrameName = nil <- served from the _caption of the base class

    upcomingInstance._rootTabFrameName = nil
    upcomingInstance._optionalAreaPopulatorWhenFirstShownFunc = nil

    return upcomingInstance
end)


function Class:ChainSet_ParentRootTabFrameName(rootTabFrameName)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNonDudString(rootTabFrameName, "rootTabFrameName")

    _rootTabFrameName = rootTabFrameName

    return self
end

function Class:ChainSet_AreaPopulatorWhenFirstShownFunc(optionalAreaPopulatorWhenFirstShownFunc)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrFunction(optionalAreaPopulatorWhenFirstShownFunc, "optionalAreaPopulatorWhenFirstShownFunc")

    _optionalAreaPopulatorWhenFirstShownFunc = optionalAreaPopulatorWhenFirstShownFunc

    return self
end

function Class:BuildImpl()
    Scopify(EScopes.Function, self)
    
    Guard.Assert.Explained.IsTable(RawPfuiGui, "Cannot build - it seems that pfUI.gui is not a table as expected (has the pfui addon been loaded first?)")
    Guard.Assert.Explained.IsTable(RawPfuiGui.frames, "Cannot build - it seems that pfUI.gui.frames is not a table as expected (has the pfui addon been loaded first?)")
    Guard.Assert.Explained.IsFunction(RawPfuiGui.CreateGUIEntry, "Cannot build - it seems that pfUI.gui.CreateGUIEntry is not a function as expected (has the pfui addon been loaded first?)")

    Guard.Assert.IsNonDudString(_caption, "caption") -- nestedTabFrameName
    Guard.Assert.IsNonDudString(_rootTabFrameName, "rootTabFrameName")
    Guard.Assert.IsNilOrFunction(_optionalAreaPopulatorWhenFirstShownFunc, "optionalAreaPopulatorWhenFirstShownFunc")    

    RawPfuiGui.CreateGUIEntry(
            _rootTabFrameName, --   _t:TryTranslate("Thirdparty")
            _caption, --            _t:TryTranslate("Zen", "|cFF7FFFD4")
            _optionalAreaPopulatorWhenFirstShownFunc
    )

    local rootTabFrame = RawPfuiGui.frames[_rootTabFrameName] or {}
    local nestedTabFrame = rootTabFrame[_caption]

    return PfuiNestedTabFrameWithAreaControl:New(nestedTabFrame)
end
