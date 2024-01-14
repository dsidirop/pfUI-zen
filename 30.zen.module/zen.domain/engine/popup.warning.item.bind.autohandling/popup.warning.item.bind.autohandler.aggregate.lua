local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Guard                        = using "System.Guard"
local Scopify                      = using "System.Scopify"
local EScopes                      = using "System.EScopes"

local PopupsHandlingService        = using "Pavilion.Warcraft.Popups.PopupsHandlingService"
local ConfirmationPopupsListener   = using "Pavilion.Warcraft.Popups.ConfirmationPopupsListener"

local SAutohandlingMode            = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SLootConfirmationPopupsAutohandlingMode"
local AutohandlerAggregateSettings = using "Pavilion.Warcraft.Addons.Zen.Domain.Engine.PopupWarningItemBindAutohandling.AutohandlerAggregateSettings"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGroupAutolooting.AssistantAggregate"

Scopify(EScopes.Function, {})

function Class:New(confirmationPopupsListener, popupsHandlingService)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceOf(popupsHandlingService,      PopupsHandlingService,      "popupsHandlingService")
    Guard.Assert.IsNilOrInstanceOf(confirmationPopupsListener, ConfirmationPopupsListener, "confirmationPopupsListener")

    return self:Instantiate({
        _settings = nil,
        _isRunning = false,

        _popupsHandlingService      = popupsHandlingService      or PopupsHandlingService:New(), --       todo   refactor this later on so that this gets injected through DI
        _confirmationPopupsListener = confirmationPopupsListener or ConfirmationPopupsListener:New(), --  todo   refactor this later on so that this gets injected through DI
    })
end -- @formatter:on

function Class:IsRunning()
    Scopify(EScopes.Function, self)

    return _isRunning
end

function Class:SetSettings(settings)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(settings, AutohandlerAggregateSettings, "settings")

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

    if _isRunning or _settings:GetMode() == SAutohandlingMode.LetUserChoose then
        return self -- nothing to do
    end

    _confirmationPopupsListener
            :StartListening()
            :EventNeedRollConfirmationRequested_Subscribe(ConfirmationPopupListener_NeedRollConfirmationRequested_, self)

    _isRunning = true

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    if not _isRunning then
        return self -- nothing to do
    end

    _confirmationPopupsListener
            :StopListening()
            :EventNeedRollConfirmationRequested_Unsubscribe(ConfirmationPopupListener_NeedRollConfirmationRequested_)

    _isRunning = false

    return self
end

function Class:SwitchMode(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SAutohandlingMode, value, "value")

    if _settings:GetMode() == value then
        return self -- nothing to do
    end

    _settings:ChainSetMode(value) --00 slight hack

    if value == SAutohandlingMode.LetUserChoose then
        self:Stop() -- special case
        return self
    end

    self:Start()

    return self

    -- 00  this is a bit of a hack   normally we should deep clone the settings and then change the mode
    --     on the clone and perform validation there   but for such a simple case it would be an overkill
end


-- private space

function Class:ConfirmationPopupListener_NeedRollConfirmationRequested_(_, ea) -- 00
    self._popupsHandlingService:HandlePopupGamblingIntent(ea:GetGamblingId(), ea:GetIntendedGamblingType())

    -- 00  for needing items   https://wowpedia.fandom.com/wiki/API_ConfirmLootRoll
end

function Class:ConfirmationPopupListener_ItemWillBindToYouConfirmationRequested_(_, ea) -- 00
    self._popupsHandlingService:HandlePopupItemWillBindToYou(ea:GetGamblingId(), ea:GetIntendedGamblingType())
    
    -- 00  for bind-on-pickup items   https://wowpedia.fandom.com/wiki/API_ConfirmLootSlot
end
