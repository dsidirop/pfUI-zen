--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local KeyEventArgs = using "Pavilion.Warcraft.Foundation.UI.Frames.Contracts.EventArgs.KeyEventArgs"

local Class = using "[declare]" "Pavilion.Warcraft.Foundation.UI.Frames.FrameX [Partial]"

-- note that this event requires  :ChainSet_FrameStrata("DIALOG"):ChainSet_KeystrokeListenerEnabled(true) to be called as well
function Class:EventKeyDown_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventKeyDown:Subscribe(handler, owner)

    self:EnsureNativeOnKeyDownListenerIsRegistered_()

    return self
end

function Class:EventKeyDown_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventKeyDown:Unsubscribe(handler)

    if not _eventKeyDown:HasSubscribers() then
        self:EnsureNativeOnKeyDownListenerIsUnregistered_()
    end

    return self
end


-- private space

function Class:EnsureNativeOnKeyDownListenerIsRegistered_()
    Scopify(EScopes.Function, self)

    if _rawWoWFrame:GetScript("OnKeyDown") then
        return self
    end

    _rawWoWFrame:SetScript("OnKeyDown", function(_, key)
        _eventKeyDown:Raise(self, KeyEventArgs:New(
                key, -- key is always 'nil' for some reason on all wow1.12 clients  go figure
                IsAltKeyDown(),
                IsShiftKeyDown(),
                IsControlKeyDown(),
                EKeyEventType.KeyDown
        ))
    end)

    return self
end

function Class:EnsureNativeOnKeyDownListenerIsUnregistered_()
    Scopify(EScopes.Function, self)

    _rawWoWFrame:SetScript("OnKeyDown", nil)

    return self
end

