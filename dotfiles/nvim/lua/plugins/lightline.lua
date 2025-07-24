-- vim status bar
return {
  {
    'itchyny/lightline.vim',
    config = function()
      -- Define the LightlineFilename function in Lua
      vim.fn["lightline#component_expand"] = vim.fn["lightline#component_expand"] or {}

      -- Register the global Lua function for lightline to call
      vim.cmd([[
        function! LightlineFilename()
        return v:lua.LightlineFilename()
      endfunction
      ]])

      _G.LightlineFilename = function()
        local ft = vim.bo.filetype
        if ft == "vimfiler" then
          return vim.fn["vimfiler#get_status_string"]()
        elseif ft == "unite" then
          return vim.fn["unite#get_status_string"]()
        elseif ft == "vimshell" then
          return vim.fn["vimshell#get_status_string"]()
        elseif vim.fn.expand("%") ~= "" then
          return vim.fn.expand("%")
        else
          return "[No Name]"
        end
      end

      -- Set lightline configuration to use that function
      vim.g.lightline = {
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
    end,
  },
}
