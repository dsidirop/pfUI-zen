--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local SGreeniesGrouplootingAutomationMode               = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind       = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Controllers.UI.Pfui.Forms.UserPreferencesForm [Partial]" --[[@formatter:on]]

function Class:InitializeControls_()
    Scopify(EScopes.Function, self)

    _ui.frmAreaContainer:SetScript("OnShow", function() self:OnShown_() end) -- note:   _ui.frmAreaContainer == _ui.hdrGrouplootSectionHeader:GetParent():GetParent():GetParent()

    _ui.hdrGrouplootSectionHeader = _pfuiMainSettingsFormGuiFactory --@formatter:off
                                                                :SpawnHeaderBuilder()
                                                                :ChainSet_Caption(_t("Grouploot Automation"))
                                                                :Build()
                                                                :ChainSet_Height(30) --@formatter:on

    _ui.lddGreeniesGrouplootingAutomation_mode = _pfuiMainSettingsFormGuiFactory --@formatter:off
                                                                :SpawnLabeledDropdownBuilder()
                                                                :ChainSet_Caption(_t("On |cFF228B22Greens|r"))
                                                                :ChainSet_MenuItems({
                                                                       SGreeniesGrouplootingAutomationMode.RollNeed      .. ":" .. _t("Roll '|cffff4500Need|r'"),
                                                                       SGreeniesGrouplootingAutomationMode.RollGreed     .. ":" .. _t("Roll '|cffffd700Greed|r'"),
                                                                       SGreeniesGrouplootingAutomationMode.JustPass      .. ":" .. _t("Just '|cff888888Pass|r'"),
                                                                       SGreeniesGrouplootingAutomationMode.LetUserChoose .. ":" .. _t("Let me handle it myself"),
                                                                })
                                                                :ChainSet_CaptionXPositionNudging(17) -- nudge the caption a bit to the right
                                                                :EventSelectionChanged_Subscribe(self.DdlGreeniesGrouplootingAutomationMode_SelectionChanged_, self)
                                                                :Build() --@formatter:on

    _ui.lddGreeniesGrouplootingAutomation_actOnKeybind = _pfuiMainSettingsFormGuiFactory --@formatter:off
                                                                :SpawnLabeledDropdownBuilder()
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
                                                                :ChainSet_CaptionXPositionNudging(17) -- nudge the caption a bit to the right
                                                                :EventSelectionChanged_Subscribe(self.DdlGreeniesGrouplootingAutomationActOnKeybind_SelectionChanged_, self)
                                                                :Build() --@formatter:on

end
