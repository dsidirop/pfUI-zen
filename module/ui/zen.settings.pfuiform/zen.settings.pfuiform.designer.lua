function ZenSettingsPfuiForm:InitializeControls()

    self.lblLootSectionHeader = self.pfuiGui.CreateConfig(nil, self.T["Loot"], nil, nil, "header")
    self.lblLootSectionHeader:GetParent().objectCount = self.lblLootSectionHeader:GetParent().objectCount - 1
    self.lblLootSectionHeader:SetHeight(20)

    self.ddlGreenItemsLootAutogambling_modeSetting = self.pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsLootAutogambling_modeSetting_selectionChanged(
                        self,
                        self.addonRawPfuiSettings[self.addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.mode.keyname]
                )
            end,
            self.T["On |cFF228B22Greens|r ..."],
            self.addonRawPfuiSettings,
            self.addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.mode.keyname,
            "dropdown",
            self.addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.mode.options
    )

    -- todo   render this as disabled if the mode is "let_user_choose"
    self.ddlGreenItemsLootAutogambling_rollOnKeybindSetting = self.pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsLootAutogambling_rollOnKeybindSetting_selectionChanged(
                        self,
                        self.addonRawPfuiSettings[self.addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.keyname]
                )
            end,
            self.T["Upon pressing ..."],
            self.addonRawPfuiSettings,
            self.addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.keyname,
            "dropdown",
            self.addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.options
    )

end
