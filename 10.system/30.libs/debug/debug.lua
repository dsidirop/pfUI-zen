local _assert, _setfenv, _debugstack, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _debugstack = _assert(_g.debugstack)
    local _namespacer = _assert(_g.pvl_namespacer_add)

    return _assert, _setfenv, _debugstack, _namespacer
end)()

_setfenv(1, {})

local Debug = _namespacer("System.Debug")

Debug.Assert = _assert
Debug.Stacktrace = _debugstack
