local function root_label(path)
  local result = path
  local home = vim.env.HOME
  result = path:gsub("^" .. home, ""):gsub("^/", string.format("%s %s", "", "  ")):gsub("/", "  ")
  return result
end

return {
  hijack_cursor = true,
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
  },
  renderer = {
    add_trailing = true,
    full_name = true,
    root_folder_label = root_label,
    highlight_git = "icon",
    highlight_diagnostics = "icon",
    highlight_modified = "icon",
    highlight_clipboard = "all",
    highlight_bookmarks = "icon",
    indent_markers = {
      enable = true,
      icons = {
        corner = " ",
        edge = " ",
        item = " ",
        bottom = " ",
        none = " ",
      },
    },
    icons = {
      diagnostics_placement = "after",
      modified_placement = "after",
      hidden_placement = "after",
      git_placement = "after",
      symlink_arrow = " -> ",
      glyphs = {
        default = "",
        symlink = "",
        modified = "",
        hidden = "",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
      },
    },
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  modified = {
    enable = true,
  },
  live_filter = {
    prefix = "  ",
  },
  ui = {
    confirm = {
      default_yes = true,
    },
  },
  filters = {
    git_ignored = false,
  },
}
