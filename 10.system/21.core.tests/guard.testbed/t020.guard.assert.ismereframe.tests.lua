--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local WowNativeCreateFrameFunc = using "[built-in]" "CreateFrame"

local Guard = using "System.Guard"

local TG, U = using "[testgroup] [tagged]" "System.Guard.Assert.IsMereFrame" { "system", "guard", "guard-check", "guard-check-mereframe" }

TG:AddDynamicTheory("T020.Guard.Assert.IsMereFrame.GivenGreenInput.ShouldNotThrow",
        function()
            local newElement = WowNativeCreateFrameFunc("Frame")
            newElement:Hide()
        
            return {
                ["GRD.SRT.IMF.GGI.SNT.0000"] = { Value = newElement },
            }
        end,
        function(options)
            -- SETUP
            local action = function() return Guard.Assert.IsMereFrame(options.Value, "options.Value") end
            
            -- ACT + ASSERT
            local result = U.Should.Not.Throw(action)
            
            U.Should.Be.PlainlyEqual(result, options.Value)
        end
)

TG:AddDynamicTheory("T020.Guard.Assert.IsMereFrame.GivenRedInput.ShouldThrow",
        function()
            return {
                ["GRD.SRT.IMF.GRI.ST.0000"] = { Value = nil },
                ["GRD.SRT.IMF.GRI.ST.0010"] = { Value = 1 },
                ["GRD.SRT.IMF.GRI.ST.0020"] = { Value = function() return 123 end },
            }
        end,
        function(options)
            -- SETUP
            local action = function() Guard.Assert.IsMereFrame(options.Value, "options.Value") end
        
            -- ACT + ASSERT
            U.Should.Throw(action, "*options.Value*")
        end
)
