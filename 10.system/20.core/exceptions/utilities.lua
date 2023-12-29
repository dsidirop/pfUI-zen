local _setfenv, _type, _tostring, _importer, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _type = _assert(_g.type)
    local _tostring = _assert(_g.tostring)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _setfenv, _type, _tostring, _importer, _namespacer
end)()

_setfenv(1, {}) --                                                            @formatter:off

local Scopify    = _importer("System.Scopify")
local EScopes    = _importer("System.EScopes")
local Reflection = _importer("System.Reflection") --                          @formatter:on

local Class = _namespacer("System.Exceptions.Utilities")

function Class.FormulateFullExceptionMessage(exception)
    Scopify(EScopes.Function, Class)

    return "[" .. (Reflection.GetNamespaceOfInstance(exception) or "(unknown exception - how!?)") .. "] " .. (exception:GetMessage() or "(exception message not available)")
            .. "\n\n--------------[ Stacktrace ]--------------\n"
            .. (exception:GetStacktrace() or "(stacktrace not available)")
            .. "------------[ End Stacktrace ]------------\n "
end
