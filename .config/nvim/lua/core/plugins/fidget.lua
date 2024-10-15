return {
  {
    "j-hui/fidget.nvim",
    config = function()
      require("fidget").setup(V.opt("fidget"))
    end,
  },
}
