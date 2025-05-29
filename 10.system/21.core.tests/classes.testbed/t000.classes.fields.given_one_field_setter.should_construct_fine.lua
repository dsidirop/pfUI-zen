local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

local TG = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.Classes.Fields.Testbed",
    Tags = { "system", "system-core", "classes", "fields" }
}

Scopify(EScopes.Function, {})

TG:AddFact("T000.Classes.Fields.GivenOneFieldSetter.ShouldConstructFine",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local Fields = using "System.Classes.Fields"
                
                local Class = using "[declare]" "T000.Classes.Fields.GivenOneFieldSetter.ShouldConstructFine.Foobar"

                Fields(function(upcomingInstance) -- we allow multiple field-setters to co-exist
                    upcomingInstance._field1 = 42 -- overrides the previous value
                    upcomingInstance._field2 = "Hello, World!"
                    return upcomingInstance
                end)

                function Class:New()
                    return self:Instantiate()
                end

                return Class:New(), Class
            end

            -- ASSERT
            local instance, classProto = U.Should.Not.Throw(action)

            U.Should.Be.Nil(classProto._field1)
            U.Should.Be.Nil(classProto._field2)

            U.Should.Be.PlainlyEqual(instance._field1, 42)
            U.Should.Be.PlainlyEqual(instance._field2, "Hello, World!")
        end
)
