return {
  "adalessa/laravel.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-dotenv",
    "MunifTanjim/nui.nvim",
    "nvimtools/none-ls.nvim",
  },
  config = function()
    require("laravel").setup(V.opt("laravel"))
  end,
  event = "VeryLazy",
  ft = { "blade", "php" },
}
