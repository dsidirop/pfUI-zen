--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Classes.Inheritance.Testbed" { "system", "system-core", "classes", "inheritance" }

TG:AddFact("T002.Inheritance.Subclassing.GivenPlainMixinToBlend.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                using "[declare] [blend]" "T002.Inheritance.Subclassing.GivenPlainMixinToBlend.ShouldThrow.Foobar" { a = 1 }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.020]*")
        end
)