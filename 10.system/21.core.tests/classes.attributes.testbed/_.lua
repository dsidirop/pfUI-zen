--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

using "[testgroup] [tagged]" "System.Core.Tests.Classes.Fields.Testbed" { "system", "system-core", "classes", "autocall" }
