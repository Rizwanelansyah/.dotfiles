return {
  {
    "mrcjkb/rustaceanvim",
    version = "^5",
    lazy = false,
    config = function()
      vim.g.rustaceanvim = {
        tools = {
          code_actions = {
            ui_select_fallback = true,
          },
        },
        server = {
          on_attach = function(client, bufnr)
            require("core.lsp.on_attach")(client, bufnr)
          end,
          default_settings = {
            ["rust-analyzer"] = {},
          },
        },
      }
    end,
  },
}
