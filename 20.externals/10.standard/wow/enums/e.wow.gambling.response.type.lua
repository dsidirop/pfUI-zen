local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local EWowGamblingResponseType = using "[declare] [enum]" "Pavilion.Warcraft.Enums.EWowGamblingResponseType" -- aka roll-mode

EWowGamblingResponseType.Pass = 0
EWowGamblingResponseType.Need = 1
EWowGamblingResponseType.Greed = 2
-- EWowGamblingResponseType.Disenchant = 3   --not supported in vanilla   introduced in wotlk patch 3.3 fall of the lich king
