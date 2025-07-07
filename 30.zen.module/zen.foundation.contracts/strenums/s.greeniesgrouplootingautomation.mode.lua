--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local SGreeniesGrouplootingAutomationMode = using "[declare] [enum]" "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"

SGreeniesGrouplootingAutomationMode.JustPass = "just_pass"
SGreeniesGrouplootingAutomationMode.RollNeed = "roll_need"
SGreeniesGrouplootingAutomationMode.RollGreed = "roll_greed"
SGreeniesGrouplootingAutomationMode.LetUserChoose = "let_user_choose"
