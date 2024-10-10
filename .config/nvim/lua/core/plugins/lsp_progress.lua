return {
  {
    "linrongbin16/lsp-progress.nvim",
    config = function()
      require("lsp-progress").setup(V.opt("lsp_progress"))
    end,
  },
}
