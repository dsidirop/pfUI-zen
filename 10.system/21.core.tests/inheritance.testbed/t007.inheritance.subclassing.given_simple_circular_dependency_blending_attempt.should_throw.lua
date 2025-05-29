local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

local TG = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Core.Tests.Classes.Inheritance.Testbed" }

Scopify(EScopes.Function, {})

TG:AddFact("T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow",
        function()
            -- ARRANGE
            do
                local Foo = using "[declare]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Foo [Partial]"

                local _ = using "[declare] [blend]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Bar" {
                    ["Foo"] = Foo,
                }
            end

            -- ACT
            function action()
                local Bar = using "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Bar"

                using "[declare] [blend]" "T007.Inheritance.Subclassing.GivenSimpleCircularDependencyBlendingAttempt.ShouldThrow.Foo" {
                    ["Bar"] = Bar, -- circular dependency
                }
            end

            -- ASSERT
            U.Should.Throw(action, "*[NR.BM.053]*")
        end
)
