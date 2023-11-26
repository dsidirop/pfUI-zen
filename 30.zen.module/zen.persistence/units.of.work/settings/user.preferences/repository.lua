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

local UserPreferencesRepositoryQueryable = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryQueryable")
local UserPreferencesRepositoryUpdatable = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.RepositoryUpdatable")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.Repository")

function Class:NewWithDBContext(dbcontext)
    _setfenv(1, self)

    _assert(_type(dbcontext) == "table")
    
    return self:New(
            UserPreferencesRepositoryQueryable:New(dbcontext),
            UserPreferencesRepositoryUpdatable:New(dbcontext)
    )
end

function Class:New(userPreferencesRepositoryQueryable, userPreferencesRepositoryUpdatable)
    _setfenv(1, self)

    _assert(_type(userPreferencesRepositoryQueryable) == "table")
    _assert(_type(userPreferencesRepositoryUpdatable) == "table")

    local instance = {
        _userPreferencesRepositoryQueryable = userPreferencesRepositoryQueryable,
        _userPreferencesRepositoryUpdatable = userPreferencesRepositoryUpdatable,
    }

    _setmetatable(instance, self)
    self.__index = self
    
    return instance
end

-- @return UserPreferencesDto
function Class:GetAllUserPreferences()
    _setfenv(1, self)

    return _userPreferencesRepositoryQueryable:GetAllUserPreferences()
end

function Class:HasChanges()
    _setfenv(1, self)

    return _userPreferencesRepositoryUpdatable:HasChanges()
end

-- @return self
function Class:GreeniesAutolooting_ChainUpdateMode(value)
    _setfenv(1, self)
    
    _userPreferencesRepositoryUpdatable:GreeniesAutolooting_ChainUpdateMode(value)
    
    return self
end

-- @return self
function Class:GreeniesAutolooting_ChainUpdateActOnKeybind(value)
    _setfenv(1, self)

    _userPreferencesRepositoryUpdatable:GreeniesAutolooting_ChainUpdateActOnKeybind(value)

    return self
end
