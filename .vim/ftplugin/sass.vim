augroup SassGroup
  autocmd!
  autocmd FileType <buffer> autocmd! SassGroup
  autocmd BufWritePre <buffer> silent! %substitute/;$//g
augroup END
