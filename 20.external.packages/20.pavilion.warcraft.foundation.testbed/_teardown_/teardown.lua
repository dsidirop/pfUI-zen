--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local VWoWUnit = using "[built-in]" [[ VWoWUnit ]]

VWoWUnit.TestsEngine:UnbindZenSharpKeywords() -- this will remove the keyword [testgroup]
