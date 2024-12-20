local bufnr = vim.api.nvim_get_current_buf()
local function opt(desc)
  return { desc = "Rustacean :: " .. desc, buffer = bufnr, remap = false, silent = true }
end
vim.keymap.set("n", "<leader>re", "<cmd>RustLsp expandMacro<cr>", opt("Expand Macro"))
vim.keymap.set("n", "<leader>rE", "<cmd>RustLsp explainError<cr>", opt("Explain Error"))
vim.keymap.set("n", "<leader>rd", "<cmd>RustLsp renderDiagnostic<cr>", opt("Diagnostic"))
vim.keymap.set("n", "<leader>rc", "<cmd>RustLsp openCargo<cr>", opt("Open Cargo.toml"))
vim.keymap.set("n", "<leader>rC", "<cmd>RustLsp flyCheck<cr>", opt("Fly Check"))
vim.keymap.set("n", "<leader>rD", "<cmd>RustLsp openDocs<cr>", opt("Open Documentation"))
vim.keymap.set("n", "<leader>rp", "<cmd>RustLsp parentModule<cr>", opt("Open Documentation"))
vim.keymap.set("n", "<leader>rJ", "<cmd>RustLsp joinLines<cr>", opt("Smart Join Lines"))
vim.keymap.set("n", "<leader>r<Up>", "<cmd>RustLsp moveItem up<cr>", opt("Move Item Up"))
vim.keymap.set("n", "<leader>r<Down>", "<cmd>RustLsp moveItem down<cr>", opt("Move Item Down"))
vim.keymap.set("n", "<leader>ca", "<cmd>RustLsp codeAction<cr>", opt("Code Action"))
