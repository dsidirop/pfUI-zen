-- inspired by pfUI-eliteOverlay.lua
local function Main(_pfUI)
    _pfUI:RegisterModule("Zen", "vanilla:tbc", function()
        setfenv(1, {}) -- we deliberately disable any and all implicit access to global variables inside this function    

        local _g = _pfUI:GetEnvironment()

        local _c = _g.assert(_g.pfUI.env.C) -- pfUI config
        local _t = _g.assert(_g.pfUI.env.T) -- pfUI translations
        local _error = _g.assert(_g.error)
        local _print = _g.assert(_g.print)
        local _format = _g.assert(_g.string.format)
        local _setfenv = _g.assert(_g.setfenv)
        local _pfuiGui = _g.assert(_g.pfUI.gui)
        local _tostring = _g.assert(_g.tostring)
        local _importer = _g.assert(_g.pvl_namespacer_get)

        local _getAddOnInfo = _g.assert(_g.GetAddOnInfo) -- wow api   todo  put this in a custom class called Zen.AddonsHelpers or something

        local Enumerable = _importer("Pavilion.Warcraft.Addons.Zen.Externals.MTALuaLinq.Enumerable")
        local KeystrokesListener = _importer("Pavilion.Warcraft.Addons.Zen.Foundation.UI.Listeners.Keystrokes.KeystrokesListener")
        local UserPreferencesForm = _importer("Pavilion.Warcraft.Addons.Zen.Controllers.UI.Pfui.Forms.UserPreferencesForm")
        local StartZenEngineCommand = _importer("Pavilion.Warcraft.Addons.Zen.Controllers.Contracts.Commands.ZenEngine.RestartEngineCommand")
        local ZenEngineCommandHandlersService = _importer("Pavilion.Warcraft.Addons.Zen.Domain.CommandingServices.ZenEngineCommandHandlersService")
        local UserPreferencesServiceQueryable = _importer("Pavilion.Warcraft.Addons.Zen.Persistence.Services.AddonSettings.UserPreferences.ServiceQueryable")

        local addon = {
            ownName = "Zen",
            fullName = "pfUI [Zen]",
            folderName = "pfUI-Zen",

            ownNameColored = "|cFF7FFFD4Zen|r",
            fullNameColored = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r",

            fullNameColoredForErrors = "|cff33ffccpf|r|cffffffffUI|r|cffaaaaaa [|r|cFF7FFFD4Zen|r|cffaaaaaa]|r|cffff5555"
        }

        local addonPath = Enumerable -- @formatter:off   detect current addon path
                            .FromList({ "", "-dev", "-master", "-tbc", "-wotlk" })
                            :Select(function (postfix)
                                local name, _, _, enabled = _getAddOnInfo(addon.folderName .. postfix)
                                return { path = name, enabled = enabled or 0 }
                            end)
                            :Where(function (x) return x.enabled == 1 end)
                            :Select(function (x) return x.path end)
                            :FirstOrDefault() -- @formatter:on

        if (not addonPath) then
            _error(_format("[PFUIZ.IM000] %s : Failed to find addon folder - please make sure that the addon is installed correctly!", addon.fullNameColoredForErrors))
            return
        end

        if (not _pfuiGui.CreateGUIEntry) then
            _error(_format("[PFUIZ.IM010] %s : The addon needs a recent version of pfUI (2023+) to work as intended - please update pfUI and try again!", addon.fullNameColoredForErrors))
            return
        end

        UserPreferencesForm -- @formatter:off
                :New(_t, _pfuiGui)
                :EventRequestingCurrentUserPreferences_Subscribe(function(_, ea)
                    ea.Response.UserPreferences = UserPreferencesServiceQueryable:New():GetAllUserPreferences()
                end)
                :Initialize() -- @formatter:on

        ZenEngineCommandHandlersService:New():Handle_RestartEngineCommand(StartZenEngineCommand:New())

        --KeystrokesListener.I:EventKeyDown_Subscribe(function(_, ea)
        --    _print("** ea:GetKey()=" .. ea:GetKey())
        --    _print("** ea:HasModifierAlt()=" .. _tostring(ea:HasModifierAlt()))
        --    _print("** ea:HasModifierShift()=" .. _tostring(ea:HasModifierShift()))
        --    _print("** ea:HasModifierControl()=" .. _tostring(ea:HasModifierControl()))
        --end)
    end)
end

Main(assert(pfUI))
