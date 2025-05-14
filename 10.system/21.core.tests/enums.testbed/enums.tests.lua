local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"

local U = using "[built-in]" [[ VWoWUnit ]]

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Enums",
    Tags = { "system", "enums" },
}

Scopify(EScopes.Function, {})

TestsGroup:AddFact("T000.Enum.GivenAttemptToAccessNonExistingMember.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local EFoo = using "[declare] [enum]" "T000.Enum.GivenAttemptToAccessNonExistingMember.ShouldThrow.EFoo"

                local _ = EFoo.Foo -- doesnt exist obviously so this should throw
            end

            -- ASSERT
            U.Should.Throw(action)
        end
)
