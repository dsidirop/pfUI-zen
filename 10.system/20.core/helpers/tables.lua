local _assert, _setfenv, _getn, _type, _next, _unpack, _pairs, _tableInsert, _rawget, _tostring, _importer, _namespacer, _setmetatable, _getmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _getn = _assert(_g.getn)
    local _type = _assert(_g.type)
    local _next = _assert(_g.next)
    local _pairs = _assert(_g.pairs)
    local _rawget = _assert(_g.rawget)
    local _unpack = _assert(_g.unpack)
    local _tostring = _assert(_g.tostring)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _tableInsert = _assert(_g.table.insert)
    local _setmetatable = _assert(_g.setmetatable)
    local _getmetatable = _assert(_g.getmetatable)

    return _assert, _setfenv, _getn, _type, _next, _unpack, _pairs, _tableInsert, _rawget, _tostring, _importer, _namespacer, _setmetatable, _getmetatable
end)()

_setfenv(1, {})

local Nils = _importer("System.Nils")
local Guard = _importer("System.Guard")

local Class = _namespacer("System.Helpers.Tables [Partial]")

function Class.Clear(tableObject)
    _assert(_type(tableObject) == 'table')

    for k in _pairs(tableObject) do
        tableObject[k] = nil
    end
end

function Class.RawGetValue(table, key)
    Guard.Assert.IsTable(table)
    Guard.Assert.IsNotNil(key)

    return _rawget(table, key)
end

function Class.Clone(tableObject, seen)
    if _type(tableObject) ~= 'table' then
        return tableObject
    end

    if seen and seen[tableObject] then
        return seen[tableObject]
    end

    local s = seen or {}
    local res = _setmetatable({}, _getmetatable(tableObject))

    s[tableObject] = res
    for k, v in Class.GetKeyValuePairs(tableObject) do
        res[Class.Clone(k, s)] = Class.Clone(v, s)
    end

    return res
end

function Class.Append(table, value)
    Guard.Assert.IsTable(table)
    Guard.Assert.IsNotNil(value)

    return _tableInsert(table, value)
end

function Class.AnyOrNil(tableObject)
    return not Class.IsEmptyOrNil(tableObject)
end

function Class.IsEmptyOrNil(tableObject)
    _assert(tableObject == nil or _type(tableObject) == 'table')
    
    return tableObject == nil or _next(tableObject) == nil
end

function Class.GetKeyValuePairs(tableObject)
    _assert(_type(tableObject) == 'table')

    return _pairs(tableObject)
end

function Class.Unpack(tableObject, ...)
    _assert(_type(tableObject) == 'table')
    _assert(_getn(arg) == 0, "it seems you are attempting to use unpack(table, startIndex, endIndex) - use UnpackRange() for this kind of thing instead!")

    return _unpack(tableObject)
end

function Class.UnpackViaLength(tableObject, chunkStartIndex, chunkLength)
    _assert(_type(tableObject) == 'table')
    _assert(_type(chunkStartIndex) == 'number' and chunkStartIndex >= 1)
    _assert(_type(chunkLength) == 'number' and chunkLength >= 0)

    return Class.UnpackRange(tableObject, chunkStartIndex, chunkStartIndex + chunkLength - 1)
end

function Class.UnpackRange(tableObject, startIndex, optionalEndIndex)
    _assert(_type(tableObject) == 'table')
    _assert(_type(startIndex) == 'number' and startIndex >= 1)
    _assert(optionalEndIndex == nil or (_type(optionalEndIndex) == 'number' and optionalEndIndex >= 1))
    
    local tableLength = _getn(tableObject)
    if tableLength == 0 then
        return -- nothing to unpack
    end

    optionalEndIndex = Nils.Coalesce(optionalEndIndex, tableLength)
    if startIndex == 1 and optionalEndIndex == tableLength then
        return _unpack(tableObject) -- optimization
    end
    
    local results = {}
    for i = startIndex, optionalEndIndex do
        _tableInsert(results, tableObject[i])
    end

    return _unpack(results)
end
