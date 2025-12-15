--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})

local Try    = using "System.Try"
local Guard  = using "System.Guard"

local QuicklaunchEngine         = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Engine.QuicklaunchEngine"
local UserPreferencesService    = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Persistence.Services.AddonSettings.UserPreferences.Service"
local QuicklaunchEngineSettings = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Domain.Contracts.Engine.QuicklaunchEngineSettings"

local SetNewCustomAssociationsCommand = using "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Controllers.Contracts.Commands.NewConfig.SetNewCustomAssociationsCommand"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Quicklaunch.Mediators.ForQuicklaunchEngine.QuicklaunchEngineMediatorService [Partial]" -- @formatter:on

function Class:Handle_SetNewCustomAssociationsCommand(command)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsInstanceOf(command, SetNewCustomAssociationsCommand, "command")

    local quicklaunchEngine = QuicklaunchEngine.I --todo   refactor this later on so that these get injected in the command-handler through DI
    local userPreferencesService = UserPreferencesService:NewWithDBContext()

    Try(function()
        -- LOAD PREFS
        local userPreferencesSnapshotDto = userPreferencesService:GetAllUserPreferences()

        -- MAP PREFS TO SETTINGS + VALIDATE NEW PREFS
        -- todo    impl parsing of the string    we need to keep this outside the if-block below to validate the string even if the engine is disabled
        -- local newEngineSettings = QuicklaunchEngineSettings:New():ChainSet_NewCustomAssociationsViaString(
        --     command:GetNewCustomAssociationsString()
        -- )
        
        if not userPreferencesSnapshotDto:Get_Quicklaunch_IsEnabled() then
            -- APPLY SETTINGS
            -- quicklaunchEngine:Restart(newEngineSettings)
            --
            -- EXTRACT STATE BACK
            -- no need in this case
        end

        -- UPDATE PREFS
        userPreferencesService:ChainSet_NewCustomAssociationsString(command:GetNewCustomAssociationsString())
        
        -- RAISE DOMAIN SIDE-EFFECT-EVENTS
        -- todo   raise side-effect domain-events here
    end):CatchAll(function(ex)

        -- todo   1. raise side-effect domain-events here like QuicklaunchEngineCustomAssociationsChangeFailedDomainEvent etc
        -- todo   2. also use logging here ...

    end):Run()

    return self
end
