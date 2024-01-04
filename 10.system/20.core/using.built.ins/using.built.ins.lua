local globalEnvironment = assert(_G or getfenv(0))

local _assert = assert(globalEnvironment.assert)

local _type = _assert(globalEnvironment.type)
local _pairs = _assert(globalEnvironment.pairs)
local _loadstring = _assert(globalEnvironment.loadstring or globalEnvironment.load)
local _namespaceBinder = _assert(globalEnvironment.pvl_namespacer_bind)

_namespaceBinder("[built-ins]", function(builtInsString)
    if _type(builtInsString) ~= "string" then
        _assert(false, "you need to specify the built-ins you want\n\n" .. _debugstack() .. "\n")
    end

    local builtIns = _assert(_loadstring("return {" .. builtInsString .. "};"))()
    
    for builtInName, builtInValue in _pairs(builtIns) do
        if builtInValue == nil then
            _assert(false, "built-in '" .. builtInName .. "' is undefined\n\n" .. _debugstack() .. "\n")
        end
    end

    return builtIns
end)
