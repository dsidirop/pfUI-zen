--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]) --[[@formatter:on]]

local LuaSetfenv = using "[built-in]" [[  setfenv  ]]

using "[declare] [bind]" "System.Scopify" (LuaSetfenv)
using "[declare] [bind]" "System.EScopes" ({ EGlobal = 0, EFunction = 1 }) -- we avoid declaring a formal enum here for the sake of performance 
