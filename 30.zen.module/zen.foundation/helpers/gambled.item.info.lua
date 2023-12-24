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

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local Classify = _importer("System.Classify")
local StringsHelper = _importer("System.Helpers.Strings")
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
    Scopify(EScopes.Function, self)

    return Classify(self, {
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
    })
end

function Class:IsHealthy()
    Scopify(EScopes.Function, self)

    return _name ~= nil
end

function Class:GetGamblingId()
    Scopify(EScopes.Function, self)

    return _rollId
end

function Class:GetName()
    Scopify(EScopes.Function, self)

    return _name
end

function Class:GetTexture()
    Scopify(EScopes.Function, self)

    return _texture
end

function Class:GetCount()
    Scopify(EScopes.Function, self)

    return _count == nil
            and 1
            or _count
end

function Class:IsNeedable()
    Scopify(EScopes.Function, self)

    return _canNeed == nil or _canNeed
end

function Class:IsGreedable()
    Scopify(EScopes.Function, self)

    return _canGreed == nil or _canGreed
end

function Class:GetQuality()
    Scopify(EScopes.Function, self)

    return _quality
end

function Class:IsGreenQuality()
    Scopify(EScopes.Function, self)

    return _quality == EWowItemQuality.Green
end

function Class:IsBlueQuality()
    Scopify(EScopes.Function, self)

    return _quality == EWowItemQuality.Blue
end

function Class:IsPurpleQuality()
    Scopify(EScopes.Function, self)

    return _quality == EWowItemQuality.Purple
end

function Class:IsOrangeQuality()
    Scopify(EScopes.Function, self)

    return _quality == EWowItemQuality.Orange
end

function Class:IsLegendaryQuality()
    Scopify(EScopes.Function, self)

    return _quality == EWowItemQuality.Legendary
end

function Class:IsArtifactQuality()
    Scopify(EScopes.Function, self)

    return _quality == EWowItemQuality.Artifact
end

function Class:IsBindOnPickUp()
    Scopify(EScopes.Function, self)

    return _bindOnPickUp
end

function Class:__tostring()
    Scopify(EScopes.Function, self)

    return StringsHelper.Format(
            "{ name = %q, rollId = %q, texture = %q, count = %q, quality = %q, bindOnPickUp = %q, canNeed = %q, canGreed = %q, canDisenchant = %q, reasonNeed = %q, reasonGreed = %q, reasonDisenchant = %q, deSkillRequired = %q, canTransmog = %q }",
            self:GetName(),
            self:GetGamblingId(),
            self:GetTexture(),
            self:GetCount(),
            self:GetQuality(),
            self:IsBindOnPickUp(),
            self:IsNeedable(),
            self:IsGreedable(),
            canDisenchant,
            reasonNeed,
            reasonGreed,
            reasonDisenchant,
            deSkillRequired,
            canTransmog
    )
end
