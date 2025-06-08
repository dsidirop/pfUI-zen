local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local TG, U = using "[testgroup] [tagged]" "System.Enums" { "system", "enums" }

TG:AddFact("T000.EnumLookup.GivenAttemptToAccessExistingMember.ShouldNotThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local EFoo = using "[declare] [enum]" "T000.Enum.GivenAttemptToAccessNonExistingMember.ShouldThrow.EFoo"

                EFoo.Bar = 1
                
                local _ = EFoo.Bar
            end

            -- ASSERT
            U.Should.Not.Throw(action)
        end
)

TG:AddFact("T050.EnumLookup.GivenAttemptToAccessNonExistingMember.ShouldThrow",
        function()
            -- ARRANGE

            -- ACT
            function action()
                local EFoo = using "[declare] [enum]" "T000.Enum.GivenAttemptToAccessNonExistingMember.ShouldThrow.EFoo"
                
                -- EFoo.Bar = 1

                local _ = EFoo.Bar -- doesnt exist obviously so this should throw
            end

            -- ASSERT
            U.Should.Throw(action)
        end
)

TG:AddTheory("T010.EnumBuiltInIsValidMethod.GivenInvalidValueToCheck.ShouldReturnExpectedVerdict",
        {
            ["EBIIVM.GIVTC.SRER.0000"] = { Value = -1, ExpectedVerdict = false },
            ["EBIIVM.GIVTC.SRER.0010"] = { Value = 0, ExpectedVerdict = false },
            ["EBIIVM.GIVTC.SRER.0020"] = { Value = 1, ExpectedVerdict = true },
            ["EBIIVM.GIVTC.SRER.0030"] = { Value = 2, ExpectedVerdict = true },
            ["EBIIVM.GIVTC.SRER.0040"] = { Value = 3, ExpectedVerdict = false },
            ["EBIIVM.GIVTC.SRER.0050"] = { Value = 4, ExpectedVerdict = false },
            ["EBIIVM.GIVTC.SRER.0060"] = { Value = 5, ExpectedVerdict = false },
        },
        function(options, subTestCaseName)
            -- ARRANGE

            -- ACT
            function action()
                local EFoo = using "[declare] [enum]" ("T010.EnumBuiltInIsValidMethod.GivenInvalidValueToCheck.ShouldReturnExpectedVerdict." .. subTestCaseName .. ".EFoo")

                EFoo.A = 1
                EFoo.B = 2
                
                return EFoo:IsValid(options.Value)
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)
            
            U.Should.Be.PlainlyEqual(result, options.ExpectedVerdict)
        end
)

TG:AddTheory("T020.StringEnumBuiltInIsValidMethod.GivenInvalidValueToCheck.ShouldReturnExpectedVerdict",
        {
            ["SEBIIVM.GIVTC.SRER.0000"] = { Value = "_", ExpectedVerdict = false },
            ["SEBIIVM.GIVTC.SRER.0020"] = { Value = "a", ExpectedVerdict = true },
            ["SEBIIVM.GIVTC.SRER.0030"] = { Value = "b", ExpectedVerdict = true },
            ["SEBIIVM.GIVTC.SRER.0040"] = { Value = ".", ExpectedVerdict = false },
        },
        function(options, subTestCaseName)
            -- ARRANGE

            -- ACT
            function action()
                local EFoo = using "[declare] [enum]" ("T020.StringEnumBuiltInIsValidMethod.GivenInvalidValueToCheck.ShouldReturnExpectedVerdict." .. subTestCaseName .. ".EFoo")

                EFoo.A = "a"
                EFoo.B = "b"

                return EFoo:IsValid(options.Value)
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(result, options.ExpectedVerdict)
        end
)
