local function set_foldexpr()
  vim.wo.foldmethod = "expr"
  vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
end

vim.api.nvim_create_augroup("TreeSitter", { clear = true })
vim.api.nvim_create_autocmd({ "FileType", "BufWritePost" }, {
  callback = set_foldexpr,
  group = "TreeSitter",
})

vim.api.nvim_create_augroup("NvimNavicWinBar", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach", "LspNotify", "BufEnter", "BufRead" }, {
  callback = function(args)
    V.check_winbar(args.buf, args)
  end,
  group = "NvimNavicWinBar",
})

vim.api.nvim_create_augroup("Telescope", { clear = true })
vim.api.nvim_create_autocmd("User", {
  pattern = "TelescopePreviewerLoaded",
  callback = function()
    vim.wo.number = true
  end,
  group = "Telescope",
})
