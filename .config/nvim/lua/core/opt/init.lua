vim.opt.termguicolors = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.wrap = false
vim.opt.number = true
vim.opt.foldlevel = 100000
vim.opt.foldenable = false
vim.opt.laststatus = 3
vim.opt.scrolloff = 1000
vim.opt.showtabline = 2
vim.opt.cursorline = true
vim.opt.relativenumber = true

vim.g.clipboard = {
  name = "wl-clipboard",
  copy = {
    ["+"] = "wl-copy --foreground --type text/plain",
    ["*"] = "wl-copy --foreground --primary --type text/plain",
  },
  paste = {
    ["+"] = function()
      return vim.fn.systemlist('wl-paste --no-newline|sed -e "s/\r$//"', { "" }, 1) -- '1' keeps empty lines
    end,
    ["*"] = function()
      return vim.fn.systemlist('wl-paste --primary --no-newline|sed -e "s/\r$//"', { "" }, 1)
    end,
  },
  cache_enabled = true,
}
