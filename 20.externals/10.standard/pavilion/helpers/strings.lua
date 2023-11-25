local _, _, _, _, _gsub, _format, _strmatch, _setfenv, _namespacer, _tableInsert = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _error = _assert(_g.error)

    local _gsub = _assert(_g.string.gsub)
    local _format = _assert(_g.string.format)
    local _strmatch = _assert(_g.string.match)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _tableInsert = _assert(_g.table.insert)

    return _g, _assert, _type, _error, _gsub, _format, _strmatch, _setfenv, _namespacer, _tableInsert
end)()

_setfenv(1, {})

local StringHelpers = _namespacer("Pavilion.Helpers.Strings")

do
    function StringHelpers.Trim(input)
        return _strmatch(input, '^()%s*$') and '' or _strmatch(input, '^%s*(.*%S)')
    end

    function StringHelpers.Split(input, delimiter)
        if not input then
            return {}
        end

        local pattern = _format("([^%s]+)", delimiter or ",")

        local fields = {}
        _gsub(
                input,
                pattern,
                function(c)
                    _tableInsert(fields, c)
                end
        )

        return fields
    end
end
