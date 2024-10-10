local cmp = require("cmp")

return {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = "path" },
  }, {
    { name = "cmdline" },
  }),
  window = {
    completion = { scrollbar = false, border = "none", winhighlight = "Normal:Pmenu,CursorLine:PmenuSel" },
  },
  completion = {
    completeopt = "noinsert,noselect",
  },
  matching = { disallow_symbol_nonprefix_matching = false },
  formatting = {
    fields = { "abbr" },
  },
}
