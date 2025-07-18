--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]


local Nils = using "System.Nils"
local Guard = using "System.Guard"
local Fields = using "System.Classes.Fields"

local SGreeniesGrouplootingAutomationMode = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local PfuiZenDBContext = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.EntityFramework.PfuiZen.PfuiZenDBContext"
local UserPreferencesDto = using "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.PfuiZen.Persistence.Settings.UserPreferences.RepositoryQueryable"


Fields(function(upcomingInstance)
    upcomingInstance._dbcontextReadonly = nil
    return upcomingInstance
end)

function Class:New(dbcontextReadonly)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrInstanceOf(dbcontextReadonly, PfuiZenDBContext, "dbcontextReadonly") -- todo  remove this later on in favour of DI

    local instance = self:Instantiate()
    
    instance._dbcontextReadonly = Nils.Coalesce(dbcontextReadonly, PfuiZenDBContext:New())
    
    return instance
end

--- @return UserPreferencesDto
function Class:GetAllUserPreferences()
    Scopify(EScopes.Function, self)

    local userPreferenceEntity = _dbcontextReadonly.Settings.UserPreferences.LoadAsNoTracking()

    -- todo   introduce ValidateCoalesce() in enums to avoid bugs with ternary operators
    local mode = not SGreeniesGrouplootingAutomationMode:IsValid(userPreferenceEntity.GreeniesGrouplootingAutomation.Mode) --00 anticorruption layer
            and SGreeniesGrouplootingAutomationMode.Greed
            or userPreferenceEntity.GreeniesGrouplootingAutomation.Mode

    local actOnKeybind = not SGreeniesGrouplootingAutomationActOnKeybind:IsValid(userPreferenceEntity.GreeniesGrouplootingAutomation.ActOnKeybind) -- anticorruption layer
            and SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt
            or userPreferenceEntity.GreeniesGrouplootingAutomation.ActOnKeybind

    return UserPreferencesDto -- todo   automapper (with precondition-validators!)
            :New()
            :ChainSet_GreeniesGrouplootingAutomation_Mode(mode)
            :ChainSet_GreeniesGrouplootingAutomation_ActOnKeybind(actOnKeybind)

    --00 todo   whenever we detect a corruption in the database we auto-sanitise it but on top of that we should also update error-metrics and log it too
end
