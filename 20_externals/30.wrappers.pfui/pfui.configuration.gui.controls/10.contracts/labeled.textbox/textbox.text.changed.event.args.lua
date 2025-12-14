--[[@formatter:off]] local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"]); local Scopify = using "System.Scopify"; local EScopes = using "System.EScopes"; Scopify(EScopes.Function, {}) --[[@formatter:on]]

local Guard = using "System.Guard"

local Fields = using "System.Classes.Fields"

local Class = using "[declare]" "Pavilion.Warcraft.Addons.Wrappers.Pfui.Contracts.Configuration.Gui.Controls.LabeledTextbox.TextboxTextChangedEventArgs"

Fields(function(upcomingInstance)
    upcomingInstance._newText = nil

    return upcomingInstance
end)

function Class:GetNewText()
    Scopify(EScopes.Function, self)

    return _newText
end

function Class:ChainSet_NewText(newText)
    Scopify(EScopes.Function, self)

    Guard.Assert.IsString(newText, "newText")

    _newText = newText

    return self
end
