local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

local TG = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.Classes.Inheritance.Testbed",
    Tags = { "system", "system-core", "classes", "inheritance" }
}

Scopify(EScopes.Function, {})

-- todo   add tests for Reflection.IsInstanceOf(<instance>, <proto>) + associated Guards
-- todo   add tests for Reflection.IsInstanceImplementing(<instance>, <interface-proto>) + associated Guards
-- todo   add support + tests for .CastAs(), .IsCastableAs(), .TryCastAs()
-- todo   enhance try-catch to support catching base-exceptions too
--
-- todo   figure out what to do with the inheritance of the __tostring() method from the base class (is it a static method or what?) 
-- todo   support passing arrays too for the mixins (as nameless mixins)

TG:AddFact("T002.Inheritance.Subclassing.GivenPlainMixinToBlend.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                using "[declare] [blend]" "T002.Inheritance.Subclassing.GivenPlainMixinToBlend.ShouldThrow.Foobar" { a = 1 }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.052]*")
        end
)