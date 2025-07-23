-- ~/.config/nvim/lua/config/autocmds.lua
vim.api.nvim_create_autocmd("InsertEnter", {
  callback = function()
    vim.opt.number = true
    vim.opt.relativenumber = false
  end,
})

vim.api.nvim_create_autocmd("InsertLeave", {
  callback = function()
    vim.opt.number = false
    vim.opt.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("BufReadPost", {
  callback = function()
    local line = vim.fn.line
    if line("'\"") > 0 and line("'\"") <= line("$") then
      vim.cmd('normal! g`"')
    end
  end,
})
