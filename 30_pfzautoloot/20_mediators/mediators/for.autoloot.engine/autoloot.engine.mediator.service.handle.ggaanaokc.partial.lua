--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard   = using "System.Guard"

local GreeniesGrouplootingAutomationApplyNewModeCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewModeCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Mediators.ForAutolootEngine.AutolootEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(command)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(command, GreeniesGrouplootingAutomationApplyNewModeCommand, "command")
    
    _autolootEngine:GreeniesGrouplootingAutomation_SwitchMode(command:GetNewValue()) -- order   todo   in here we should intercept even the exceptions and marshal them into a verdict-domain-event (indicating success/failure) which is how handlers are supposed to work in this respect!

    local wasDifferentFromExistingValue = _userPreferencesService:GreeniesGrouplootingAutomation_UpdateMode(command:GetNewValue()) -- order
    if not wasDifferentFromExistingValue then
        -- todo  use logging here    ("[AEMS.HGGAANMC.900] Info: The new value '%s' for GreeniesGrouplootingAutomation mode is the same as the existing one; no update was necessary.", command:GetNewValue())
    end

    return self
end
