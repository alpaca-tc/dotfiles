local fn = vim.fn

vim.o.runtimepath = vim.o.runtimepath..','..os.getenv('HOME').."/.vim"..os.getenv("HOME").."/.vim/after"

vim.cmd('source '.. os.getenv('HOME') .. '/.vim/vimrc')

vim.o.termguicolors = true
vim.o.clipboard=vim.o.clipboard..','..'unnamedplus'

-- if fn.executable('pyenv') then
--   -- let g:python3_host_prog = $HOME . '/.pyenv/versions/3.11.1/bin/python'
--   -- let g:python_host_prog = $HOME . '/.pyenv/versions/2.7.18/bin/python'
-- else
--   -- let g:python_host_prog = 'python'
-- end

-- if executable('rbenv')
--   " let g:ruby_host_prog = system('rbenv which ruby')
--   let g:ruby_host_prog = $HOME . '/.rbenv/versions/3.1.2/bin/ruby'
-- else
--   let g:ruby_host_prog = 'ruby'
-- endif
--
-- set runtimepath+=/usr/local/share/nvim/runtime
-- set runtimepath+=$HOME/.vim
--
-- nnoremap <Space><Space>s :<C-U>source ~/.vim/nvimrc<CR>
--
-- " deoplete
-- let g:deoplete#enable_at_startup = 1
