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

-- gh-line
g.gh_open_command = 'fn() { echo "$@" | xclip; }; fn '
