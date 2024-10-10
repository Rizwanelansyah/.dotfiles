return {
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = function()
      return V.opt("whichkey")
    end,
    keys = {
      {
        "<leader>?",
        function()
          require("which-key").show({ global = false })
        end,
        desc = "Buffer Local Keymaps (which-key)",
      },
    },
  },
}
