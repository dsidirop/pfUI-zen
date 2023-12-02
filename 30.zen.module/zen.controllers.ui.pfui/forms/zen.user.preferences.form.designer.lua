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
local SGreeniesGrouplootingAutomationMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode")
local SGreeniesGrouplootingAutomationActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Controllers.UI.Pfui.Forms.UserPreferencesForm [Partial]")

function Class:InitializeControls_()
    _setfenv(1, self)

    _ui.lblGrouplootSectionHeader = _pfuiGui.CreateConfig(nil, _t["Grouploot Automation"], nil, nil, "header")
    _ui.lblGrouplootSectionHeader:SetHeight(20)

    _ui.frmContainer = _ui.lblGrouplootSectionHeader:GetParent()
    _ui.frmContainer.objectCount = _ui.frmContainer.objectCount - 1 -- vital for lblGrouplootSectionHeader to be positioned properly
    _ui.frmContainer:SetScript("OnShow", function()
        self:OnShown_()
    end)

    _ui.ddlGreeniesGrouplootingAutomation_mode = PfuiDropdownX:New() --@formatter:off
                                                     :ChainSetCaption(_t["On |cFF228B22Greens|r"])
                                                     :ChainSetMenuItems({
                                                            SGreeniesGrouplootingAutomationMode.RollNeed .. ":" .. _t["Roll '|cFFFF4500Need|r'"],
                                                            SGreeniesGrouplootingAutomationMode.RollGreed .. ":" .. _t["Roll '|cFFFFD700Greed|r'"],
                                                            SGreeniesGrouplootingAutomationMode.JustPass .. ":" .. _t["Just '|cff888888Pass|r'"],
                                                            SGreeniesGrouplootingAutomationMode.LetUserChoose .. ":" .. _t["Let me handle it myself"],
                                                     })
                                                     :EventSelectionChanged_Subscribe(DdlGreeniesGrouplootingAutomationMode_SelectionChanged_, self)
                                                     :Initialize() --@formatter:on

    _ui.ddlGreeniesGrouplootingAutomation_actOnKeybind = PfuiDropdownX:New() --@formatter:off
                                                             :ChainSetCaption(_t["Upon Pressing"])
                                                             :ChainSetMenuItems({
                                                                    SGreeniesGrouplootingAutomationActOnKeybind.Automatic .. ":" .. _t["|cff888888(Simply Autoloot)|r"],
                                                                    SGreeniesGrouplootingAutomationActOnKeybind.Alt .. ":" .. _t["Alt"],
                                                                    SGreeniesGrouplootingAutomationActOnKeybind.Ctrl .. ":" .. _t["Ctrl"],
                                                                    SGreeniesGrouplootingAutomationActOnKeybind.Shift .. ":" .. _t["Shift"],
                                                                    SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt .. ":" .. _t["Ctrl + Alt"],
                                                                    SGreeniesGrouplootingAutomationActOnKeybind.CtrlShift .. ":" .. _t["Ctrl + Shift"],
                                                                    SGreeniesGrouplootingAutomationActOnKeybind.AltShift .. ":" .. _t["Alt + Shift"],
                                                                    SGreeniesGrouplootingAutomationActOnKeybind.CtrlAltShift .. ":" .. _t["Ctrl + Alt + Shift"],
                                                             })
                                                             :EventSelectionChanged_Subscribe(DdlGreeniesGrouplootingAutomationActOnKeybind_SelectionChanged_, self)
                                                             :Initialize() --@formatter:on

end
