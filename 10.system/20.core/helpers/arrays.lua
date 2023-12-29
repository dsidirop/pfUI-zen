local _setfenv, _getn, _importer, _namespacer, _tableInsert = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _getn = _assert(_g.table.getn)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _tableInsert = _assert(_g.table.insert)

    return _setfenv, _getn, _importer, _namespacer, _tableInsert
end)()

_setfenv(1, {})

local Guard = _importer("System.Guard")

local Class = _namespacer("System.Helpers.Arrays [Partial]")

function Class.Count(array)
    Guard.Assert.IsTable(array)

    return _getn(array)
end

function Class.Append(array, value)
    Guard.Assert.IsTable(array)
    Guard.Assert.IsNotNil(value)

    return _tableInsert(array, value)
end
