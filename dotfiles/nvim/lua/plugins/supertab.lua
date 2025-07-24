-- tab completion
return {
  {
    'ervandew/supertab',
    config = function()
      vim.g.SuperTabDefaultCompletionType = "<c-n>"
    end,
  },
}
