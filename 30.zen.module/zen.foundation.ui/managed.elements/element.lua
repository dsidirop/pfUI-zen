local _assert, _setfenv, _type, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _assert, _setfenv, _type, _importer, _namespacer
end)()

_setfenv(1, {})

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local IsAltKeyDown = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsAltKeyDown")
local IsShiftKeyDown = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsShiftKeyDown")
local IsControlKeyDown = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsControlKeyDown")

local Event = _importer("System.Event")
local OnEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.EventArgs.OnEventArgs")
local KeyEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.EventArgs.KeyEventArgs")
local EKeyEventType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Enums.EKeyEventType")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Element")

function Class:New(nativeElement)
    Scopify(EScopes.Function, self)
    
    _assert(_type(nativeElement) == "table", "nativeElement must be a table")

    return self:Instantiate({
        _nativeElement = nativeElement,

        _eventKeyDown = Event:New(),
        _eventOnEvent = Event:New(),
    })
end

function Class:Hide()
    Scopify(EScopes.Function, self)

    _nativeElement:Hide()

    return self
end

function Class:ChainSetPropagateKeyboardInput(value)
    Scopify(EScopes.Function, self)
    
    _assert(_type(value) == "boolean", "value must be a boolean")

    if _nativeElement.SetPropagateKeyboardInput then
        _nativeElement:SetPropagateKeyboardInput(value) -- 00
    end
    
    return self
    
    --00 vanilla wow 1.12 doesnt seem to support SetPropagateKeyboardInput()  https://wowpedia.fandom.com/wiki/API_Frame_EnableKeyboard
end

function Class:ChainSetFrameStrata(value)
    Scopify(EScopes.Function, self)
    
    _assert(_type(value) == "string", "value must be a boolean")

    _nativeElement:SetFrameStrata(value)

    return self
end

function Class:ChainSetKeystrokeListenerEnabled(onOrOff)
    Scopify(EScopes.Function, self)

    -- _assert(...) -- nah  dont

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

    _nativeElement:SetScript("OnEvent", function(_, event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10)
        _eventOnEvent:Raise(self, OnEventArgs:New(event, arg1, arg2, arg3, arg4, arg5, arg6, arg7, arg8, arg9, arg10))
    end)

    return self
end

function Class:EnsureNativeOnEventListenerIsUnregistered_()
    Scopify(EScopes.Function, self)

    _nativeElement:SetScript("OnEvent", nil)

    return self
end
