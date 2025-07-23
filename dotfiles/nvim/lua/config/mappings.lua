local map = vim.keymap.set

-- Insert mode
map("i", "jj", "<Esc>")

-- Normal mode
map("n", "Y", "y$")
map("n", "<Leader>l", ":ls<CR>")
map("n", "<Leader>b", ":bp<CR>")
map("n", "<Leader>f", ":bn<CR>")
map("n", "<Leader>g", ":e#<CR>")
map("n", "<Leader>c", ":bd<CR>")

-- Easy window navigation
map("n", "<C-J>", "<C-W><C-J>")
map("n", "<C-K>", "<C-W><C-K>")
map("n", "<C-L>", "<C-W><C-L>")
map("n", "<C-H>", "<C-W><C-H>")

-- matchit for <> navigation
vim.cmd("packadd! matchit")

