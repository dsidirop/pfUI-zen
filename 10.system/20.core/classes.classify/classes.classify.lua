local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Validation = using "System.Validation"

local MetaTable = using "System.Classes.MetaTable"
local RawTypeSystem = using "System.Language.RawTypeSystem"

local Classify = using "[declare]" "System.Classes.Classify [Partial]"

-- Classify() calls go here
--
-- note that we are using debug.assert instead of guard.assert because this method is used even inside the
-- 'system' project during bootstrapping and guard.assert is not guaranteed to be available during this time
--
function Classify:__Call__(classProto, optionalClassFields)
    Validation.Assert(RawTypeSystem.IsTable(classProto), "classProto was expected to be a table")
    Validation.Assert(RawTypeSystem.IsNilOrTable(classProto), "optionalClassFields was expected to be either a table or nil")

    optionalClassFields = optionalClassFields or {}

    MetaTable.Set(optionalClassFields, classProto)
    classProto.__index = classProto

    return optionalClassFields
end
