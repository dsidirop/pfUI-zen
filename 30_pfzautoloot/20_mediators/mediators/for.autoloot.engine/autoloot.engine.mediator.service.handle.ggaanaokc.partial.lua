--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard   = using "System.Guard"

local AutolootEngine         = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Domain.Engine.AutolootEngine"
local UserPreferencesService = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Services.AddonSettings.UserPreferences.Service"

local GreeniesGrouplootingAutomationApplyNewModeCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewModeCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Mediators.ForAutolootEngine.AutolootEngineMediatorService [Partial]" -- @formatter:on

-- todo    strictly speaking the mediator service should not be handling commands directly; instead we should have matching command-handlers for this that
-- todo    get invoked by the mediator service; however, until we have a DI system in place to wire this up properly, we will let the mediator service handle
-- todo    commands directly     the mediator should also take care to inject whatever dependencies are needed by each command-handler-instance
function Class:Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(command)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(command, GreeniesGrouplootingAutomationApplyNewModeCommand, "command")

    local autolootEngine = AutolootEngine.I --todo   refactor this later on so that these get injected in the command-handler through DI
    local userPreferencesService = UserPreferencesService:NewWithDBContext()
    
    autolootEngine:GreeniesGrouplootingAutomation_SwitchMode(command:GetNewValue()) -- order   todo   in here we should intercept even the exceptions and marshal them into a verdict-domain-event (indicating success/failure) which is how handlers are supposed to work in this respect!

    local wasDifferentFromExistingValue = userPreferencesService:GreeniesGrouplootingAutomation_UpdateMode(command:GetNewValue()) -- order
    if not wasDifferentFromExistingValue then
        -- todo  use logging here    ("[AEMS.HGGAANMC.900] Info: The new value '%s' for GreeniesGrouplootingAutomation mode is the same as the existing one; no update was necessary.", command:GetNewValue())
    end

    return self
end
