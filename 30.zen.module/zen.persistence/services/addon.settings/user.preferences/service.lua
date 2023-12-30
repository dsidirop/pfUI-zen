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
local Classify = _importer("System.Class.Classify")

local DBContext = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.EntityFramework.PfuiZen.DBContext")
local ServiceQueryable = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.ServiceQueryable")
local ServiceWriteable = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.ServiceWriteable")
local UserPreferencesUnitOfWork = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.UnitOfWork")
local UserPreferencesRepositoryQueryable = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryQueryable")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.Service")

function Class:NewWithDBContext(dbcontext)
    Scopify(EScopes.Function, self)

    _assert(dbcontext == nil or _type(dbcontext) == "table")

    dbcontext = dbcontext or DBContext:New()

    return self:New(
            ServiceQueryable:New(UserPreferencesRepositoryQueryable:New(dbcontext)),
            ServiceWriteable:New(UserPreferencesUnitOfWork:New(dbcontext))
    )
end

function Class:New(serviceQueryable, serviceWriteable)
    Scopify(EScopes.Function, self)

    _assert(_type(serviceQueryable) == "table")
    _assert(_type(serviceWriteable) == "table")

    return Classify(self, {
        _serviceQueryable = serviceQueryable,
        _serviceWriteable = serviceWriteable,
    })
end

function Class:GetAllUserPreferences()
    Scopify(EScopes.Function, self)

    return _serviceQueryable:GetAllUserPreferences()
end

function Class:GreeniesGrouplootingAutomation_UpdateMode(value)
    Scopify(EScopes.Function, self)

    return _serviceWriteable:GreeniesGrouplootingAutomation_UpdateMode(value)
end

function Class:GreeniesGrouplootingAutomation_UpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    return _serviceWriteable:GreeniesGrouplootingAutomation_UpdateActOnKeybind(value)
end
