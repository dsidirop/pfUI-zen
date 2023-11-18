local _g =  assert(_G or getfenv(0))
local _assert = assert
local _setfenv = assert(_g.setfenv)
local _namespacer = assert(_g.pvl_namespacer_add)
local _setmetatable = assert(_g.setmetatable)

_setfenv(1, {})

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm")

-- this only gets called during a user session the very first time that the user explicitly
-- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
function Class:New(T, pfuiGui, addonRawPfuiPreferences, addonRawPfuiPreferencesSchemaV1)

    local instance = {
        _t =  _assert(T),
        _pfuiGui =  _assert(pfuiGui),
        _addonRawPfuiPreferences =  _assert(addonRawPfuiPreferences),
        _addonRawPfuiPreferencesSchemaV1 =  _assert(addonRawPfuiPreferencesSchemaV1),
        
        _ui = {
            lblGrouplootSectionHeader = nil,
            ddlGreenItemsAutolooting_modeSetting = nil,
            ddlGreenItemsAutolooting_actOnKeybindSetting = nil,    
        },
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function Class:Initialize()
    _setfenv(1, self)
    
    _pfuiGui.CreateGUIEntry(
            _t["Thirdparty"],
            _t["|cFF7FFFD4Zen|r"],
            function()
                -- this only gets called during a user session the very first time that the user explicitly
                -- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
                self:InitializeControls()

                if _addonRawPfuiPreferences[_addonRawPfuiPreferencesSchemaV1.greenies_autolooting.mode.keyname] == "let_user_choose" then
                    _ui.ddlGreenItemsAutolooting_actOnKeybindSetting:Hide()
                end
            end
    )
end

function Class:ddlGreenItemsAutolooting_modeSetting_selectionChanged(_, newValue)
    _setfenv(1, self)

    if newValue == "let_user_choose" then
        _ui.ddlGreenItemsAutolooting_actOnKeybindSetting:Hide()
    else
        _ui.ddlGreenItemsAutolooting_actOnKeybindSetting:Show()
    end

    -- todo   effectuate the change on the zen-engine

    -- the addon settings automatically get autoupdated inside pfUI_config by pfUI's dropdown control   so we dont need to worry about that anymore
end

function Class:ddlGreenItemsAutolooting_actOnKeybindSetting_selectionChanged(_, _)
    _setfenv(1, self)
    
    -- the settings automatically get updated inside pfUI_config by pfUI's dropdown control   so we dont need to worry about that anymore

    -- todo   effectuate the change on the zen-engine
end 