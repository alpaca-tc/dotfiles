if !isdirectory(g:my.dir.neobundle.'/neobundle.vim')
  call system('git clone https://github.com/Shougo/neobundle.vim.git '. g:my.dir.neobundle . '/neobundle.vim')
endif

" Create directries
call alpaca#initialize#directory(values(g:my.dir))
