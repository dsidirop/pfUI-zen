local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

local TG = U.TestsEngine:CreateOrUpdateGroup { Name = "System.Core.Tests.InheritanceTestbed" }

Scopify(EScopes.Function, {})

TG:AddFact("T006.Inheritance.Subclassing.GivenEmptyMixinsTableToBlend.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                using "[declare] [blend]" "T006.Inheritance.Subclassing.GivenEmptyMixinsTableToBlend.ShouldThrow.Ping" {}
            end

            -- ASSERT
            U.Should.Throw(action)
        end
)
