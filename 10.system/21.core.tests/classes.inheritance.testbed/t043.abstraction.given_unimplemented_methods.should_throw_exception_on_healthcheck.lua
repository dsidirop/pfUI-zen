--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Try = using "System.Try"

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddDynamicTheory("T021.Inheritance.Abstraction.GivenUnimplementedMethods.ShouldThrowExceptionOnHealthcheck",
    function()
        return {
            ["INH.ABS.GUM.STEOHC.000"] = {
                Action = function()
                    local AFoo1 = using "[declare] [abstract]" "INH.ABS.GUM.STEOHC.000.AFoo1"

                    using "[abstract]" "Ping"
                    function AFoo1:Ping(a, b, c)
                        -- Throw(NotImplementedException:New()) -- this is not needed because the infrastructure already auto-sets the methods properly
                    end

                    local AFoo2 = using "[declare] [abstract] [blend]" "INH.ABS.GUM.STEOHC.000.AFoo2" {
                        "Foo1", AFoo1
                    }

                    local Bar = using "[declare] [blend]" "INH.ABS.GUM.STEOHC.000.Bar" {
                        "Foo2", AFoo2
                    }

                    function Bar:New()
                        return self:Instantiate()
                    end

                    using "[healthcheck]"     -- this should throw
                end,

                ErrorGlob = ""
                    .. "*[NR.HCR.RN.020]*"
                    .. "*[NR.ENT.HCI.010]*"
                    .. "*[INH.ABS.GUM.STEOHC.000.Bar]*"
                    .. "*[INH.ABS.GUM.STEOHC.000.AFoo1:Ping()]*"
            },

            ["INH.ABS.GUM.STEOHC.010"] = {
                Action = function()
                    local IFoo1 = using "[declare] [interface]" "INH.ABS.GUM.STEOHC.010.IFoo1"

                    function IFoo1:Ping(a, b, c)
                    end

                    local Bar = using "[declare] [abstract] [blend]" "INH.ABS.GUM.STEOHC.010.Bar" {
                        "IFoo1", IFoo1,
                    }

                    function Bar:New()
                        return self:Instantiate()
                    end

                    using "[healthcheck]" -- this should throw
                end,

                ErrorGlob = ""
                    .. "*[NR.ENT.HCI.010]*"
                    .. "*[INH.ABS.GUM.STEOHC.010.Bar]*"
                    .. "*[INH.ABS.GUM.STEOHC.010.IFoo1:Ping()]*"
            },
            
            ["INH.ABS.GUM.STEOHC.020"] = {
                Action = function()
                    local IFoo1 = using "[declare] [interface]" "INH.ABS.GUM.STEOHC.020.IFoo1"

                    function IFoo1:Ping(a, b, c)
                    end

                    local Bar = using "[declare] [abstract] [blend]" "INH.ABS.GUM.STEOHC.020.Bar" {
                        "IFoo1", IFoo1,
                    }

                    --function Bar:Ping(a, b, c) --not implemented
                    --end

                    function Bar:New()
                        return self:Instantiate()
                    end

                    using "[healthcheck]" -- this should throw
                end,

                ErrorGlob = ""
                    .. "*[NR.ENT.HCI.010]*"
                    .. "*[INH.ABS.GUM.STEOHC.020.Bar]*"
                    .. "*[INH.ABS.GUM.STEOHC.020.IFoo1:Ping()]*"
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
