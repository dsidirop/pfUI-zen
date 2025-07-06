local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local T = using "System.Helpers.Tables" -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Event    = using "System.Event"
local Fields   = using "System.Classes.Fields"

local LRUCache = using "Pavilion.DataStructures.LRUCache"

local PfuiRoll                                 = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Roll"
local PendingLootItemGamblingDetectedEventArgs = using "Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.EventArgs.PendingLootItemGamblingDetectedEventArgs" --@formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Pfui.Listeners.GroupLooting.Listener"

Scopify(EScopes.Function, {})

Fields(function(upcomingInstance)
    upcomingInstance._active = false
    upcomingInstance._hookApplied = false

    upcomingInstance._rollIdsEncounteredCache = nil
    upcomingInstance._eventPendingLootItemGamblingDetected = nil

    return upcomingInstance
end)

function Class:New()
    Scopify(EScopes.Function, self)
    
    local instance = self:Instantiate()

    instance._active = false
    instance._hookApplied = false
    instance._rollIdsEncounteredCache = LRUCache:New {
        MaxSize                      = 10,
        TrimRatio                    = 0.25,
        MaxLifespanPerEntryInSeconds = 5 * 60,
    }
    instance._eventPendingLootItemGamblingDetected = Event:New()

    return instance
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

    for rollFrameIndex in T.GetPairs(PfuiRoll.frames) do
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
