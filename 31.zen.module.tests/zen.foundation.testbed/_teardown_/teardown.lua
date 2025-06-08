local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local VWoWUnit = using "[built-in]" [[ VWoWUnit ]]

VWoWUnit.TestsEngine:UnbindZenSharpKeywords() -- this will add keyword [testgroup]
