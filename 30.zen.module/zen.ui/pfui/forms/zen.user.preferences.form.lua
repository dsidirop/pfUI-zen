local _assert, _setfenv, _type, _error, _, _importer, _namespacer, _setmetatable = (function()
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

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm")

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
            function()
                -- 00
                self:_InitializeControls() --                   order
                self:_OnRequestingCurrentUserPreferences() --   order

                -- _ddlGreenItemsAutolootingMode_selectionChanged(self, response.PfuiUserPreferencesAdapter:GreenItemsAutolooting_GetMode()) --vital
            end
    )

    -- 00  this only gets called during a user session the very first time that the user explicitly
    --     navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
end

-- privates
function Class:_OnShown()
    _setfenv(1, self)

    self:_OnRequestingCurrentUserPreferences()
end

function Class:_OnRequestingCurrentUserPreferences()
    _setfenv(1, self)

    local response = _requestingCurrentUserPreferences:Raise(self, { Response = { UserPreferences = nil } }).Response -- todo    RequestingCurrentUserPreferencesEventArgs:New()
    if not response.UserPreferences then
        _error("[ZUPF.OCUPR.010] failed to retrieve user-preferences")
        return nil
    end

    _ui.ddlGreenItemsAutolooting_mode:SetSelectedOptionByValue(response.UserPreferences.Mode)
    _ui.ddlGreenItemsAutolooting_actOnKeybind:SetSelectedOptionByValue(response.UserPreferences.ActOnKeybind)

    return response
end

function Class:_ddlGreenItemsAutolootingMode_selectionChanged(sender, ea)
    _setfenv(1, self)

    _assert(sender)
    _assert(_type(ea) == "table")

    _ui.ddlGreenItemsAutolooting_actOnKeybind:SetVisibility(ea.New ~= "let_user_choose")

    -- todo   effectuate the change on the zen-engine
end

function Class:_ddlGreenItemsAutolootingActOnKeybind_selectionChanged(_, _)
    _setfenv(1, self)

    -- todo   effectuate the change on the zen-engine
end
