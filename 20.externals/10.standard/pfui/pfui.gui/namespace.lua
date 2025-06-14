local using = assert((_G or getfenv(0) or {})["ZENSHARP:USING"])

local B = using "[built-ins]" [[  PfuiGui = pfUI.gui  ]]

local Namespacer = using "System.Namespacer"

Namespacer:BindRawSymbol("Pavilion.Warcraft.Addons.Zen.Externals.Pfui.Gui", B.PfuiGui)
