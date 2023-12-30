local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Guard = using "System.Guard"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Classify = using "System.Classes.Classify"
local TablesHelper = using "System.Helpers.Tables"

local Class = using "[declare]" "System.Event [Partial]"

Scopify(EScopes.Function, {})

function Class:New()
    Scopify(EScopes.Function, self)

    return Classify(self, {
        _handlers = {},
        _handlersJustOnce = {}
    })
end

local NoOwner = {}
function Class:Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(handler, "handler")
    Guard.Assert.IsOptionallyTable(owner, "owner")

    _handlers[handler] = owner or NoOwner -- we prevent double-subscriptions by using the handler itself as the key
    
    return self
end

function Class:SubscribeOnce(handler, owner)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(handler, "handler")
    Guard.Assert.IsOptionallyTable(owner, "owner")

    self:Subscribe(handler, owner)
    self:SubscribeOnceImpl_(handler, owner)

    return self
end

function Class:HasSubscribers()
    Scopify(EScopes.Function, self)
    
    return TablesHelper.AnyOrNil(_handlers) 
end

function Class:SubscribeOnceImpl_(handler, owner)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(handler, "handler")
    Guard.Assert.IsOptionallyTable(owner, "owner")

    _handlersJustOnce[handler] = owner or NoOwner

    return self
end

function Class:Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsFunction(handler, "handler")

    _handlers[handler] = nil
    _handlersJustOnce[handler] = nil

    return self
end

function Class:Clear()
    Scopify(EScopes.Function, self)

    _handlers = {}
    _handlersJustOnce = {}

    return self
end

function Class:Fire(sender, eventArgs)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(sender, "sender")
    Guard.Assert.IsTable(eventArgs, "eventArgs")

    self:Raise(sender, eventArgs)

    return self -- 00
    
    -- 00  the return value is the difference between :fire() and :raise()   the :raise() flavour returns
    --     the eventArgs   while the :fire() flavour returns the event object itself for further chaining
end

function Class:Raise(sender, eventArgs)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsTable(sender, "sender")
    Guard.Assert.IsTable(eventArgs, "eventArgs")

    for k, v in TablesHelper.GetKeyValuePairs(_handlers) do
        if v and v ~= NoOwner then -- v is the owning class-instance of the handler
            k(v, sender, eventArgs)
        else
            k(sender, eventArgs)
        end
    end

    for _, v in TablesHelper.GetKeyValuePairs(_handlersJustOnce) do
        _handlers[v] = nil -- rip off the handler
    end

    _handlersJustOnce = {} -- and finally reset the just-once handlers

    return eventArgs
end
