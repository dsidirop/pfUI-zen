local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]) -- @formatter:off

local Guard   = using "System.Guard"
local Event   = using "System.Event"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Fields  = using "System.Classes.Fields"

local IsAltKeyDown     = using "Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsAltKeyDown"
local IsShiftKeyDown   = using "Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsShiftKeyDown"
local IsControlKeyDown = using "Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsControlKeyDown"

local KeyEventArgs  = using "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.EventArgs.KeyEventArgs"
local EKeyEventType = using "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Enums.EKeyEventType"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Element" -- @formatter:on

Scopify(EScopes.Function, {})

Fields(function(upcomingInstance)
    upcomingInstance._nativeElement = nil

    upcomingInstance._eventKeyDown = nil
    upcomingInstance._eventOnEvent = nil

    return upcomingInstance
end)

function Class:New(nativeElement)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsTable(nativeElement, "nativeElement")

    local instance = self:Instantiate()

    instance._eventKeyDown = Event:New()
    instance._eventOnEvent = Event:New()
    instance._nativeElement = nativeElement

    return instance
end

function Class:ChainSetPropagateKeyboardInput(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(value, "value")

    if _nativeElement.SetPropagateKeyboardInput then
        _nativeElement:SetPropagateKeyboardInput(value) -- 00
    end
    
    return self
    
    --00 vanilla wow 1.12 doesnt seem to support SetPropagateKeyboardInput()  https://wowpedia.fandom.com/wiki/API_Frame_EnableKeyboard
end

function Class:ChainSetFrameStrata(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(value, "value")

    _nativeElement:SetFrameStrata(value)

    return self
end

function Class:ChainSetKeystrokeListenerEnabled(onOrOff)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsBoolean(onOrOff, "onOrOff")

    _nativeElement:EnableKeyboard(onOrOff)

    return self
end

function Class:EventOnEvent_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventOnEvent:Subscribe(handler, owner)

    self:EnsureNativeOnEventListenerIsRegistered_()

    return self
end

function Class:EventOnEvent_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventOnEvent:Unsubscribe(handler)

    if not _eventOnEvent:HasSubscribers() then
        self:EnsureNativeOnEventListenerIsUnregistered_()
    end

    return self
end

-- note that this event requires  :ChainSetFrameStrata("DIALOG"):ChainSetKeystrokeListenerEnabled(true) to be called as well
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
    
    if _nativeElement:GetScript("OnKeyDown") then
        return self
    end

    _nativeElement:SetScript("OnKeyDown", function(_, key)
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

    _nativeElement:SetScript("OnKeyDown", nil)
    
    return self
end

function Class:EnsureNativeOnEventListenerIsRegistered_()
    Scopify(EScopes.Function, self)

    if _nativeElement:GetScript("OnEvent") then
        return self
    end

    _nativeElement:SetScript("OnEvent", function(_, ea)
        _eventOnEvent:Raise(self, ea)
    end)

    return self
end

function Class:EnsureNativeOnEventListenerIsUnregistered_()
    Scopify(EScopes.Function, self)

    _nativeElement:SetScript("OnEvent", nil)

    return self
end
