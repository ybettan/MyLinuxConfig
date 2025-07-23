local opt = vim.opt
local g = vim.g

opt.number = true
opt.relativenumber = true
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true
opt.colorcolumn = "80"
opt.splitbelow = true
opt.splitright = true
opt.laststatus = 2
opt.title = true
opt.ignorecase = true
opt.hlsearch = true
opt.background = "dark"
opt.dictionary = "/usr/dict/words"
opt.complete:remove("i")
opt.backspace = { "indent", "eol", "start" }
opt.foldmethod = "marker"
opt.mmp = 5000

-- gruvbox specific
g.gruvbox_italic = 1
