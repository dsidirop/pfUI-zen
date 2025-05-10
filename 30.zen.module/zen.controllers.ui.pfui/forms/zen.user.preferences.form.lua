local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify  = using "System.Scopify" -- @formatter:off
local EScopes  = using "System.EScopes"

local Guard = using "System.Guard"
local Event = using "System.Event"

local PfuiGui                         = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui"
local ZenEngineCommandHandlersService = using "Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandHandlersService"

local SGreeniesGrouplootingAutomationMode         = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local UserPreferencesDto                                        = using "Pavilion.Warcraft.Addons.Zen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto"
local GreeniesGrouplootingAutomationApplyNewModeCommand         = using "Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewModeCommand"
local GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand = using "Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewActOnKeybindCommand" -- @formatter:on

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Controllers.UI.Pfui.Forms.UserPreferencesForm"

-- this only gets called once during a user session the very first time that the user explicitly
-- navigates to the "thirdparty" section and clicks on the "zen" tab   otherwise it never gets called
function Class:New(translationService)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNilOrTable(translationService, "translationService")

    return self:Instantiate({
        _t = translationService,

        _ui = {
            frmContainer = nil,
            lblGrouplootSectionHeader = nil,
            ddlGreeniesGrouplootingAutomation_mode = nil,
            ddlGreeniesGrouplootingAutomation_actOnKeybind = nil,
        },

        _commandsEnabled = false,
        _eventRequestingCurrentUserPreferences = Event:New(),
    })
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

    PfuiGui.CreateGUIEntry(-- 00
            _t("Thirdparty"),
            _t("Zen", "|cFF7FFFD4"),
            function()
                self:InitializeControls_() --                   order
                self:OnRequestingCurrentUserPreferences_() --   order
            end
    )

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

    local ea_ = { -- todo    RequestingCurrentUserPreferencesEventArgs:New()
        Response = {
            UserPreferences = nil -- type: UserPreferencesDto
        }
    }

    _eventRequestingCurrentUserPreferences:Raise(self, ea_)

    Guard.Assert.Explained.IsNotNil(ea_.Response ~= nil, "[ZUPF.OCUPR.010] failed to retrieve user-preferences")
    Guard.Assert.Explained.IsNotNil(ea_.Response.UserPreferences ~= nil, "[ZUPF.OCUPR.020] failed to retrieve user-preferences")
    Guard.Assert.Explained.IsInstanceOf(ea_.Response.UserPreferences, UserPreferencesDto, "[ZUPF.OCUPR.030] failed to retrieve user-preferences", "ea_.Response.UserPreferences")

    return ea_.Response.UserPreferences
end

function Class:ApplyNewUserPreferences_(newUserPreferences)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(newUserPreferences, UserPreferencesDto, "newUserPreferences")

    _commandsEnabled = false --00

    if not _ui.ddlGreeniesGrouplootingAutomation_mode:TrySetSelectedOptionByValue(newUserPreferences:GetGreeniesGrouplootingAutomation_Mode()) then
        _ui.ddlGreeniesGrouplootingAutomation_mode:TrySetSelectedOptionByValue(SGreeniesGrouplootingAutomationMode.RollGreed)
    end

    if not _ui.ddlGreeniesGrouplootingAutomation_actOnKeybind:TrySetSelectedOptionByValue(newUserPreferences:GetGreeniesGrouplootingAutomation_ActOnKeybind()) then
        _ui.ddlGreeniesGrouplootingAutomation_actOnKeybind:TrySetSelectedOptionByValue(SGreeniesGrouplootingAutomationActOnKeybind.Automatic)
    end

    _commandsEnabled = true

    return newUserPreferences

    --00  we dont want these change-events to be advertised to the outside world when we are simply updating the
    --    controls to reflect the current user-preferences
    --
    --    we only want the change-events to be advertised when the user actually tweaks the user preferences by hand
end

function Class:DdlGreeniesGrouplootingAutomationMode_SelectionChanged_(_, ea)
    Scopify(EScopes.Function, self)

    _ui.ddlGreeniesGrouplootingAutomation_actOnKeybind:SetVisibility(ea:GetNewValue() ~= SGreeniesGrouplootingAutomationMode.LetUserChoose)

    if _commandsEnabled then
        ZenEngineCommandHandlersService:New():Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(
                GreeniesGrouplootingAutomationApplyNewModeCommand:New()
                                                        :ChainSetOld(ea:GetOldValue())
                                                        :ChainSetNew(ea:GetNewValue())
        )
    end
end

function Class:DdlGreeniesGrouplootingAutomationActOnKeybind_SelectionChanged_(_, ea)
    Scopify(EScopes.Function, self)

    if _commandsEnabled then
        ZenEngineCommandHandlersService:New():Handle_GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand(
                GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand:New()
                                                                :ChainSetOld(ea:GetOldValue())
                                                                :ChainSetNew(ea:GetNewValue())
        )
    end
end
