--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard"

local AutolootEngine         = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Domain.Engine.AutolootEngine"
local UserPreferencesService = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Persistence.Services.AddonSettings.UserPreferences.Service"
local AutolootEngineSettings = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Domain.Contracts.Engine.AutolootEngineSettings"

local RestartEngineIfApplicableCommand   = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Controllers.Contracts.Commands.EngineControl.RestartEngineIfApplicableCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Mediators.ForAutolootEngine.AutolootEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_RestartEngineIfApplicableCommand(command)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsInstanceOf(command, RestartEngineIfApplicableCommand, "command")

    local autolootEngine = AutolootEngine.I --todo   refactor this later on so that these get injected in the command-handler through DI
    local userPreferencesService = UserPreferencesService:NewWithDBContext()
    
    local zenEngineSettings = AutolootEngineSettings:New()
    local userPreferencesDto = userPreferencesService:GetAllUserPreferences()

    zenEngineSettings:GetGreeniesGrouplootingAssistantAggregateSettings()
                     :ChainSetMode(userPreferencesDto:Get_GreeniesGrouplootingAutomation_Mode())
                     :ChainSetActOnKeybind(userPreferencesDto:Get_GreeniesGrouplootingAutomation_ActOnKeybind())
    
    -- todo   add more settings-sections here

    autolootEngine:Stop() -- todo   wrap this in a try-catch block to normalize exceptions
                       :SetSettings(zenEngineSettings)
                       :Start()

    -- todo   raise side-effect domain-events here

    return self
end
