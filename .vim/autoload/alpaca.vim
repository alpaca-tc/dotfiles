" XXX vimprocが読み込まれているか、動的に判別
let s:is_vimproc = 1

" XXX vimprocの使い方というか仕様が分からない...
function! alpaca#system(...) "{{{
  let command = join(a:000)
  if s:is_vimproc
    return vimproc#system(command)
  else
    return system(command)
  endif
endfunction"}}}

function! alpaca#system_bg(...) "{{{
  let command = join(a:000)
  if s:is_vimproc
    return vimproc#system_bg(command)
  else
    return system(command)
  endif
endfunction"}}}

function! alpaca#let_g:(name, value) "{{{
  let global_variable_name = 'g:' . a:name
  if !exists(global_variable_name)
    let cmd = 'let ' . global_variable_name . ' = ' . string( a:value )
    exe cmd
  endif
endfunction

function! alpaca#print_error(string) "{{{
  echohl Error | echomsg a:string | echohl None
endfunction"}}}
