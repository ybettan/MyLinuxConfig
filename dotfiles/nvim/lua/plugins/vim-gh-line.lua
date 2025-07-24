-- vim status bar
return {
  {
    'ruanyl/vim-gh-line',
    config = function()
      vim.g.gh_open_command = 'fn() { echo "$@" | xclip; }; fn '
    end,
  },
}
