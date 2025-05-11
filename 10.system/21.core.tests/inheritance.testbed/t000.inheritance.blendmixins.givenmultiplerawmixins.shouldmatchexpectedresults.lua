local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get) -- @formatter:off

local Scopify       = using "System.Scopify"
local EScopes       = using "System.EScopes"
local MixinsBlender = using "System.Classes.Mixins.MixinsBlender"

local U = using "[built-in]" [[ VWoWUnit ]] -- @formatter:on         

Scopify(EScopes.Function, {})

local TG = U.TestsEngine:CreateOrUpdateGroup {
    Name = "System.Core.Tests.InheritanceTestbed",
    Tags = { "system", "system-core", "inheritance" }
}

Scopify(EScopes.Function, {})

TG:AddFact("T000.Inheritance.BlendMixins.GivenMultipleRawMixins.ShouldMatchExpectedResults",
        function()
            -- ARRANGE

            -- Create an object
            local player = { x = 0, y = 0 } -- keep this first

            local FooMovable = { x = 0, y = 0 }
            FooMovable.__index = FooMovable

            function FooMovable:Move(x, y)
                U.Should.Be.PlainlyEqual(self, player)

                self.x = self.x + x
                self.y = self.y + y
            end

            function FooMovable:Jump()
                U.Should.Be.PlainlyEqual(self, player)

                return true
            end

            function FooMovable:ShadowStep()
                U.Should.Not.ReachHere("FooMovable:ShadowStep() should not be reached - the fact that it was means something is amiss with the mixin")
            end

            local BarSpeakable = { }
            BarSpeakable.__index = BarSpeakable

            function BarSpeakable:Speak(message)
                U.Should.Be.PlainlyEqual(self, player)

                return "Speakable: " .. message
            end

            function BarSpeakable.SomeUtilityMethod(message)
                U.Should.Not.Be.PlainlyEqual(message, player)

                return message
            end

            function BarSpeakable.AnotherUtilityMethod(message)
                U.Should.Not.Be.PlainlyEqual(message, player)

                return message
            end

            -- Apply both mixins with explicit names
            MixinsBlender.Blend(player, {
                ["IMovable"]   = FooMovable,
                ["ISpeakable"] = BarSpeakable
            })

            -- Override the move method and call base methods using self.asBlendxin
            function player:Move(x, y)
                U.Should.Be.PlainlyEqual(self, player)

                self.asBlendxin.IMovable:Move(x, y)
                return self.asBlendxin.ISpeakable:Speak("I moved to (" .. x .. ", " .. y .. ")")
            end

            function player:ShadowStep()
                -- completely over
                U.Should.Be.PlainlyEqual(self, player)

                return true
            end

            -- function player:Jump() -- dont   we want to test whether the original FooMovable:Jump() will be called
            -- end

            function player:Speak(message)
                U.Should.Be.PlainlyEqual(self, player)

                return self.blendxin:Speak(message)
            end

            --function player.AnotherUtilityMethod(message) -- todo
            --    return "[Wrapped] " .. player.blendxin.AnotherUtilityMethod(message) -- todo  .blendxin_raw?
            --end

            local coords = { x = 5, y = 3 }
            local actualSpeakMessage = ""
            local actualJumpReturnValue = ""
            local actualSomeUtilityMethodReturnValue = ""
            -- local actualAnotherUtilityMethodReturnValue = ""

            -- ACT
            function action()
                player:Move(coords.x, coords.y)
                player:ShadowStep()

                actualSpeakMessage = player:Speak("Hello, world!")
                actualJumpReturnValue = player:Jump() -- this should call the original Jump method from FooMovable
                actualSomeUtilityMethodReturnValue = player.SomeUtilityMethod("Hello, world!")
                -- actualAnotherUtilityMethodReturnValue = player.AnotherUtilityMethod("Hello, world!") -- todo
            end

            -- ASSERT
            U.Should.Not.Throw(action)

            U.Should.Be.Equivalent({ x = player.x, y = player.y }, coords)
            U.Should.Be.PlainlyEqual(actualSpeakMessage, "Speakable: Hello, world!")
            U.Should.Be.PlainlyEqual(actualJumpReturnValue, true)
            U.Should.Be.PlainlyEqual(actualSomeUtilityMethodReturnValue, "Hello, world!")
            -- U.Should.Be.PlainlyEqual(actualAnotherUtilityMethodReturnValue, "[Wrapped] Hello, world!") -- todo
        end
)
