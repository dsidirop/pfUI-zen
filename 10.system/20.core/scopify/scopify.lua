local _setfenv, _namespacer_bind = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _namespacer_bind = _assert(_g.pvl_namespacer_bind)
    
    return _setfenv, _namespacer_bind
end)()

_namespacer_bind("System.EScopes", {
    EGlobal = 0,
    EFunction = 1,
})

_namespacer_bind("System.Scopify", _setfenv)
