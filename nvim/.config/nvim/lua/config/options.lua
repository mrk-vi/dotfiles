vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.relativenumber = true
vim.opt.ignorecase = true
vim.opt.scrolloff = 0

vim.opt.undofile = true
vim.opt.backup = true

local local_vimrc = vim.fn.expand("~/.vimrc.local")
if vim.fn.filereadable(local_vimrc) == 1 then
  pcall(vim.cmd, "silent! source " .. local_vimrc)
end
