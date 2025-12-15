--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Try    = using "System.Try"
local Guard  = using "System.Guard"

local QuicklaunchEngine         = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Engine.QuicklaunchEngine"
local UserPreferencesService    = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Services.AddonSettings.UserPreferences.Service"
local QuicklaunchEngineSettings = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.QuicklaunchEngineSettings"

local RestartEngineIfApplicableCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.Contracts.Commands.EngineControl.RestartEngineIfApplicableCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Mediators.ForQuicklaunchEngine.QuicklaunchEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_RestartEngineIfApplicableCommand(command)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(command, RestartEngineIfApplicableCommand, "command")

    local quicklaunchEngine = QuicklaunchEngine.I --todo   refactor this later on so that these get injected in the command-handler through DI
    local userPreferencesService = UserPreferencesService:NewWithDBContext()

    Try(function()
        -- LOAD PREFS
        local userPreferencesDto = userPreferencesService:GetAllUserPreferences()

        -- VALIDATE PREFS
        -- todo   if not userPreferencesDto:Get_Quicklaunch_IsEnabled() then
        -- todo       return self -- feature is disabled; nothing to do here
        -- todo   end

        -- MAP PREFS TO SETTINGS
        -- todo   local newEngineSettings = QuicklaunchEngineSettings:New():ChainSet_NewCustomAssociationsViaString(
        -- todo           userPreferencesDto:Get_Quicklaunch_CustomAssociationsString()
        -- todo   )

        -- APPLY SETTINGS
        -- todo   quicklaunchEngine:Restart(newEngineSettings)

        -- EXTRACT STATE BACK
        -- no need in this case

        -- SAVE EXTRACTED STATE BACK
        -- no need in this case

        -- RAISE DOMAIN SIDE-EFFECT-EVENTS
        -- todo   raise side-effect domain-events here
    end):CatchAll(function(ex)

        -- todo   1. raise side-effect domain-events here like QuicklaunchEngineEnabledStateChangeFailedDomainEvent etc
        -- todo   2. also use logging here    ("[QEMS.HTESOECH.900] Error: Failed to tweak the enabled state on QuicklaunchEngine to '%s': %s", tostring(command:GetDesiredEnabledState()), tostring(ex))

    end):Run()

    return self
end
