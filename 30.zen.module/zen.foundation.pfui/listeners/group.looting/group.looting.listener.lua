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

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local Event = _importer("System.Event")
local LRUCache = _importer("Pavilion.DataStructures.LRUCache")
local TablesHelper = _importer("System.Helpers.Tables")

local PfuiRoll = _importer("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Roll")
local PendingLootItemGamblingDetectedEventArgs = _importer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.PendingLootItemGamblingDetectedEventArgs")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.Listener")

function Class:New()
    Scopify(EScopes.Function, self)

    return self:Instantiate({
        _active = false,
        _hookApplied = false,
        _rollIdsEncounteredCache = LRUCache:New {
            MaxSize = 10,
            TrimRatio = 0.25,
            MaxLifespanPerEntryInSeconds = 5 * 60,
        },

        _eventPendingLootItemGamblingDetected = Event:New(),
    })
end

function Class:StartListening()
    Scopify(EScopes.Function, self)

    if _active then
        return self
    end

    self:ApplyHookOnce_()
        :EvaluatePossibleItemRollFramesThatMayCurrentlyBeDisplayed_()

    _active = true

    return self
end

function Class:StopListening()
    Scopify(EScopes.Function, self)

    _active = false

    return self
end

function Class:EventPendingLootItemGamblingDetected_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventPendingLootItemGamblingDetected:Subscribe(handler, owner)

    return self
end

function Class:EventPendingLootItemGamblingDetected_Unsubscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventPendingLootItemGamblingDetected:Unsubscribe(handler, owner)

    return self
end

-- private space
function Class:EvaluatePossibleItemRollFramesThatMayCurrentlyBeDisplayed_()
    Scopify(EScopes.Function, self)

    for rollFrameIndex in TablesHelper.GetKeyValuePairs(PfuiRoll.frames) do
        self:EvaluateItemRollFrameAndReportIfNew_(PfuiRoll, rollFrameIndex)
    end

    return self
end

function Class:ApplyHookOnce_()
    Scopify(EScopes.Function, self)

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
    Scopify(EScopes.Function, self)

    if not _active then
        return
    end

    local pfuiGambledItemFrame = pfuiRoll.frames
            and pfuiRoll.frames[gambledItemFrameIndex]
            or nil

    if not self:IsBrandNewItemGamblingUIFrame_(pfuiGambledItemFrame) then
        return
    end

    _eventPendingLootItemGamblingDetected:Raise(self, PendingLootItemGamblingDetectedEventArgs:New(pfuiGambledItemFrame.rollID))
end

function Class:IsBrandNewItemGamblingUIFrame_(pfuiItemFrame)
    Scopify(EScopes.Function, self)

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

Class.I = Class:New() -- todo   remove this once di comes to town
