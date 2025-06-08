local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local VWoWUnit = using "[built-in]" [[ VWoWUnit ]]

VWoWUnit.TestsEngine:BindZenSharpKeywords() -- this will add keyword [testgroup]
