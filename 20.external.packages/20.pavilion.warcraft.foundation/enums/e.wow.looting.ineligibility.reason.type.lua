--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {})  --[[@formatter:on]]

local EWoWLootingIneligibilityReasonType = using "[declare] [enum]" "Pavilion.Warcraft.Foundation.Enums.EWoWLootingIneligibilityReasonType" --@formatter:off    aka roll-mode

EWoWLootingIneligibilityReasonType.None                                                  = 0 -- green
EWoWLootingIneligibilityReasonType.InappropriateClass                                    = 1
EWoWLootingIneligibilityReasonType.CannotCarryMoreItemsOfThisKind                        = 2
EWoWLootingIneligibilityReasonType.NotDisenchantableAndThusCantBeLootedByTheDisenchanter = 3
EWoWLootingIneligibilityReasonType.NoEnchanterWithHighEnoughSkillInGroup                 = 4
EWoWLootingIneligibilityReasonType.NeedRollsDisabledForThisItem                          = 5
