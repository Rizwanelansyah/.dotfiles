return {
  "adalessa/laravel.nvim",
  dependencies = {
    "nvim-telescope/telescope.nvim",
    "tpope/vim-dotenv",
    "MunifTanjim/nui.nvim",
    "kevinhwang91/promise-async",
  },
  config = function()
    require("laravel").setup(V.opt("laravel"))
  end,
  ft = { "blade", "php" },
}
