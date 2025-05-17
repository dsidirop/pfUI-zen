local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

local TG = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.InheritanceTestbed",
    Tags = { "system", "system-core", "inheritance" }
}

Scopify(EScopes.Function, {})

-- todo   add tests for Reflection.IsInstanceOf(<instance>, <proto>) + associated Guards
-- todo   add tests for Reflection.Is(<instance>, <proto>) + associated Guards
-- todo   add tests for Reflection.IsImplementingInterface(<instance>, <interface-proto>) + associated Guards
-- todo   add support + tests for .CastAs(), .IsCastableAs(), .TryCastAs()
--
-- todo   figure out what to do with the inheritance of the __tostring() method from the base class (is it a static method or what?) 
-- todo   support passing arrays too for the mixins (as nameless mixins)

TG:AddFact("T002.Inheritance.NamespaceBlending.GivenPlainMixinToBlend.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                using "[declare] [blend]" "T002.Inheritance.NamespaceBlending.GivenPlainMixinToBlend.ShouldThrow.Foobar" { a = 1 }
            end

            -- ASSERT
            U.Should.Throw(action)
        end
)