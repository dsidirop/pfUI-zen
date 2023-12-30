local _setfenv, _tostring, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _tostring = _assert(_g.tostring)

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _tostring, _importer, _namespacer
end)()

_setfenv(1, {})

local Scopify = _importer("System.Scopify")
local EScopes = _importer("System.EScopes")

local StringsHelper = _namespacer("System.Helpers.Strings [Partial]")

function StringsHelper.Stringify(value)
    Scopify(EScopes.Function, StringsHelper)
   
    return _tostring(value)
end
