--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Try    = using "System.Try"
local Guard  = using "System.Guard"

local QuicklaunchEngine      = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Engine.QuicklaunchEngine"
local UserPreferencesService = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Services.AddonSettings.UserPreferences.Service"

local TweakEnabledStateOnEngineCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.Contracts.Commands.EngineControl.TweakEnabledStateOnEngineCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Mediators.ForQuicklaunchEngine.QuicklaunchEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_TweakEnabledStateOnEngineCommand(command)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(command, TweakEnabledStateOnEngineCommand, "command")

    local quicklaunchEngine = QuicklaunchEngine.I -- todo   refactor this later on so that these get injected in the command-handler through di
    local userPreferencesService = UserPreferencesService:NewWithDBContext()

    Try(function()
        
        -- LOAD PREFS
        -- no need in this case

        -- VALIDATE PREFS
        -- if command:GetDesiredNewState() == userPreferencesDto:Get_Quicklaunch_IsEnabled() then -- no need   the engine checks this anyway

        -- MAP PREFS TO SETTINGS
        -- no need in this case

        -- APPLY SETTINGS
        -- local didChangeTheEngineStatus = quicklaunchEngine:TweakEnabledState(command:GetDesiredNewState()) -- todo
        
        -- SAVE EXTRACTED STATE BACK
        -- userPreferencesService:Quicklaunch_UpdateEnabledState(command:GetDesiredNewState()) --todo

        -- RAISE DOMAIN SIDE-EFFECT-EVENTS
        -- if didChangeTheEngineStatus then --todo
        --     -- todo   raise side-effect domain-events here like QuicklaunchEngineEnabledStateChangedDomainEvent etc
        -- end
    
    end):CatchAll(function(ex)

        -- todo   1. raise side-effect domain-events here like QuicklaunchEngineEnabledStateChangeFailedDomainEvent etc
        -- todo   2. also use logging here    ("[QEMS.HTESOECH.900] Error: Failed to tweak the enabled state on QuicklaunchEngine to '%s': %s", command:GetDesiredEnabledState(), ex)

    end):Run()

    return self
end
