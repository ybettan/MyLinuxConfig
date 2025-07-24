-- python plugin for vim
return {
  {
    'davidhalter/jedi-vim',
    -- Optional: load the plugin only for python files.
    ft = "python",
    config = function()
      -- Set the command for showing call signatures
      vim.g["jedi#show_call_signatures"] = 2
      -- Set the command for goto functionality
      vim.g["jedi#goto_command"] = "<C-p>"
    end,
  },
}
