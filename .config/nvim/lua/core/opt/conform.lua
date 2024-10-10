return {
  formatters_by_ft = {
    lua = { "stylua" },
    rust = { "rustfmt" },
    javascript = { "prettier" },
    html = { "prettier" },
    css = { "prettier" },
    json = { "prettier" },
    blade = { "php_cs_fixer" },
    php = { "php_cs_fixer" },
  },
  formatters = {
    stylua = {
      prepend_args = { "--indent-type", "Spaces", "--indent-width", "2" },
    },
  },
  default_format_opts = {
    lsp_format = "fallback",
  },
}
