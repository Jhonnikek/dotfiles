local map = vim.keymap.set

map("n", "<C-Left>", "<C-w>h", { remap = true })
map("n", "<C-Right>", "<C-w>l", { remap = true })

map("n", "<S-Left>", "<cmd>bprevious<cr>", { desc = "Prev Buffer" })
map("n", "<S-Right>", "<cmd>bnext<cr>", { desc = "Next Buffer" })

vim.keymap.set({ "n", "v" }, "d", [["_d]])
