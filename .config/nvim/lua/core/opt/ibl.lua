local highlight = {
  "RainbowDelimiterRed",
  "RainbowDelimiterBlue",
  "RainbowDelimiterGreen",
  "RainbowDelimiterOrange",
  "RainbowDelimiterViolet",
  "RainbowDelimiterCyan",
  "RainbowDelimiterYellow",
}

---@type ibl.config
return {
  scope = {
    show_end = true,
    show_start = true,
    enabled = true,
  },
  indent = {
    char = "▏",
    highlight = highlight,
  },
}
