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

function StringsHelper.IsDudString(value)
    Scopify(EScopes.Function, StringsHelper)
    
    Guard.Assert.IsOptionallyString(value)
    
    if value == nil then
        return true
    end
    
    local startIndex = StringsHelper.Find(value, "^()%s*$")
    
    return startIndex ~= nil
end
