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

-- local Schema = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.Schemas.SchemaV1")
local SGreenItemsAutolootingMode = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingMode")
local SGreenItemsAutolootingActOnKeybind = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreenItemsAutolootingActOnKeybind")

local Class = _namespacer("Pavilion.Warcraft.Addons.Zen.Persistence.Settings.UserPreferences.Repository")

function Class:New(userPreferencesEntity)  
    _setfenv(1, self)

    _assert(_type(userPreferencesEntity) == "table")

    local instance = {
        _userPreferencesEntity = userPreferencesEntity,
    }

    _setmetatable(instance, self)
    self.__index = self
    
    return instance
end

function Class:Get()
    _setfenv(1, self)

    return { -- todo  consolidate this into a dto class
        GreeniesAutolooting = {
            Mode = _userPreferencesEntity.GreeniesAutolooting.Mode,
            ActOnKeybind = _userPreferencesEntity.GreeniesAutolooting.ActOnKeybind,    
        },        
    }
end

function Class:GreeniesAutolooting_UpdateMode(value)
    _setfenv(1, self)
    
    _assert(SGreenItemsAutolootingMode.Validate(value))
    
    if _userPreferencesEntity.GreeniesAutolooting.Mode == value then
        return self
    end

    _userPreferencesEntity.GreeniesAutolooting.Mode = value

    return self
end

function Class:GreeniesAutolooting_UpdateActOnKeybind(value)
    _setfenv(1, self)

    _assert(SGreenItemsAutolootingActOnKeybind.Validate(value))

    if _userPreferencesEntity.GreeniesAutolooting.ActOnKeybind == value then
        return self
    end

    _userPreferencesEntity.GreeniesAutolooting.ActOnKeybind = value

    return self
end 
