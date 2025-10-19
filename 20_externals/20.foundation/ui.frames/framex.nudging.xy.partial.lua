--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local Class = using "[declare]" "Pavilion.Warcraft.Foundation.UI.Frames.FrameX [Partial]"

function Class:ChainApply_NudgingX(xNudge)
    Scopify(EScopes.Function, self)

    return self:ChainApply_NudgingXY(xNudge, 0)
end

function Class:ChainApply_NudgingY(yNudge)
    Scopify(EScopes.Function, self)

    return self:ChainApply_NudgingXY(0, yNudge)
end

function Class:ChainApply_NudgingXY(xNudge, yNudge)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNumber(xNudge, "xNudge") -- +/-px horizontally from the default position
    Guard.Assert.IsNumber(yNudge, "yNudge") -- +/-px vertically   from the default position

    if xNudge == 0 and yNudge == 0 then
        return self -- nothing to do
    end

    local anchor, relativeControl, relativeAnchor, xpos, ypos = _rawWoWFrame.caption:GetPoint()

    _rawWoWFrame.caption:SetPoint(
            anchor,
            relativeControl,
            relativeAnchor,
            xpos + xNudge,
            ypos + yNudge
    )

    return self
end
