local rainbow_delimiters = require("rainbow-delimiters")

return {
  strategy = {
    [""] = rainbow_delimiters.strategy["global"],
    vim = rainbow_delimiters.strategy["local"],
  },
  query = {
    [""] = "rainbow-delimiters",
    lua = "rainbow-blocks",
  },
  priority = {
    [""] = 110,
    lua = 210,
  },
  highlight = {
    "RainbowDelimiterRed",
    "RainbowDelimiterBlue",
    "RainbowDelimiterGreen",
    "RainbowDelimiterOrange",
    "RainbowDelimiterViolet",
    "RainbowDelimiterCyan",
    "RainbowDelimiterYellow",
  },
}
