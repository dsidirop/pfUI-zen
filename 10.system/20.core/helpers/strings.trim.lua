local _setfenv, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _namespacer
end)()

_setfenv(1, {})

local StringsHelper = _namespacer("System.Helpers.Strings [Partial]")

function StringsHelper.Trim(input)
    return StringsHelper.Match(input, '^()%s*$')
            and ''
            or StringsHelper.Match(input, '^%s*(.*%S)')
end
