local _g =  assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer = assert(_g.pavilion_pfui_zen_namespacer)

_setfenv(1, {})

local class = _namespacer(_g, "Pavilion.Pfui.Zen.UI.ZenSettingsPfuiForm")

function class:Initialize()
    _setfenv(1, self)

    _lblLootSectionHeader = _pfuiGui.CreateConfig(nil, _t["Loot"], nil, nil, "header")
    _lblLootSectionHeader:GetParent().objectCount = _lblLootSectionHeader:GetParent().objectCount - 1
    _lblLootSectionHeader:SetHeight(20)

    _ddlGreenItemsLootAutogambling_modeSetting = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsLootAutogambling_modeSetting_selectionChanged(
                        self,
                        _addonRawPfuiSettings[_addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.mode.keyname]
                )
            end,
            _t["On |cFF228B22Greens|r ..."],
            _addonRawPfuiSettings,
            _addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.mode.keyname,
            "dropdown",
            _addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.mode.options
    )

    _ddlGreenItemsLootAutogambling_rollOnKeybindSetting = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsLootAutogambling_rollOnKeybindSetting_selectionChanged(
                        self,
                        _addonRawPfuiSettings[_addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.keyname]
                )
            end,
            _t["Upon pressing ..."],
            _addonRawPfuiSettings,
            _addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.keyname,
            "dropdown",
            _addonRawPfuiSettingsSpecsV1.greenies_loot_autogambling.roll_on_keybind.options
    )

end
