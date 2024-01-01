local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) --@formatter:off

local Guard        = using "System.Guard"
local Scopify      = using "System.Scopify"
local EScopes      = using "System.EScopes"
local Console      = using "System.Console"
local TablesHelper = using "System.Helpers.Tables"

local LRUCache     = using "Pavilion.DataStructures.LRUCache"

local GroupLootingHelper       = using "Pavilion.Warcraft.Addons.Zen.Foundation.Helpers.GroupLooting.Helper"
local ModifierKeysListener     = using "Pavilion.Warcraft.Addons.Zen.Foundation.Listeners.ModifiersKeystrokes.ModifierKeysListener"
local PfuiGroupLootingListener = using "Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.Listener"

local EWowGamblingResponseType                    = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowGamblingResponseType"
local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind" --@formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesGrouplootingAssistant.Aggregate"

Scopify(EScopes.Function, {})

function Class:New(groupLootingListener, modifierKeysListener, groupLootingHelper)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceOf(groupLootingHelper, GroupLootingHelper, "groupLootingHelper")
    Guard.Assert.IsNilOrInstanceOf(modifierKeysListener, ModifierKeysListener, "modifierKeysListener")
    Guard.Assert.IsNilOrInstanceOf(groupLootingListener, PfuiGroupLootingListener, "groupLootingListener")

    return self:Instantiate({
        _settings = nil,

        _isRunning = false,
        _pendingLootGamblingRequests = LRUCache:New {
            MaxSize = 20,
            MaxLifespanPerEntryInSeconds = 1 + 5 * 60,
        },

        _groupLootingHelper = groupLootingHelper or GroupLootingHelper:New(), --todo   refactor this later on so that this gets injected through DI
        _modifierKeysListener = modifierKeysListener or ModifierKeysListener:New():ChainSetPollingInterval(0.1), --todo   refactor this later on so that this gets injected through DI
        _groupLootingListener = groupLootingListener or PfuiGroupLootingListener:New(), --todo   refactor this later on so that this gets injected through DI
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

    Console.Out:WriteFormatted("** GLL.PLIGD010 ea:GetGamblingId()=%s desiredLootGamblingBehaviour=%s", ea:GetGamblingId(), _settings:GetMode())

    local desiredLootGamblingBehaviour = _settings:GetMode()
    if desiredLootGamblingBehaviour == nil or desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.LetUserChoose then
        Console.Out:WriteFormatted("** GLL.PLIGD020")
        return -- let the user choose
    end

    local gambledItemInfo = _groupLootingHelper:GetGambledItemInfo(ea:GetGamblingId()) -- rollid essentially
    Console.Out:WriteFormatted("** GLL.PLIGD030 rolledItemInfo: %s", gambledItemInfo)
    if not gambledItemInfo:IsGreenQuality() then
        Console.Out:WriteFormatted("** GLL.PLIGD040 it's not green ...")
        return
    end

    Console.Out:WriteFormatted("** GLL.PLIGD050")
    if desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.RollNeed and not gambledItemInfo:IsNeedable() then
        Console.Out:WriteFormatted("** GLL.PLIGD060 it's not needable ...")
        return
    end

    Console.Out:WriteFormatted("** GLL.PLIGD070")
    --if desiredLootGamblingBehaviour == SGreeniesGrouplootingAutomationMode.RollGreed and not gambledItemInfo:IsGreedable() then
    --    Console.Out:WriteFormatted("** GLL.PLIGD080 it's not greedable ...")
    --    return
    --end

    Console.Out:WriteFormatted("** GLL.PLIGD090")
    if _settings:GetActOnKeybind() == SGreeniesGrouplootingAutomationActOnKeybind.Automatic then
        Console.Out:WriteFormatted("** GLL.PLIGD100 submitting response ...")
        _groupLootingHelper:SubmitResponseToItemGamblingRequest(
                ea:GetGamblingId(),
                self:TranslateModeSettingToWoWNativeGamblingResponseType_(desiredLootGamblingBehaviour)
        )
        return
    end

    Console.Out:WriteFormatted("** GLL.PLIGD110 waiting for keybind press ...")
    _pendingLootGamblingRequests:Upsert(ea:GetGamblingId()) --                                                                  order
    _modifierKeysListener:EventModifierKeysStatesChanged_Subscribe(ModifierKeysListener_ModifierKeysStatesChanged_, self) --    order
    _modifierKeysListener:Start()

    -- todo   add take into account CANCEL_LOOT_ROLL event at some point
    --
    -- todo   ensure that pfUI reacts accordingly to this by hiding the green item roll frame
    --
    -- todo   consolidate this into a console write or something
    --
    -- local _, _, _, _greeniesQualityHex = _getItemQualityColor(QUALITY_GREEN)
    -- DEFAULT_CHAT_FRAME:AddMessage("[pfUI.Zen] " .. _greeniesQualityHex .. wowRollMode .. "|cffffffff Roll " .. _getLootRollItemLink(frame.rollID))
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
            _groupLootingHelper:SubmitResponseToItemGamblingRequest(gamblingId, wowNativeGamblingResponseType)
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
