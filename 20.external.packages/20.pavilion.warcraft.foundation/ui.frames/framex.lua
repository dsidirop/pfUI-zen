--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard   = using "System.Guard"
local Fields  = using "System.Classes.Fields"

local IFrameX = using "Pavilion.Warcraft.Foundation.UI.Frames.Contracts.IFrameX"

local Class = using "[declare] [blend]" "Pavilion.Warcraft.Foundation.UI.Frames.FrameX" { --@formatter:on  https://wowpedia.fandom.com/wiki/UIOBJECT_Frame
    "IFrameX", IFrameX
}


Fields(function(upcomingInstance)
    upcomingInstance._rawWoWFrame = nil
    return upcomingInstance
end)

function Class:New(rawWoWFrame)
    Scopify(EScopes.Function, {})

    Guard.Assert.IsMereFrame(rawWoWFrame, "rawWoWFrame") -- todo   such guards (and their test-suites!) should be part of pavilion   they don't belong under system.*!
    
    local newInstance = self:Instantiate(rawWoWFrame)
    
    newInstance._rawWoWFrame = rawWoWFrame

    return newInstance
end

function Class:GetRawWowFrame()
    return self._rawWoWFrame
end

-- extra pavilion methods on the frame

function Class:ChainSet_Height(height)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveNumber(height, "height")

    _rawWoWFrame:SetHeight(height)

    return self
end

function Class:ChainSet_Visibility(showNotHide)
    Scopify(EScopes.Function, self)

    if showNotHide then
        _rawWoWFrame:Show()
    else
        _rawWoWFrame:Hide()
    end

    return self
end
