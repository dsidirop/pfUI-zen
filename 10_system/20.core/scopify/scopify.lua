--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]) --[[@formatter:on]]

local Global = using "System.Global"

using "[declare] [bind]" "System.Scopify" (Global.setfenv or function() --[[dud]] end) -- bear in mind that in lua 5.2+ setfenv is gone 
using "[declare] [bind]" "System.EScopes" ({ EGlobal = 0, EFunction = 1 }) -- we avoid declaring a formal enum here for the sake of performance 
