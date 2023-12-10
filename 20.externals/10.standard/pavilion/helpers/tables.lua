﻿local _assert, _setfenv, _type, _getn, _next, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _getn = _assert(_g.table.getn)
    local _next = _assert(_g.next)
    local _error = _assert(_g.error)
    local _print = _assert(_g.print)
    local _pairs = _assert(_g.pairs)
    local _unpack = _assert(_g.unpack)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _assert, _setfenv, _type, _getn, _next, _error, _print, _unpack, _pairs, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Class = _namespacer("Pavilion.Helpers.Tables")

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
    for k, v in _pairs(tableObject) do
        res[Class.Clone(k, s)] = Class.Clone(v, s)
    end

    return res
end

function Class.IsEmpty(tableObject)
    return _type(tableObject) ~= 'table' or _next(tableObject) == nil
end