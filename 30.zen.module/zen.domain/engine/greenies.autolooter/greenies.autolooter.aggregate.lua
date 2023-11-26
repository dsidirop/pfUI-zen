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

local SWowNativeRollMode = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SWowNativeRollMode")
local SGreenItemsAutolootingMode = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingMode")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Domain.Engine.GreeniesAutolooter.Aggregate")

local QUALITY_GREEN = 2

function Class:New(pfuiGroupLootingFramesWatcher)
    _setfenv(1, self)

    local _, _, _, greeniesQualityHex = _getItemQualityColor(QUALITY_GREEN) -- todo  consolidate this in a helper or something
    
    local instance = {
        _state = nil,
        _greeniesQualityHex = greeniesQualityHex,

        _pfuiGroupLootingFramesWatcher = pfuiGroupLootingFramesWatcher or PfuiGroupLootingFramesWatcher:New(),
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
    _pfuiGroupLootingFramesWatcher.EventLootRollFrameUpdated_Subscribe(_PfuiGroupLootingFramesWatcher_EventLootRollFrameUpdated, self);
    
    return self
end

function Class:Shutdown()
    _setfenv(1, self)

    _pfuiGroupLootingFramesWatcher.EventLootRollFrameUpdated_Unsubscribe(_PfuiGroupLootingFramesWatcher_EventLootRollFrameUpdated);
    
    return self
end

function Class:_PfuiGroupLootingFramesWatcher_EventLootRollFrameUpdated(_, ea)
    _setfenv(1, self)

    local wowRollMode = _TranslateModeSettingToWoWNativeRollMode(_stage:GetMode())
    if not wowRollMode then
        return -- let the user choose
    end

    local frame = ea:GetRollFrame() -- _pfUI.roll.frames[i]
    local lootItemInfo = LootItemInfo:New(ea:GetRollId())
    if not lootItemInfo:IsGreenQuality() then
        return
    end

    if _stage:GetActOnKeybind() == SGreenItemsAutolootingActOnKeybind.Automatic then
        _RollOnLootItem(frame.rollID, wowRollMode)
    end

    -- todo   add take into account CANCEL_LOOT_ROLL event at some point
    --
    -- todo  consolidate this into a helper class
    -- local _, _, _, quality = _getLootRollItemInfo(frame.rollID)   
    -- if quality ~= QUALITY_GREEN then
    --     return
    -- end
    --
    -- todo   if not frame or not frame.rollID or not frame:IsShown() or not frame:IsVisible() then  <-- check these before we emit the event
    --
    -- todo   if we actually have a keybind we should put the lootid in an observable sink that merges with the keybinding events
end

function Class:_RollOnLootItem(rollID, wowRollMode)
    _setfenv(1, self)
    
    _assert(SWowNativeRollMode.Validate(wowRollMode))
    
    _rollOnLoot(rollID, wowRollMode) -- todo   ensure that pfUI reacts accordingly to this by hiding the green item roll frame

    -- todo  consolidate this into a console write or something
    -- DEFAULT_CHAT_FRAME:AddMessage("[pfUI.Zen] " .. _greeniesQualityHex .. wowRollMode .. "|cffffffff Roll " .. _getLootRollItemLink(frame.rollID))
end

--local _base_pfuiRoll_UpdateLootRoll = _pfUI.roll.UpdateLootRoll
--function _pfUI.roll:UpdateLootRoll(i)
--    -- override pfUI:UpdateLootRoll()
--    _base_pfuiRoll_UpdateLootRoll(i)
--end

function Class:_TranslateModeSettingToWoWNativeRollMode(greeniesAutogamblingMode)
    _setfenv(1, self)

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.JustPass then
        return SWowNativeRollMode.Pass
    end

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.RollNeed then
        return SWowNativeRollMode.Need
    end

    if greeniesAutogamblingMode == SGreenItemsAutolootingMode.RollGreed then
        return SWowNativeRollMode.Greed
    end

    return nil -- SGreenItemsAutolootingMode.LetUserChoose
end
