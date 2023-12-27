local _assert, _setfenv, _namespacer_bind, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _setmetatable = _assert(_g.setmetatable)
    local _namespacer_bind = _assert(_g.pvl_namespacer_bind)

    return _assert, _setfenv, _namespacer_bind, _setmetatable
end)()

_setfenv(1, {})

_namespacer_bind("System.Classify", function(selfie, instance)
    _assert(selfie)
    
    instance = instance or {}
    
    _setmetatable(instance, selfie)
    selfie.__index = selfie -- 00

    return instance
    
    -- 00  todo   strictly speaking __index should be set to a function that checks that non-constructor/non-static
    --     todo   method calls are made on the instance and not the class-prototype
end)
