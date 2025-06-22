local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Classes.Inheritance.Testbed" { "system", "system-core", "classes", "inheritance" }

-- todo   add support + tests for .CastAs(), .IsCastableAs(), .TryCastAs()
-- todo   enhance try-catch to support catching base-exceptions too
--
-- todo   figure out what to do with the inheritance of the __tostring() method from the base class (is it a static method or what?) 

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