" if exists('g:loaded_calculator')
"   finish
" endif
" let g:loaded_calculator = 1
"
" let s:save_cpo = &cpo
" set cpo&vim

function! s:build_calculator() "{{{
  let tempfile = tempname() . '.rb'
  call writefile(['p '], tempfile)

  new `=tempfile`
  silent resize 1
  setlocal nobuflisted noswapfile bufhidden=hide filetype=ruby

  autocmd InsertLeave * QuickRun
endfunction"}}}

command! C call s:build_calculator()

" let &cpo = s:save_cpo
" unlet s:save_cpo
