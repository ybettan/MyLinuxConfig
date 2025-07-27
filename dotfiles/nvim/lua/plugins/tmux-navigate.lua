-- vim-tmux navigator
return {
  {
    'sunaku/tmux-navigate',
    config = function()
      if vim.env.TMUX then
        local function tmux_or_split(wincmd, tmuxdir)
          local previous = vim.fn.winnr()
          vim.cmd("wincmd " .. wincmd)
          if previous == vim.fn.winnr() then
            vim.fn.system("tmux select-pane -" .. tmuxdir)
            vim.cmd("redraw!")
          end
        end

        vim.keymap.set("n", "<C-h>", function() tmux_or_split("h", "L") end, { silent = true })
        vim.keymap.set("n", "<C-j>", function() tmux_or_split("j", "D") end, { silent = true })
        vim.keymap.set("n", "<C-k>", function() tmux_or_split("k", "U") end, { silent = true })
        vim.keymap.set("n", "<C-l>", function() tmux_or_split("l", "R") end, { silent = true })
      end
    end,
  },
}
