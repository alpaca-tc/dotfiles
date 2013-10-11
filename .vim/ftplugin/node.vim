function! s:detect_ft_for_node() "{{{
  if getline(1) =~ '^#!\s*/.*/bin/node$'
    setl filetype=javascript
  endif
endfunction"}}}

augroup MyFtDetect
  autocmd BufRead * call s:detect_ft_for_node()
augroup END
