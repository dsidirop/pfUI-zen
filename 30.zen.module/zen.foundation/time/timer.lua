local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Guard   = using "System.Guard"
local Global  = using "System.Global"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Event          = using("System.Event")
local WoWCreateFrame = using("Pavilion.Warcraft.Addons.Zen.Externals.WoW.CreateFrame")

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.Time.Timer" -- @formatter:on

Scopify(EScopes.Function, {})

function Class:New(interval)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveNumber(interval, "interval")

    local element = WoWCreateFrame("Frame") -- 00
    element:Hide() -- 10

    return self:Instantiate({
        _global = Global, -- 20

        _interval = interval,
        _wantedActive = false,

        _element = element,
        _eventElapsed = Event:New(),
        _elapsedTimeSinceLastFiring = 0,
    })

    -- 00  dont even bother using strenums here
    -- 10  we need to hide the frame because its important to ensure that the timer is not running when we create it
    -- 20  this is vital in order for us to have access to _global.arg1 inside the onupdate handler
end

function Class:GetInterval()
    Scopify(EScopes.Function, self)

    return _interval
end

function Class:ChainSetInterval(newInterval)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsPositiveNumber(newInterval, "newInterval")

    _interval = newInterval

    return self
end

function Class:IsRunning()
    Scopify(EScopes.Function, self)

    return _element:IsVisible()
end

function Class:Start()
    Scopify(EScopes.Function, self)

    _wantedActive = true
    self:OnSettingsChanged_()

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    _wantedActive = false
    self:OnSettingsChanged_()

    return self
end

function Class:EventElapsed_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventElapsed:Subscribe(handler, owner) --   order
    self:OnSettingsChanged_() --                 order

    return self
end

function Class:EventElapsed_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventElapsed:Unsubscribe(handler)  --   order
    self:OnSettingsChanged_() --             order

    return self
end

-- private space

function Class:OnSettingsChanged_()
    Scopify(EScopes.Function, self)

    if _wantedActive and _eventElapsed:HasSubscribers() then
        self:StartImpl_()
        return self
    end

    do
        -- wantedActive==false  or  wantedActive==true but noone is listening   so we need to halt the timer
        self:StopImpl_()
    end

    return self
end

function Class:StartImpl_()
    Scopify(EScopes.Function, self)

    self:EnsureInitializedOnlyOnce_()

    _element:Show()

    return self
end

function Class:StopImpl_()
    Scopify(EScopes.Function, self)

    _element:Hide()
    _elapsedTimeSinceLastFiring = 0

    return self
end

function Class:EnsureInitializedOnlyOnce_()
    Scopify(EScopes.Function, self)

    if _element:GetScript("OnUpdate") then
        return
    end

    _element:SetScript("OnUpdate", function()
        _elapsedTimeSinceLastFiring = _elapsedTimeSinceLastFiring + _global.arg1 -- 00
        if _elapsedTimeSinceLastFiring < _interval then
            return
        end

        -- _elapsedTimeSinceLastFiring >= _interval   its important to trim down the excess
        -- time as much as it is necessary to ensure it goes beneath the interval threshold
        repeat
            _elapsedTimeSinceLastFiring = _elapsedTimeSinceLastFiring - _interval
        until _elapsedTimeSinceLastFiring < _interval

        _eventElapsed:Raise(self, {})
        if not _eventElapsed:HasSubscribers() then
            self:OnSettingsChanged_()
        end
    end)

    -- 00  arg1 is the elapsed time since the previous callback invocation   there is no other way to get this value
    --     other than grabbing it from the global environment like we do here   very strange but true
end
