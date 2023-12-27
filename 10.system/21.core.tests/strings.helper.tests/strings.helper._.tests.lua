local _setfenv, _VWoWUnit = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _VWoWUnit = _assert(_g.VWoWUnit)

    return _setfenv, _VWoWUnit
end)()

_setfenv(1, {})

_VWoWUnit.I:CreateOrUpdateGroup {
    Name = "System.Helpers.Strings",
    Tags = { "system", "helpers", "strings" },
}
