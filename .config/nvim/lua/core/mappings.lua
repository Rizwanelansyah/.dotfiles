local map = vim.keymap.set

map("n", "<leader>bo", function()
  local curbuf = vim.api.nvim_get_current_buf()
  local buffers = vim.api.nvim_list_bufs()
  for _, buf in ipairs(buffers) do
    if buf ~= curbuf then
      vim.api.nvim_buf_delete(buf, { force = true })
    end
  end
end, { desc = "Buffer :: Close All" })

map("n", "<leader><Right>", function()
  vim.cmd.bnext()
  V.check_winbar(vim.api.nvim_get_current_buf())
end, { desc = "Buffer :: Next" })

map("n", "<leader><Left>", function()
  vim.cmd.bprev()
  V.check_winbar(vim.api.nvim_get_current_buf())
end, { desc = "Buffer :: Prev" })

map("n", "<leader>bd", function()
  vim.api.nvim_buf_delete(vim.api.nvim_get_current_buf(), { force = true })
end, { desc = "Buffer :: Delete", silent = true })

vim.keymap.set("n", "<leader>fe", "<cmd>NvimTreeToggle<cr>", { desc = "NvimTree :: Toggle" })

local telescope = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", telescope.find_files, { desc = "Telescope :: Find Files" })
vim.keymap.set("n", "<leader>ft", telescope.builtin, { desc = "Telescope :: Builtins" })
vim.keymap.set("n", "<leader>fg", telescope.live_grep, { desc = "Telescope :: Live Grep" })
vim.keymap.set("n", "<leader>fb", telescope.buffers, { desc = "Telescope :: Buffers" })
vim.keymap.set("n", "<leader>fh", telescope.help_tags, { desc = "Telescope :: Help Tags" })

vim.keymap.set("n", "<leader>nn", "<cmd>Neotest summary toggle<cr>", { desc = "Neotest :: Summary Toggle" })
vim.keymap.set("n", "<leader>nr", "<cmd>Neotest run<cr>", { desc = "Neotest :: Run" })
vim.keymap.set("n", "<leader>ns", "<cmd>Neotest stop<cr>", { desc = "Neotest :: Stop" })
vim.keymap.set("n", "<leader>nj", "<cmd>Neotest jump next<cr>", { desc = "Neotest :: Jump Next" })
vim.keymap.set("n", "<leader>nJ", "<cmd>Neotest jump prev<cr>", { desc = "Neotest :: Jump Previous" })

vim.keymap.set("n", "K", require("hover").hover, { desc = "Hover :: Hover" })
vim.keymap.set("n", "gK", require("hover").hover_select, { desc = "Hover :: Hover (Select)" })
vim.keymap.set("n", "<C-p>", function()
  ---@diagnostic disable-next-line: missing-parameter
  require("hover").hover_switch("previous")
end, { desc = "hover.nvim (previous source)" })
vim.keymap.set("n", "<C-n>", function()
  ---@diagnostic disable-next-line: missing-parameter
  require("hover").hover_switch("next")
end, { desc = "hover.nvim (next source)" })
