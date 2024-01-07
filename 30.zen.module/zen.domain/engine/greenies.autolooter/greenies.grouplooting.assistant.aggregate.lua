local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Guard        = using "System.Guard"
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"
local Console      = using "System.Console"
local TablesHelper = using "System.Helpers.Tables"

local LRUCache     = using "Pavilion.DataStructures.LRUCache"

local GroupLootGamblingService = using "Pavilion.Warcraft.GroupLooting.GroupLootGamblingService"

local ModifierKeysListener     = using "Pavilion.Warcraft.Addons.Zen.Foundation.Listeners.ModifiersKeystrokes.ModifierKeysListener"
local PfuiGroupLootingListener = using "Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.Listener"

local EWowGamblingResponseType                    = using "Pavilion.Warcraft.Enums.EWowGamblingResponseType"
local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind" --@formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGrouplootingAssistant.Aggregate"

Scopify(EScopes.Function, {})

function Class:New(groupLootingListener, modifierKeysListener, groupLootGamblingService)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceOf(modifierKeysListener, ModifierKeysListener, "modifierKeysListener")
    Guard.Assert.IsNilOrInstanceOf(groupLootingListener, PfuiGroupLootingListener, "groupLootingListener")
    Guard.Assert.IsNilOrInstanceOf(groupLootGamblingService, GroupLootGamblingService, "groupLootGamblingService")

    return self:Instantiate({
        _settings = nil,

        _isRunning = false,
        _pendingLootGamblingRequests = LRUCache:New {
            MaxSize = 20,
            MaxLifespanPerEntryInSeconds = 1 + 5 * 60,
        },

        _modifierKeysListener = modifierKeysListener or ModifierKeysListener:New():ChainSetPollingInterval(0.1), --todo   refactor this later on so that this gets injected through DI
        _groupLootingListener = groupLootingListener or PfuiGroupLootingListener:New(), --todo   refactor this later on so that this gets injected through DI
        _groupLootGamblingService = groupLootGamblingService or GroupLootGamblingService:New(), --todo   refactor this later on so that this gets injected through DI
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

    --00  this is a bit of a hack   normally we should deep clone the settings and then change the mode
    --    on the clone and perform validation there   but for such a simple case it would be an overkill
    --
    --10  the keybind interceptor should never be getting launched here   it should be getting launched on
    --    demand if and only if loot gambling is detected
end

-- private space

function Class:GroupLootingListener_PendingLootItemGamblingDetected_(_, ea)
    Scopify(EScopes.Function, self)

    local desiredLootGamblingBehaviour = _settings:GetMode()
    if desiredLootGamblingBehaviour == nil or desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.LetUserChoose then
        return -- let the user choose
    end

    local gambledItemInfo = _groupLootGamblingService:GetGambledItemInfo(ea:GetGamblingId()) -- rollid essentially

    Console.Out:WriteFormatted("** GLL.PLIGD010 ea:GetGamblingId()=%s desiredLootGamblingBehaviour=%s rolledItemInfo: %s", ea:GetGamblingId(), _settings:GetMode(), gambledItemInfo)
    if not gambledItemInfo:IsGreenQuality() then
        return
    end

    if desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.RollNeed and not gambledItemInfo:IsNeedable() then
        return
    end

    --if desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.RollGreed and not gambledItemInfo:IsGreedable() then
    --    Console.Out:WriteFormatted("** GLL.PLIGD080 it's not greedable ...")
    --    return
    --end

    if _settings:GetActOnKeybind() == SGreeniesGrouplootingAutomationActOnKeybind.Automatic then
        _groupLootGamblingService:SubmitResponseToItemGamblingRequest(
                ea:GetGamblingId(),
                self:TranslateModeSettingToWoWNativeGamblingResponseType_(desiredLootGamblingBehaviour)
        )
        return
    end

    _pendingLootGamblingRequests:Upsert(ea:GetGamblingId()) --                                                                  order
    _modifierKeysListener:EventModifierKeysStatesChanged_Subscribe(ModifierKeysListener_ModifierKeysStatesChanged_, self) --    order
    _modifierKeysListener:Start()

    -- todo   add take into account CANCEL_LOOT_ROLL event at some point
end

function Class:ModifierKeysListener_ModifierKeysStatesChanged_(_, ea)
    Scopify(EScopes.Function, self)

    local desiredLootGamblingBehaviour = _settings:GetMode() --00  
    if desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.LetUserChoose then
        _pendingLootGamblingRequests:Clear()
        _modifierKeysListener:EventModifierKeysStatesChanged_Unsubscribe(ModifierKeysListener_ModifierKeysStatesChanged_)
        return
    end

    if _settings:GetActOnKeybind() == SGreeniesGrouplootingAutomationActOnKeybind.Automatic or ea:ToString() == _settings:GetActOnKeybind() then
        _modifierKeysListener:EventModifierKeysStatesChanged_Unsubscribe(ModifierKeysListener_ModifierKeysStatesChanged_) -- vital    

        local requests = _pendingLootGamblingRequests:GetKeys() --                                                                         order
        local wowNativeGamblingResponseType = self:TranslateModeSettingToWoWNativeGamblingResponseType_(desiredLootGamblingBehaviour) --   order

        _pendingLootGamblingRequests:Clear() --     order        
        for _, gamblingId in TablesHelper.GetKeyValuePairs(requests) do
            -- order
            _groupLootGamblingService:SubmitResponseToItemGamblingRequest(gamblingId, wowNativeGamblingResponseType)
        end
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
