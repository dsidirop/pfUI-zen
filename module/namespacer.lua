local _g = assert(_G or getfenv(0))
local _assert = assert

if _g.pavilion_pfui_zen_namespacer then
    return -- already in place
end

local _getn = _assert(_g.table.getn)

local _type = _assert(_g.type)
local _error = _assert(_g.error)
local _pairs = _assert(_g.pairs)

local _gsub = _assert(_g.string.gsub)
local _match = _assert(_g.string.match)
local _format = _assert(_g.string.format)

local function _is_valid_namespace_component(name)
    return _match(name, "^[_%a][%w]*$") ~= nil
end

-- inspired by pfUI.api.strsplit 
function _strsplit(delimiter, subject)
    if not subject then
        return nil
    end

    local pattern = _format("([^%s]+)", delimiter or ":")

    local fields = {}
    _gsub(
            subject,
            pattern,
            function(c)
                fields[_getn(fields) + 1] = c
            end
    )

    return fields
end

local function _namespacer(base_namespace_registry, namespace_path)
    _assert(_type(base_namespace_registry) == "table", "base_namespace_registry must be a table")
    _assert(namespace_path ~= nil and _type(namespace_path) == "string" and namespace_path ~= "", "namespace_path must not be nil")

    local tmp
    local head = base_namespace_registry
    local components = _strsplit(".", namespace_path)
    for _, key in _pairs(components) do
        if not _is_valid_namespace_component(key) then
            _error("Namespace '" .. namespace_path .. "' has component '" .. key .. "' which is invalid: Each component must start with a letter or _ followed by any number of _ or alphanumeric characters.")
        end

        tmp = head[key] or {}
        head[key] = tmp
        head = tmp
    end

    return head
end

_g.pavilion_pfui_zen_namespacer = _namespacer
