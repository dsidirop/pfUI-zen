--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard"
local Event  = using "System.Event"
local Fields = using "System.Classes.Fields"

local IsAltKeyDown     = using "Pavilion.Warcraft.Foundation.Natives.Input.Keyboard.IsAltKeyDown"
local IsShiftKeyDown   = using "Pavilion.Warcraft.Foundation.Natives.Input.Keyboard.IsShiftKeyDown"
local IsControlKeyDown = using "Pavilion.Warcraft.Foundation.Natives.Input.Keyboard.IsControlKeyDown"

local Timer                                = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Time.Timer"
local ModifierKeysStatusesChangedEventArgs = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Listeners.ModifiersKeystrokes.EventArgs.ModifierKeysStatusesChangedEventArgs"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Listeners.ModifiersKeystrokes.ModifierKeysListener" -- @formatter:on


Fields(function(upcomingInstance)
    upcomingInstance._timer = nil

    upcomingInstance._wantedActive = false
    upcomingInstance._mustEmitOnFreshStart = false

    upcomingInstance._lastEventArgsEmitted = nil
    upcomingInstance._eventModifierKeysStatesChanged = nil

    return upcomingInstance
end)

function Class:New(timer)
    Scopify(EScopes.Function, self)
    
    local instance = self:Instantiate()

    instance._timer = timer or Timer:New(0.1) -- todo di this as a singleton when di comes to town

    instance._wantedActive = false
    instance._mustEmitOnFreshStart = false

    instance._lastEventArgs = nil
    instance._eventModifierKeysStatesChanged = Event:New()

    return instance
end

function Class:SetMustEmitOnFreshStart(mustEmitOnFreshStart)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsBoolean(mustEmitOnFreshStart, "mustEmitOnFreshStart")

    _mustEmitOnFreshStart = mustEmitOnFreshStart

    return self
end

function Class:ChainSetPollingInterval(interval)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsPositiveNumber(interval, "interval")

    _timer:ChainSetInterval(interval)

    return self
end

function Class:Start()
    Scopify(EScopes.Function, self)

    _wantedActive = true --       order
    self:OnSettingsChanged_() --  order

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    _wantedActive = false --       order
    self:OnSettingsChanged_() --   order

    return self
end

function Class:EventModifierKeysStatesChanged_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventModifierKeysStatesChanged:Subscribe(handler, owner) --  order
    self:OnSettingsChanged_() --                                  order

    return self
end

function Class:EventModifierKeysStatesChanged_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventModifierKeysStatesChanged:Unsubscribe(handler) --     order
    self:OnSettingsChanged_() --                                order

    return self
end

Class.I = Class:New() -- singleton   todo  remove this once di becomes available


-- private space

Class.ModifierKeysStatusesChangedEventArgsCache_ = (function() --@formatter:off
    local function add(cache_, alt_, shift_, control_)
        cache_[alt_]                   = cache_[alt_]                   or {}
        cache_[alt_][shift_]           = cache_[alt_][shift_]           or {}
        cache_[alt_][shift_][control_] = cache_[alt_][shift_][control_] or ModifierKeysStatusesChangedEventArgs:New(alt_, shift_, control_)
    end
    
    local cache = {}
    add( cache, false , false , false )
    add( cache, true  , false , false )
    add( cache, false , true  , false )
    add( cache, false , false , true  )
    add( cache, true  , true  , false )
    add( cache, true  , false , true  )
    add( cache, false , true  , true  )
    add( cache, true  , true  , true  )

    return cache --@formatter:on
end)()

Class.EmptyModifierKeysStatusesChangedEventArgs_ = Class.ModifierKeysStatusesChangedEventArgsCache_[false][false][false]

function Class:OnSettingsChanged_()
    Scopify(EScopes.Function, self)

    if _wantedActive and _eventModifierKeysStatesChanged:HasSubscribers() then
        if _timer:IsRunning() then
            return
        end
        
        _timer:EventElapsed_Subscribe(self.Timer_Elapsed_, self)
        _timer:Start()

        if _mustEmitOnFreshStart then
            self:Timer_Elapsed_(nil, nil)
        end
        return
    end

    do
        -- wantedActive==false  or  wantedActive==true but noone is listening   so we need to halt the timer
        _timer:Stop()
        _lastEventArgsEmitted = Class.EmptyModifierKeysStatusesChangedEventArgs_
    end

    return self
end

function Class:Timer_Elapsed_(_, _)
    Scopify(EScopes.Function, self)

    --@formatter:off
    local isAltKeyDown     = IsAltKeyDown()
    local isShiftKeyDown   = IsShiftKeyDown()
    local isControlKeyDown = IsControlKeyDown()

    if     _lastEventArgsEmitted:HasModifierAlt()     == isAltKeyDown
       and _lastEventArgsEmitted:HasModifierShift()   == isShiftKeyDown
       and _lastEventArgsEmitted:HasModifierControl() == isControlKeyDown then
        return
    end

    _lastEventArgsEmitted = Class.ModifierKeysStatusesChangedEventArgsCache_[isAltKeyDown][isShiftKeyDown][isControlKeyDown]
    _eventModifierKeysStatesChanged:Raise(self, _lastEventArgsEmitted)

    if not _eventModifierKeysStatesChanged:HasSubscribers() then
        self:OnSettingsChanged_() --00
    end

    --@formatter:on
    --00  if the event handlers are ephimeral we might end up with no handlers in which case we have to stop the timer for the sake of efficiency 
end
