local function get_highlight(name)
  return vim.api.nvim_get_hl(0, { name = name, create = false })
end

return {
  bg0 = "#202328",
  bg1 = "#312742",
  bg2 = "#312742",
  fg = "#bbc2cf",
  yellow = "#ECBE7B",
  darkblue = "#081633",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  bright_bg = get_highlight("Folded").bg,
  bright_fg = get_highlight("Folded").fg,
  red = get_highlight("DiagnosticError").fg,
  dark_red = get_highlight("DiffDelete").bg,
  green = get_highlight("String").fg,
  blue = get_highlight("Function").fg,
  gray = get_highlight("NonText").fg,
  orange = get_highlight("Constant").fg,
  purple = get_highlight("Statement").fg,
  cyan = get_highlight("Special").fg,
  diag_warn = get_highlight("DiagnosticWarn").fg,
  diag_error = get_highlight("DiagnosticError").fg,
  diag_hint = get_highlight("DiagnosticHint").fg,
  diag_info = get_highlight("DiagnosticInfo").fg,
  git_del = get_highlight("diffDeleted").fg,
  git_add = get_highlight("diffAdded").fg,
  git_change = get_highlight("diffChanged").fg,
}
