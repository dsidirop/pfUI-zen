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

local EWoWLootingInelligibilityReasonType = _namespacer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWoWLootingInelligibilityReasonType") -- aka roll-mode

EWoWLootingInelligibilityReasonType.InappropriateClass = 1
EWoWLootingInelligibilityReasonType.CannotCarryMoreItemsOfThisKind = 2
EWoWLootingInelligibilityReasonType.NotDisenchantableAndThusCantBeLootedByTheDisenchanter = 3
EWoWLootingInelligibilityReasonType.NoEnchanterWithHighEnoughSkillInGroup = 4
EWoWLootingInelligibilityReasonType.NeedRollsDisabledForThisItem = 5

_setmetatable(EWoWLootingInelligibilityReasonType, { __index = TablesHelper.RawGetValue })

function EWoWLootingInelligibilityReasonType.IsValid(value)
    if not Reflection.IsNumber(value) then
        return false
    end

    return value >= EWoWLootingInelligibilityReasonType.InappropriateClass and value <= EWoWLootingInelligibilityReasonType.NeedRollsDisabledForThisItem
end
