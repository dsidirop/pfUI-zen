local _setfenv, _importer = (function()
    local _g = assert(_G or getfenv(0))
    local _assert = assert
    local _setfenv = _assert(_g.setfenv)
    _setfenv(1, {})

    local _importer = _assert(_g.pvl_namespacer_get)

    return _setfenv, _importer
end)()

_setfenv(1, {}) --                                                                                                           @formatter:off

local U = _importer("Pavilion.Warcraft.Addons.Zen.Externals.WoW.VWoWUnit")

local StringsHelper = _importer("System.Helpers.Strings")

local EWowItemQuality = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWowItemQuality")
local GambledItemInfo = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.GroupLooting.GambledItemInfo")
local EWoWLootingInelligibilityReasonType = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.Contracts.Enums.EWoWLootingInelligibilityReasonType")

local TestsGroup = U.I:CreateOrUpdateGroup {
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
            local gambledItemInfo = GambledItemInfo:New { -- we want to pass just the mandatory parameters to see if the rest are defaulted properly
                Name = options.Name,
                GamblingId = options.GamblingId,
                ItemQuality = options.ItemQuality,
                IsBindOnPickUp = options.IsBindOnPickUp,
            }

            -- ASSERT
            U.AreEqual(gambledItemInfo:GetName(), StringsHelper.Trim(options.Name))
            U.AreEqual(gambledItemInfo:GetGamblingId(), options.GamblingId)
            U.AreEqual(gambledItemInfo:GetItemQuality(), options.ItemQuality)
            U.AreEqual(gambledItemInfo:IsBindOnPickUp(), options.IsBindOnPickUp)

            U.AreEqual(gambledItemInfo:IsNeedable(), options.IsNeedable)
            U.AreEqual(gambledItemInfo:IsGreedable(), options.IsGreedable)
            U.AreEqual(gambledItemInfo:IsDisenchantable(), options.IsDisenchantable)
            U.AreEqual(gambledItemInfo:IsTransmogrifiable(), options.IsTransmogrifiable)

            U.AreEqual(gambledItemInfo:GetCount(), options.Count)
            U.AreEqual(gambledItemInfo:GetTextureFilepath(), options.TextureFilepath)
            U.AreEqual(gambledItemInfo:GetEnchantingLevelRequiredToDEItem(), options.EnchantingLevelRequiredToDEItem)

            U.AreEqual(gambledItemInfo:GetNeedInelligibilityReasonType(), options.NeedInelligibilityReasonType)
            U.AreEqual(gambledItemInfo:GetGreedInelligibilityReasonType(), options.GreedInelligibilityReasonType)
            U.AreEqual(gambledItemInfo:GetDisenchantInelligibilityReasonType(), options.DisenchantInelligibilityReasonType)

            U.AreEqual(gambledItemInfo:IsGreyQuality(), options.ItemQuality == EWowItemQuality.Grey)
            U.AreEqual(gambledItemInfo:IsWhiteQuality(), options.ItemQuality == EWowItemQuality.White)
            U.AreEqual(gambledItemInfo:IsBlueQuality(), options.ItemQuality == EWowItemQuality.Blue)
            U.AreEqual(gambledItemInfo:IsGreenQuality(), options.ItemQuality == EWowItemQuality.Green)
            U.AreEqual(gambledItemInfo:IsPurpleQuality(), options.ItemQuality == EWowItemQuality.Purple)
            U.AreEqual(gambledItemInfo:IsOrangeQuality(), options.ItemQuality == EWowItemQuality.Orange)
            
            U.AreEqual(gambledItemInfo:IsArtifactQuality(), options.ItemQuality == EWowItemQuality.Artifact)
            U.AreEqual(gambledItemInfo:IsLegendaryQuality(), options.ItemQuality == EWowItemQuality.Legendary)
        end
)
