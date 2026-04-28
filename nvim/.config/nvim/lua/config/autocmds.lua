local augroup = vim.api.nvim_create_augroup("UserAutocmds", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
  group = augroup,
  pattern = "text",
  callback = function()
    vim.opt_local.textwidth = 78
  end,
})
