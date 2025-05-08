-- https://wowpedia.fandom.com/wiki/API_StaticPopup_Hide

local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local B = using "[built-ins]" [[  HideStaticPopup = StaticPopup_Hide  ]]

local Namespacer = using "System.Namespacer"

Namespacer:Bind("Pavilion.Warcraft.Popups.BuiltIns.HideStaticPopup", B.HideStaticPopup)
