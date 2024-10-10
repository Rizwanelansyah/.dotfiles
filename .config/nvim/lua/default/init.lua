vim.filetype.add({
  extension = {
    ["blade.php"] = "blade",
  },
})

local map = vim.keymap.set

map("n", "<leader>La", "<cmd>Laravel artisan<cr>", { desc = "Laravel :: Artisan" })
map("n", "<leader>Lm", "<cmd>Laravel make<cr>", { desc = "Laravel :: Artisan Make" })
map("n", "<leader>Lr", "<cmd>Laravel routes<cr>", { desc = "Laravel :: Artisan Routes" })
