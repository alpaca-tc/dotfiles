function! s:detect_ft_for_node() "{{{
  if getline(1) =~ '^#!\s*/.*/bin/node$'
    setl filetype=javascript.node
  endif
endfunction"}}}

autocmd BufRead * call s:detect_ft_for_node()
