--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local ComboTranslationsService = using "Pavilion.Warcraft.Foundation.Internationalization.ComboTranslationsService"

local TG, U = using "[testgroup]" "Pavilion.Warcraft.Foundation.Tests.Internationalization.ComboTranslationsService"

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
        function(options, subTestcaseName)
            -- ARRANGE

            local zenAddonTranslatorMock
            do
                local ITranslatorService = using "Pavilion.Warcraft.Foundation.Contracts.Internationalization.Contracts.ITranslatorService"

                local MockedPrimaryTranslator = using "[declare] [blend]" (subTestcaseName .. ".T005.ComboTranslationsService.TryTranslateWithDefaultCall.GivenValidTranslators.ShouldTranslateSuccessfully.MockedPrimaryTranslator") {
                    "ITranslatorService", ITranslatorService
                }

                using "[autocall]" "TryTranslate"
                function MockedPrimaryTranslator:TryTranslate(message, optionalColor)
                    return nil
                end

                zenAddonTranslatorMock = MockedPrimaryTranslator:New()
            end

            local pfuiTranslatorAsFallbackMock
            do
                local ITranslatorService = using "Pavilion.Warcraft.Foundation.Contracts.Internationalization.Contracts.ITranslatorService"

                local MockedPfuiTranslator = using "[declare] [blend]" (subTestcaseName .. ".T005.ComboTranslationsService.TryTranslateWithDefaultCall.GivenValidTranslators.ShouldTranslateSuccessfully.MockedPfuiTranslator") {
                    "ITranslatorService", ITranslatorService
                }

                using "[autocall]" "TryTranslate"
                function MockedPfuiTranslator:TryTranslate(message, optionalColor)
                    return "(Translated) " .. message
                end

                pfuiTranslatorAsFallbackMock = MockedPfuiTranslator:New()
            end

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
