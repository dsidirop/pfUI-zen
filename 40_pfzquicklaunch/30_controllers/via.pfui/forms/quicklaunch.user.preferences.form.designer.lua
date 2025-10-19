--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Form = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.ViaPfui.Forms.QuicklaunchUserPreferencesForm [Partial]" --[[@formatter:on]]

function Form:InitializeControls_()
    Scopify(EScopes.Function, self)

    _ui.frmAreaInsideContainer:SetScript("OnShow", function() self:OnShown_() end) -- [note]   _ui.frmAreaInsideContainer == _ui.hdrGrouplootSectionHeader:GetParent():GetParent():GetParent()

    _ui.hdrGrouplootSectionHeader = _pfuiMainSettingsFormGuiControlsFactory --@formatter:off
                                                                :SpawnHeaderControlBuilder()
                                                                :ChainSet_Height(30)
                                                                :ChainSet_Caption(_t("Quicklaunch"))
                                                                :Build() --@formatter:on

end
