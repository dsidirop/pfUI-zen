local _time, _setfenv, _namespacer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _time = _assert(_g.time)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    
    return _time, _setfenv, _namespacer
end)()

_setfenv(1, {})

local Class = _namespacer("System.Time [Partial]")

function Class.Now()
    return _time()
end
