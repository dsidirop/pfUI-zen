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
local NewItemGamblingRoundStartedEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.NewItemGamblingRoundStartedEventArgs")

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

        _eventNewItemGamblingRoundStarted = Event:New(),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:StartListening()
    _setfenv(1, self)
    
    _active = true
    if _hookApplied then
        return
    end

    local updateLootRollSnapshot = PfuiRoll.UpdateLootRoll
    PfuiRoll.UpdateLootRoll = function(pfuiRoll, gambledItemFrameIndex) -- todo   create a general purpose hooking function that can be used for all hooks
        updateLootRollSnapshot(pfuiRoll, gambledItemFrameIndex)

        _OnLootRollFrameUpdated(pfuiRoll, gambledItemFrameIndex)
    end

    _hookApplied = true
end

function Class:_OnLootRollFrameUpdated(pfuiRoll, gambledItemFrameIndex)
    if not _active then
        return
    end

    local pfuiGambledItemFrame = pfuiRoll.frames
            and pfuiRoll.frames[gambledItemFrameIndex]
            or nil

    if not _IsBrandNewItemGamblingUIFrame(pfuiGambledItemFrame) then
        return
    end

    _eventNewItemGamblingRoundStarted:Raise(NewItemGamblingRoundStartedEventArgs:New(pfuiGambledItemFrame.rollID))
end

function Class:_IsBrandNewItemGamblingUIFrame(pfuiItemFrame)
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

function Class:StopListening()
    _setfenv(1, self)

    _active = false
end

function Class:EventNewItemGamblingRoundStarted_Subscribe(handler, owner)
    _setfenv(1, self)

    _eventNewItemGamblingRoundStarted:Subscribe(handler, owner)
end

function Class:EventNewItemGamblingRoundStarted_Unsubscribe(handler, owner)
    _setfenv(1, self)

    _eventNewItemGamblingRoundStarted:Unsubscribe(handler, owner)
end
