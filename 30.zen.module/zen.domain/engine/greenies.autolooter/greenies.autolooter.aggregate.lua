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

local EWowGamblingResponseType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowGamblingResponseType")
local GroupLootingHelper = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Helpers.GroupLootingHelper")
local PfuiGroupLootingListener = _importer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.Listener")
local SGreenItemsAutolootingMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingMode")
local SGreenItemsAutolootingActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesAutolooter.Aggregate")

function Class:New(groupLootingListener, groupLootingHelper)
    _setfenv(1, self)

    local instance = {
        _settings = nil,

        _groupLootingHelper = groupLootingHelper or GroupLootingHelper:New(), --todo   refactor this later on so that this gets injected through DI
        _groupLootingListener = groupLootingListener or PfuiGroupLootingListener:New(), --todo   refactor this later on so that this gets injected through DI
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

-- settings is expected to be AggregateSettings
function Class:SetSettings(settings)
    _setfenv(1, self)

    _settings = settings
end

function Class:Restart()
    _setfenv(1, self)

    Stop()
    Start()
end

function Class:Start()
    _setfenv(1, self)

    _assert(_settings, "attempt to run without any settings being loaded")

    if _settings:GetMode() == SGreenItemsAutolootingMode.LetUserChoose then
        return self -- nothing to do
    end

    -- todo   wire up a keybind interceptor too here
    _groupLootingListener:EventNewItemGamblingRoundStarted_Subscribe(_GroupLootingListener_NewItemGamblingRoundStarted, self);

    return self
end

function Class:Stop()
    _setfenv(1, self)

    -- todo   unwire the keybind interceptor too here
    _groupLootingListener:EventNewItemGamblingRoundStarted_Unsubscribe(_GroupLootingListener_NewItemGamblingRoundStarted);

    return self
end


function Class:SwitchMode(value)
    _setfenv(1, self)
    
    _assert(SGreenItemsAutolootingMode.Validate(value))

    _settings:ChainSetMode(value) --00 slight hack
    
    Restart() --vital
    
    return self
    
    --00 this is a bit of a hack   normally we should deep clone the settings and then change the mode
    --   on the clone and perform validation there   but for such a simple case it would be an overkill
end

function Class:SwitchActOnKeybind(value)
    _setfenv(1, self)

    _assert(SGreenItemsAutolootingActOnKeybind.Validate(value))

    _settings:ChainSetActOnKeybind(value) --00 slight hack
    
    return self

    --00 this is a bit of a hack   normally we should deep clone the settings and then change the mode
    --   on the clone and perform validation there   but for such a simple case it would be an overkill
end


function Class:_GroupLootingListener_NewItemGamblingRoundStarted(_, ea)
    _setfenv(1, self)

    local desiredLootGamblingBehaviour = _settings:GetMode()
    if desiredLootGamblingBehaviour == nil or desiredLootGamblingBehaviour == SGreenItemsAutolootingMode.LetUserChoose then
        return -- let the user choose
    end

    local rolledItemInfo = _groupLootingHelper:GetGambledItemInfo(ea:GetItemGamblingRequestId())
    if not rolledItemInfo:IsGreenQuality() then
        return
    end

    if desiredLootGamblingBehaviour == SGreenItemsAutolootingMode.RollNeed and not rolledItemInfo:IsNeedable() then
        return
    end

    if desiredLootGamblingBehaviour == SGreenItemsAutolootingMode.RollGreed and not rolledItemInfo:IsGreedable() then
        return
    end

    if _stage:GetActOnKeybind() == SGreenItemsAutolootingActOnKeybind.Automatic then
        _groupLootingHelper:SubmitResponseToItemGamblingRequest(ea:GetItemGamblingRequestId(), _TranslateModeSettingToWoWNativeGamblingResponseType(desiredLootGamblingBehaviour))
    end

    -- todo   add take into account CANCEL_LOOT_ROLL event at some point
    --
    -- todo   if we actually have a keybind we should put the lootid in an observable sink that merges with the keybinding events
    --
    -- todo   ensure that pfUI reacts accordingly to this by hiding the green item roll frame
    --
    -- todo   consolidate this into a console write or something
    --
    -- local _, _, _, _greeniesQualityHex = _getItemQualityColor(QUALITY_GREEN)
    -- DEFAULT_CHAT_FRAME:AddMessage("[pfUI.Zen] " .. _greeniesQualityHex .. wowRollMode .. "|cffffffff Roll " .. _getLootRollItemLink(frame.rollID))
end

function Class:_TranslateModeSettingToWoWNativeGamblingResponseType(greeniesAutogamblingMode)
    _setfenv(1, self)

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.JustPass then
        return EWowGamblingResponseType.Pass
    end

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.RollNeed then
        return EWowGamblingResponseType.Need
    end

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.RollGreed then
        return EWowGamblingResponseType.Greed
    end

    return nil -- SGreenItemsAutolootingMode.LetUserChoose
end
