local _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local IsAltKeyDown = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsAltKeyDown")
local IsShiftKeyDown = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsShiftKeyDown")
local IsControlKeyDown = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.IsControlKeyDown")

local Event = _importer("Pavilion.System.Event")
local KeyEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.EventArgs.KeyEventArgs")
local EKeyEventType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Enums.EKeyEventType")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Element")

function Class:New(nativeElement)
    _setfenv(1, self)
    
    _assert(_type(nativeElement) == "table", "nativeElement must be a table")

    local instance = {
        _nativeElement = nativeElement,

        _eventKeyDown = Event:New(),
        _isNativeKeyDownListenerActive = false,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:ChainSetPropagateKeyboardInput(value)
    _setfenv(1, self)
    
    _assert(_type(value) == "boolean", "value must be a boolean")

    if _nativeElement.SetPropagateKeyboardInput then
        _nativeElement:SetPropagateKeyboardInput(value) -- 00
    end
    
    return self
    
    --00 vanilla wow 1.12 doesnt seem to support SetPropagateKeyboardInput()  https://wowpedia.fandom.com/wiki/API_Frame_EnableKeyboard
end

function Class:ChainSetFrameStrata(value)
    _setfenv(1, self)
    
    _assert(_type(value) == "string", "value must be a boolean")

    _nativeElement:SetFrameStrata(value)

    return self
end

function Class:ChainSetKeystrokeListenerEnabled(onOrOff)
    _setfenv(1, self)

    -- _assert(...) -- nah  dont

    _nativeElement:EnableKeyboard(onOrOff)

    return self
end

-- note that this event requires  :ChainSetFrameStrata("DIALOG"):ChainSetKeystrokeListenerEnabled(true) to be called as well
function Class:EventKeyDown_Subscribe(handler, owner)
    _setfenv(1, self)
    
    _eventKeyDown:Subscribe(handler, owner)
    
    self:EnsureNativeKeyDownListenerIsRegistered_()

    return self
end

function Class:EventKeyDown_Unsubscribe(handler)
    _setfenv(1, self)

    _eventKeyDown:Unsubscribe(handler)
    
    if not _eventKeyDown:HasSubscribers() then
        self:EnsureNativeKeyDownListenerIsUnregistered_()
    end

    return self
end

-- private space

function Class:EnsureNativeKeyDownListenerIsRegistered_()
    _setfenv(1, self)
    
    if _isNativeKeyDownListenerActive then
        return self
    end

    _nativeElement:SetScript("OnKeyDown", function(_, key)
        _eventKeyDown:Fire(self, KeyEventArgs:New(
                key, -- key is always 'nil' for some reason on all wow1.12 clients  go figure
                IsAltKeyDown(),
                IsShiftKeyDown(),
                IsControlKeyDown(),
                EKeyEventType.KeyDown
        ))
    end)

    _isNativeKeyDownListenerActive = true

    return self
end

function Class:EnsureNativeKeyDownListenerIsUnregistered_()
    _setfenv(1, self)
    
    if not _isNativeKeyDownListenerActive then
        return self
    end       

    _nativeElement:SetScript("OnKeyDown", nil)

    _isNativeKeyDownListenerActive = false
    
    return self
end