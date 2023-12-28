local _setfenv, U = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local U = _assert(_g.VWoWUnit)

    return _setfenv, U
end)()

_setfenv(1, {})

U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Helpers.Strings",
    Tags = { "system", "helpers", "strings" },
}
