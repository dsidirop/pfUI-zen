local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local S                                     = using "System.Helpers.Strings" --                                                               @formatter:off
local EWowItemQuality                       = using "Pavilion.Warcraft.Enums.EWowItemQuality"
local GambledItemInfoDto                    = using "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto"
local EWoWLootingIneligibilityReasonType    = using "Pavilion.Warcraft.Enums.EWoWLootingIneligibilityReasonType"

local TG, U = using "[testgroup.tagged]" "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto.Tests" { "pavilion", "grouplooting" } -- @formatter:on

TG:AddDynamicTheory("GambledItemInfoDto.Constructor.GivenFullValidParameters.ShouldConstructSuccessfully",
        function()
            return {
                ["GII.CTOR.GFVP.SCS.010"] = {
                    Name = "Foobar",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,

                    IsNeedable = true,
                    IsGreedable = true,
                    IsDisenchantable = true,
                    IsTransmogrifiable = true,

                    Count = 1,
                    TextureFilepath = "abc/def/ghi",
                    EnchantingLevelRequiredToDEItem = 0,

                    NeedIneligibilityReasonType = EWoWLootingIneligibilityReasonType.None,
                    GreedIneligibilityReasonType = EWoWLootingIneligibilityReasonType.None,
                    DisenchantIneligibilityReasonType = EWoWLootingIneligibilityReasonType.None,
                },
                ["GII.CTOR.GFVP.SCS.020"] = {
                    Name = " Foobar ",
                    GamblingId = 456,
                    ItemQuality = 14, --  <-- this should pass because we are sensibly future-leaning when it comes to additions to the enum
                    IsBindOnPickUp = true,

                    IsNeedable = true,
                    IsGreedable = true,
                    IsDisenchantable = true,
                    IsTransmogrifiable = true,

                    Count = 3,
                    TextureFilepath = "abc/def/ghi",
                    EnchantingLevelRequiredToDEItem = 999, -- <-- this should pass fine too

                    NeedIneligibilityReasonType = 14, --  <-- these should pass because we are sensibly future-leaning when it comes to additions to the enum
                    GreedIneligibilityReasonType = 14,
                    DisenchantIneligibilityReasonType = 14,
                },
            }
        end,
        function(options)
            -- ARRANGE
            -- ...

            -- ACT
            local gambledItemInfo = GambledItemInfoDto:New(options)

            -- ASSERT
            U.Should.Be.Equivalent(gambledItemInfo:GetName(), S.Trim(options.Name))
            U.Should.Be.Equivalent(gambledItemInfo:GetGamblingId(), options.GamblingId)
            U.Should.Be.Equivalent(gambledItemInfo:GetItemQuality(), options.ItemQuality)
            U.Should.Be.Equivalent(gambledItemInfo:IsBindOnPickUp(), options.IsBindOnPickUp)

            U.Should.Be.Equivalent(gambledItemInfo:IsNeedable(), options.IsNeedable)
            U.Should.Be.Equivalent(gambledItemInfo:IsGreedable(), options.IsGreedable)
            U.Should.Be.Equivalent(gambledItemInfo:IsDisenchantable(), options.IsDisenchantable)
            U.Should.Be.Equivalent(gambledItemInfo:IsTransmogrifiable(), options.IsTransmogrifiable)

            U.Should.Be.Equivalent(gambledItemInfo:GetCount(), options.Count)
            U.Should.Be.Equivalent(gambledItemInfo:GetTextureFilepath(), options.TextureFilepath)
            U.Should.Be.Equivalent(gambledItemInfo:GetEnchantingLevelRequiredToDEItem(), options.EnchantingLevelRequiredToDEItem)

            U.Should.Be.Equivalent(gambledItemInfo:GetNeedIneligibilityReasonType(), options.NeedIneligibilityReasonType)
            U.Should.Be.Equivalent(gambledItemInfo:GetGreedIneligibilityReasonType(), options.GreedIneligibilityReasonType)
            U.Should.Be.Equivalent(gambledItemInfo:GetDisenchantIneligibilityReasonType(), options.DisenchantIneligibilityReasonType)

            U.Should.Be.Equivalent(gambledItemInfo:IsGreyQuality(), options.ItemQuality == EWowItemQuality.Grey)
            U.Should.Be.Equivalent(gambledItemInfo:IsWhiteQuality(), options.ItemQuality == EWowItemQuality.White)
            U.Should.Be.Equivalent(gambledItemInfo:IsBlueQuality(), options.ItemQuality == EWowItemQuality.Blue)
            U.Should.Be.Equivalent(gambledItemInfo:IsGreenQuality(), options.ItemQuality == EWowItemQuality.Green)
            U.Should.Be.Equivalent(gambledItemInfo:IsPurpleQuality(), options.ItemQuality == EWowItemQuality.Purple)
            U.Should.Be.Equivalent(gambledItemInfo:IsOrangeQuality(), options.ItemQuality == EWowItemQuality.Orange)

            U.Should.Be.Equivalent(gambledItemInfo:IsArtifactQuality(), options.ItemQuality == EWowItemQuality.Artifact)
            U.Should.Be.Equivalent(gambledItemInfo:IsLegendaryQuality(), options.ItemQuality == EWowItemQuality.Legendary)
        end
)
