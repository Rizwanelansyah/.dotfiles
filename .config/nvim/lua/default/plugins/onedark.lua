return {
  "navarasu/onedark.nvim",
  priority = 1000,
  config = function()
    require("onedark").setup(V.opt("onedark"))
    require("onedark").load()
  end,
}
