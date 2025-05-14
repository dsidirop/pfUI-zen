local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local EWoWLootingIneligibilityReasonType = using "[declare] [enum]" "Pavilion.Warcraft.Enums.EWoWLootingIneligibilityReasonType" -- aka roll-mode

EWoWLootingIneligibilityReasonType.None = 0 -- green
EWoWLootingIneligibilityReasonType.InappropriateClass = 1
EWoWLootingIneligibilityReasonType.CannotCarryMoreItemsOfThisKind = 2
EWoWLootingIneligibilityReasonType.NotDisenchantableAndThusCantBeLootedByTheDisenchanter = 3
EWoWLootingIneligibilityReasonType.NoEnchanterWithHighEnoughSkillInGroup = 4
EWoWLootingIneligibilityReasonType.NeedRollsDisabledForThisItem = 5
