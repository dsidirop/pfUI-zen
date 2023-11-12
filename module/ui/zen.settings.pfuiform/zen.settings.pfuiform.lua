﻿local _g =  assert(_G or getfenv(0))
local _assert = assert
local _setfenv = assert(_g.setfenv)
local _namespacer = assert(_g.pavilion_pfui_zen_namespacer)
local _setmetatable = assert(_g.setmetatable)

_setfenv(1, {})

local class = _namespacer(_g, "Pavilion.Pfui.Zen.UI.ZenSettingsPfuiForm")

-- this only gets called during a user session the very first time that the user explicitly
-- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
function class:New(T, pfuiGui, addonRawPfuiSettings, addonRawPfuiSettingsSpecsV1)

    local instance = {
        _t =  _assert(T),
        _pfuiGui =  _assert(pfuiGui),
        _addonRawPfuiSettings =  _assert(addonRawPfuiSettings),
        _addonRawPfuiSettingsSpecsV1 =  _assert(addonRawPfuiSettingsSpecsV1),

        _lblLootSectionHeader = nil,
        _ddlGreenItemsLootAutogambling_modeSetting = nil,
        _ddlGreenItemsLootAutogambling_rollOnKeybindSetting = nil,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

function class:ddlGreenItemsLootAutogambling_modeSetting_selectionChanged(_, newValue)
    _setfenv(1, self)

    if newValue == "let_user_choose" then
        _ddlGreenItemsLootAutogambling_rollOnKeybindSetting:Hide()
    else
        _ddlGreenItemsLootAutogambling_rollOnKeybindSetting:Show()
    end

    -- todo   effectuate the change on the zen-engine

    -- the addon settings automatically get autoupdated inside pfUI_config by pfUI's dropdown control   so we dont need to worry about that anymore
end

function class:ddlGreenItemsLootAutogambling_rollOnKeybindSetting_selectionChanged(_, _)
    _setfenv(1, self)
    
    -- the settings automatically get updated inside pfUI_config by pfUI's dropdown control   so we dont need to worry about that anymore

    -- todo   effectuate the change on the zen-engine
end 