local _setfenv, _namespacer = (function() -- todo  consolidate this into a single function
    local _g = assert(getfenv(0))
    local _assert = assert(_g.assert)

    local _setfenv = _assert(_g.setfenv)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _namespacer
end)() --order

_setfenv(1, {}) --order

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm [Partial]") 

function Class:InitializeControls()
    _setfenv(1, self)

    -- todo   add a "reset to defaults" button
    --
    -- todo   refactor the form so that its options are not hardbinded to the raw-pfui-preferences-table
    -- todo   for this to work we will need to have "save/apply" buttons or raise domain events to notify the addon about the changes
    -- todo   add polyfils for lua 5.2+ in regard to setfenv()/getfenv per  https://stackoverflow.com/a/14554565/863651

    _ui.lblGrouplootSectionHeader = _pfuiGui.CreateConfig(nil, _t["Grouploot Automation"], nil, nil, "header")
    _ui.lblGrouplootSectionHeader:GetParent().objectCount = _ui.lblGrouplootSectionHeader:GetParent().objectCount - 1
    _ui.lblGrouplootSectionHeader:SetHeight(20)

    _ui.ddlGreenItemsAutolooting_modeSetting = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsAutolooting_modeSetting_selectionChanged(
                        self,
                        _addonRawPfuiPreferences[_addonRawPfuiPreferencesSchemaV1.greenies_autolooting.mode.keyname]
                )
            end,
            _t["On |cFF228B22Greens|r ..."],
            _addonRawPfuiPreferences,
            _addonRawPfuiPreferencesSchemaV1.greenies_autolooting.mode.keyname,
            "dropdown",
            _addonRawPfuiPreferencesSchemaV1.greenies_autolooting.mode.options
    )

    _ui.ddlGreenItemsAutolooting_actOnKeybindSetting = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsAutolooting_actOnKeybindSetting_selectionChanged(
                        self,
                        _addonRawPfuiPreferences[_addonRawPfuiPreferencesSchemaV1.greenies_autolooting.act_on_keybind.keyname]
                )
            end,
            _t["Upon Pressing ..."],
            _addonRawPfuiPreferences,
            _addonRawPfuiPreferencesSchemaV1.greenies_autolooting.act_on_keybind.keyname,
            "dropdown",
            _addonRawPfuiPreferencesSchemaV1.greenies_autolooting.act_on_keybind.options
    )

end
