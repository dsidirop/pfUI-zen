local _print, _setfenv, _tostring, _importer, _namespacer, _assert = (function()
    local _g = assert(getfenv(0))
    local _assert = assert(_g.assert)

    local _print = _assert(_g.print)
    local _setfenv = _assert(_g.setfenv)
    local _tostring = _assert(_g.tostring)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _print, _setfenv, _tostring, _importer, _namespacer, _assert
end)()

_setfenv(1, {})

local PfuiDropdownX = _importer("Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.DropdownX")
local SGreenItemsAutolootingMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingMode")
local SGreenItemsAutolootingActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingActOnKeybind")

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
                                                                    SGreenItemsAutolootingActOnKeybind.Automatic .. ":" .. _t["|cff888888(Simply Autoloot)|r"],
                                                                    SGreenItemsAutolootingActOnKeybind.Alt .. ":" .. _t["Alt"],
                                                                    SGreenItemsAutolootingActOnKeybind.Ctrl .. ":" .. _t["Ctrl"],
                                                                    SGreenItemsAutolootingActOnKeybind.Shift .. ":" .. _t["Shift"],
                                                                    SGreenItemsAutolootingActOnKeybind.CtrlAlt .. ":" .. _t["Ctrl + Alt"],
                                                                    SGreenItemsAutolootingActOnKeybind.CtrlShift .. ":" .. _t["Ctrl + Shift"],
                                                                    SGreenItemsAutolootingActOnKeybind.AltShift .. ":" .. _t["Alt + Shift"],
                                                                    SGreenItemsAutolootingActOnKeybind.CtrlAltShift .. ":" .. _t["Ctrl + Alt + Shift"],
                                                             })
                                                             :EventSelectionChanged_Subscribe(function(sender, ea)
                                                                    self:_ddlGreenItemsAutolootingActOnKeybind_selectionChanged(sender, ea)
                                                             end)
                                                             :Initialize() --@formatter:on

end
