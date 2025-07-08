--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local ComboTranslationsService = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.ComboTranslationsService"

local TG, U = using "[testgroup]" "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.ComboTranslationsService.Tests"

TG:AddTheory("T005.ComboTranslationsService.TryTranslateWithDefaultCall.GivenValidTranslators.ShouldTranslateSuccessfully",
        {
            ["TS.TTWDC.GVT.STS.010"] = {
                Text           = "Foobar",
                Color          = nil,
                ExpectedResult = "(Translated) Foobar",
            },
            ["TS.TTWDC.GVT.STS.020"] = {
                Text           = "Foobar",
                Color          = "|cFF00FF00",
                ExpectedResult = "|cFF00FF00(Translated) Foobar|r",
            },
        },
        function(options)
            -- ARRANGE
            local zenAddonTranslatorMock = {
                Translate = function(_, _)
                    return nil
                end
            }

            local pfuiTranslatorAsFallbackMock = {
                Translate = function(_, message)
                    return "(Translated) " .. message
                end
            }

            local translationsService = ComboTranslationsService:New(zenAddonTranslatorMock, pfuiTranslatorAsFallbackMock)

            -- ACT
            local action = function()
                return translationsService(options.Text, options.Color)
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(result, options.ExpectedResult)
        end
)
