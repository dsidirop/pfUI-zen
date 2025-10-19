--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Class = using "[declare]" "Pavilion.Warcraft.Foundation.UI.Frames.FrameX [Partial]"

function Class:EventOnGameNotificationReceived_Subscribe(handler, owner) -- todo   add an extra option to filter by specific game-notification-name like "CHAT_MSG_SYSTEM" etc
    Scopify(EScopes.Function, self)

    _eventOnGameNotificationReceived:Subscribe(handler, owner)

    self:EnsureNativeOnGameNotificationReceivedListenerIsRegistered_()

    return self
end

function Class:EventOnGameNotificationReceived_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventOnGameNotificationReceived:Unsubscribe(handler)

    if not _eventOnGameNotificationReceived:HasSubscribers() then
        self:EnsureNativeOnGameNotificationReceivedListenerIsUnregistered_()
    end

    return self
end

function Class:EnsureNativeOnGameNotificationReceivedListenerIsRegistered_()
    Scopify(EScopes.Function, self)

    if _rawWoWFrame:GetScript("OnEvent") then
        return self
    end

    _rawWoWFrame:SetScript("OnEvent", function(_, ea)
        _eventOnGameNotificationReceived:Raise(self, ea)
    end)

    return self
end

function Class:EnsureNativeOnGameNotificationReceivedListenerIsUnregistered_()
    Scopify(EScopes.Function, self)

    _rawWoWFrame:SetScript("OnEvent", nil)

    return self
end
