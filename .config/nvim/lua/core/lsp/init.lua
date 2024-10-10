require("nvim-navic").setup(V.opt("lsp.navic"))
require("nvim-navbuddy").setup(V.opt("lsp.navbuddy"))
local cmp = require("cmp")
cmp.setup(V.opt("cmp"))
cmp.setup.cmdline({ "/", "?" }, V.opt("cmp.cmdsearch"))
cmp.setup.cmdline({ ":" }, V.opt("cmp.cmdline"))

local _border = "single"

vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
  border = _border,
})

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
  border = _border,
})

vim.diagnostic.config(V.opt("diagnostic"))

local capabilities = require("cmp_nvim_lsp").default_capabilities()
local servers = V.opt("lsp.servers")
require("neodev").setup(V.opt("lsp.neodev"))
local on_attach = require("core.lsp.on_attach")
for name, option in pairs(servers) do
  if type(option) == "function" then
    local new_option = {
      capabilities = capabilities,
      on_attach = on_attach,
    }
    option(new_option)
    option = new_option
  else
    if type(option.capabilities) == "function" then
      option.capabilities = option.capabilities(capabilities)
    else
      option.capabilities = vim.tbl_extend("force", capabilities, option.capabilites or {})
    end
    option.on_attach = on_attach
  end

  require("lspconfig")[name].setup(option)
end
