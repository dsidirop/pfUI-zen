local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify" -- @formatter:off
local EScopes = using "System.EScopes"

local PfuiGui                                           = using "Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui"
local PfuiDropdownX                                     = using "Pavilion.Warcraft.Addons.Zen.UI.Pfui.ControlsX.Dropdown.DropdownX"
local SGreeniesGrouplootingAutomationMode               = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind       = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Controllers.UI.Pfui.Forms.UserPreferencesForm [Partial]"

function Class:InitializeControls_()
    Scopify(EScopes.Function, self)

    _ui.lblGrouplootSectionHeader = PfuiGui.CreateConfig(nil, _t("Grouploot Automation"), nil, nil, "header")
    _ui.lblGrouplootSectionHeader:SetHeight(20)

    _ui.frmContainer = _ui.lblGrouplootSectionHeader:GetParent()
    _ui.frmContainer.objectCount = _ui.frmContainer.objectCount - 1 -- vital for lblGrouplootSectionHeader to be positioned properly
    _ui.frmContainer:SetScript("OnShow", function()
        self:OnShown_()
    end)

    _ui.ddlGreeniesGrouplootingAutomation_mode = PfuiDropdownX:New() --@formatter:off
                                                              :ChainSetCaption(_t("On |cFF228B22Greens|r"))
                                                              :ChainSetMenuItems({
                                                                     SGreeniesGrouplootingAutomationMode.RollNeed .. ":" .. _t("Roll '|cFFFF4500Need|r'"),
                                                                     SGreeniesGrouplootingAutomationMode.RollGreed .. ":" .. _t("Roll '|cFFFFD700Greed|r'"),
                                                                     SGreeniesGrouplootingAutomationMode.JustPass .. ":" .. _t("Just '|cff888888Pass|r'"),
                                                                     SGreeniesGrouplootingAutomationMode.LetUserChoose .. ":" .. _t("Let me handle it myself"),
                                                              })
                                                              :EventSelectionChanged_Subscribe(self.DdlGreeniesGrouplootingAutomationMode_SelectionChanged_, self)
                                                              :Initialize() --@formatter:on

    _ui.ddlGreeniesGrouplootingAutomation_actOnKeybind = PfuiDropdownX:New() --@formatter:off
                                                                      :ChainSetCaption(_t("Upon Pressing"))
                                                                      :ChainSetMenuItems({
                                                                             SGreeniesGrouplootingAutomationActOnKeybind.Automatic .. ":" .. _t("|cff888888(No Need to Press Anything)|r"),
                                                                             SGreeniesGrouplootingAutomationActOnKeybind.Alt .. ":" .. _t("Alt"),
                                                                             SGreeniesGrouplootingAutomationActOnKeybind.Ctrl .. ":" .. _t("Ctrl"),
                                                                             SGreeniesGrouplootingAutomationActOnKeybind.Shift .. ":" .. _t("Shift"),
                                                                             SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt .. ":" .. _t("Ctrl + Alt"),
                                                                             SGreeniesGrouplootingAutomationActOnKeybind.CtrlShift .. ":" .. _t("Ctrl + Shift"),
                                                                             SGreeniesGrouplootingAutomationActOnKeybind.AltShift .. ":" .. _t("Alt + Shift"),
                                                                             SGreeniesGrouplootingAutomationActOnKeybind.CtrlAltShift .. ":" .. _t("Ctrl + Alt + Shift"),
                                                                      })
                                                                      :EventSelectionChanged_Subscribe(self.DdlGreeniesGrouplootingAutomationActOnKeybind_SelectionChanged_, self)
                                                                      :Initialize() --@formatter:on

end
