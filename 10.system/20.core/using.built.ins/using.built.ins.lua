local globalEnvironment = assert(_G or getfenv(0))

local _assert = assert(globalEnvironment.assert)

local _type = _assert(globalEnvironment.type)
local _next = _assert(globalEnvironment.next)
local _pairs = _assert(globalEnvironment.pairs)
local _debugstack = _assert(globalEnvironment.debugstack)
local _loadstring = _assert(globalEnvironment.loadstring or globalEnvironment.load)
local _namespaceBinder = _assert(globalEnvironment.pvl_namespacer_bind)

local _getBuiltIns = function(builtInsString)
    if _type(builtInsString) ~= "string" then
        _assert(false, "you need to specify the built-ins you want\n\n" .. _debugstack() .. "\n")
    end
    
    local func, errorMessage = _loadstring("return {" .. builtInsString .. "};")
    if func == nil or errorMessage ~= nil then
        _assert(false, "failed to load built-ins: " .. errorMessage .. "\n\n" .. _debugstack() .. "\n")
    end

    local builtIns = func()
    
    if _next(builtIns) == nil then
        _assert(false, "no built-ins loaded\n\n" .. _debugstack() .. "\n")
    end

    for builtInName, builtInValue in _pairs(builtIns) do
        if builtInName == nil or builtInValue == nil then
            _assert(false, "built-in '" .. builtInName .. "' is undefined\n\n" .. _debugstack() .. "\n")
        end
    end

    return builtIns
end

_namespaceBinder("[built-in]", function(builtInString)
    return _getBuiltIns(builtInString)[1]
end)

_namespaceBinder("[built-ins]", _getBuiltIns)
