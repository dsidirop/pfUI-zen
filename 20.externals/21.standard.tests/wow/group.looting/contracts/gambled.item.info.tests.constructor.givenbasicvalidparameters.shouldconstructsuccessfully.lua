local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local S                                      = using "System.Helpers.Strings" --                                                               @formatter:off
local EWowItemQuality                        = using "Pavilion.Warcraft.Enums.EWowItemQuality"
local GambledItemInfoDto                     = using "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto"
local EWoWLootingInelligibilityReasonType    = using "Pavilion.Warcraft.Enums.EWoWLootingInelligibilityReasonType"

local TG, U = using "[testgroup.tagged]" "Pavilion.Warcraft.GroupLooting.Contracts.GambledItemInfoDto.Tests" { "pavilion", "grouplooting" } -- @formatter:on

TG:AddDynamicTheory("GambledItemInfoDto.Constructor.GivenBasicValidParameters.ShouldConstructSuccessfully",
        function()
            return {
                ["GII.CTOR.GBVP.SCS.010"] = {
                    Name = "Foobar",
                    GamblingId = 123,
                    ItemQuality = EWowItemQuality.Green,
                    IsBindOnPickUp = false,

                    IsNeedable = true,
                    IsGreedable = true,
                    IsDisenchantable = true,
                    IsTransmogrifiable = true,

                    Count = 1,
                    TextureFilepath = "",
                    EnchantingLevelRequiredToDEItem = 0,

                    NeedInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                    GreedInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                    DisenchantInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                },
                ["GII.CTOR.GBVP.SCS.020"] = {
                    Name = " Foobar ",
                    GamblingId = 456,
                    ItemQuality = EWowItemQuality.Blue,
                    IsBindOnPickUp = true,

                    IsNeedable = true,
                    IsGreedable = true,
                    IsDisenchantable = true,
                    IsTransmogrifiable = true,

                    Count = 1,
                    TextureFilepath = "",
                    EnchantingLevelRequiredToDEItem = 0,

                    NeedInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                    GreedInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                    DisenchantInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                },
                ["GII.CTOR.GBVP.SCS.030"] = {
                    Name = " Foobar ",
                    GamblingId = 456,
                    ItemQuality = 14,
                    IsBindOnPickUp = true,

                    IsNeedable = true,
                    IsGreedable = true,
                    IsDisenchantable = true,
                    IsTransmogrifiable = true,

                    Count = 1,
                    TextureFilepath = "",
                    EnchantingLevelRequiredToDEItem = 0,

                    NeedInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                    GreedInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                    DisenchantInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                },
            }
        end,
        function(options)
            -- ARRANGE
            -- ...

            -- ACT
            local gambledItemInfo = GambledItemInfoDto:New { -- we want to pass just the mandatory parameters to see if the rest are defaulted properly
                Name = options.Name,
                GamblingId = options.GamblingId,
                ItemQuality = options.ItemQuality,
                IsBindOnPickUp = options.IsBindOnPickUp,
            }

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

            U.Should.Be.Equivalent(gambledItemInfo:GetNeedInelligibilityReasonType(), options.NeedInelligibilityReasonType)
            U.Should.Be.Equivalent(gambledItemInfo:GetGreedInelligibilityReasonType(), options.GreedInelligibilityReasonType)
            U.Should.Be.Equivalent(gambledItemInfo:GetDisenchantInelligibilityReasonType(), options.DisenchantInelligibilityReasonType)

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
