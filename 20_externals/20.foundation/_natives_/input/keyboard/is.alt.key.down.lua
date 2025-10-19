--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local WowNativeIsAltKeyDown = using "[built-in]" [[  IsAltKeyDown  ]]

local function IsAltKeyDownBooleanized()
    return WowNativeIsAltKeyDown() == 1
end

using "[declare] [bind]" "Pavilion.Warcraft.Foundation.Natives.Input.Keyboard.IsAltKeyDown" (IsAltKeyDownBooleanized)
