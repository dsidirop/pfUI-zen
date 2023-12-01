local _assert, _setfenv, _type, _error, _print, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _error, _print, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Event = _importer("System.Event")
local ZenEngineCommandsService = _importer("Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandsService")
local SGreenItemsAutolootingMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingMode")
local SGreenItemsAutolootingActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingActOnKeybind")
local GreenItemsAutolootingApplyNewModeCommand = _importer("Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.GreenItemsAutolooting.ApplyNewModeCommand")
local GreenItemsAutolootingApplyNewActOnKeybindCommand = _importer("Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.GreenItemsAutolooting.ApplyNewActOnKeybindCommand")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Controllers.UI.Pfui.Forms.UserPreferencesForm")

-- this only gets called once during a user session the very first time that the user explicitly
-- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
function Class:New(T, pfuiGui)
    _setfenv(1, self)

    local instance = {
        _t = _assert(T),
        _pfuiGui = _assert(pfuiGui),

        _ui = {
            frmContainer = nil,
            lblGrouplootSectionHeader = nil,
            ddlGreenItemsAutolooting_mode = nil,
            ddlGreenItemsAutolooting_actOnKeybind = nil,
        },

        _eventRequestingCurrentUserPreferences = Event:New(),

        _commandsEnabled = false,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:EventRequestingCurrentUserPreferences_Subscribe(handler, owner)
    _setfenv(1, self)

    _eventRequestingCurrentUserPreferences:Subscribe(handler, owner)

    return self
end

function Class:EventRequestingCurrentUserPreferences_Unsubscribe(handler)
    _setfenv(1, self)

    _eventRequestingCurrentUserPreferences:Unsubscribe(handler)

    return self
end

function Class:Initialize()
    _setfenv(1, self)

    _pfuiGui.CreateGUIEntry(-- 00
            _t["Thirdparty"],
            _t["|cFF7FFFD4Zen|r"],
            function()
                self:InitializeControls_() --                   order
                self:OnRequestingCurrentUserPreferences_() --   order
            end
    )

    -- 00  this only gets called during a user session the very first time that the user explicitly
    --     navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
end

-- privates
function Class:OnShown_()
    _setfenv(1, self)

    self:OnRequestingCurrentUserPreferences_()
end

function Class:OnRequestingCurrentUserPreferences_()
    _setfenv(1, self)

    local response = _eventRequestingCurrentUserPreferences:Raise( -- @formatter:off todo    RequestingCurrentUserPreferencesEventArgs:New()
            self,
            { 
                 Response = {
                     UserPreferences = nil -- type UserPreferencesDto
                 }
            })
            .Response -- @formatter:on

    if not response.UserPreferences then
        _error("[ZUPF.OCUPR.010] failed to retrieve user-preferences")
        return nil
    end

    _commandsEnabled = false --00

    if not _ui.ddlGreenItemsAutolooting_mode:TrySetSelectedOptionByValue(response.UserPreferences:GetGreeniesAutolooting_Mode()) then
        _ui.ddlGreenItemsAutolooting_mode:TrySetSelectedOptionByValue(SGreenItemsAutolootingMode.RollGreed)
    end

    if not _ui.ddlGreenItemsAutolooting_actOnKeybind:TrySetSelectedOptionByValue(response.UserPreferences:GetGreeniesAutolooting_ActOnKeybind()) then
        _ui.ddlGreenItemsAutolooting_actOnKeybind:TrySetSelectedOptionByValue(SGreenItemsAutolootingActOnKeybind.Automatic)
    end

    _commandsEnabled = true

    return response

    --00  we dont want these change-events to be advertised to the outside world when we are simply updating the
    --    controls to reflect the current user-preferences
    --
    --    we only want the change-events to be advertised when the user actually tweaks the user preferences by hand
end

function Class:DdlGreenItemsAutolootingMode_SelectionChanged_(sender, ea)
    _setfenv(1, self)

    _assert(sender)
    _assert(_type(ea) == "table")

    _ui.ddlGreenItemsAutolooting_actOnKeybind:SetVisibility(ea:GetNewValue() ~= SGreenItemsAutolootingMode.LetUserChoose)

    if _commandsEnabled then
        ZenEngineCommandsService:New():Handle_GreenItemsAutolootingApplyNewModeCommand(
                GreenItemsAutolootingApplyNewModeCommand:New()
                                                        :ChainSetOld(ea:GetOldValue())
                                                        :ChainSetNew(ea:GetNewValue())
        )
    end
end

function Class:DdlGreenItemsAutolootingActOnKeybind_SelectionChanged_(sender, ea)
    _setfenv(1, self)

    _assert(sender)
    _assert(_type(ea) == "table")

    if _commandsEnabled then
        ZenEngineCommandsService:New():Handle_GreenItemsAutolootingApplyNewActOnKeybindCommand(
                GreenItemsAutolootingApplyNewActOnKeybindCommand:New()
                                                                :ChainSetOld(ea:GetOldValue())
                                                                :ChainSetNew(ea:GetNewValue())
        )
    end
end
