local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Exception = using "System.Exceptions.Exception"

local U = using "[global]" "VWoWUnit"

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Exceptions",
    Tags = { "system", "exceptions" }
}

Scopify(EScopes.Function, {})

TestsGroup:AddTheory("Exceptions.Exception.Constructor.GivenGreenInput.ShouldNotErrorOut",
        {
            ["EXC.EXC.CTOR.GGI.SNE.0000"] = { Message = nil },
            ["EXC.EXC.CTOR.GGI.SNE.0010"] = { Message = "abc" },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Not.Throw(function()
                Exception:New(options.Message)
            end)
        end
)

TestsGroup:AddTheory("Exceptions.Exception.Constructor.GivenRedInput.ShouldThrowGuardException",
        {
            ["EXC.EXC.CTOR.GRI.STGE.0000"] = { Message = 0 },
            ["EXC.EXC.CTOR.GRI.STGE.0010"] = { Message = { x = 123 } },
            ["EXC.EXC.CTOR.GRI.STGE.0020"] = { Message = function()
                return 123
            end },
            ["EXC.EXC.CTOR.GRI.STGE.0030"] = { Message = "" },
            ["EXC.EXC.CTOR.GRI.STGE.0040"] = { Message = "   " },
        },
        function(options)
            -- ACT + ASSERT
            U.Should.Throw(function()
                Exception:New(options.Message)
            end)
        end
)
