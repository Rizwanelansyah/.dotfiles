local sev = vim.diagnostic.severity
local icons = V.opt("icons")
local icon_map = {
  [sev.ERROR] = icons.error,
  [sev.WARN] = icons.warning,
  [sev.INFO] = icons.info,
  [sev.HINT] = icons.hint,
}

---@type vim.diagnostic.Opts
return {
  signs = {
    text = icon_map,
  },
  virtual_text = {
    format = function(diagnostic)
      return string.format(
        "%s%s %s",
        icon_map[diagnostic.severity or sev.INFO],
        diagnostic.source and "  " .. diagnostic.source .. ":" or "",
        diagnostic.message
      )
    end,
    source = false,
    prefix = "",
  },
  float = {
    border = "single",
  },
}
