local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local EWowItemQuality = using "[declare:enum]" "Pavilion.Warcraft.Enums.EWowItemQuality" -- @formatter:off

EWowItemQuality.Poor        = 0 --    grey      https://wowwiki-archive.fandom.com/wiki/API_ITEM_QUALITY_COLORS
EWowItemQuality.Common      = 1 --    white
EWowItemQuality.Uncommon    = 2 --    green
EWowItemQuality.Rare        = 3 --    blue
EWowItemQuality.Epic        = 4 --    purple
EWowItemQuality.Legendary   = 5 --    orange   vanilla wow does have some artifacts like thunderfury sulfuras andonisus and atiesh
EWowItemQuality.Artifact    = 6 --    gold     this came in legion 7.0.3
-- EWowItemQuality.Heirloom = 7 --    this came in wotlk 3.0.2
-- EWowItemQuality.WoWToken = 8 --    this is out of scope for us

EWowItemQuality.Grey        = EWowItemQuality.Poor -- aliases
EWowItemQuality.White       = EWowItemQuality.Common
EWowItemQuality.Green       = EWowItemQuality.Uncommon
EWowItemQuality.Blue        = EWowItemQuality.Rare
EWowItemQuality.Purple      = EWowItemQuality.Epic
EWowItemQuality.Orange      = EWowItemQuality.Legendary
EWowItemQuality.Gold        = EWowItemQuality.Artifact -- @formatter:on
