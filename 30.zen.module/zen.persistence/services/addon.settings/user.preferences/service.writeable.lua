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

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")
local Classify = _importer("System.Classes.Classify")

local PfuiZenDbContext = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.PfuiZen.DBContext")
local UserPreferencesUnitOfWork = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.UnitOfWork")
local SGreeniesGrouplootingAutomationMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode")
local SGreeniesGrouplootingAutomationActOnKeybind = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.ServiceWriteable")

function Class:New(userPreferencesUnitOfWork)
    Scopify(EScopes.Function, self)

    _assert(userPreferencesUnitOfWork == nil or _type(userPreferencesUnitOfWork) == "table")

    return Classify(self, {
        _userPreferencesUnitOfWork = userPreferencesUnitOfWork or UserPreferencesUnitOfWork:New(PfuiZenDbContext:New()), --todo   refactor this later on so that this gets injected through DI
    })
end

function Class:GreeniesGrouplootingAutomation_UpdateMode(value)
    Scopify(EScopes.Function, self)

    _assert(SGreeniesGrouplootingAutomationMode.IsValid(value))

    _userPreferencesUnitOfWork:GetUserPreferencesRepository()
                              :GreeniesGrouplootingAutomation_ChainUpdateMode(value)

    return _userPreferencesUnitOfWork:SaveChanges()
end

function Class:GreeniesGrouplootingAutomation_UpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _assert(SGreeniesGrouplootingAutomationActOnKeybind.IsValid(value))

    _userPreferencesUnitOfWork:GetUserPreferencesRepository()
                              :GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)

    return _userPreferencesUnitOfWork:SaveChanges()
end
