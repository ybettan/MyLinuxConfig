-- golang plugin for vim
return {
  {
    "fatih/vim-go",
    build = ":GoUpdateBinaries",
    ft = "go"  -- Optional: load the plugin only for go files.
  },
}

