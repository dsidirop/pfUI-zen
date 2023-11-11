ZenSettingsPfuiForm = {}

-- this only gets called during a user session the very first time that the user explicitly
-- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
function ZenSettingsPfuiForm:New(T, pfuiGui, addonRawPfuiSettings, addonRawPfuiSettingsSpecsV1)

    local newForm = {
        setfenv = assert(setfenv),

        _t = assert(T),
        _pfuiGui = assert(pfuiGui),
        _addonRawPfuiSettings = assert(addonRawPfuiSettings),
        _addonRawPfuiSettingsSpecsV1 = assert(addonRawPfuiSettingsSpecsV1),

        _lblLootSectionHeader = nil,
        _ddlGreenItemsLootAutogambling_modeSetting = nil,
        _ddlGreenItemsLootAutogambling_rollOnKeybindSetting = nil,
    }

    setmetatable(newForm, self)
    self.__index = self

    return newForm
end

function ZenSettingsPfuiForm:ddlGreenItemsLootAutogambling_modeSetting_selectionChanged(source, newValue)
    self.setfenv(1, self)

    if newValue == "let_user_choose" then
        _ddlGreenItemsLootAutogambling_rollOnKeybindSetting:Hide()
    else
        _ddlGreenItemsLootAutogambling_rollOnKeybindSetting:Show()
    end

    -- todo   effectuate the change on the zen-engine

    -- the addon settings automatically get autoupdated inside pfUI_config by pfUI's dropdown control   so we dont need to worry about that anymore
end

function ZenSettingsPfuiForm:ddlGreenItemsLootAutogambling_rollOnKeybindSetting_selectionChanged(source, newValue)
    self.setfenv(1, self)
    
    -- the settings automatically get updated inside pfUI_config by pfUI's dropdown control   so we dont need to worry about that anymore

    -- todo   effectuate the change on the zen-engine
end 