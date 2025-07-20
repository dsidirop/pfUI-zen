--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard" 

local GreeniesGrouplootingAutomationApplyNewModeCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewModeCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Mediators.ForZenEngine.ZenEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(command)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(command, GreeniesGrouplootingAutomationApplyNewModeCommand, "command")

    _zenEngineSingleton:GreeniesGrouplootingAutomation_SwitchMode(command:GetNewValue()) --                     order

    local success = _userPreferencesService:GreeniesGrouplootingAutomation_UpdateMode(command:GetNewValue()) -- order   todo   wrap this in a try-catch block to normalize exceptions
    if success then
        -- todo   raise side-effect domain-events here
    end

    return self
end
