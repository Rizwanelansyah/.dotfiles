local cmp = require("cmp")
local border = { " ", " ", " ", " ", " ", " ", " ", " " }
local kinds = V.opt("lsp.kinds")

return {
  completion = {
    completeopt = "noinsert,select",
  },
  snippet = {
    expand = function(args)
      vim.snippet.expand(args.body)
    end,
  },
  window = {
    completion = {
      scrollbar = false,
      border = border,
      winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,CursorLine:PmenuSel",
    },
    documentation = { scrollbar = false, border = "single", winhighlight = "Normal:Normal,FloatBorder:Normal" },
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Up>"] = cmp.mapping.scroll_docs(-4),
    ["<C-Down>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = function()
      if cmp.visible() then
        cmp.close()
      else
        cmp.complete()
      end
    end,
    ["<C-d>"] = function()
      if cmp.visible_docs() then
        cmp.close_docs()
      else
        cmp.open_docs()
      end
    end,
    ["<CR>"] = cmp.mapping.confirm({ select = false }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = 1 }) then
        vim.snippet.jump(1)
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if vim.snippet.active({ direction = -1 }) then
        vim.snippet.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
  }, {
    { name = "buffer" },
  }),
  formatting = {
    fields = { "kind", "abbr" },
    expandable_indicator = true,
    format = function(entry, vim_item)
      vim_item.kind = kinds[vim_item.kind] or "?"
      return vim_item
    end,
  },
}
