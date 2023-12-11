local _, _, _, _, _gsub, _format, _strmatch, _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _error = _assert(_g.error)

    local _gsub = _assert(_g.string.gsub)
    local _format = _assert(_g.string.format)
    local _strmatch = _assert(_g.string.match)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _g, _assert, _type, _error, _gsub, _format, _strmatch, _setfenv, _importer, _namespacer
end)()

_setfenv(1, {})

local Table = _importer("System.Table")

local StringsHelpers = _namespacer("Pavilion.Helpers.Strings")

function StringsHelpers.Trim(input)
    return _strmatch(input, '^()%s*$')
            and ''
            or _strmatch(input, '^%s*(.*%S)')
end

function StringsHelpers.Split(input, delimiter)
    if not input then
        return {}
    end

    local pattern = _format("([^%s]+)", delimiter or ",")

    local fields = {}
    _gsub(
            input,
            pattern,
            function(c)
                Table.insert(fields, c)
            end
    )

    return fields
end
