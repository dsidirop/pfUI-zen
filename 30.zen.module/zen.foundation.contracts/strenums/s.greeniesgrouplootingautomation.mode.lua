local _setfenv, _importer, _namespacer, _setmetatable = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)

    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)
    local _namespacer = _assert(_g.pvl_namespacer_add)
    local _setmetatable = _assert(_g.setmetatable)

    return _setfenv, _importer, _namespacer, _setmetatable
end)()

_setfenv(1, {})

local Reflection = _importer("System.Reflection")
local TablesHelper = _importer("System.Helpers.Tables")

local SGreeniesGrouplootingAutomationMode = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Strenums.SGreeniesGrouplootingAutomationMode")

SGreeniesGrouplootingAutomationMode.JustPass = "just_pass"
SGreeniesGrouplootingAutomationMode.RollNeed = "roll_need"
SGreeniesGrouplootingAutomationMode.RollGreed = "roll_greed"
SGreeniesGrouplootingAutomationMode.LetUserChoose = "let_user_choose"

_setmetatable(SGreeniesGrouplootingAutomationMode, { __index = TablesHelper.RawGetValue })

function SGreeniesGrouplootingAutomationMode.IsValid(value)
    if not Reflection.IsString(value) then
        return false
    end

    return value == SGreeniesGrouplootingAutomationMode.JustPass
            or value == SGreeniesGrouplootingAutomationMode.RollNeed
            or value == SGreeniesGrouplootingAutomationMode.RollGreed
            or value == SGreeniesGrouplootingAutomationMode.LetUserChoose
end
