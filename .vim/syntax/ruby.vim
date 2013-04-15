autocmd MyAutoCmd FileType ruby
      \ if expand("%:t") =~ '_spec\.rb'
      \   |setl foldminlines=1 foldnestmax=3 foldlevel=2 foldlevelstart=3|
      \ else
      \   |setl foldminlines=1 foldnestmax=3 foldlevel=1 foldlevelstart=1|
      \ endif
