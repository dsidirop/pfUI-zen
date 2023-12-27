local _setfenv, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _importer, _namespacer
end)()

_setfenv(1, {})

local Guard = _importer("System.Guard")
local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local StringsHelper = _namespacer("System.Helpers.Strings [Partial]")

function StringsHelper.Trim(input)
    Scopify(EScopes.Function, StringsHelper)

    Guard.Check.IsString(input, "input")
    
    if input == "" then
        return input
    end
    
    return StringsHelper.Match(input, "^()%s*$")
            and ""
            or StringsHelper.Match(input, "^%s*(.*%S)")
end
