﻿local _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
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

local GreeniesAutolooterAggregate = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesAutolooter.Aggregate")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngine")

function Class:New(greeniesAutolooterAggregate)
    _setfenv(1, self)

    local instance = {
        _state = nil,
        
        _greeniesAutolooterAggregate = greeniesAutolooterAggregate or GreeniesAutolooterAggregate:New(),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

-- state is expected to be ZenEngineStateDTO
function Class:SetState(state)
    _setfenv(1, self)
    
    -- todo validate state first
    
    _state = state
    _greeniesAutolooterAggregate:ChainSetState(state:GetGreeniesAutolooterAggregateStateDTO())
end

function Class:Run()
    _setfenv(1, self)

    _greeniesAutolooterAggregate:Run()

    return self
end