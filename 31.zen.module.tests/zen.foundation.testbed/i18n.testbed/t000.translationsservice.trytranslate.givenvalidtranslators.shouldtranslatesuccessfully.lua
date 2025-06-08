local using = assert((_G or getfenv(0) or {}).pvl_namespacer_get)

local TranslationsService = using "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.TranslationsService"

local TG, U = using "[testgroup] [tagged]" "Pavilion.Warcraft.Addons.Zen.Foundation.Internationalization.TranslationsService.Tests" { "pavilion", "i18n", "translations" }

TG:AddTheory("T000.TranslationsService.TryTranslate.GivenValidTranslators.ShouldTranslateSuccessfully",
        {
            ["TS.TT.GVT.STS.010"] = {
                Text           = "Foobar",
                Color          = nil,
                ExpectedResult = "(Translated) Foobar",
            },
            ["TS.TT.GVT.STS.020"] = {
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

            local translationsService = TranslationsService:New(zenAddonTranslatorMock, pfuiTranslatorAsFallbackMock)

            -- ACT
            local action = function()
                return translationsService:TryTranslate(options.Text, options.Color)
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(result, options.ExpectedResult)
        end
)
