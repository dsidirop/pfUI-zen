local _setfenv, _importer, _namespacer, _assert = (function()
    local _g = assert(getfenv(0))
    local _assert = assert(_g.assert)

    local _setfenv = _assert(_g.setfenv)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _importer, _namespacer, _assert
end)()

_setfenv(1, {})

local PfuiDropdownX = _importer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.CustomizedControls.PfuiDropdownX")
local SGreenItemsAutolootingMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Strenums.SGreenItemsAutolootingMode")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.UserPreferencesForm [Partial]")

function Class:_InitializeControls()
    _setfenv(1, self)

    -- todo   add a "reset to defaults" button
    -- todo   add polyfils for lua 5.2+ in regard to setfenv()/getfenv per  https://stackoverflow.com/a/14554565/863651
    -- todo   introduce fluent builders for constructing families of ui elements like the ones below

    _ui.lblGrouplootSectionHeader = _pfuiGui.CreateConfig(nil, _t["Grouploot Automation"], nil, nil, "header")
    _ui.lblGrouplootSectionHeader:SetHeight(20)

    _ui.frmContainer = _ui.lblGrouplootSectionHeader:GetParent()
    _ui.frmContainer.objectCount = _ui.frmContainer.objectCount - 1 -- vital for lblGrouplootSectionHeader to be positioned properly
    _ui.frmContainer:SetScript("OnShow", function()
        self:_OnShown()
    end)

    _ui.ddlGreenItemsAutolooting_mode = PfuiDropdownX:New() --@formatter:off
                                                     :ChainSetCaption(_t["On |cFF228B22Greens|r"])
                                                     :ChainSetMenuItems({
                                                            SGreenItemsAutolootingMode.RollNeed .. ":" .. _t["Roll '|cFFFF4500Need|r'"],
                                                            SGreenItemsAutolootingMode.RollGreed .. ":" .. _t["Roll '|cFFFFD700Greed|r'"],
                                                            SGreenItemsAutolootingMode.JustPass .. ":" .. _t["Just '|cff888888Pass|r'"],
                                                            SGreenItemsAutolootingMode.LetUserChoose .. ":" .. _t["Let me handle it myself"],
                                                     })
                                                     :EventSelectionChanged_Subscribe(function(sender, ea)
                                                            self:_ddlGreenItemsAutolootingMode_selectionChanged(sender, ea)
                                                     end)
                                                     :Initialize() --@formatter:on

    _ui.ddlGreenItemsAutolooting_actOnKeybind = PfuiDropdownX:New() --@formatter:off
                                                             :ChainSetCaption(_t["Upon Pressing"])
                                                             :ChainSetMenuItems({
                                                                     "automatic:" .. _t["|cff888888(Simply Autoloot)|r"],
                                                                     "alt:" .. _t["Alt"],
                                                                     "ctrl:" .. _t["Ctrl"],
                                                                     "shift:" .. _t["Shift"],
                                                                     "ctrl_alt:" .. _t["Ctrl + Alt"],
                                                                     "ctrl_shift:" .. _t["Ctrl + Shift"],
                                                                     "alt_shift:" .. _t["Alt + Shift"],
                                                                     "ctrl_alt_shift:" .. _t["Ctrl + Alt + Shift"],
                                                             })
                                                             :EventSelectionChanged_Subscribe(function(sender, ea)
                                                                    self:_ddlGreenItemsAutolootingActOnKeybind_selectionChanged(sender, ea)
                                                             end)
                                                             :Initialize() --@formatter:on

end
