local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Scopify = using "System.Scopify"
local EScopes = using "System.EScopes"
local Metatable = using "System.Classes.Metatable"

local TG, U = using "[testgroup]" "System.Core.Tests.Classes.Inheritance.Testbed"

TG:AddFact("T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork",
        function()
            -- ARRANGE
            local FoobarInstance

            -- ACT
            function action()
                -------

                do
                    local IPingTagInterface = using "[declare] [interface]" "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.IPingTagInterface"

                    function IPingTagInterface:Chaching() end
                end
                
                -------

                do
                    local Fields = using "System.Classes.Fields"

                    local Class = using "[declare]" "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Zong"

                    Class._.W = 1 -- statics
                    Class._.F = 2
                    
                    function Class:New()
                        Scopify(EScopes.Function, self)

                        return self:Instantiate()
                    end

                    Fields(function(upcomingInstance)
                        upcomingInstance._a = 1
                        upcomingInstance._b = 2
                        
                        return upcomingInstance
                    end)

                    function Class:Zang()
                        return true
                    end
                end

                -------

                do
                    local Fields = using "System.Classes.Fields"

                    local Class = using "[declare] [abstract]" "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.AGring"

                    function Class:New()
                        Scopify(EScopes.Function, self)

                        return self:Instantiate()
                    end

                    Fields(function(upcomingInstance)
                        upcomingInstance._gringA = 1
                        upcomingInstance._gringB = 2

                        return upcomingInstance
                    end)

                    function Class:Gring()
                        return true
                    end
                end

                -------

                do
                    local Fields = using "System.Classes.Fields"
                    
                    local Zong = using "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Zong"
                    local AGring = using "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.AGring"
                    local IPing = using "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.IPingTagInterface"
                    
                    local Class = using "[declare] [blend]" "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Foobar" {
                        "Zong", Zong,
                        "IPing", IPing,
                        "AGring", AGring
                    }

                    function Class:New()
                        Scopify(EScopes.Function, self)

                        U.Should.Be.True(self.__index == self)
                        U.Should.Not.Be.Nil(self.base)
                        U.Should.Not.Be.Nil(self.asBase)
                        U.Should.Not.Be.Nil(self.asBase.Zong)
                        
                        local newInstance = self:Instantiate() -- order  calls the field-pluggers automatically

                        U.Should.Be.PlainlyEqual(newInstance._a, 1)
                        U.Should.Be.PlainlyEqual(newInstance._b, 10)
                        U.Should.Be.PlainlyEqual(newInstance._gringA, 1)
                        U.Should.Be.PlainlyEqual(newInstance._gringB, 2)
                        
                        U.Should.Be.True(Metatable.Get(newInstance).__index == Metatable.Get(newInstance))
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance))
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).base)
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).asBase)
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).asBase.Zong)
                        U.Should.Not.Be.Nil(Metatable.Get(newInstance).asBase.AGring)
                        -- U.Should.Not.Be.Nil(newInstance.base) -- these should be offlimits and any attempt to access them should generate an exception
                        -- U.Should.Not.Be.Nil(newInstance.asBase) -- these should be offlimits and any attempt to access them should generate an exception

                        newInstance = newInstance.asBase.Zong.New(newInstance) --   order   notice that we are calling it as .New() instead of :New()
                        newInstance = newInstance.asBase.AGring.New(newInstance) --  order   that is intentional because we want to call the base constructor

                        newInstance._sum = newInstance._a + newInstance._b -- finally the constructor can work its own magic after all super-constructors have been invoked above

                        return newInstance
                    end

                    function Class:Chaching()
                        return true
                    end

                    Fields(function(upcomingInstance)
                        upcomingInstance._b = 10
                        upcomingInstance._sum = 0
                        return upcomingInstance
                    end)

                    using "[healthcheck]" -- this should not throw
                end
                
                ------

                do
                    local Foobar = using "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Foobar"
                    
                    FoobarInstance = Foobar:New()

                    FoobarInstance:Gring()
                end                
            end

            -- ASSERT
            U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(FoobarInstance._a, 1)
            U.Should.Be.PlainlyEqual(FoobarInstance._b, 10)
            U.Should.Be.PlainlyEqual(FoobarInstance._sum, 11)

            local ZongProto = using "T050.Inheritance.Subclassing.GivenGreenInterfaceAndConcreteBaseClass.ShouldWork.Zong"
            U.Should.Be.PlainlyEqual(FoobarInstance._.W, ZongProto._.W)
            U.Should.Be.PlainlyEqual(FoobarInstance._.F, ZongProto._.F)

            U.Should.Not.Be.Nil(FoobarInstance.base) --   we do allow interfaces to provide default implementations like in
            U.Should.Not.Be.Nil(FoobarInstance.asBase) -- the latest versions of C# and Java so these members should not be nil

            U.Should.Be.Nil(FoobarInstance.asBase.Zong._a) -- these members should never be
            U.Should.Be.Nil(FoobarInstance.asBase.Zong._b) -- initialized at the proto level

            U.Should.Not.Be.Nil(FoobarInstance.asBase.Zong)
            U.Should.Not.Be.Nil(FoobarInstance.asBase.Zong.Zang)
            U.Should.Not.Be.Nil(FoobarInstance.asBase.IPing)
            U.Should.Not.Be.Nil(FoobarInstance.asBase.AGring)
        end
)
