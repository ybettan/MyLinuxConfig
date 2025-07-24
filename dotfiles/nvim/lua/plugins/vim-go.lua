-- golang plugin for vim
return {
  {
    "fatih/vim-go",
    build = ":GoUpdateBinaries",
    ft = "go",  -- Optional: load the plugin only for go files.
    config = function()
      -- Set gofmt command to goimports
      vim.g.go_fmt_command = "goimports"
      -- Enable auto type info
      vim.g.go_auto_type_info = 1
      -- Highlight types, extra types, and fields
      vim.g.go_highlight_types = 1
      vim.g.go_highlight_extra_types = 1
      vim.g.go_highlight_fields = 1
    end,
    keys = {
        {"<C-p>", ":GoDef<CR>", mode = "n", ft = {"go"}, desc = "Jump to definition"},
        {".", ".<C-x><C-o>", mode = "i", ft = {"go"}, noremap = true, desc = "Insert dot and trigger omni-completion in Go files"},
    },
  },
}
