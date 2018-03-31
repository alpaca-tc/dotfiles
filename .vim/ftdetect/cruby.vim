function! s:is_cruby()
  let fn = expand('%:p')

  if fn =~# ':[\/]\{2\}'
    return 0
  endif

  if !isdirectory(fn)
    let fn = fnamemodify(fn, ':h')
  endif

  let files = findfile('ruby.c', escape(fn, ', ') . ';', -1)
  let files = filter(files, '!empty(v:val) && filereadable(v:val)')
  let files = map(files, 'fnamemodify(v:val, ":p")')

  let found_file = get(files, 0, 0)

  return !empty(found_file)
endfunction

function! s:detect_cruby_and_set_filetype()
  if s:is_cruby()
    setlocal filetype=cruby
  endif
endfunction

autocmd BufNewFile,BufRead *.[chy] call s:detect_cruby_and_set_filetype()
