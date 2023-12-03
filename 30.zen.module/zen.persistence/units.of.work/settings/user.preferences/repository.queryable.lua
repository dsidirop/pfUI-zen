local _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _getn, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local SGreeniesGrouplootingAutomationMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode")
local SGreeniesGrouplootingAutomationActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind")

local DBContext = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.PfuiZen.DBContext")
local UserPreferencesDto = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Contracts.Settings.UserPreferences.UserPreferencesDto")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryQueryable")

function Class:New(dbcontextReadonly)
    _setfenv(1, self)

    _assert(dbcontextReadonly == nil or _type(dbcontextReadonly) == "table")

    dbcontextReadonly = dbcontextReadonly or DBContext:New() -- todo  remove this later on in favour of DI

    local instance = {
        _userPreferencesEntity = dbcontextReadonly.Settings.UserPreferences,
    }

    _setmetatable(instance, self)
    self.__index = self

    return instance
end

-- @return UserPreferencesDto
function Class:GetAllUserPreferences()
    _setfenv(1, self)

    local mode = SGreeniesGrouplootingAutomationMode.Validate(_userPreferencesEntity.GreeniesGrouplootingAutomation.Mode) --00 anticorruption layer
            and _userPreferencesEntity.GreeniesGrouplootingAutomation.Mode
            or SGreeniesGrouplootingAutomationMode.Greed

    local actOnKeybind = SGreeniesGrouplootingAutomationActOnKeybind.Validate(_userPreferencesEntity.GreeniesGrouplootingAutomation.ActOnKeybind) -- anticorruption layer
            and _userPreferencesEntity.GreeniesGrouplootingAutomation.ActOnKeybind
            or SGreeniesGrouplootingAutomationActOnKeybind.CtrlAlt

    return UserPreferencesDto -- todo   automapper (with precondition-validators!)
            :New()
            :ChainSetGreeniesGrouplootingAutomation_Mode(mode)
            :ChainSetGreeniesGrouplootingAutomation_ActOnKeybind(actOnKeybind)

    --00 todo   whenever we detect a corruption in the database we auto-sanitive it but on top of that we should also update error-metrics and log it too
end
