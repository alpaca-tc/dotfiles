augroup MyFtDetect
  autocmd BufNewFile,BufRead *.txt call s:set_help_settings()
augroup END

function! s:set_help_settings()
  if expand("%:p")  =~ 'doc/.*\.txt'
    setl filetype=help
  endif
endfunction
