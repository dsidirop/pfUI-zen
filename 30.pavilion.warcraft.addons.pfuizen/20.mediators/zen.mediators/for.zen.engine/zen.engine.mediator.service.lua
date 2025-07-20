--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Nils   = using "System.Nils"
local Guard  = using "System.Guard" 
local Fields = using "System.Classes.Fields"

local ZenEngine              = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Engine.ZenEngine"
local IZenEngine             = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.IZenEngine"

local ZenEngineSettings      = using "Pavilion.Warcraft.Addons.PfuiZen.Domain.Contracts.Engine.ZenEngineSettings"
local UserPreferencesService = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Services.AddonSettings.UserPreferences.Service"

local IUserPreferencesService = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Services.AddonSettings.UserPreferences.IService"

local RestartEngineCommand                                      = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.ZenEngine.RestartEngineCommand"
local GreeniesGrouplootingAutomationApplyNewModeCommand         = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewModeCommand"
local GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewActOnKeybindCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Mediators.ForZenEngine.ZenEngineMediatorService" -- @formatter:on


Fields(function(upcomingInstance)
    upcomingInstance._zenEngineSingleton = nil -- todo   get rid of these when we replace this service with a proper mediator that employs command-handlers once we have the DI system in place
    upcomingInstance._userPreferencesService = nil

    return upcomingInstance
end)

function Class:New(zenEngineSingleton, userPreferencesService)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNilOrInstanceImplementing(zenEngineSingleton, IZenEngine, "zenEngineSingleton")
    Guard.Assert.IsNilOrInstanceImplementing(userPreferencesService, IUserPreferencesService, "userPreferencesService")
    
    local instance = self:Instantiate()
    
    instance._zenEngineSingleton = Nils.Coalesce(zenEngineSingleton, ZenEngine.I) --todo   refactor this later on so that this gets injected through DI
    instance._userPreferencesService = Nils.Coalesce(userPreferencesService, UserPreferencesService:NewWithDBContext())
    
    return instance
end

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
