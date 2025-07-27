--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard               = using "System.Guard"
local Fields              = using "System.Classes.Fields"

local PfuiGui             = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.RawBindings.PfuiGui"
local IPfuiHeaderBuilder  = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.Header.IPfuiHeaderBuilder"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Configuration.Gui.Controls.Header.PfuiHeaderBuilder" { --[[@formatter:on]]
    "IPfuiHeaderBuilder", IPfuiHeaderBuilder,
}

Fields(function(upcomingInstance)
    upcomingInstance._caption = nil
    upcomingInstance._nativePfuiControlFrame = nil

    return upcomingInstance
end)

function Class:ChainSet_Caption(caption)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(caption, "caption")

    _caption = caption

    return self
end

function Class:Build()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNonDudString(_caption, "_caption")

    _nativePfuiControlFrame = PfuiGui.CreateConfig(
        nil, -- todo   explore when this 'ufunc' is getting fired   I suspect its when it is shown or first-shown
        _caption,
        nil, -- ignored
        nil, -- ignored
        "header" -- hardcoded
    )

    return self -- todo  we should return a wrapped _nativePfuiControlFrame and move the :ChainSet_Visibility() and other methods in that wrapper
end

-- todo   all these methods should be moved to the control class itself
function Class:ChainSet_Height(height)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveNumber(height, "height")
    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control has not beed built - call Build() first")

    _nativePfuiControlFrame:SetHeight(height)

    return self
end

function Class:ChainSet_Visibility(showNotHide)
    Scopify(EScopes.Function, self)

    if showNotHide then
        self:Show()
    else
        self:Hide()
    end

    return self
end

function Class:Show()
    Scopify(EScopes.Function, self)

    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control has not beed built - call Build() first")

    _nativePfuiControlFrame:Show()

    return self
end

function Class:Hide()
    Scopify(EScopes.Function, self)

    Guard.Assert.Explained.IsNotNil(_nativePfuiControlFrame, "control has not beed built - call Build() first")

    _nativePfuiControlFrame:Hide()

    return self
end
