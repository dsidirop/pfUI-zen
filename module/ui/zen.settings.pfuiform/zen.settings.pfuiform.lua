ZenSettingsPfuiForm = {}

-- this only gets called during a user session the very first time that the user explicitly
-- navigates to the "thirtparty" section and clicks on the "zen" tab   otherwise it never gets called
function ZenSettingsPfuiForm:New(T, pfuiGui, addonRawPfuiSettings, addonRawPfuiSettingsSpecsV1)

    local newForm = {
        T = assert(T),
        pfuiGui = assert(pfuiGui),
        addonRawPfuiSettings = assert(addonRawPfuiSettings),
        addonRawPfuiSettingsSpecsV1 = assert(addonRawPfuiSettingsSpecsV1),

        ddlGreenItemsLootAutogambling_modeSetting = nil,
        ddlGreenItemsLootAutogambling_rollOnKeybindSetting = nil,
    }

    setmetatable(newForm, self)
    self.__index = self

    return newForm
end

function ZenSettingsPfuiForm:ddlGreenItemsLootAutogambling_modeSetting_selectionChanged(source, newValue)
    -- the settings automatically get updated inside pfUI_config by pfUI's dropdown control   so we dont need to worry about that anymore

    if newValue == "let_user_choose" then
        self.ddlGreenItemsLootAutogambling_rollOnKeybindSetting:Hide()
    else
        self.ddlGreenItemsLootAutogambling_rollOnKeybindSetting:Show()
    end

    -- todo   effectuate the change on the zen-engine
end

function ZenSettingsPfuiForm:ddlGreenItemsLootAutogambling_rollOnKeybindSetting_selectionChanged(source, newValue)
    -- the settings automatically get updated inside pfUI_config by pfUI's dropdown control   so we dont need to worry about that anymore

    -- todo   effectuate the change on the zen-engine
end 