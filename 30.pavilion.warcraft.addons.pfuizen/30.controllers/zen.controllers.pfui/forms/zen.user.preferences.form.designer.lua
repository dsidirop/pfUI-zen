--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local SGreeniesGrouplootingAutomationMode               = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind       = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Form = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Pfui.Forms.UserPreferencesForm [Partial]" --[[@formatter:on]]

function Form:InitializeControls_()
    Scopify(EScopes.Function, self)

    _ui.frmAreaInsideContainer:SetScript("OnShow", function() self:OnShown_() end) -- note:   _ui.frmAreaInsideContainer == _ui.hdrGrouplootSectionHeader:GetParent():GetParent():GetParent()

    _ui.hdrGrouplootSectionHeader = _pfuiMainSettingsFormGuiControlsFactory --@formatter:off
                                                                :SpawnHeaderControlBuilder()
                                                                :ChainSet_Height(30)
                                                                :ChainSet_Caption(_t("Grouploot Automation"))
                                                                :Build() --@formatter:on

    _ui.lddGreeniesGrouplootingAutomation_Mode = _pfuiMainSettingsFormGuiControlsFactory --@formatter:off
                                                                :SpawnLabeledDropdownControlBuilder()
                                                                :ChainSet_Caption(_t("On |cFF228B22Greens|r"))
                                                                :ChainSet_MenuItems({
                                                                       SGreeniesGrouplootingAutomationMode.RollNeed      .. ":" .. _t("Roll '|cffff4500Need|r'"),
                                                                       SGreeniesGrouplootingAutomationMode.RollGreed     .. ":" .. _t("Roll '|cffffd700Greed|r'"),
                                                                       SGreeniesGrouplootingAutomationMode.JustPass      .. ":" .. _t("Just '|cff888888Pass|r'"),
                                                                       SGreeniesGrouplootingAutomationMode.LetUserChoose .. ":" .. _t("Let me handle it myself"),
                                                                })
                                                                :ChainApply_NudgingX(17) -- nudge the caption a bit to the right
                                                                :Build()
                                                                :EventSelectionChanged_Subscribe(self.lddGreeniesGrouplootingAutomation_Mode_SelectionChanged_, self) --@formatter:on

    _ui.lddGreeniesGrouplootingAutomation_ActOnKeybind = _pfuiMainSettingsFormGuiControlsFactory --@formatter:off
                                                                :SpawnLabeledDropdownControlBuilder()
                                                                :ChainSet_Caption(_t("Upon Pressing"))
                                                                :ChainSet_MenuItems({
                                                                       SGreeniesGrouplootingAutomationActOnKeybind.Automatic    .. ":" .. _t("|cff888888(No Need to Press Anything)|r"),
                                                                       SGreeniesGrouplootingAutomationActOnKeybind.Alt          .. ":" .. _t("Alt"),
                                                                       SGreeniesGrouplootingAutomationActOnKeybind.Ctrl         .. ":" .. _t("Ctrl"),
                                                                       SGreeniesGrouplootingAutomationActOnKeybind.Shift        .. ":" .. _t("Shift"),
                                                                       SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt      .. ":" .. _t("Ctrl + Alt"),
                                                                       SGreeniesGrouplootingAutomationActOnKeybind.CtrlShift    .. ":" .. _t("Ctrl + Shift"),
                                                                       SGreeniesGrouplootingAutomationActOnKeybind.AltShift     .. ":" .. _t("Alt + Shift"),
                                                                       SGreeniesGrouplootingAutomationActOnKeybind.CtrlAltShift .. ":" .. _t("Ctrl + Alt + Shift"),
                                                                })
                                                                :ChainApply_NudgingX(17) -- nudge the caption a bit to the right
                                                                :Build()
                                                                :EventSelectionChanged_Subscribe(self.lddGreeniesGrouplootingAutomation_ActOnKeybind_SelectionChanged_, self) --@formatter:on

end
