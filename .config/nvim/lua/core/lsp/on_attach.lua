local navic = require("nvim-navic")
local navbuddy = require("nvim-navbuddy")

return function(client, bufnr)
  local function opt(desc)
    return { desc = desc, buffer = bufnr, remap = false, silent = true }
  end
  -- vim.keymap.set("n", "K", vim.lsp.buf.hover, opt "LSP :: Hover")
  vim.keymap.set({ "n", "i", "x" }, "<C-k>", vim.lsp.buf.signature_help, opt("LSP :: Signature Help"))
  vim.keymap.set("n", "gd", vim.lsp.buf.definition, opt("LSP :: Go To Definition"))
  vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opt("LSP :: Go To Declaration"))
  vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opt("LSP :: Rename"))
  vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opt("LSP :: Code Action"))
  vim.keymap.set("n", "<leader>on", "<cmd>Navbuddy<cr>", opt("Navbuddy :: Open"))
  vim.keymap.set("n", "]d", vim.diagnostic.goto_next, opt("Diagnostic :: Go To Next"))
  vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, opt("Diagnostic :: Go To Prev"))

  if client.server_capabilities.documentSymbolProvider then
    navic.attach(client, bufnr)
    navbuddy.attach(client, bufnr)
  end

  local success, attach = pcall(V.req, "lsp.on_attach")
  if success then
    attach(client, bufnr)
  end
end
