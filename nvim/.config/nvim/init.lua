vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shared config
vim.cmd.source('~/.vimrc')
require("config.lazy")

-- Neovim 0.12.2: bundled markdown parser is ABI-incompatible with nvim-treesitter
-- queries, causing crashes in popup hover buffers. Disable treesitter on nofile
-- buffers (popups, help, etc.) to avoid the issue.
local _ts_start = vim.treesitter.start
vim.treesitter.start = function(bufnr, lang)
  bufnr = bufnr or 0
  if vim.bo[bufnr].buftype == "nofile" then
    return
  end
  _ts_start(bufnr, lang)
end
require("config.keymaps")
