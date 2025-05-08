local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Event   = using "System.Event"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local ManagedElementsBuilder           = using "Pavilion.Warcraft.Addons.Zen.Foundation.UI.ManagedElements.Builder"
local LootBindConfirmPoppedUpEventArgs = using "Pavilion.Warcraft.Addons.Zen.Foundation.Listeners.LootBindConfirmPopups.EventArgs.LootBindConfirmPoppedUpEventArgs"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Foundation.UI.Listeners.LootBindConfirmPopups.LootBindConfirmPopupsListener" -- @formatter:on

Scopify(EScopes.Function, {})
    
function Class:New()
    Scopify(EScopes.Function, self)

    local lootBindConfirmManagedFrame = ManagedElementsBuilder
            :New()
            :WithType("Frame")
            :WithName("Pavilion_LootBindConfirmListenerFrame")
            :WithStrata("DIALOG")
            :WithUseWowUIRootFrameAsParent(true)
            :Build()

    lootBindConfirmManagedFrame:Hide()

    return self:Instantiate({
        _lootBindConfirmManagedFrame = lootBindConfirmManagedFrame,

        _eventLootBindConfirmPoppedUp = Event:New(),
    })
end

function Class:Start()
    Scopify(EScopes.Function, self)

    _wantedActive = true

    return self
end

function Class:Stop()
    Scopify(EScopes.Function, self)

    _wantedActive = false

    return self
end

function Class:EventLootBindConfirmPoppedUp_SubscribeOnce(handler, owner)
    Scopify(EScopes.Function, self)

    _eventLootBindConfirmPoppedUp:SubscribeOnce(handler, owner) -- order
    self:OnSettingsChanged_() --                                   order

    return self
end

function Class:EventLootBindConfirmPoppedUp_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventLootBindConfirmPoppedUp:Subscribe(handler, owner) -- order
    self:OnSettingsChanged_() --                               order

    return self
end

function Class:EventLootBindConfirmPoppedUp_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventLootBindConfirmPoppedUp:Unsubscribe(handler) -- order
    self:OnSettingsChanged_() --                          order

    return self
end

Class.I = Class:New() -- singleton   todo  remove this once di becomes available


-- private space

function Class:OnSettingsChanged_()
    Scopify(EScopes.Function, self)

    if _wantedActive and _eventLootBindConfirmPoppedUp:HasSubscribers() then
        _lootBindConfirmManagedFrame:EventOnEvent_Subscribe(OnEvent_, self)
        return
    end

    do
        _lootBindConfirmManagedFrame:EventOnEvent_Unsubscribe(OnEvent_)
    end

    return self
end

function Class:OnEvent_(_, ea)
    Scopify(EScopes.Function, self)

    if ea:GetEvent() ~= "LOOT_BIND_CONFIRM" then
        return
    end

    _eventLootBindConfirmPoppedUp:Fire(LootBindConfirmPoppedUpEventArgs:New(ea:GetArg1()))
end
