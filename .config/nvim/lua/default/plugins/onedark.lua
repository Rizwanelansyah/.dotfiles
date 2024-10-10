return {
  "navarasu/onedark.nvim",
  config = function()
    require("onedark").setup(V.opt("onedark"))
    require("onedark").load()
  end,
}
