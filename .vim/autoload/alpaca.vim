" XXX
let s:is_vimproc = 1

function! alpaca#system(...) "{{{
  let command = join(a:000)
  return s:is_vimproc? vimproc#system(command) : system(command)
endfunction"}}}
