local fn = vim.fn

require("rails").setup()
require("plugins")
require("typeprof").setup()

vim.cmd('source ' .. os.getenv('HOME') .. '/.vim/vimrc')

vim.o.runtimepath = table.concat({ vim.o.runtimepath, os.getenv('HOME').."/.vim", os.getenv("HOME").."/.vim/after" }, ",")

vim.o.termguicolors = true
vim.o.clipboard=vim.o.clipboard..','..'unnamedplus'

if fn.executable('pyenv') then
  vim.g.python3_host_prog = os.getenv('HOME') .. '/.pyenv/versions/3.12.1/bin/python'
  vim.g.python_host_prog = os.getenv('HOME') .. '/.pyenv/versions/2.7.18/bin/python'
else
  vim.g.python_host_prog = 'python'
end

if fn.executable('rbenv') then
  -- vim.g.ruby_host_prog = fn.system({ 'rbenv', 'which', 'ruby' })
  vim.g.ruby_host_prog = os.getenv('HOME') .. '/.rbenv/versions/3.2.2/bin/ruby'
else
  vim.g.ruby_host_prog = 'ruby'
end

vim.o.runtimepath = table.concat({ vim.o.runtimepath, "/usr/local/share/nvim/runtime", '/opt/homebrew/share/nvim/runtime', os.getenv('HOME') .. '/.vim' }, ",")
