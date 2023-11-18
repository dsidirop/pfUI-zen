local _assert, _setfenv, _error, _print, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})
    
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _error, _print, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Event = _importer("System.Event")
local PfuiUserPreferencesAdapter = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Settings.PfuiUserPreferencesAdapter")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm")

-- this only gets called once during a user session the very first time that the user explicitly
-- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
function Class:New(T, pfuiGui)
    _setfenv(1, self)

    local instance = {
        _t = _assert(T),
        _pfuiGui = _assert(pfuiGui),
        _userPreferencesAdapter = PfuiUserPreferencesAdapter:New(),

        _ui = {
            frmContainer = nil,
            lblGrouplootSectionHeader = nil,
            ddlGreenItemsAutolooting_mode = nil,
            ddlGreenItemsAutolooting_actOnKeybind = nil,
        },
        
        _requestingCurrentUserPreferences = Event:New(),
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:EventRequestingCurrentUserPreferences_Subscribe(handler)
    _setfenv(1, self)

    _requestingCurrentUserPreferences:Subscribe(handler)
    
    return self
end

function Class:EventRequestingCurrentUserPreferences_Unsubscribe(handler)
    _setfenv(1, self)

    _requestingCurrentUserPreferences:Unsubscribe(handler)

    return self
end

function Class:Initialize()
    _setfenv(1, self)
    
    _pfuiGui.CreateGUIEntry(
            _t["Thirdparty"],
            _t["|cFF7FFFD4Zen|r"],
            function() -- 00
                self:InitializeControls() --                   order
                self:OnRequestingCurrentUserPreferences() --   order
                
                -- ddlGreenItemsAutolooting_mode_selectionChanged(self, response.PfuiUserPreferencesAdapter:GreenItemsAutolooting_GetMode()) --vital
            end
    )
    
    -- 00  this only gets called during a user session the very first time that the user explicitly
    --     navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
end

function Class:OnShown()
    _setfenv(1, self)

    self:OnRequestingCurrentUserPreferences()
end

function Class:OnRequestingCurrentUserPreferences()
    _setfenv(1, self)

    local response = _requestingCurrentUserPreferences
            :Raise( --    @formatter:off
                self,
                {
                    Response = { UserPreferences = nil }  -- eventargs    todo    RequestingCurrentUserPreferencesEventArgs:New()
                }
            )
            .Response --  @formatter:on

    if not response.UserPreferences then
        _error("[ZUPF.OCUPR.010] failed to retrieve user-preferences")
        return nil
    end

    -- _print("** OnRequestingCurrentUserPreferences: Mode="..response.UserPreferences.Mode..", ActOnKeybind="..response.UserPreferences.ActOnKeybind.." **")

    --_userPreferencesAdapter -- not really necessary but just for the sake of completeness
    --        :GreenItemsAutolooting_ChainSetMode(response.UserPreferences.Mode)
    --        :GreenItemsAutolooting_ChainSetActOnKeybind(response.UserPreferences.ActOnKeybind)

    --todo   wrap the underlying pfui controls and provide these methods as wrappers
    --_ui.ddlGreenItemsAutolooting_mode.SetSelectionByOptionNickname(response.UserPreferences.Mode)
    --_ui.ddlGreenItemsAutolooting_actOnKeybind.input:SetSelectionByOptionNickname(response.UserPreferences.ActOnKeybind)
    
    return response
end

function Class:ddlGreenItemsAutolooting_mode_selectionChanged(_, newValue)
    _setfenv(1, self)

    if newValue == "let_user_choose" then
        _ui.ddlGreenItemsAutolooting_actOnKeybind:Hide()
    else
        _ui.ddlGreenItemsAutolooting_actOnKeybind:Show()
    end

    -- todo   effectuate the change on the zen-engine
end

function Class:ddlGreenItemsAutolooting_actOnKeybind_selectionChanged(_, _)
    _setfenv(1, self)

    -- todo   effectuate the change on the zen-engine
end 