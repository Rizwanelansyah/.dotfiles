return {
  {
    "ricardoramirezr/blade-nav.nvim",
    dependencies = {
      "hrsh7th/nvim-cmp",
    },
    ft = { "blade", "php" },
    config = function()
      require("blade-nav").setup(V.opt("blade_nav"))
    end,
  },
}
