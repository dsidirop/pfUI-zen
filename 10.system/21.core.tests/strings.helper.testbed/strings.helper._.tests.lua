local U, _setfenv = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local U = _assert(_g.VWoWUnit)

    return U, _setfenv
end)()

_setfenv(1, {})

U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Helpers.Strings",
    Tags = { "system", "helpers", "strings" },
}
