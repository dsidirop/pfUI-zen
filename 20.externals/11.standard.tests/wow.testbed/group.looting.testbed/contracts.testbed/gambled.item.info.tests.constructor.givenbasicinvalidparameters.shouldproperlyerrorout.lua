local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local Try                                    = using "System.Try" --                                                                          @formatter:off
local EWowItemQuality                        = using "Pavilion.Warcraft.Enums.EWowItemQuality"
local GambledItemInfoDto                     = using "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto"

local ValueIsOutOfRangeException             = using "System.Exceptions.ValueIsOutOfRangeException"
local ValueHasInappropriateTypeException     = using "System.Exceptions.ValueIsOfInappropriateTypeException"

local TG, U = using "[testgroup] [tagged]" "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto.Tests" { "pavilion", "grouplooting" } -- @formatter:on

TG:AddDynamicTheory("GambledItemInfoDto.Constructor.GivenBasicInvalidParameters.ShouldProperlyErrorOut",
        function()
            return {
                ["GII.CTOR.GBIP.SPEO.010"] = {
                    Name           = nil,
                    GamblingId     = 123,
                    ItemQuality    = EWowItemQuality.Green,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.020"] = {
                    Name           = "",
                    GamblingId     = 123,
                    ItemQuality    = EWowItemQuality.Green,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.030"] = {
                    Name           = "   ",
                    GamblingId     = 123,
                    ItemQuality    = EWowItemQuality.Green,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.040"] = {
                    Name           = "Foobar",
                    GamblingId     = -1,
                    ItemQuality    = EWowItemQuality.Green,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.050"] = {
                    Name           = "Foobar",
                    GamblingId     = 1,
                    ItemQuality    = nil,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.060"] = {
                    Name           = "Foobar",
                    GamblingId     = 1,
                    ItemQuality    = -1,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.070"] = {
                    Name           = "Foobar",
                    GamblingId     = 1,
                    ItemQuality    = 99, -- <-- this should trigger an error because the value is too high and its way too suspicious for us to allow it 
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.080"] = {
                    Name           = "Foobar",
                    GamblingId     = 1,
                    ItemQuality    = EWowItemQuality.Green,
                    IsBindOnPickUp = { },
                },
                ["GII.CTOR.GBIP.SPEO.090"] = {
                    Name           = "Foobar",
                    GamblingId     = 123,
                    ItemQuality    = EWowItemQuality.Green,
                    IsBindOnPickUp = false,

                    Count          = 99999, -- <-- way too high so it should trigger an error
                },
                ["GII.CTOR.GBIP.SPEO.100"] = {
                    Name            = "Foobar",
                    GamblingId      = 123,
                    ItemQuality     = EWowItemQuality.Green,
                    IsBindOnPickUp  = false,

                    TextureFilepath = "", -- <-- this should trigger an error because its not a valid texture filepath
                },
                ["GII.CTOR.GBIP.SPEO.110"] = {
                    Name            = "Foobar",
                    GamblingId      = 123,
                    ItemQuality     = EWowItemQuality.Green,
                    IsBindOnPickUp  = false,

                    TextureFilepath = "  ", -- <-- this should also trigger an error because its not a valid texture filepath
                },
            }
        end,
        function(options)
            -- ARRANGE
            local properExceptionThrown = false

            -- ACT
            local gambledItemInfo = Try:New(function() --@formatter:off
                return GambledItemInfoDto:New(options)
            end)
            :Catch(ValueIsOutOfRangeException, function()
                -- (using "System.Console").Out:WriteFormatted("%s", ex)
                
                properExceptionThrown = true
            end)
            :Catch(ValueHasInappropriateTypeException, function()
                -- (using "System.Console").Out:WriteFormatted("%s", ex)
                
                properExceptionThrown = true
            end)
            :Run() --@formatter:on

            -- ASSERT
            U.Should.Be.Nil(gambledItemInfo)
            U.Should.Be.Truthy(properExceptionThrown)
        end
)
