local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Guard        = using "System.Guard"
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"
local SMode        = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SPopupWarningItemWillBindToYouAutohandlingMode" -- @formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGroupAutolooting.AssistantAggregate"

Scopify(EScopes.Function, {})

function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate({
        _settings = nil,

        _isRunning = false,
    })
end

function Class:IsRunning()
    Scopify(EScopes.Function, self)

    return _isRunning
end

-- settings is expected to be AggregateSettings
function Class:SetSettings(settings)
    Scopify(EScopes.Function, self)

    _settings = settings
end

function Class:Restart()
    Scopify(EScopes.Function, self)

    self:Stop()
    self:Start()
end

function Class:Start()
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNotNil(_settings, "Self.Settings")

    if _isRunning then
        return self -- nothing to do
    end

    if _settings:GetMode() == SMode.LetUserChoose then
        return self -- nothing to do
    end

    _isRunning = true

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    if not _isRunning then
        return self -- nothing to do
    end

    _isRunning = false

    return self
end

function Class:SwitchMode(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SMode, value, "value")

    if _settings:GetMode() == value then
        return self -- nothing to do
    end

    _settings:ChainSetMode(value) --00 slight hack

    if value == SMode.LetUserChoose then
        self:Stop() -- special case
        return self
    end

    self:Start()

    return self

    --00 this is a bit of a hack   normally we should deep clone the settings and then change the mode
    --   on the clone and perform validation there   but for such a simple case it would be an overkill
end

-- private space

-- https://wowpedia.fandom.com/wiki/API_ConfirmLootRoll
function Class:ConfirmationPopupListener_NeedRollConfirmationRequested_(_, ea) -- 00
    Scopify(EScopes.Function, self)

    if _settings:GetMode() == SMode.LetUserChoose then
        return
    end

    _groupLootGamblingService:SubmitGamblingIntentConfirmation(ea:GetGamblingId(), ea:GetIntendedGamblingType())

    -- 00  for needing items
end

-- https://wowpedia.fandom.com/wiki/API_ConfirmLootSlot
function Class:ConfirmationPopupListener_ItemWillBindToYouConfirmationRequested_(_, ea) -- 00
    Scopify(EScopes.Function, self)

    if _settings:GetMode() == SMode.LetUserChoose then
        return
    end

    _groupLootGamblingService:SubmitItemWillBindToYouConfirmation(ea:GetGamblingId(), ea:GetIntendedGamblingType())
    
    -- 00  for bind-on-pickup items
end
