--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils  = using "System.Nils"
local Guard = using "System.Guard"
local Event = using "System.Event"

local Fields = using "System.Classes.Fields"

local IPfuiMainSettingsFormGuiFactory = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiMainSettingsFormGuiFactory"

local ZenEngineCommandHandlersService = using "Pavilion.Warcraft.Addons.PfuiZen.Mediators.ForZenEngine.ZenEngineMediatorService"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local UserPreferencesDto                                        = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto"

local ITranslatorService                                        = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Internationalization.ITranslatorService"

local RequestingCurrentUserPreferencesEventArgs                 = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.UI.Pfui.Forms.Events.RequestingCurrentUserPreferencesEventArgs"
local GreeniesGrouplootingAutomationApplyNewModeCommand         = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewModeCommand"
local GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewActOnKeybindCommand" -- @formatter:on


local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Controllers.UI.Pfui.Forms.UserPreferencesForm"

Fields(function(upcomingInstance)
    upcomingInstance._t = nil    
    upcomingInstance._pfuiMainSettingsFormGuiFactory = nil -- IPfuiMainSettingsFormGuiFactory
    
    upcomingInstance._ui = {
        -- these are initialized when the :Initialize() is invoked after the constructor
        frmContainer                                   = nil,
        frmAreaContainer                               = nil,
        
        hdrGrouplootSectionHeader                      = nil,
        lddGreeniesGrouplootingAutomation_Mode         = nil,
        lddGreeniesGrouplootingAutomation_ActOnKeybind = nil,
    }

    upcomingInstance._commandsEnabled = false
    upcomingInstance._eventRequestingCurrentUserPreferences = nil

    return upcomingInstance
end)

-- this only gets called once during a user session the very first time that the user explicitly
-- navigates to the "thirdparty" section and clicks on the "zen" tab   otherwise it never gets called
function Class:New(pfuiMainSettingsFormGuiFactory, translationService)
    Scopify(EScopes.Function, self)

    local instance = self:Instantiate() --@formatter:off

    instance._t                                     = Guard.Assert.IsInstanceImplementing(translationService,             ITranslatorService,              "translationService")    
    instance._pfuiMainSettingsFormGuiFactory        = Guard.Assert.IsInstanceImplementing(pfuiMainSettingsFormGuiFactory, IPfuiMainSettingsFormGuiFactory, "pfuiMainSettingsFormGuiFactory")
    instance._eventRequestingCurrentUserPreferences = Event:New()
    
    instance._commandsEnabled = false --00
    
    return instance
    
    --00 instance._ui.xyz = ... <- this stuff get initialized in the :Initialize() method which must be called separately   @formatter:on
end

function Class:EventRequestingCurrentUserPreferences_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventRequestingCurrentUserPreferences:Subscribe(handler, owner)

    return self
end

function Class:EventRequestingCurrentUserPreferences_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventRequestingCurrentUserPreferences:Unsubscribe(handler)

    return self
end

function Class:Initialize()
    Scopify(EScopes.Function, self)

    _ui.frmContainer, _ui.frmAreaContainer = _pfuiMainSettingsFormGuiFactory:SpawnNestedTabFrameWithAreaBuilder() --00
        :ChainSet_RootTabFrameName(_t("Thirdparty")) --           reminder   this is just a shorthand for _t:TryTranslate("Thirdparty")
        :ChainSet_NestedTabFrameName(_t("Zen", "|cFF7FFFD4")) --  reminder   this is just a shorthand for _t:TryTranslate("Zen", "|cFF7FFFD4")
        :ChainSet_AreaPopulatorWhenFirstShownFunc(function()
            self:InitializeControls_() --                         order   from the [partial]
            self:OnRequestingCurrentUserPreferences_() --         order
        end)
        :Build()

    -- 00  this only gets called during a user session the very first time that the user explicitly
    --     navigates to the "thirdparty" section and clicks on the "zen" tab   otherwise it never gets called
end

-- privates
function Class:OnShown_()
    Scopify(EScopes.Function, self)

    self:OnRequestingCurrentUserPreferences_()
end

function Class:OnRequestingCurrentUserPreferences_()
    Scopify(EScopes.Function, self)

    local newUserPreferences = self:OnRequestingCurrentUserPreferencesImpl_()

    return self:ApplyNewUserPreferences_(newUserPreferences)
end

function Class:OnRequestingCurrentUserPreferencesImpl_()
    Scopify(EScopes.Function, self)

    local response = _eventRequestingCurrentUserPreferences:Raise(self, RequestingCurrentUserPreferencesEventArgs:New()).Response

    Guard.Assert.Explained.IsNotNil(response.UserPreferences, "[ZUPF.OCUPR.010] failed to retrieve user-preferences")
    Guard.Assert.Explained.IsInstanceOf(response.UserPreferences, UserPreferencesDto, "[ZUPF.OCUPR.020] failed to retrieve user-preferences", "ea.Response.UserPreferences")

    return response.UserPreferences
end

function Class:ApplyNewUserPreferences_(newUserPreferences)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(newUserPreferences, UserPreferencesDto, "newUserPreferences")

    _commandsEnabled = false --00

    if not _ui.lddGreeniesGrouplootingAutomation_Mode:TrySetSelectedOptionByValue(newUserPreferences:Get_GreeniesGrouplootingAutomation_Mode()) then
        _ui.lddGreeniesGrouplootingAutomation_Mode:TrySetSelectedOptionByValue(SGreeniesGrouplootingAutomationMode.RollGreed)
    end

    if not _ui.lddGreeniesGrouplootingAutomation_ActOnKeybind:TrySetSelectedOptionByValue(newUserPreferences:Get_GreeniesGrouplootingAutomation_ActOnKeybind()) then
        _ui.lddGreeniesGrouplootingAutomation_ActOnKeybind:TrySetSelectedOptionByValue(SGreeniesGrouplootingAutomationActOnKeybind.Automatic)
    end

    _commandsEnabled = true

    return newUserPreferences

    --00  we dont want these change-events to be advertised to the outside world when we are simply updating the
    --    controls to reflect the current user-preferences
    --
    --    we only want the change-events to be advertised when the user actually tweaks the user preferences by hand
end

function Class:lddGreeniesGrouplootingAutomation_Mode_SelectionChanged_(_, ea)
    Scopify(EScopes.Function, self)

    _ui.lddGreeniesGrouplootingAutomation_ActOnKeybind:ChainSet_Visibility(ea:GetNewValue() ~= SGreeniesGrouplootingAutomationMode.LetUserChoose)
    if not _commandsEnabled then
        return
    end
    
    ZenEngineCommandHandlersService:New():Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(
        GreeniesGrouplootingAutomationApplyNewModeCommand
        :New()
        :ChainSetOld(ea:GetOldValue())
        :ChainSetNew(ea:GetNewValue())
    )
end

function Class:lddGreeniesGrouplootingAutomation_ActOnKeybind_SelectionChanged_(_, ea)
    Scopify(EScopes.Function, self)

    if not _commandsEnabled then
        return
    end

    ZenEngineCommandHandlersService:New():Handle_GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand(
        GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand
        :New()
        :ChainSetOld(ea:GetOldValue())
        :ChainSetNew(ea:GetNewValue())
    )
end
