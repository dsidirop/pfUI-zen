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

local Event = _importer("Pavilion.System.Event")
local WoWCreateFrame = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.CreateFrame")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Time.Timer")

function Class:New(interval)
    _setfenv(1, self)
    
    _assert(_type(interval) == "number" and interval > 0, "interval must be a positive number")

    local instance = {
        _interval = interval,

        _element = nil,
        _eventElapsed = Event:New(),
        _elapsedTimeSinceLastFiring = 0,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:Start()
    _setfenv(1, self)
    
    if _eventElapsed:HasSubscribers() then
        self:StartImpl_()
    end    
    
    _active = true

    return self
end

function Class:Stop()
    _setfenv(1, self)

    self:StopImpl_()
    _active = false
    
    return self
end

function Class:EventElapsed_Subscribe(handler, owner)
    _setfenv(1, self)

    _eventElapsed:Subscribe(handler, owner)
    if _isActive then -- autorestart after someone resubscribes
        self:StartImpl_() 
    end

    return self
end

function Class:EventElapsed_Unsubscribe(handler)
    _setfenv(1, self)

    _eventElapsed:Unsubscribe(handler)
    if not _eventElapsed:HasSubscribers() then
        self:StopImpl_() -- if there is noone listening then we pause for the sake of respecting performance 
    end

    return self
end

-- private space

function Class:StartImpl_()
    _setfenv(1, self)

    self:EnsureInitializedOnlyOnce_()

    _element:Show()

    return self
end


function Class:StopImpl_()
    _setfenv(1, self)

    -- _element = nil --dont  there is no point in doing this

    _element:Hide()
    _elapsedTimeSinceLastFiring = 0

    return self
end

function Class:EnsureInitializedOnlyOnce_()
    _setfenv(1, self)

    if _element then
        return
    end

    _element = WoWCreateFrame("Frame") -- dont even bother using strenums here
    _element:SetScript("OnUpdate", function()
        _elapsedTimeSinceLastFiring = _elapsedTimeSinceLastFiring + arg1 -- 00

        while (_elapsedTimeSinceLastFiring > _interval) do
            _elapsedTimeSinceLastFiring = _elapsedTimeSinceLastFiring - _interval

            _eventElapsed:Raise({})
        end
    end)
    
    -- 00  arg1 is the elapsed time since the previous callback invocation   there is no other way to get this value
end