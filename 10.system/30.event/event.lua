local _assert, _setfenv, _type, _pairs, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _pairs = _assert(_g.pairs)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)
    
    return _assert, _setfenv, _type, _pairs, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Class = _namespacer("System.Event")

function Class:New()
    _setfenv(1, self)

    local instance = {
        _handlers = {},
        _handlersJustOnce = {}
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:Subscribe(handler)
    _setfenv(1, self)
    _assert(_type(handler) == "function")

    _handlers[handler] = handler -- we prevent double-subscriptions by using the handler itself as the key
    
    return self
end

function Class:SubscribeOnce(handler)
    _setfenv(1, self)
    _assert(_type(handler) == "function")

    _handlers[handler] = handler -- we prevent double-subscriptions by using the handler itself as the key
    _handlersJustOnce[handler] = handler

    return self
end

function Class:Unsubscribe(handler)
    _setfenv(1, self)
    _assert(_type(handler) == "function")

    _handlers[handler] = nil

    return self
end

function Class:Clear()
    _setfenv(1, self)

    _handlers = {}

    return self
end

function Class:Fire(sender, eventArgs)
    _setfenv(1, self)

    self:Raise(sender, eventArgs)

    return self -- 00
    
    -- 00  the return value is the difference between :fire() and :raise()   the :raise() flavour returns
    --     the eventArgs   while the :fire() flavour returns the event object itself for further chaining
end

function Class:Raise(sender, eventArgs)
    _setfenv(1, self)
    _assert(eventArgs)

    for _, v in _pairs(_handlers) do
        v(sender, eventArgs)
    end

    for _, v in _pairs(_handlersJustOnce) do
        _handlers[v] = nil -- rip off the handler
    end

    _handlersJustOnce = {} -- and finally reset the just-once handlers

    return eventArgs
end
