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
    upcomingInstance._userPreferencesLocalEntity = nil -- cached

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

    local userPreferencesLocalEntity = self:GetUserPreferencesLocalEntity_()

    -- todo   introduce ValidateCoalesce() in enums to avoid bugs with ternary operators
    local mode = not SGreeniesGrouplootingAutomationMode:IsValid(userPreferencesLocalEntity.GreeniesGrouplootingAutomation.Mode) --00 anticorruption layer
            and SGreeniesGrouplootingAutomationMode.Greed
            or userPreferencesLocalEntity.GreeniesGrouplootingAutomation.Mode

    local actOnKeybind = not SGreeniesGrouplootingAutomationActOnKeybind:IsValid(userPreferencesLocalEntity.GreeniesGrouplootingAutomation.ActOnKeybind) -- anticorruption layer
            and SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt
            or userPreferencesLocalEntity.GreeniesGrouplootingAutomation.ActOnKeybind

    return UserPreferencesDto -- todo   automapper (with precondition-validators!)
            :New()
            :ChainSet_GreeniesGrouplootingAutomation_Mode(mode)
            :ChainSet_GreeniesGrouplootingAutomation_ActOnKeybind(actOnKeybind)

    --00 todo   whenever we detect a corruption in the database we auto-sanitise it but on top of that we should also update error-metrics and log it too
end


-- PRIVATES

function Class:GetUserPreferencesLocalEntity_()
    Scopify(EScopes.Function, self)

    if _userPreferencesLocalEntity ~= nil then
        return _userPreferencesLocalEntity
    end

    _userPreferencesLocalEntity = instance._dbcontextReadonly.Settings.UserPreferences -- we intentionally avoid deep-cloning here

    return _userPreferencesLocalEntity
end
