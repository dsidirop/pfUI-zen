local _assert, _setfenv, _importer, _namespacer_bind, _tostring = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _tostring = _assert(_g.tostring)
    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer_bind = _assert(_g.pvl_namespacer_bind)

    return _assert, _setfenv, _importer, _namespacer_bind, _tostring
end)()

_setfenv(1, {})

local Debug = _importer("System.Debug")

_namespacer_bind("System.Exceptions.Throw", function(exception)
    if exception.ChainSetStacktrace ~= nil then
        exception:ChainSetStacktrace(Debug.Stacktrace(1))
    end

    _assert(false, _tostring(exception)) -- 00

    -- 00  notice that we intentionally use assert() instead of error() here primarily because pfui and other libraries override the vanilla
    --     error() function to make it not throw an exception-error opting to simply print a message to the chat frame  this ofcourse is bad
    --     practice but we have to live with this shortcoming   so we use assert() instead which is typically not overriden
end)
