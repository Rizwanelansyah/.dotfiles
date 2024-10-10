return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup(V.opt("conform"))
      vim.keymap.set("n", "<leader>f=", function()
        require("conform").format()
      end, { desc = "Conform/LSP :: Format" })
    end,
  },
}
