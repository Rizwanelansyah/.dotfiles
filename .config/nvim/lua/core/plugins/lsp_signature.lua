return {
  {
    "ray-x/lsp_signature.nvim",
    event = "VeryLazy",
    config = function()
      require("lsp_signature").setup(V.opt("lsp_signature"))
    end,
  },
}
