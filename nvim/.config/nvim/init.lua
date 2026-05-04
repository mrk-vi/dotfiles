-- neovim 0.12.2: bundled markdown treesitter parsers are ABI-broken,
-- causing "attempt to call method 'range' (a nil value)" in any treesitter
-- operation on markdown buffers. Prevent vim.treesitter.start() for markdown.
local _ts_start = vim.treesitter.start
vim.treesitter.start = function(bufnr, lang)
  if (lang or vim.filetype.match({ buf = bufnr or 0 })) == "markdown" then
    return
  end
  _ts_start(bufnr, lang)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.cmd.source('~/.vimrc')    -- shared config
require("config.lazy")
require("config.keymaps")
