--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Guard  = using "System.Guard" 

local ZenEngineSettings    = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.ZenEngineSettings"
local RestartEngineCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.ZenEngine.RestartEngineCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Mediators.ForZenEngine.ZenEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_RestartEngineCommand(command)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsInstanceOf(command, RestartEngineCommand, "command")

    local userPreferencesDto = _userPreferencesService:GetAllUserPreferences()

    local zenEngineSettings = ZenEngineSettings:New()

    zenEngineSettings:GetGreeniesGrouplootingAssistantAggregateSettings()
                     :ChainSetMode(userPreferencesDto:Get_GreeniesGrouplootingAutomation_Mode())
                     :ChainSetActOnKeybind(userPreferencesDto:Get_GreeniesGrouplootingAutomation_ActOnKeybind())
    
    -- todo   add more settings-sections here

    _zenEngineSingleton:Stop() -- todo   wrap this in a try-catch block to normalize exceptions
                       :SetSettings(zenEngineSettings)
                       :Start()

    -- todo   raise side-effect domain-events here

    return self
end
