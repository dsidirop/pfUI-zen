--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils  = using "System.Nils"
local Guard = using "System.Guard"
local Event = using "System.Event"

local Fields = using "System.Classes.Fields"

-- local QuicklaunchEngineMediatorService       = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Mediators.ForQuicklaunchEngine.QuicklaunchEngineMediatorService"
local IPfuiMainSettingsFormGuiControlsFactory   = using "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.IPfuiMainSettingsFormGuiControlsFactory"

local ITranslatorService                        = using "Pavilion.Warcraft.Foundation.Contracts.Internationalization.Contracts.ITranslatorService"

local QuicklaunchUserPreferencesDto             = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto"
local IQuicklaunchUserPreferencesForm           = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.ViaPfui.Contracts.Forms.IQuicklaunchUserPreferencesForm"
local RequestingCurrentUserPreferencesEventArgs = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.ViaPfui.Contracts.Forms.Events.RequestingCurrentUserPreferencesEventArgs"

local Form = using "[declare] [blend]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.ViaPfui.Forms.QuicklaunchUserPreferencesForm" {
    "IQuicklaunchUserPreferencesForm", IQuicklaunchUserPreferencesForm,
}


Fields(function(upcomingInstance)
    upcomingInstance._t = nil    
    upcomingInstance._pfuiMainSettingsFormGuiControlsFactory = nil -- IPfuiMainSettingsFormGuiControlsFactory
    
    upcomingInstance._ui = {
        -- these are initialized when the :Initialize() is invoked after the constructor
        frmAreaInsideContainer       = nil,
        hdrQuicklaunchSectionHeader  = nil,

        chbQuicklaunchEnabled        = nil,
        txtQuicklaunchCustomAssociations = nil,
    }

    upcomingInstance._commandsEnabled = false
    upcomingInstance._eventRequestingCurrentUserPreferences = nil

    return upcomingInstance
end)


-- this only gets called once during a user session the very first time that the user explicitly
-- navigates to the "thirdparty" section and clicks on the "zen" tab   otherwise it never gets called
function Form:New(pfuiMainSettingsFormGuiControlsFactory, translationService)
    Scopify(EScopes.Function, self)

    local instance = self:Instantiate() --@formatter:off

    instance._t                                      = Guard.Assert.IsInstanceImplementing(translationService,                     ITranslatorService,                      "translationService")    
    instance._pfuiMainSettingsFormGuiControlsFactory = Guard.Assert.IsInstanceImplementing(pfuiMainSettingsFormGuiControlsFactory, IPfuiMainSettingsFormGuiControlsFactory, "pfuiMainSettingsFormGuiControlsFactory")
    instance._eventRequestingCurrentUserPreferences  = Event:New()
    
    instance._commandsEnabled = false --00
    
    return instance
    
    --00 instance._ui.xyz = ... <- this stuff get initialized in the :Initialize() method which must be called separately   @formatter:on
end

function Form:EventRequestingCurrentUserPreferences_Subscribe(handler, owner)
    Scopify(EScopes.Function, self)

    _eventRequestingCurrentUserPreferences:Subscribe(handler, owner)

    return self
end

function Form:EventRequestingCurrentUserPreferences_Unsubscribe(handler)
    Scopify(EScopes.Function, self)

    _eventRequestingCurrentUserPreferences:Unsubscribe(handler)

    return self
end

function Form:Initialize()
    Scopify(EScopes.Function, self)

    _ui.frmAreaInsideContainer = _pfuiMainSettingsFormGuiControlsFactory:SpawnNestedTabFrameWithAreaControlBuilder() --00
        :ChainSet_Caption(_t("[|cFF7FFFD4Zen|r] Quicklaunch")) -- reminder   this is just a shorthand for _t:TryTranslate("foobar", "|cFF7FFFD4")
        :ChainSet_ParentRootTabFrameName(_t("Thirdparty"))
        :ChainSet_AreaPopulatorWhenFirstShownFunc(function()
            self:InitializeControls_() --                         order   from the [partial]
            self:OnRequestingCurrentUserPreferences_() --         order
        end)
        :Build()
        :GetArea()

    -- 00  this only gets called during a user session the very first time that the user explicitly
    --     navigates to the "thirdparty" section and clicks on the "zen" tab   otherwise it never gets called
end

-- privates
function Form:OnShown_()
    Scopify(EScopes.Function, self)

    self:OnRequestingCurrentUserPreferences_()
end

function Form:OnRequestingCurrentUserPreferences_()
    Scopify(EScopes.Function, self)

    local newUserPreferences = self:OnRequestingCurrentUserPreferencesImpl_()

    return self:ApplyNewUserPreferencesOnUIControls_(newUserPreferences)
end

function Form:OnRequestingCurrentUserPreferencesImpl_()
    Scopify(EScopes.Function, self)

    local response = _eventRequestingCurrentUserPreferences:Raise(self, RequestingCurrentUserPreferencesEventArgs:New()).Response

    Guard.Assert.Explained.IsNotNil(response.UserPreferences, "[QLUPF.OCUPR.010] failed to retrieve user-preferences")
    Guard.Assert.Explained.IsInstanceOf(response.UserPreferences, QuicklaunchUserPreferencesDto, "[QLUPF.OCUPR.020] failed to retrieve user-preferences", "ea.Response.UserPreferences")

    return response.UserPreferences
end

function Form:ApplyNewUserPreferencesOnUIControls_(newUserPreferences)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(newUserPreferences, QuicklaunchUserPreferencesDto, "newUserPreferences")

    _commandsEnabled = false --00

    _ui.chbQuicklaunchEnabled:ChainSet_State(newUserPreferences:Get_IsEnabled())
    _ui.txtQuicklaunchCustomAssociations:ChainSet_Text(newUserPreferences:Get_CustomAssociations())

    _commandsEnabled = true

    return newUserPreferences

    --00  we dont want these change-events to be advertised to the outside world when we are simply updating the
    --    controls to reflect the current user-preferences
    --
    --    we only want the change-events to be advertised when the user actually tweaks the user preferences by hand
end

