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

local EWowItemQuality = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowItemQuality")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Loot.GambledItemInfo")

function Class:New(
        rollId,
        texture,
        name,
        count,
        quality,
        bindOnPickUp,
        canNeed,
        canGreed,
        canDisenchant,
        reasonNeed,
        reasonGreed,
        reasonDisenchant,
        deSkillRequired,
        canTransmog
)
    _setfenv(1, self)

    local instance = {
        _rollId = rollId,

        _name = name,
        _count = count,
        _texture = texture,
        _quality = quality,
        _canNeed = canNeed,
        _canGreed = canGreed,
        _reasonNeed = reasonNeed,
        _canTransmog = canTransmog,
        _reasonGreed = reasonGreed,
        _bindOnPickUp = bindOnPickUp,
        _canDisenchant = canDisenchant,
        _deSkillRequired = deSkillRequired,
        _reasonDisenchant = reasonDisenchant,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:IsHealthy()
    _setfenv(1, self)

    return _name ~= nil
end

function Class:GetRollId()
    _setfenv(1, self)

    return _rollId
end

function Class:GetName()
    _setfenv(1, self)

    return _name
end

function Class:IsNeedable()
    _setfenv(1, self)

    return _canNeed
end

function Class:IsGreedable()
    _setfenv(1, self)
    
    return _canGreed
end

function Class:IsGreenQuality()
    _setfenv(1, self)

    return _quality == EWowItemQuality.Green
end
