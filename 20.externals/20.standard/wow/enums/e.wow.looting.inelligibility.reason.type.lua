local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local EWoWLootingInelligibilityReasonType = using "[declare:enum]" "Pavilion.Warcraft.Enums.EWoWLootingInelligibilityReasonType" -- aka roll-mode

EWoWLootingInelligibilityReasonType.None = 0 -- green
EWoWLootingInelligibilityReasonType.InappropriateClass = 1
EWoWLootingInelligibilityReasonType.CannotCarryMoreItemsOfThisKind = 2
EWoWLootingInelligibilityReasonType.NotDisenchantableAndThusCantBeLootedByTheDisenchanter = 3
EWoWLootingInelligibilityReasonType.NoEnchanterWithHighEnoughSkillInGroup = 4
EWoWLootingInelligibilityReasonType.NeedRollsDisabledForThisItem = 5
