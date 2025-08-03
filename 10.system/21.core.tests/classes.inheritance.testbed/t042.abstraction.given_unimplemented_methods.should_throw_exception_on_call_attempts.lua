--[[@formatter:off]]
local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes =
using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

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

            ["INH.ABS.GUM.STEOCA.030"] = {
                Action = function()
                    local AFoo1 = using "[declare] [abstract]" "INH.ABS.GUM.STEOCA.030.AFoo1"

                    using "[abstract]" "Ping"
                    function AFoo1:Ping(a, b, c)
                        -- Throw(NotImplementedException:New()) -- this is not needed because the infrastructure already auto-sets the methods properly
                    end

                    local AFoo2 = using "[declare] [abstract] [blend]" "INH.ABS.GUM.STEOCA.030.AFoo2" {
                        "Foo1", AFoo1
                    }

                    local Bar = using "[declare] [blend]" "INH.ABS.GUM.STEOCA.030.Bar" {
                        "Foo2", AFoo2
                    }

                    function Bar:New()
                        return self:Instantiate()
                    end

                    using "[healthcheck]"     -- this should throw
                end,

                ErrorGlob = ""
                    .. "*[NR.ENT.HCI.010]*"
                    .. "*[INH.ABS.GUM.STEOCA.030.Bar]*"
                    .. "*[INH.ABS.GUM.STEOCA.030.AFoo2:Ping()]*"
            },

            ["INH.ABS.GUM.STEOCA.040"] = {
                Action = function()
                    local IFoo1 = using "[declare] [interface]" "INH.ABS.GUM.STEOCA.040.IFoo1"

                    function IFoo1:Ping(a, b, c)
                    end

                    local Bar = using "[declare] [blend]" "INH.ABS.GUM.STEOCA.040.Bar" {
                        "IFoo1", IFoo1
                    }

                    function Bar:New()
                        return self:Instantiate()
                    end

                    using "[healthcheck]" -- this should throw
                end,

                ErrorGlob = ""
                    .. "*[NR.ENT.HCI.010]*"
                    .. "*[INH.ABS.GUM.STEOCA.040.Bar]*"
                    .. "*[INH.ABS.GUM.STEOCA.040.IFoo1:Ping()]*"
            },
        }
    end,
    function(options)
        -- ARRANGE

        -- ACT + ASSERT
        U.Should.Throw(options.Action, options.ErrorGlob)
    end
)
