--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard" 

local AutolootEngineSettings    = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Domain.Contracts.Engine.AutolootEngineSettings"
local RestartEngineCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Controllers.Contracts.Commands.AutolootEngine.RestartEngineCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Autoloot.Mediators.ForAutolootEngine.AutolootEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_RestartEngineCommand(command)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsInstanceOf(command, RestartEngineCommand, "command")

    local userPreferencesDto = _userPreferencesService:GetAllUserPreferences()

    local zenEngineSettings = AutolootEngineSettings:New()

    zenEngineSettings:GetGreeniesGrouplootingAssistantAggregateSettings()
                     :ChainSetMode(userPreferencesDto:Get_GreeniesGrouplootingAutomation_Mode())
                     :ChainSetActOnKeybind(userPreferencesDto:Get_GreeniesGrouplootingAutomation_ActOnKeybind())
    
    -- todo   add more settings-sections here

    _autolootEngine:Stop() -- todo   wrap this in a try-catch block to normalize exceptions
                       :SetSettings(zenEngineSettings)
                       :Start()

    -- todo   raise side-effect domain-events here

    return self
end
