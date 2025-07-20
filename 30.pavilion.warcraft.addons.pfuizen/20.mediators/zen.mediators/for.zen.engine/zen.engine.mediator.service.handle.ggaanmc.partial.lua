--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard" 

local GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewActOnKeybindCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Mediators.ForZenEngine.ZenEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand(command)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(command, GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand, "command")

    _zenEngineSingleton:GreeniesGrouplootingAutomation_SwitchActOnKeybind(command:GetNewValue()) --                      order

    local success = _userPreferencesService:GreeniesGrouplootingAutomation_UpdateActOnKeybind(command:GetNewValue()) --  order
    if success then
        -- todo   raise side-effect domain-events here
    end

    return self
end
