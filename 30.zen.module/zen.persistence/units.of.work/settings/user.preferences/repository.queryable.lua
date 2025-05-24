local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "System.Nils"
local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local Guard = using "System.Guard"
local SGreeniesGrouplootingAutomationMode = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode"
local SGreeniesGrouplootingAutomationActOnKeybind = using "Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind"

local DBContext = using "Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.PfuiZen.DBContext"
local UserPreferencesDto = using "Pavilion.Warcraft.Addons.Zen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryQueryable"

Scopify(EScopes.Function, {})

function Class._.EnrichInstanceWithFields(upcomingInstance)
    upcomingInstance._userPreferencesEntity = nil

    return upcomingInstance
end

function Class:New(dbcontextReadonly)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsNilOrTable(dbcontextReadonly, "dbcontextReadonly") -- todo  remove this later on in favour of DI

    local instance = self:Instantiate()
    
    instance._userPreferencesEntity = Nils.Coalesce(dbcontextReadonly, DBContext:New()).Settings.UserPreferences
    
    return instance
end

-- @return UserPreferencesDto
function Class:GetAllUserPreferences()
    Scopify(EScopes.Function, self)

    local mode = SGreeniesGrouplootingAutomationMode:IsValid(_userPreferencesEntity.GreeniesGrouplootingAutomation.Mode) --00 anticorruption layer
            and _userPreferencesEntity.GreeniesGrouplootingAutomation.Mode
            or SGreeniesGrouplootingAutomationMode.Greed

    local actOnKeybind = SGreeniesGrouplootingAutomationActOnKeybind:IsValid(_userPreferencesEntity.GreeniesGrouplootingAutomation.ActOnKeybind) -- anticorruption layer
            and _userPreferencesEntity.GreeniesGrouplootingAutomation.ActOnKeybind
            or SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt

    return UserPreferencesDto -- todo   automapper (with precondition-validators!)
            :New()
            :ChainSet_GreeniesGrouplootingAutomation_Mode(mode)
            :ChainSet_GreeniesGrouplootingAutomation_ActOnKeybind(actOnKeybind)

    --00 todo   whenever we detect a corruption in the database we auto-sanitive it but on top of that we should also update error-metrics and log it too
end
