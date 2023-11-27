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
local PfuiRoll = _importer("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Roll")
local NewItemGamblingRoundStartedEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.NewItemGamblingRoundStartedEventArgs")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.Listener")

function Class:New()
    _setfenv(1, self)

    local instance = {
        _rollIdsAlreadySeen = {},
        _updateLootRollSnapshot = nil,

        _eventNewItemGamblingRoundStarted = Event:New(),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:StartListening()
    _setfenv(1, self)

    _updateLootRollSnapshot = PfuiRoll.UpdateLootRoll
    PfuiRoll.UpdateLootRoll = function(pfuiRoll, i)
        _updateLootRollSnapshot(pfuiRoll, i)

        local frame = pfuiRoll.frames[i] -- @formatter:off
        if    frame == nil
           or frame.rollID == nil
           or _rollIdsAlreadySeen[frame.rollID] ~= nil -- already seen
           or not frame:IsShown()
           or not frame:IsVisible() then
            return
        end -- @formatter:on

        _rollIdsAlreadySeen[frame.rollID] = true

        _eventNewItemGamblingRoundStarted:Raise(NewItemGamblingRoundStartedEventArgs:New(frame.rollID))
    end
end

function Class:StopListening()
    _setfenv(1, self)

    PfuiRoll.UpdateLootRoll = _updateLootRollSnapshot
end

function Class:EventNewItemGamblingRoundStarted_Subscribe(handler, owner)
    _setfenv(1, self)

    _eventNewItemGamblingRoundStarted:Subscribe(handler, owner)
end

function Class:EventNewItemGamblingRoundStarted_Unsubscribe(handler, owner)
    _setfenv(1, self)

    _eventNewItemGamblingRoundStarted:Unsubscribe(handler, owner)
end
