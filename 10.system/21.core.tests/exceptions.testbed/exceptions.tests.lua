--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Exception = using "System.Exceptions.Exception"

local TG, U = using "[testgroup] [tagged]" "System.Core.Tests.Exceptions.Testbed" { "system", "exceptions" }

TG:AddTheory("T000.ExceptionConstructor.GivenGreenInput.ShouldNotErrorOut",
        {
            ["EXCCTOR.GGI.SNE.0000"] = { Message = nil },
            ["EXCCTOR.GGI.SNE.0010"] = { Message = "abc" },
        },
        function(options)
            -- ACT + ASSERT
            --U.Should.Not.Throw(function()
            --    Exception:New(options.Message)
            --end)

            Exception:New(options.Message)
        end
)

TG:AddTheory("T010.ExceptionConstructor.GivenRedInput.ShouldThrowGuardException", --@formatter:off
        {
            ["EXCCTOR.GRI.STGE.0000"] = { Message = 0                         },
            ["EXCCTOR.GRI.STGE.0010"] = { Message = { x = 123 }               },
            ["EXCCTOR.GRI.STGE.0020"] = { Message = function() return 123 end },
            ["EXCCTOR.GRI.STGE.0030"] = { Message = ""                        },
            ["EXCCTOR.GRI.STGE.0040"] = { Message = "   "                     },
        }, --@formatter:on
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                Exception:New(options.Message)
            end)
        end
)
