return {
  {
    "nvim-treesitter/nvim-treesitter",
    dependencies = {
      "nvim-treesitter/nvim-treesitter-textobjects",
      "windwp/nvim-ts-autotag",
    },
    build = ":TSUpdate",
    config = function()
      local configs = require("nvim-treesitter.configs")
      local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
      local parsers = V.opt("treesitter.parsers")
      for name, value in pairs(parsers) do
        parser_config[name] = type(value) == "function" and value(parser_config[name]) or value
      end
      require("nvim-ts-autotag").setup(V.opt("ts_autotag"))
      configs.setup(V.opt("treesitter"))
    end,
  },
}
