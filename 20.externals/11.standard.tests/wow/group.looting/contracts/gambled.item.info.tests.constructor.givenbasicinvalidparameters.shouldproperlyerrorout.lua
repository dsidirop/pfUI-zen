﻿local _setfenv, _importer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)

    return _setfenv, _importer
end)()

_setfenv(1, {}) --                                                                                                           @formatter:off

local Try                                   = _importer("System.Try")

local U                                     = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.VWoWUnit")
local GambledItemInfoDto                    = _importer("Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto")

local EWowItemQuality                       = _importer("Pavilion.Warcraft.Enums.EWowItemQuality")

local ValueIsOutOfRangeException            = _importer("System.Exceptions.ValueIsOutOfRangeException")
local ArgumentHasInappropriateTypeException = _importer("System.Exceptions.ValueIsOfInappropriateTypeException")

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto.Tests",
    Tags = { "pavilion", "grouplooting" },
} --                                                                                                                         @formatter:on

TestsGroup:AddDynamicTheory("GambledItemInfoDto.Constructor.GivenBasicInvalidParameters.ShouldProperlyErrorOut",
        function()
            return {
                ["GII.CTOR.GBIP.SPEO.010"] = {
                    Name = nil,
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.020"] = {
                    Name = "",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.030"] = {
                    Name = "   ",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.040"] = {
                    Name = "Foobar",
                    GamblingId = -1,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.050"] = {
                    Name = "Foobar",
                    GamblingId = 1,
                    ItemQuality = nil,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.060"] = {
                    Name = "Foobar",
                    GamblingId = 1,
                    ItemQuality = -1,
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.070"] = {
                    Name = "Foobar",
                    GamblingId = 1,
                    ItemQuality = 99, -- <-- this should trigger an error because the value is too high and its way too suspicious for us to allow it 
                    IsBindOnPickUp = false,
                },
                ["GII.CTOR.GBIP.SPEO.080"] = {
                    Name = "Foobar",
                    GamblingId = 1,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = { },
                },
                ["GII.CTOR.GBIP.SPEO.090"] = {
                    Name = "Foobar",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,

                    Count = 99999, -- <-- way too high so it should trigger an error
                },
                ["GII.CTOR.GBIP.SPEO.100"] = {
                    Name = "Foobar",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,

                    TextureFilepath = "", -- <-- this should trigger an error because its not a valid texture filepath
                },
                ["GII.CTOR.GBIP.SPEO.110"] = {
                    Name = "Foobar",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,

                    TextureFilepath = "  ", -- <-- this should also trigger an error because its not a valid texture filepath
                },
            }
        end,
        function(options)
            -- ARRANGE
            local properExceptionThrown = false

            -- ACT   todo  introduce fluent assertions
            local gambledItemInfo = Try(function() --@formatter:off
                return GambledItemInfoDto:New(options)
            end)
            :Catch(ValueIsOutOfRangeException, function()
                -- _importer("System.Console").Out:WriteFormatted("%s", ex)
                
                properExceptionThrown = true
            end)
            :Catch(ArgumentHasInappropriateTypeException, function()
                -- _importer("System.Console").Out:WriteFormatted("%s", ex)
                
                properExceptionThrown = true
            end)
            :Run() --@formatter:on

            -- ASSERT
            U.Should.Be.Truthy(gambledItemInfo == nil)
            U.Should.Be.Truthy(properExceptionThrown)
        end
)
