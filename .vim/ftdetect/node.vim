function! s:detect_ft_for_node() "{{{
  if getline(1) =~ '^#!\s*/.*/bin/node$'
    setl filetype=javascript.node
  endif
endfunction"}}}

augroup MyFtnode
  autocmd!
  autocmd BufRead * call s:detect_ft_for_node()
augroup END
