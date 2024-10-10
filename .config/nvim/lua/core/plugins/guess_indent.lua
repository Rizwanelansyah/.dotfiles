return {
  {
    "nmac427/guess-indent.nvim",
    config = function()
      require("guess-indent").setup(V.opt("guess_indent"))
    end,
  },
}
