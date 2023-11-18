local _setfenv, _importer, _namespacer, _assert = (function()
    local _g = assert(getfenv(0))
    local _assert = assert(_g.assert)

    local _setfenv = _assert(_g.setfenv)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _importer, _namespacer, _assert
end)()

_setfenv(1, {})

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm [Partial]")

function Class:InitializeControls()
    _setfenv(1, self)

    -- todo   add a "reset to defaults" button
    -- todo   add polyfils for lua 5.2+ in regard to setfenv()/getfenv per  https://stackoverflow.com/a/14554565/863651
    -- todo   introduce fluent builders for constructing families of ui elements like the ones below

    _ui.lblGrouplootSectionHeader = _pfuiGui.CreateConfig(nil, _t["Grouploot Automation"], nil, nil, "header")
    _ui.lblGrouplootSectionHeader:SetHeight(20)
    
    _ui.frmContainer = _ui.lblGrouplootSectionHeader:GetParent()
    _ui.frmContainer.objectCount = _ui.frmContainer.objectCount - 1 -- vital for lblGrouplootSectionHeader to be positioned properly
    _ui.frmContainer:SetScript("OnShow", function()
        self:OnShown()
    end)

    _ui.ddlGreenItemsAutolooting_mode = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsAutolooting_mode_selectionChanged(self, _userPreferencesAdapter:GreenItemsAutolooting_GetMode())
            end,
            _t["On |cFF228B22Greens|r"],
            _userPreferencesAdapter:GetRawTable(),
            _userPreferencesAdapter.Schema.greenies_autolooting.mode.keyname,
            "dropdown",
            {
                "roll_need:" .. _t["Roll '|cFFFF4500Need|r'"],
                "roll_greed:" .. _t["Roll '|cFFFFD700Greed|r'"],
                "just_pass:" .. _t["Just '|cff888888Pass|r'"],
                "let_user_choose:" .. _t["Let me handle it myself"],
            }
    )

    _ui.ddlGreenItemsAutolooting_actOnKeybind = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsAutolooting_mode_selectionChanged(self, _userPreferencesAdapter:GreenItemsAutolooting_GetActOnKeybind())
            end,
            _t["Upon Pressing"],
            _userPreferencesAdapter:GetRawTable(),
            _userPreferencesAdapter.Schema.greenies_autolooting.act_on_keybind.keyname,
            "dropdown",
            {
                "automatic:" .. _t["|cff888888(Simply Autoloot)|r"],
                "alt:" .. _t["Alt"],
                "ctrl:" .. _t["Ctrl"],
                "shift:" .. _t["Shift"],
                "ctrl_alt:" .. _t["Ctrl + Alt"],
                "ctrl_shift:" .. _t["Ctrl + Shift"],
                "alt_shift:" .. _t["Alt + Shift"],
                "ctrl_alt_shift:" .. _t["Ctrl + Alt + Shift"],
            }
    )

end
