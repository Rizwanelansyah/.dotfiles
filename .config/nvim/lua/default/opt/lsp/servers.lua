return {
  cssls = {},
  html = {},
  jsonls = {},
  bashls = {},
  emmet_ls = function(opt)
    opt.filetypes = {
      "astro",
      "css",
      "eruby",
      "html",
      "htmldjango",
      "javascriptreact",
      "less",
      "pug",
      "sass",
      "scss",
      "svelte",
      "typescriptreact",
      "vue",
      "htmlangular",
      "php",
      "blade",
    }
  end,
  tailwindcss = {},
  ts_ls = {},
  intelephense = {},
}
