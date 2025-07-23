local g = vim.g

-- supertab
g.SuperTabDefaultCompletionType = "<c-n>"

-- lightline
g.lightline = {
  active = {
    left = {
      { "mode", "paste" },
      { "gitbranch", "readonly", "filename", "modified" },
    },
  },
  component_function = {
    gitbranch = "FugitiveHead",
    filename = "LightlineFilename",
  },
}

-- Lightline filename function
vim.cmd([[
function! LightlineFilename()
  return &filetype ==# 'vimfiler' ? vimfiler#get_status_string() :
       \ &filetype ==# 'unite' ? unite#get_status_string() :
       \ &filetype ==# 'vimshell' ? vimshell#get_status_string() :
       \ expand('%') !=# '' ? expand('%') : '[No Name]'
endfunction
]])

-- vim-go
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.api.nvim_buf_set_keymap(0, "i", ".", ".<C-x><C-o>", { noremap = true })
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  pattern = "go",
  callback = function()
    vim.keymap.set("n", "<C-p>", ":GoDef<CR>", { buffer = true, noremap = true, silent = true })
  end,
})
g.go_highlight_types = 1
g.go_highlight_extra_types = 1
g.go_highlight_fields = 1
g.go_fmt_command = "goimports"
g.go_auto_type_info = 1

-- jedi-vim
g["jedi#show_call_signatures"] = "2"
g["jedi#goto_command"] = "<C-p>"

-- gh-line
g.gh_open_command = 'fn() { echo "$@" | xclip; }; fn '
