return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "saadparwaiz1/cmp_luasnip",
    "folke/neodev.nvim",
    "SmiteshP/nvim-navic",
    "SmiteshP/nvim-navbuddy",
    "MunifTanjim/nui.nvim",
  },
  config = function()
    require("core.lsp")
  end,
}
