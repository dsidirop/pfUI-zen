--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local ComboTranslationsService = using "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.ComboTranslationsService"

local TG, U = using "[testgroup] [tagged]" "Pavilion.Warcraft.Addons.PfuiZen.Foundation.Internationalization.ComboTranslationsService.Tests" { "pavilion", "i18n", "translations" }

TG:AddTheory("T000.ComboTranslationsService.TryTranslate.GivenValidTranslators.ShouldTranslateSuccessfully",
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
                TryTranslate = function(_, _)
                    return nil
                end
            }

            local pfuiTranslatorAsFallbackMock = {
                TryTranslate = function(_, message)
                    return "(Translated) " .. message
                end
            }

            local translationsService = ComboTranslationsService:New(zenAddonTranslatorMock, pfuiTranslatorAsFallbackMock)

            -- ACT
            local action = function()
                return translationsService:TryTranslate(options.Text, options.Color)
            end

            -- ASSERT
            local result = U.Should.Not.Throw(action)

            U.Should.Be.PlainlyEqual(result, options.ExpectedResult)
        end
)
