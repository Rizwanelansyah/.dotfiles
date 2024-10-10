local act = require("nvim-navbuddy.actions")

return {
  icons = V.opt("lsp.kinds"),
  mappings = {
    ["<Left>"] = act.parent(),
    ["<Right>"] = act.children(),
  },
  window = {
    border = { " ", " ", " ", " ", " ", " ", " ", " " },
    size = { height = "40%", width = "100%" },
    position = { row = "100%", col = "0%" },
    scrollof = 2,
  },
  node_markers = {
    enabled = true,
    icons = {
      leaf = "  ",
      leaf_selected = "<| ",
      branch = ">> ",
    },
  },
}
