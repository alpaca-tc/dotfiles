let s:system = dein#is_sourced('vimproc') ? 'vimproc#system' : 'system'
let s:system_bg = dein#is_sourced('vimproc') ? 'vimproc#system_bg' : 'system'

function! s:let(scope, name, value) "{{{
  let global_variable_name = a:scope . ':' . a:name
  if !exists(global_variable_name)
    execute 'let ' . global_variable_name . ' = ' . string( a:value )
  endif
endfunction"}}}

function! alpaca#current_root(cwd)
  if !exists('s:V')
    let s:V = vital#of('dotfiles')
  endif

  return s:V.import('Prelude').path2project_directory(a:cwd)
endfunction

function! alpaca#system(...) "{{{
  let command = join(a:000)
  return {s:system}(command)
endfunction"}}}
function! alpaca#system_bg(...) "{{{
  let command = join(a:000)
  call {s:system_bg}(command)
endfunction"}}}

function! alpaca#print_error(string) "{{{
  echohl Error | echomsg a:string | echohl None
endfunction"}}}

function! alpaca#print_message(string) "{{{
  echohl Comment | echomsg a:string | echohl None
endfunction"}}}
