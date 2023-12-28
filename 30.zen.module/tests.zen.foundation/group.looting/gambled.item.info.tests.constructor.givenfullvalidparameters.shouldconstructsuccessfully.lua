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

local TestsGroup = U.TestsEngine:CreateOrUpdateGroup {
    Name = "Pavilion.Warcraft.Addons.Zen.Foundation.GroupLooting.GambledItemInfo.Tests",
    Tags = { "pavilion", "grouplooting" },
} --                                                                                                                         @formatter:on

TestsGroup:AddDynamicTheory("GambledItemInfo.Constructor.GivenFullValidParameters.ShouldConstructSuccessfully",
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

                    NeedInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                    GreedInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
                    DisenchantInelligibilityReasonType = EWoWLootingInelligibilityReasonType.None,
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

                    NeedInelligibilityReasonType = 14, --  <-- these should pass because we are sensibly future-leaning when it comes to additions to the enum
                    GreedInelligibilityReasonType = 14,
                    DisenchantInelligibilityReasonType = 14,
                },
            }
        end,
        function(options)
            -- ARRANGE
            -- ...

            -- ACT
            local gambledItemInfo = GambledItemInfo:New(options)

            -- ASSERT
            U.Assert.AreEqual(gambledItemInfo:GetName(), StringsHelper.Trim(options.Name))
            U.Assert.AreEqual(gambledItemInfo:GetGamblingId(), options.GamblingId)
            U.Assert.AreEqual(gambledItemInfo:GetItemQuality(), options.ItemQuality)
            U.Assert.AreEqual(gambledItemInfo:IsBindOnPickUp(), options.IsBindOnPickUp)

            U.Assert.AreEqual(gambledItemInfo:IsNeedable(), options.IsNeedable)
            U.Assert.AreEqual(gambledItemInfo:IsGreedable(), options.IsGreedable)
            U.Assert.AreEqual(gambledItemInfo:IsDisenchantable(), options.IsDisenchantable)
            U.Assert.AreEqual(gambledItemInfo:IsTransmogrifiable(), options.IsTransmogrifiable)

            U.Assert.AreEqual(gambledItemInfo:GetCount(), options.Count)
            U.Assert.AreEqual(gambledItemInfo:GetTextureFilepath(), options.TextureFilepath)
            U.Assert.AreEqual(gambledItemInfo:GetEnchantingLevelRequiredToDEItem(), options.EnchantingLevelRequiredToDEItem)

            U.Assert.AreEqual(gambledItemInfo:GetNeedInelligibilityReasonType(), options.NeedInelligibilityReasonType)
            U.Assert.AreEqual(gambledItemInfo:GetGreedInelligibilityReasonType(), options.GreedInelligibilityReasonType)
            U.Assert.AreEqual(gambledItemInfo:GetDisenchantInelligibilityReasonType(), options.DisenchantInelligibilityReasonType)

            U.Assert.AreEqual(gambledItemInfo:IsGreyQuality(), options.ItemQuality == EWowItemQuality.Grey)
            U.Assert.AreEqual(gambledItemInfo:IsWhiteQuality(), options.ItemQuality == EWowItemQuality.White)
            U.Assert.AreEqual(gambledItemInfo:IsBlueQuality(), options.ItemQuality == EWowItemQuality.Blue)
            U.Assert.AreEqual(gambledItemInfo:IsGreenQuality(), options.ItemQuality == EWowItemQuality.Green)
            U.Assert.AreEqual(gambledItemInfo:IsPurpleQuality(), options.ItemQuality == EWowItemQuality.Purple)
            U.Assert.AreEqual(gambledItemInfo:IsOrangeQuality(), options.ItemQuality == EWowItemQuality.Orange)

            U.Assert.AreEqual(gambledItemInfo:IsArtifactQuality(), options.ItemQuality == EWowItemQuality.Artifact)
            U.Assert.AreEqual(gambledItemInfo:IsLegendaryQuality(), options.ItemQuality == EWowItemQuality.Legendary)
        end
)
