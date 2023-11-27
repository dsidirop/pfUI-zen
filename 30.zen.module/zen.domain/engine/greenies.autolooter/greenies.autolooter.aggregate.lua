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

local GambledItemInfo = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Loot.GambledItemInfo") -- todo   move this into the GroupLootingHelper 

local EWowRollMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowRollMode")
local GroupLootingHelper = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Helpers.GroupLootingHelper")
local PfuiGroupLootingListener = _importer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting")
local SGreenItemsAutolootingMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingMode")
local SGreenItemsAutolootingActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesAutolooter.Aggregate")

function Class:New(groupLootingListener, groupLootingHelper)
    _setfenv(1, self)


    local instance = {
        _state = nil,
        
        _groupLootingHelper = groupLootingHelper or GroupLootingHelper:New(), --todo   refactor this later on so that this gets injected through DI
        _groupLootingListener = groupLootingListener or PfuiGroupLootingListener:New(), --todo   refactor this later on so that this gets injected through DI
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

-- state is expected to be AggregateStateDTO
function Class:SetState(state)
    _setfenv(1, self)

    _state = state
end

function Class:Run()
    _setfenv(1, self)

    _assert(_state, "attempt to run without any state being loaded")

    if _state:GetMode() == SGreenItemsAutolootingMode.LetUserChoose then
        return self -- nothing to do
    end

    -- todo   wire up a keybind interceptor too

    _groupLootingListener.EventNewItemGamblingStarted_Subscribe(_GroupLootingListener_NewItemGamblingStarted, self);

    return self
end

function Class:Shutdown()
    _setfenv(1, self)

    _groupLootingListener.EventNewItemGamblingStarted_Unsubscribe(_GroupLootingListener_NewItemGamblingStarted);

    return self
end

function Class:_GroupLootingListener_NewItemGamblingStarted(_, ea)
    _setfenv(1, self)

    local wowRollMode = _TranslateModeSettingToWoWNativeRollMode(_stage:GetMode())
    if not wowRollMode then
        return -- let the user choose
    end

    local rolledItemInfo = _groupLootingHelper:GetGambledItemInfo(ea:GetRollId())
    if not rolledItemInfo:IsGreenQuality() then
        return
    end

    if wowRollMode == SGreenItemsAutolootingMode.RollNeed and not rolledItemInfo:IsNeedable() then
        return
    end

    if wowRollMode == SGreenItemsAutolootingMode.RollGreed and not rolledItemInfo:IsGreedable() then
        return
    end

    if _stage:GetActOnKeybind() == SGreenItemsAutolootingActOnKeybind.Automatic then
        _groupLootingHelper:RollFor(ea:GetRollId(), wowRollMode)
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

function Class:_TranslateModeSettingToWoWNativeRollMode(greeniesAutogamblingMode)
    _setfenv(1, self)

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.JustPass then
        return EWowRollMode.Pass
    end

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.RollNeed then
        return EWowRollMode.Need
    end

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.RollGreed then
        return EWowRollMode.Greed
    end

    return nil -- SGreenItemsAutolootingMode.LetUserChoose
end
