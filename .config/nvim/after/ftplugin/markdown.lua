local bufnr = vim.api.nvim_get_current_buf()
vim.keymap.set('n', '<leader>mv', "<cmd>Markview splitEnable<cr>", { buffer = bufnr })
