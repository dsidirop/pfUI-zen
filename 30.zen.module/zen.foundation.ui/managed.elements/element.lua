local _assert, _setfenv, _type, _getn, _, _, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
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

local KeyEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.KeyEventArgs")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Element")

function Class:New(nativeElement)
    _setfenv(1, self)
    
    _assert(_type(nativeElement) == "table", "nativeElement must be a table")

    local instance = {
        _eventKeyDown = Event:New(),
        _nativeElement = nativeElement,
        _nativeKeyDownListenerActive = false,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:ChainSetPropagateKeyboardInput(value)
    _setfenv(1, self)
    
    _assert(_type(value) == "boolean", "value must be a boolean")
    
    _nativeElement:SetPropagateKeyboardInput(value)

    return self
end

function Class:EventKeyDown_Subscribe(handler, owner)
    _setfenv(1, self)
    
    _eventKeyDown:Subscribe(handler, owner)
    
    self:ChainEnsureNativeKeyDownListenerIsRegistered_()

    return self
end

function Class:EventKeyDown_Unsubscribe(handler)
    _setfenv(1, self)

    _eventKeyDown:Unsubscribe(handler)
    
    if not _eventKeyDown:HasSubscribers() then
        self:ChainEnsureNativeKeyDownListenerIsUnregistered_()
    end

    return self
end

-- private space

function Class:ChainEnsureNativeKeyDownListenerIsRegistered_()
    _setfenv(1, self)
    
    if _nativeKeyDownListenerActive then
        return self
    end       

    _nativeElement:SetScript("OnKeyDown", function(_, key)
        _eventKeyDown:Fire(KeyEventArgs:New(key))
    end)

    _nativeKeyDownListenerActive = true

    return self
end

function Class:ChainEnsureNativeKeyDownListenerIsUnregistered_()
    _setfenv(1, self)
    
    if not _nativeKeyDownListenerActive then
        return self
    end       

    _nativeElement:SetScript("OnKeyDown", nil)

    _nativeKeyDownListenerActive = false
    
    return self
end