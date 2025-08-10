--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Try = using "System.Try"

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddDynamicTheory("T021.Inheritance.Abstraction.GivenUnimplementedMethods.ShouldThrowExceptionOnCallAttempts",
    function()
        return {
            ["INH.ABS.GUM.STEOCA.010"] = {
                Action = function()
                    local AFoo = using "[declare] [abstract]" "INH.ABS.GUM.STEOCA.010.AFoo"

                    using "[abstract]" "Ping"
                    function AFoo:Ping(a, b, c)
                        -- Throw(NotImplementedException:New()) -- this is not needed because the infrastructure already auto-sets the methods properly
                    end

                    local Bar = using "[declare] [blend]" "INH.ABS.GUM.STEOCA.010.Bar" {
                        "Foo", AFoo
                    }

                    function Bar:New()
                        return self:Instantiate()
                    end

                    local barInstance = Bar:New()

                    barInstance:Ping()     -- this should throw
                end,

                ErrorGlob = ""
                    .. "*[System.Exceptions.NotImplementedException]"
                    .. "*[INH.ABS.GUM.STEOCA.010.AFoo:Ping()]"
                    .. "*[INH.ABS.GUM.STEOCA.010.Bar]*"
            },

            ["INH.ABS.GUM.STEOCA.020"] = {
                Action = function()
                    local AFoo1 = using "[declare] [abstract]" "INH.ABS.GUM.STEOCA.020.AFoo1"

                    using "[abstract]" "Ping"
                    function AFoo1:Ping(a, b, c)
                        -- Throw(NotImplementedException:New()) -- this is not needed because the infrastructure already auto-sets the methods properly
                    end

                    local AFoo2 = using "[declare] [abstract] [blend]" "INH.ABS.GUM.STEOCA.020.AFoo2" {
                        "Foo1", AFoo1
                    }

                    local Bar = using "[declare] [blend]" "INH.ABS.GUM.STEOCA.020.Bar" {
                        "Foo2", AFoo2
                    }

                    function Bar:New()
                        return self:Instantiate()
                    end

                    local barInstance = Bar:New()

                    barInstance.Ping()     -- this should throw too
                end,

                ErrorGlob = ""
                    .. "*[System.Exceptions.NotImplementedException]"
                    .. "*[INH.ABS.GUM.STEOCA.020.AFoo1:Ping()]*"
            },
        }
    end,
    function(options)
        -- ARRANGE
        Try:New(function() using "[healthcheck]" end):CatchAll():Run()

        -- ACT + ASSERT        
        U.Should.Throw(options.Action, options.ErrorGlob)

        Try:New(function() using "[healthcheck]" end):CatchAll():Run() -- vital  todo we should support removing faulty classes altogether
    end
)
