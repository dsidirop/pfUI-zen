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

local UserPreferencesRepositoryQueryable = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryQueryable")
local UserPreferencesRepositoryWriteable = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryWriteable")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.Repository")

function Class:NewWithDBContext(dbcontext)
    Scopify(EScopes.Function, self)

    _assert(_type(dbcontext) == "table")
    
    return self:New(
            UserPreferencesRepositoryQueryable:New(dbcontext),
            UserPreferencesRepositoryWriteable:New(dbcontext)
    )
end

function Class:New(userPreferencesRepositoryQueryable, userPreferencesRepositoryWriteable)
    Scopify(EScopes.Function, self)

    _assert(_type(userPreferencesRepositoryQueryable) == "table")
    _assert(_type(userPreferencesRepositoryWriteable) == "table")

    return Classify(self, {
        _userPreferencesRepositoryQueryable = userPreferencesRepositoryQueryable,
        _userPreferencesRepositoryWriteable = userPreferencesRepositoryWriteable,
    })
end

-- @return UserPreferencesDto
function Class:GetAllUserPreferences()
    Scopify(EScopes.Function, self)

    return _userPreferencesRepositoryQueryable:GetAllUserPreferences()
end

function Class:HasChanges()
    Scopify(EScopes.Function, self)

    return _userPreferencesRepositoryWriteable:HasChanges()
end

-- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateMode(value)
    Scopify(EScopes.Function, self)
    
    _userPreferencesRepositoryWriteable:GreeniesGrouplootingAutomation_ChainUpdateMode(value)
    
    return self
end

-- @return self
function Class:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)
    Scopify(EScopes.Function, self)

    _userPreferencesRepositoryWriteable:GreeniesGrouplootingAutomation_ChainUpdateActOnKeybind(value)

    return self
end
