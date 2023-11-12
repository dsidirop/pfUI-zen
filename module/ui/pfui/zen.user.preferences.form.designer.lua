local _g =  assert(_G or getfenv(0))
local _setfenv = assert(_g.setfenv)
local _namespacer = assert(_g.pavilion_pfui_zen_class_namespacer__add)

_setfenv(1, {})

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm [Partial]") 

function Class:InitializeControls()
    _setfenv(1, self)

    _ui.lblLootSectionHeader = _pfuiGui.CreateConfig(nil, _t["Loot"], nil, nil, "header")
    _ui.lblLootSectionHeader:GetParent().objectCount = _ui.lblLootSectionHeader:GetParent().objectCount - 1
    _ui.lblLootSectionHeader:SetHeight(20)

    _ui.ddlGreenItemsAutolooting_modeSetting = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsAutolooting_modeSetting_selectionChanged(
                        self,
                        _addonRawPfuiPreferences[_addonRawPfuiPreferencesSpecsV1.greenies_autolooting.mode.keyname]
                )
            end,
            _t["On |cFF228B22Greens|r ..."],
            _addonRawPfuiPreferences,
            _addonRawPfuiPreferencesSpecsV1.greenies_autolooting.mode.keyname,
            "dropdown",
            _addonRawPfuiPreferencesSpecsV1.greenies_autolooting.mode.options
    )

    _ui.ddlGreenItemsAutolooting_actOnKeybindSetting = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsAutolooting_actOnKeybindSetting_selectionChanged(
                        self,
                        _addonRawPfuiPreferences[_addonRawPfuiPreferencesSpecsV1.greenies_autolooting.act_on_keybind.keyname]
                )
            end,
            _t["Upon Pressing ..."],
            _addonRawPfuiPreferences,
            _addonRawPfuiPreferencesSpecsV1.greenies_autolooting.act_on_keybind.keyname,
            "dropdown",
            _addonRawPfuiPreferencesSpecsV1.greenies_autolooting.act_on_keybind.options
    )

end
