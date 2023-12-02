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

local Event = _importer("System.Event")
local LRUCache = _importer("Pavilion.DataStructures.LRUCache")
local PfuiRoll = _importer("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Roll")
local PendingLootItemGamblingDetectedEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.PendingLootItemGamblingDetectedEventArgs")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.Listener")

function Class:New()
    _setfenv(1, self)

    local instance = {
        _active = false,
        _hookApplied = false,
        _rollIdsEncounteredCache = LRUCache:New {
            maxSize = 10,
            trimRatio = 0.25,
            maxLifespanPerEntryInSeconds = 5 * 60,
        },

        _eventPendingLootItemGamblingDetected = Event:New(),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:StartListening()
    _setfenv(1, self)

    if _active then
        return self
    end

    self:ApplyHookOnce_()
        :EvaluatePossibleItemRollFramesThatAreCurrentlyDisplayed_()

    _active = true

    return self
end

function Class:StopListening()
    _setfenv(1, self)

    _active = false

    return self
end

function Class:EventPendingLootItemGamblingDetected_Subscribe(handler, owner)
    _setfenv(1, self)

    _eventPendingLootItemGamblingDetected:Subscribe(handler, owner)

    return self
end

function Class:EventPendingLootItemGamblingDetected_Unsubscribe(handler, owner)
    _setfenv(1, self)

    _eventPendingLootItemGamblingDetected:Unsubscribe(handler, owner)

    return self
end

-- private space
function Class:EvaluatePossibleItemRollFramesThatAreCurrentlyDisplayed_()
    _setfenv(1, self)

    for rollFrameIndex in _pairs(PfuiRoll.frames) do
        self:EvaluateItemRollFrameAndReportIfNew_(PfuiRoll, rollFrameIndex)
    end

    return self
end

function Class:ApplyHookOnce_()
    _setfenv(1, self)

    if _hookApplied then
        return self
    end

    local selfSnapshot = self
    local updateLootRollSnapshot = PfuiRoll.UpdateLootRoll
    PfuiRoll.UpdateLootRoll = function(pfuiRoll, gambledItemFrameIndex)
        -- todo   create a general purpose hooking function that can be used for all hooks
        updateLootRollSnapshot(pfuiRoll, gambledItemFrameIndex)

        selfSnapshot:EvaluateItemRollFrameAndReportIfNew_(pfuiRoll, gambledItemFrameIndex)
    end

    _hookApplied = true

    return self
end

function Class:EvaluateItemRollFrameAndReportIfNew_(pfuiRoll, gambledItemFrameIndex)
    _setfenv(1, self)

    if not _active then
        return
    end

    local pfuiGambledItemFrame = pfuiRoll.frames
            and pfuiRoll.frames[gambledItemFrameIndex]
            or nil

    if not self:IsBrandNewItemGamblingUIFrame_(pfuiGambledItemFrame) then
        return
    end

    _eventPendingLootItemGamblingDetected:Raise(PendingLootItemGamblingDetectedEventArgs:New(pfuiGambledItemFrame.rollID))
end

function Class:IsBrandNewItemGamblingUIFrame_(pfuiItemFrame)
    _setfenv(1, self)

    -- @formatter:off
    if    pfuiItemFrame == nil
       or pfuiItemFrame.rollID == nil
       or _rollIdsEncounteredCache:Get(pfuiItemFrame.rollID) ~= nil -- already seen
       or not pfuiItemFrame:IsShown()
       or not pfuiItemFrame:IsVisible() then
        return false
    end -- @formatter:on

    _rollIdsEncounteredCache:Upsert(pfuiItemFrame.rollID)

    return true
end
