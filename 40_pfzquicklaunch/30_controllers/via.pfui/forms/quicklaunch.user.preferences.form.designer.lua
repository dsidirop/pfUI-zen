--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Form = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.ViaPfui.Forms.QuicklaunchUserPreferencesForm [Partial]" --[[@formatter:on]]

function Form:InitializeControls_()
    Scopify(EScopes.Function, self)

    _ui.frmAreaInsideContainer:SetScript("OnShow", function() self:OnShown_() end) -- [note]   _ui.frmAreaInsideContainer == _ui.hdrGrouplootSectionHeader:GetParent():GetParent():GetParent()

    _ui.hdrQuicklaunchSectionHeader = _pfuiMainSettingsFormGuiControlsFactory --@formatter:off
                                                                :SpawnHeaderControlBuilder()
                                                                :ChainSet_Height(30)
                                                                :ChainSet_Caption(_t("Quicklaunch"))
                                                                :Build() --@formatter:on

    _ui.chbQuicklaunchEnabled = _pfuiMainSettingsFormGuiControlsFactory --@formatter:off
                                                                :SpawnLabeledCheckboxControlBuilder()
                                                                :ChainApply_NudgingX(17) -- nudge the caption a bit to the right
                                                                :ChainSet_Caption(_t("Enabled"))
                                                                :Build()
                                                                :EventStateChanged_Subscribe(self.chbQuicklaunchEnabled_StateChanged_, self) --@formatter:on

    _ui.txtQuicklaunchCustomAssociations = _pfuiMainSettingsFormGuiControlsFactory --@formatter:off
                                                                :SpawnLabeledTextboxControlBuilder()
                                                                :ChainApply_NudgingX(17) -- nudge the caption a bit to the right
                                                                :ChainSet_Caption(_t("Associations"))
                                                                -- :ChainSet_Width(400):ChainSet_Height(400)  -- todo   fix the rendering issues ...
                                                                :ChainSet_IsMultiLine(true)
                                                                :ChainSet_JustifyHorizontally("LEFT")
                                                                :Build()
                                                                :EventTextChanged_Subscribe(self.txtQuicklaunchCustomAssociations_TextChanged_, self) --@formatter:on

end
