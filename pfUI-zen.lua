---@diagnostic disable: undefined-global
pfUI:RegisterModule("Zen", "vanilla:tbc", function ()
  local _ = {
    T = T,
    pfUI = pfUI,
  } ---@diagnostic enable: undefined-global

  _.pfUI.gui.dropdowns.Zen_green_items_roll = {
    "need:" .. _.T["Need"],
    "greed:" .. _.T["Greed"],
    "pass:" .. _.T["Pass"]
  }
end)