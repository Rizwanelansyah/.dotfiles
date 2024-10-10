return {
  defaults = {
    borderchars = {
      prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
      results = { " ", " ", " ", " ", " ", " ", " ", " " },
      preview = { "─", "│", "─", " ", "─", "┐", "┘", "─" },
    },
    prompt_prefix = "  ",
    selection_caret = " ",
    multi_icon = "+",
    results_title = "  Items",
    prompt_title = "  Search",
  },
  extensions = {
    ["ui-select"] = require("telescope.themes").get_dropdown({
      borderchars = {
        prompt = { " ", " ", " ", " ", " ", " ", " ", " " },
        results = { " ", " ", " ", " ", " ", " ", " ", " " },
      },
    }),
  },
  pickers = {
    find_files = {
      prompt_title = "  Find Files",
    },
    live_grep = {
      prompt_title = "󰦨 Live Grep",
    },
    help_tags = {
      prompt_title = " Help Tags",
    },
  },
}
