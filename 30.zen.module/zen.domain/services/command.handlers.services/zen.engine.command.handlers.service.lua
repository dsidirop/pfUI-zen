local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Nils     = using "System.Nils"
local Guard    = using "System.Guard" 
local Scopify  = using "System.Scopify"
local EScopes  = using "System.EScopes"

local ZenEngine              = using "Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngine"
local ZenEngineSettings      = using "Pavilion.Warcraft.Addons.Zen.Domain.Engine.ZenEngineSettings"
local UserPreferencesService = using "Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.Service"

local GreeniesGrouplootingAutomationApplyNewModeCommand         = using "Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewModeCommand"
local GreeniesGrouplootingAutomationApplyNewActOnKeybindCommand = using "Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.GreeniesGrouplootingAutomation.ApplyNewActOnKeybindCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandHandlersService" -- @formatter:on

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._zenEngineSingleton = nil
    upcomingInstance._userPreferencesService = nil

    return upcomingInstance
end

function Class:New(userPreferencesService)
    Scopify(EScopes.Function, self)
    
    Guard.Assert.IsNilOrTable(userPreferencesService, "userPreferencesService")
    
    local instance = self:Instantiate()
    
    instance._zenEngineSingleton = ZenEngine.I --todo   refactor this later on so that this gets injected through DI
    instance._userPreferencesService = Nils.Coalesce(userPreferencesService, UserPreferencesService:NewWithDBContext())
    
    return instance
end

function Class:Handle_RestartEngineCommand(_)
    Scopify(EScopes.Function, self)

    local userPreferencesDto = _userPreferencesService:GetAllUserPreferences()

    local zenEngineSettings = ZenEngineSettings:New()

    zenEngineSettings:GetGreeniesAutolooterAggregateSettings()
                     :ChainSetMode(userPreferencesDto:Get_GreeniesGrouplootingAutomation_Mode())
                     :ChainSetActOnKeybind(userPreferencesDto:Get_GreeniesGrouplootingAutomation_ActOnKeybind())
    
    -- todo   add more settings-sections here

    _zenEngineSingleton:Stop()
                       :SetSettings(zenEngineSettings)
                       :Start()

    return self
end

function Class:Handle_GreeniesGrouplootingAutomationApplyNewModeCommand(command)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(command, GreeniesGrouplootingAutomationApplyNewModeCommand, "command")

    _zenEngineSingleton:GreeniesGrouplootingAutomation_SwitchMode(command:GetNewValue()) --                     order

    local success = _userPreferencesService:GreeniesGrouplootingAutomation_UpdateMode(command:GetNewValue()) -- order
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
