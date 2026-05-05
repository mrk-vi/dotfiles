vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Shared config
vim.cmd.source('~/.vimrc')
require("config.lazy")

-- Neovim 0.12.2: bundled markdown parser is ABI-incompatible with nvim-treesitter
-- queries, causing crashes in markdown buffers and popup hover. Disable treesitter
-- for markdown entirely (filetype + nofile buffers like popups).
local _ts_start = vim.treesitter.start
vim.treesitter.start = function(bufnr, lang)
  bufnr = bufnr or 0
  local ft = lang or vim.filetype.match({ buf = bufnr })
  if vim.bo[bufnr].buftype == "nofile" or ft == "markdown" or ft == "markdown_inline" then
    return
  end
  _ts_start(bufnr, lang)
end
require("config.keymaps")
