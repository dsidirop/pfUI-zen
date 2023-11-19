local _g, _assert, _type, _, _gsub, _format, _strmatch, _setfenv, _tableInsert = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _error = _assert(_g.error)

    local _gsub = _assert(_g.string.gsub)
    local _format = _assert(_g.string.format)
    local _strmatch = _assert(_g.string.match)
    local _tableInsert = _assert(_g.table.insert)

    return _g, _assert, _type, _error, _gsub, _format, _strmatch, _setfenv, _tableInsert
end)()

if _g.PavilionStringUtils then
    return -- already in place
end

_setfenv(1, {})

_g.PavilionStringUtils = {}
do
    function _g.PavilionStringUtils.Trim(input)
        return _strmatch(input, '^()%s*$') and '' or _strmatch(input, '^%s*(.*%S)')
    end

    function _g.PavilionStringUtils.Split(input, delimiter)
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
