local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Instantiator = using "[declare]" "System.Classes.Instantiator [Partial]"

--
-- note that this utility class is meant to be used in private utility-classes which are not meant to be registered
-- in their own namespace to be publicly consumed
--
-- for run-of-the-mill namespace-classes just use the standard built-in 'self:Instantiate()' approach  
--
-- note that we are using debug.assert instead of guard.assert because this method is used even inside the
-- 'system' project during bootstrapping and guard.assert is not guaranteed to be available during this time
--
function Instantiator:__Call__(otherClassProto, instanceSpecificFields)
    return self.Instantiate(otherClassProto, instanceSpecificFields) -- just use the standard cookie cutter method under the hood
end
