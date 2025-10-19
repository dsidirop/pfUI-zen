--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils         = using "System.Nils"
local Guard        = using "System.Guard"
local Fields       = using "System.Classes.Fields"

local StringsHelper   = using "System.Helpers.Strings"
local BooleansHelper  = using "System.Helpers.Booleans"

local EWowItemQuality = using "Pavilion.Warcraft.Foundation.Enums.EWowItemQuality"

local Class = using "[declare]" "Pavilion.Warcraft.Foundation.GroupLooting.Contracts.GambledItemInfoDto" --@formater:on


Fields(function(upcomingInstance) --@formatter:off
    upcomingInstance._name        = ""
    upcomingInstance._gamblingId  = 0
    upcomingInstance._itemQuality = 0

    upcomingInstance._isNeedable         = false
    upcomingInstance._isGreedable        = false
    upcomingInstance._isBindOnPickUp     = false
    upcomingInstance._isDisenchantable   = false
    upcomingInstance._isTransmogrifiable = false

    upcomingInstance._count                           = 0
    upcomingInstance._textureFilepath                 = ""
    upcomingInstance._enchantingLevelRequiredToDEItem = 0

    upcomingInstance._needIneligibilityReasonType       = 0
    upcomingInstance._greedIneligibilityReasonType      = 0
    upcomingInstance._disenchantIneligibilityReasonType = 0

    return upcomingInstance --@formatter:on
end)

function Class:New(options)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsTable(options, "options") -- todo   Guard.Assert.IsTableWithSpecificPropertyNames(options, OptionsPrototype)  

    Guard.Assert.IsNonDudStringOfMaxLength(options.Name, 512, "options.Name")
   
    Guard.Assert.IsPositiveIntegerOrZero(options.GamblingId, "options.GamblingId")
    Guard.Assert.IsPositiveIntegerOfMaxValue(options.ItemQuality, 20, "options.ItemQuality") -- EWowItemQuality  but better not enforce checking for the enum type

    Guard.Assert.IsNilOrBooleanizable(options.IsNeedable, "options.IsNeedable") -- the following are all optionals
    Guard.Assert.IsNilOrBooleanizable(options.IsGreedable, "options.IsGreedable")
    Guard.Assert.IsNilOrBooleanizable(options.IsBindOnPickUp, "options.IsBindOnPickUp")
    Guard.Assert.IsNilOrBooleanizable(options.IsDisenchantable, "options.IsDisenchantable")
    Guard.Assert.IsNilOrBooleanizable(options.IsTransmogrifiable, "options.IsTransmogrifiable")

    Guard.Assert.IsNilOrNonDudStringOfMaxLength(options.TextureFilepath, 1024, "options.TextureFilepath")
    Guard.Assert.IsNilOrPositiveIntegerOfMaxValue(options.Count, 2000, "options.Count")
    Guard.Assert.IsNilOrPositiveIntegerOrZeroOfMaxValue(options.EnchantingLevelRequiredToDEItem, 3000, "options.EnchantingLevelRequiredToDEItem")

    Guard.Assert.IsNilOrPositiveIntegerOrZeroOfMaxValue(options.NeedIneligibilityReasonType, 20, "options.NeedIneligibilityReasonType")  --            EWowLootingIneligibilityReasonType  but its better to not enforce the enum type via an explicit check
    Guard.Assert.IsNilOrPositiveIntegerOrZeroOfMaxValue(options.GreedIneligibilityReasonType, 20, "options.GreedIneligibilityReasonType") --           EWowLootingIneligibilityReasonType
    Guard.Assert.IsNilOrPositiveIntegerOrZeroOfMaxValue(options.DisenchantIneligibilityReasonType, 20, "options.DisenchantIneligibilityReasonType") -- EWowLootingIneligibilityReasonType

    local instance = self:Instantiate() --@formatter:off

    instance._name        = StringsHelper.Trim(options.Name)
    instance._gamblingId  = options.GamblingId
    instance._itemQuality = options.ItemQuality

    instance._isNeedable         = BooleansHelper.Booleanize(options.IsNeedable,         true)
    instance._isGreedable        = BooleansHelper.Booleanize(options.IsGreedable,        true)
    instance._isBindOnPickUp     = BooleansHelper.Booleanize(options.IsBindOnPickUp,     true)
    instance._isDisenchantable   = BooleansHelper.Booleanize(options.IsDisenchantable,   true)
    instance._isTransmogrifiable = BooleansHelper.Booleanize(options.IsTransmogrifiable, true)

    instance._count                           = Nils.Coalesce(options.Count, 1)
    instance._textureFilepath                 = Nils.Coalesce(options.TextureFilepath, "")
    instance._enchantingLevelRequiredToDEItem = Nils.Coalesce(options.EnchantingLevelRequiredToDEItem, 0)

    instance._needIneligibilityReasonType       = Nils.Coalesce(options.NeedIneligibilityReasonType, 0) --        can be nil if isNeedable       is true
    instance._greedIneligibilityReasonType      = Nils.Coalesce(options.GreedIneligibilityReasonType, 0) --       can be nil if isGreedable      is true
    instance._disenchantIneligibilityReasonType = Nils.Coalesce(options.DisenchantIneligibilityReasonType, 0) --  can be nil if isDisenchantable is true

    return instance --@formatter:on
end

function Class:GetName()
    Scopify(EScopes.Function, self)

    return _name
end

function Class:GetGamblingRequestId()
    Scopify(EScopes.Function, self)

    return _gamblingId
end

function Class:GetTextureFilepath()
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

function Class:IsDisenchantable()
    Scopify(EScopes.Function, self)

    return _isDisenchantable
end

function Class:IsTransmogrifiable()
    Scopify(EScopes.Function, self)

    return _isTransmogrifiable
end

function Class:GetItemQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality
end

function Class:IsGreyQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality == EWowItemQuality.Grey
end

function Class:IsWhiteQuality()
    Scopify(EScopes.Function, self)

    return _itemQuality == EWowItemQuality.White
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

function Class:GetEnchantingLevelRequiredToDEItem()
    Scopify(EScopes.Function, self)

    return _enchantingLevelRequiredToDEItem
end

-- @return EWowLootingIneligibilityReasonType
function Class:GetNeedIneligibilityReasonType()
    Scopify(EScopes.Function, self)
    
    return _needIneligibilityReasonType
end

-- @return EWowLootingIneligibilityReasonType
function Class:GetGreedIneligibilityReasonType()
    Scopify(EScopes.Function, self)

    return _greedIneligibilityReasonType
end

-- @return EWowLootingIneligibilityReasonType
function Class:GetDisenchantIneligibilityReasonType()
    Scopify(EScopes.Function, self)

    return _disenchantIneligibilityReasonType
end

function Class:ToString()
    Scopify(EScopes.Function, self)

    return StringsHelper.Format( --@formatter:off
            "{\n"                                              ..
            "  Name                               = %q,\n"     ..
            "  Quality                            = %q,\n"     ..
            "  GamblingId                         = %s,\n"     ..

            "  IsNeedable                         = %s,\n"     ..
            "  IsGreedable                        = %s,\n"     ..
            "  IsBindOnPickUp                     = %s,\n"     ..
            "  IsDisenchantable                   = %s,\n"     ..
            "  IsTransmogrifiable                 = %s,\n"     ..

            "  Count                              = %s,\n"     ..
            "  Texture                            = %q,\n"     ..
            "  EnchantingLevelRequiredToDEItem    = %s,\n"     ..

            "  NeedIneligibilityReasonType       = %s,\n"     ..
            "  GreedIneligibilityReasonType      = %s,\n"     ..
            "  DisenchantIneligibilityReasonType = %s\n"      ..
            "}\n",
            self:GetName(),
            self:GetItemQuality(),
            self:GetGamblingRequestId(),

            self:IsNeedable(),
            self:IsGreedable(),
            self:IsBindOnPickUp(),
            self:IsDisenchantable(),
            self:IsTransmogrifiable(),

            self:GetCount(),
            self:GetTextureFilepath(),
            self:GetEnchantingLevelRequiredToDEItem(),

            self:GetNeedIneligibilityReasonType(),
            self:GetGreedIneligibilityReasonType(),
            self:GetDisenchantIneligibilityReasonType()            
    ) --@formatter:on
end
