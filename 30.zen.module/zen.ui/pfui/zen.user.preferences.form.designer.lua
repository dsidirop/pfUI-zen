local _setfenv, _importer, _namespacer, _assert = (function() -- todo  consolidate this into a single function
    local _g = assert(getfenv(0))
    local _assert = assert(_g.assert)

    local _setfenv = _assert(_g.setfenv)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _setfenv, _importer, _namespacer, _assert
end)() --order

_setfenv(1, {}) --order

local PfuiUserPreferencesAdapter = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Settings.PfuiUserPreferencesAdapter")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm [Partial]")

function Class:InitializeControls(pfuiUserPreferencesAdapter)
    _setfenv(1, self)

    _assert(pfuiUserPreferencesAdapter ~= nil)

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
                self:ddlGreenItemsAutolooting_modeSetting_selectionChanged(self, pfuiUserPreferencesAdapter:GreenItemsAutolooting_GetMode())
            end,
            _t["On |cFF228B22Greens|r ..."],
            pfuiUserPreferencesAdapter:GetRawTable(),
            PfuiUserPreferencesAdapter.Schema.greenies_autolooting.mode.keyname,
            "dropdown",
            {
                "roll_need:" .. _t["Roll '|cFFFF4500Need|r'"],
                "roll_greed:" .. _t["Roll '|cFFFFD700Greed|r'"],
                "just_pass:" .. _t["Just '|cff888888Pass|r'"],
                "let_user_choose:" .. _t["Let me handle it myself"],
            }
    )

    _ui.ddlGreenItemsAutolooting_actOnKeybindSetting = _pfuiGui.CreateConfig(
            function()
                self:ddlGreenItemsAutolooting_modeSetting_selectionChanged(self, pfuiUserPreferencesAdapter:GreenItemsAutolooting_GetActOnKeybind())
            end,
            _t["Upon Pressing ..."],
            pfuiUserPreferencesAdapter:GetRawTable(),
            PfuiUserPreferencesAdapter.Schema.greenies_autolooting.act_on_keybind.keyname,
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
