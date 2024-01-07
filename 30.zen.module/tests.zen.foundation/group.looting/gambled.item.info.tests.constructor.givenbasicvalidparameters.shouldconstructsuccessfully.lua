local _setfenv, _importer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)

    return _setfenv, _importer
end)()

_setfenv(1, {}) --                                                                                                           @formatter:off

local S                                   = _importer("System.Helpers.Strings")

local U                                   = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.VWoWUnit")
local GambledItemInfoDto                  = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.GroupLooting.Contracts.GambledItemInfoDto")

local EWowItemQuality                     = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.Enums.EWowItemQuality")
local EWoWLootingInelligibilityReasonType = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.Enums.EWoWLootingInelligibilityReasonType")

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "Pavilion.Warcraft.Addons.Zen.Foundation.GroupLooting.GambledItemInfo.Tests",
    Tags = { "pavilion", "grouplooting" },
} --                                                                                                                         @formatter:on

TestsGroup:AddDynamicTheory("GambledItemInfo.Constructor.GivenBasicValidParameters.ShouldConstructSuccessfully",
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
