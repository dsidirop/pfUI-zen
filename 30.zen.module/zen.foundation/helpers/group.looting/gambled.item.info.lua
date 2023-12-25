local _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _importer, _namespacer
end)()

_setfenv(1, {}) --                                                                                               @formater:off

local Guard           = _importer("System.Guard")
local Scopify         = _importer("System.Scopify")
local EScopes         = _importer("System.EScopes")
local Classify        = _importer("System.Classify")

local StringsHelper   = _importer("System.Helpers.Strings")
local BooleansHelper  = _importer("System.Helpers.Booleans")

local EWowItemQuality = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowItemQuality") --  @formater:off

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Helpers.GroupLooting.GambledItemInfo")

function Class:New(
        rollId,
        textureFilepath,
        name,
        count,
        itemQuality,
        isBindOnPickUp,
        isNeedable,
        isGreedable,
        isDisenchantable,
        needInelligibilityReasonType,
        greedInelligibilityReasonType,
        disenchantInelligibilityReasonType,
        disechantingSkillRequired,
        isTransmogrifiable
)
    Scopify(EScopes.Function, self)

    Guard.Check.IsPositiveInteger(rollId)
    
    Guard.Check.IsNonEmptyString(name)
    Guard.Check.IsPositiveInteger(itemQuality) -- EWowItemQuality  but better not enforce checking for the enum type
    Guard.Check.IsOptionallyNonEmptyString(textureFilepath)
    
    Guard.Check.IsPositiveInteger(count)
    Guard.Check.IsOptionallyBooleanizable(isNeedable)
    Guard.Check.IsOptionallyBooleanizable(isGreedable)
    Guard.Check.IsOptionallyBooleanizable(isBindOnPickUp)
    Guard.Check.IsOptionallyBooleanizable(isDisenchantable)
    Guard.Check.IsOptionallyBooleanizable(isTransmogrifiable)
    Guard.Check.IsOptionallyPositiveIntegerOrZero(disechantingSkillRequired)

    Guard.Check.IsOptionallyPositiveIntegerOrZero(needInelligibilityReasonType)  --      EWowLootingInelligibilityReasonType  but its better to not enforce the enum type via an explicit check
    Guard.Check.IsOptionallyPositiveIntegerOrZero(greedInelligibilityReasonType) --      EWowLootingInelligibilityReasonType  but its better to not enforce the enum type via an explicit check
    Guard.Check.IsOptionallyPositiveIntegerOrZero(disenchantInelligibilityReasonType) -- EWowLootingInelligibilityReasonType  but its better to not enforce the enum type via an explicit check
    
    return Classify(self, { --@formatter:off
        _rollId = rollId,

        _name            = name,
        _itemQuality     = itemQuality,
        
        _isNeedable                = BooleansHelper.Booleanize(isNeedable,         true),
        _isGreedable               = BooleansHelper.Booleanize(isGreedable,        true),
        _isBindOnPickUp            = BooleansHelper.Booleanize(isBindOnPickUp,     true),
        _isDisenchantable          = BooleansHelper.Booleanize(isDisenchantable,   true),
        _isTransmogrifiable        = BooleansHelper.Booleanize(isTransmogrifiable, true),

        _count                     = count,
        _textureFilepath           = textureFilepath,
        _disechantingSkillRequired = disechantingSkillRequired == nil and 0 or disechantingSkillRequired,
        
        _needInelligibilityReasonType       = needInelligibilityReasonType       == nil and 0 or needInelligibilityReasonType, --        can be nil if isNeedable       is true
        _greedInelligibilityReasonType      = greedInelligibilityReasonType      == nil and 0 or greedInelligibilityReasonType, --       can be nil if isGreedable      is true
        _disenchantInelligibilityReasonType = disenchantInelligibilityReasonType == nil and 0 or disenchantInelligibilityReasonType --   can be nil if isDisenchantable is true
    }) --@formatter:on
end

function Class:GetName()
    Scopify(EScopes.Function, self)

    return _name
end

function Class:GetGamblingId()
    Scopify(EScopes.Function, self)

    return _rollId
end

function Class:GetTexture()
    Scopify(EScopes.Function, self)

    return _textureFilepath
end

function Class:GetCount()
    Scopify(EScopes.Function, self)

    return _count
end

function Class:IsNeedable()
    Scopify(EScopes.Function, self)

    return _isNeedable
end

function Class:IsGreedable()
    Scopify(EScopes.Function, self)

    return _isGreedable
end

function Class:GetQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality
end

function Class:IsGreenQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality == EWowItemQuality.Green
end

function Class:IsBlueQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality == EWowItemQuality.Blue
end

function Class:IsPurpleQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality == EWowItemQuality.Purple
end

function Class:IsOrangeQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality == EWowItemQuality.Orange
end

function Class:IsLegendaryQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality == EWowItemQuality.Legendary
end

function Class:IsArtifactQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality == EWowItemQuality.Artifact
end

function Class:IsBindOnPickUp()
    Scopify(EScopes.Function, self)

    return _isBindOnPickUp
end

function Class:GetDisechantingSkillRequired()
    Scopify(EScopes.Function, self)

    return _disechantingSkillRequired
end

-- @return EWowLootingInelligibilityReasonType
function Class:GetNeedInelligibilityReasonType()
    Scopify(EScopes.Function, self)
    
    return _needInelligibilityReasonType
end

-- @return EWowLootingInelligibilityReasonType
function Class:GetGreedInelligibilityReasonType()
    Scopify(EScopes.Function, self)

    return _greedInelligibilityReasonType
end

-- @return EWowLootingInelligibilityReasonType
function Class:GetDisenchantInelligibilityReasonType()
    Scopify(EScopes.Function, self)

    return _disenchantInelligibilityReasonType
end


function Class:__tostring()
    Scopify(EScopes.Function, self)

    return StringsHelper.Format( --@formatter:off
            "{\n"                                              ..
            "  Name                               = %q,\n"     ..
            "  Quality                            = %q,\n"     ..
            "  GamblingId                         = %d,\n"     ..

            "  IsNeedable                         = %s,\n"     ..
            "  IsGreedable                        = %s,\n"     ..
            "  IsBindOnPickUp                     = %s,\n"     ..
            "  IsDisenchantable                   = %s,\n"     ..
            "  IsTransmogrifiable                 = %s,\n"     ..

            "  Count                              = %d,\n"     ..
            "  Texture                            = %q,\n"     ..
            "  DisechantingSkillRequired          = %d,\n"     ..

            "  NeedInelligibilityReasonType       = %d,\n"     ..
            "  GreedInelligibilityReasonType      = %d,\n"     ..
            "  DisenchantInelligibilityReasonType = %d\n"      ..
            "}\n",
            self:GetName(),
            self:GetQuality(),
            self:GetGamblingId(),

            self:IsNeedable(),
            self:IsGreedable(),
            self:IsBindOnPickUp(),
            self:IsDisenchantable(),
            self:IsTransmogrifiable(),

            self:GetCount(),
            self:GetTexture(),
            self:GetDisechantingSkillRequired(),

            self:GetNeedInelligibilityReasonType(),
            self:GetGreedInelligibilityReasonType(),
            self:GetDisenchantInelligibilityReasonType()            
    ) --@formatter:on
end
