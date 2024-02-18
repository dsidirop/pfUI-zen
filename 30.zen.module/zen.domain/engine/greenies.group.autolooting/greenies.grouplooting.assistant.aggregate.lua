local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local B = using "[built-ins]" [[
    GetNumRaidMembers = GetNumRaidMembers,
    GetNumPartyMembers = GetNumPartyMembers,

    LootSlot = LootSlot,
    StaticPopup1Button1 = StaticPopup1Button1,
]]

local Try          = using "System.Try"
local Guard        = using "System.Guard"
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"

local LRUCache     = using "Pavilion.DataStructures.LRUCache"

local GroupLootGamblingService = using "Pavilion.Warcraft.GroupLooting.GroupLootGamblingService"

local ModifierKeysListener          = using "Pavilion.Warcraft.Addons.Zen.Foundation.Listeners.ModifiersKeystrokes.ModifierKeysListener"
local PfuiGroupLootingListener      = using "Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.Listener"
local LootBindConfirmPopupsListener = using "Pavilion.Warcraft.Addons.Zen.Foundation.UI.Listeners.LootBindConfirmPopups.LootBindConfirmPopupsListener"

local EWowGamblingResponseType                    = using "Pavilion.Warcraft.Enums.EWowGamblingResponseType"
local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local AssistantAggregateSettings = using "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGroupAutolooting.AssistantAggregateSettings"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGroupAutolooting.AssistantAggregate"

Scopify(EScopes.Function, {})

function Class:New(groupLootingListener, modifierKeysListener, groupLootGamblingService, lootBindConfirmPopupsListener)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceOf(modifierKeysListener,          ModifierKeysListener,          "modifierKeysListener")
    Guard.Assert.IsNilOrInstanceOf(groupLootingListener,          PfuiGroupLootingListener,      "groupLootingListener")
    Guard.Assert.IsNilOrInstanceOf(groupLootGamblingService,      GroupLootGamblingService,      "groupLootGamblingService")
    Guard.Assert.IsNilOrInstanceOf(lootBindConfirmPopupsListener, LootBindConfirmPopupsListener, "lootBindConfirmPopupsListener")

    return self:Instantiate({
        _settings = nil,

        _isRunning = false,
        _pendingLootGamblingRequests = LRUCache:New {
            MaxSize = 20,
            MaxLifespanPerEntryInSeconds = 1 + 5 * 60,
        },

        _modifierKeysListener           = modifierKeysListener          or ModifierKeysListener:New():ChainSetPollingInterval(0.1), --todo   refactor this later on so that this gets injected through DI
        _groupLootingListener           = groupLootingListener          or PfuiGroupLootingListener:New(),
        _lootBindConfirmPopupsListener  = lootBindConfirmPopupsListener or LootBindConfirmPopupsListener:New(),

        _groupLootGamblingService       = groupLootGamblingService      or GroupLootGamblingService:New(),
    })
end --@formatter:on

function Class:IsRunning()
    Scopify(EScopes.Function, self)

    return _isRunning
end

function Class:SetSettings(settings)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(settings, AssistantAggregateSettings, "settings")

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

    if _settings:GetMode() == SGreeniesGrouplootingAutomationMode.LetUserChoose then
        return self -- nothing to do
    end

    _groupLootingListener:StartListening()
                         :EventPendingLootItemGamblingDetected_Subscribe(GroupLootingListener_PendingLootItemGamblingDetected_, self)

    -- _modifierKeysListener:Start() -- dont start the keybind listener here 

    _isRunning = true

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    if not _isRunning then
        return self -- nothing to do
    end

    _groupLootingListener:StopListening():EventPendingLootItemGamblingDetected_Unsubscribe(GroupLootingListener_PendingLootItemGamblingDetected_)

    _modifierKeysListener:EventModifierKeysStatesChanged_Unsubscribe(ModifierKeysListener_ModifierKeysStatesChanged_)

    _isRunning = false

    return self
end

function Class:SwitchMode(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationMode, value, "value")

    if _settings:GetMode() == value then
        return self -- nothing to do
    end

    _settings:ChainSetMode(value) --00 slight hack

    if value == SGreeniesGrouplootingAutomationMode.LetUserChoose then
        self:Stop() -- special case
        return self
    end

    self:Start()

    return self

    --00 this is a bit of a hack   normally we should deep clone the settings and then change the mode
    --   on the clone and perform validation there   but for such a simple case it would be an overkill
end

function Class:SwitchActOnKeybind(value)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationActOnKeybind, value, "value")

    if _settings:GetActOnKeybind() == value then
        return self -- nothing to do
    end

    _settings:ChainSetActOnKeybind(value) --00 slight hack

    -- _keybindIntercept:Start() --10 dont

    return self

    -- 00  this is a bit of a hack   normally we should deep clone the settings and then change the mode
    --     on the clone and perform validation there   but for such a simple case it would be an overkill
    --
    -- 10  the keybind interceptor should never be getting launched here   it should be getting launched on
    --     demand if and only if loot gambling is detected
end

-- private space

function Class:GroupLootingListener_PendingLootItemGamblingDetected_(_, ea)
    Scopify(EScopes.Function, self)

    local gamblingId = ea:GetGamblingId()
    local desiredLootGamblingBehaviour = _settings:GetMode()
    if not self:IsEligibleForAutoGamble(gamblingId, desiredLootGamblingBehaviour) then
        return
    end

    _pendingLootGamblingRequests:Upsert(gamblingId) -- order
    if _settings:GetActOnKeybind() == SGreeniesGrouplootingAutomationActOnKeybind.Automatic then
        -- order
        self:SubmitSameResponseToAllItemGamblingRequests_(_pendingLootGamblingRequests:PopKeysArray(), desiredLootGamblingBehaviour)
        return
    end

    _modifierKeysListener:EventModifierKeysStatesChanged_Subscribe(ModifierKeysListener_ModifierKeysStatesChanged_, self)
    _modifierKeysListener:Start()

    -- todo   add take into account CANCEL_LOOT_ROLL event at some point
end

function Class:IsEligibleForAutoGamble(gamblingId, desiredLootGamblingBehaviour)
    Scopify(EScopes.Function, self)

    if desiredLootGamblingBehaviour == nil or desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.LetUserChoose then
        return false -- let the user choose
    end

    local gambledItemInfo = _groupLootGamblingService:GetGambledItemInfo(gamblingId) -- rollid essentially

    -- Console.Out:WriteFormatted("[GLL.PLIGD010] ea:GetGamblingId()=%s desiredLootGamblingBehaviour=%s rolledItemInfo: %s", ea:GetGamblingId(), _settings:GetMode(), gambledItemInfo)
    if not gambledItemInfo:IsGreenQuality() then
        return false
    end

    if desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.RollNeed and not gambledItemInfo:IsNeedable() then
        return false
    end

    if desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.RollGreed and not gambledItemInfo:IsGreedable() then
        -- Console.Out:WriteFormatted("[GLL.PLIGD080] it's not greedable ...")
        return false
    end

    return true
end

function Class:ModifierKeysListener_ModifierKeysStatesChanged_(_, ea)
    Scopify(EScopes.Function, self)

    local desiredLootGamblingBehaviour = _settings:GetMode() --00  
    if desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.LetUserChoose then
        _pendingLootGamblingRequests:Clear()
        _modifierKeysListener:EventModifierKeysStatesChanged_Unsubscribe(ModifierKeysListener_ModifierKeysStatesChanged_)
        return
    end

    local actOnKeybindSetting = _settings:GetActOnKeybind()
    if     actOnKeybindSetting == SGreeniesGrouplootingAutomationActOnKeybind.Automatic       --@formatter:off
        or actOnKeybindSetting == ea:ToString() then
        --@formatter:on

        _modifierKeysListener:EventModifierKeysStatesChanged_Unsubscribe(ModifierKeysListener_ModifierKeysStatesChanged_) -- vital

        self:SubmitSameResponseToAllItemGamblingRequests_(_pendingLootGamblingRequests:PopKeysArray(), desiredLootGamblingBehaviour)
    end

    --00  we need to always keep in mind that the user might change the settings while item-gambling is in progress
end

function Class:TranslateModeSettingToWoWNativeGamblingResponseType_(greeniesAutogamblingMode)
    Scopify(EScopes.Function, self)

    if greeniesAutogamblingMode == SGreeniesGrouplootingAutomationMode.JustPass then
        return EWowGamblingResponseType.Pass
    end

    if greeniesAutogamblingMode == SGreeniesGrouplootingAutomationMode.RollNeed then
        return EWowGamblingResponseType.Need
    end

    if greeniesAutogamblingMode == SGreeniesGrouplootingAutomationMode.RollGreed then
        return EWowGamblingResponseType.Greed
    end

    return nil -- SGreeniesGrouplootingAutomationMode.LetUserChoose
end

function Class:SubmitSameResponseToAllItemGamblingRequests_(gamblingIds, desiredLootGamblingBehaviour)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsArray(gamblingIds, "gamblingIds")
    Guard.Assert.IsEnumValue(SGreeniesGrouplootingAutomationMode, desiredLootGamblingBehaviour, "desiredLootGamblingBehaviour")

    Try(function() -- @formatter:off
        _lootBindConfirmPopupsListener:EventLootBindConfirmPoppedUp_Subscribe(LootBindConfirmPoppedUp_LootBindConfirmPoppedUp_, self)

        _groupLootGamblingService:SubmitSameResponseToAllItemGamblingRequests(
            gamblingIds,
            self:TranslateModeSettingToWoWNativeGamblingResponseType_(desiredLootGamblingBehaviour)
        )
    end)
    :Finally(function()
        _lootBindConfirmPopupsListener:EventLootBindConfirmPoppedUp_Unsubscribe(LootBindConfirmPoppedUp_LootBindConfirmPoppedUp_)
    end)
    :Run() -- @formatter:on
end

function Class:LootBindConfirmPoppedUp_LootBindConfirmPoppedUp_(_, ea)
    Scopify(EScopes.Function, self)

    local isSolo = B.GetNumPartyMembers() == 0 and B.GetNumRaidMembers() == 0
    if isSolo then
        return -- this scenario is handled by pfui itself so no need for us to do anything
    end

    B.LootSlot(ea:GetLootSlotIndex())
    B.StaticPopup1Button1:Click()
end
