﻿local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Nils = using "System.Nils"

local TG, U = using "[testgroup] [tagged]" "System.Nils" { "system", "nils" }

TG:AddTheory("Nils.Coalesce.GivenGreenInput.ShouldReturnExpectedValues", -- @formatter:off
        {
            ["NILS.COA.GGI.SREV.0000"] = { Value = nil,                         FallbackValue = 1,   ExpectValueNotFallbackValue = false },
            ["NILS.COA.GGI.SREV.0010"] = { Value = 0,                           FallbackValue = 1,   ExpectValueNotFallbackValue = true  },
            ["NILS.COA.GGI.SREV.0020"] = { Value = 1,                           FallbackValue = 2,   ExpectValueNotFallbackValue = true  },
            ["NILS.COA.GGI.SREV.0030"] = { Value = "abc",                       FallbackValue = 1,   ExpectValueNotFallbackValue = true  },
            ["NILS.COA.GGI.SREV.0040"] = { Value = {},                          FallbackValue = 1,   ExpectValueNotFallbackValue = true  },
            ["NILS.COA.GGI.SREV.0050"] = { Value = function() return 123 end,   FallbackValue = 1,   ExpectValueNotFallbackValue = true  },
                                                                         
            ["NILS.COA.GGI.SREV.0060"] = { Value = true,                        FallbackValue = 1,   ExpectValueNotFallbackValue = true  },
            ["NILS.COA.GGI.SREV.0070"] = { Value = false,                       FallbackValue = 1,   ExpectValueNotFallbackValue = true  },
        }, -- @formatter:on
        function(options)
            -- ARRANGE
            local returnedValue
            local expectedValue = (function()
                if options.ExpectValueNotFallbackValue then
                    return options.Value
                end

                return options.FallbackValue
            end)()

            -- ACT
            returnedValue = U.Should.Not.Throw(function()
                return Nils.Coalesce(options.Value, options.FallbackValue) -- options.Value ?? options.FallbackValue
            end)

            -- ASSERT
            U.Should.Be.PlainlyEqual(expectedValue, returnedValue)
        end
)
