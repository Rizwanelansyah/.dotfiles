local cmp = require("cmp")

return {
  mapping = cmp.mapping.preset.cmdline(),
  window = {
    completion = { scrollbar = false, border = "none", winhighlight = "Normal:Pmenu,CursorLine:PmenuSel" },
  },
  completion = {
    completeopt = "noinsert,noselect",
  },
  sources = {
    { name = "buffer" },
  },
  formatting = {
    fields = { "abbr" },
  },
}
