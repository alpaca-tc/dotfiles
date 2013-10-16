augroup MyFtDetect
augroup END
augroup MyFtracc
  autocmd!
  autocmd BufNewFile,BufRead *.y setl ft=ruby.racc
augroup END
