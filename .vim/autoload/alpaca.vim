let s:system = neobundle#is_installed('vimproc') ? 'vimproc#system' : 'system'
let s:system_bg = neobundle#is_installed('vimproc') ? 'vimproc#system_bg' : 'system'
function! s:let(scope, name, value) "{{{
  let global_variable_name = a:scope . ':' . a:name
  if !exists(global_variable_name)
    execute 'let ' . global_variable_name . ' = ' . string( a:value )
  endif
endfunction"}}}

function! alpaca#system(...) "{{{
  let command = join(a:000)
  return {s:system}(command)
endfunction"}}}

function! alpaca#system_bg(...) "{{{
  let command = join(a:000)
  call {s:system_bg}(command)
endfunction"}}}

function! alpaca#let_g:(name, value) "{{{
  call s:let('g', a:name, a:value)
endfunction"}}}
function! alpaca#let_b:(name, value) "{{{
  call s:let('b', a:name, a:value)
endfunction"}}}
function! alpaca#let_dict(name, dict) "{{{
  let scope_and_name = substitute(a:name, '\([a-zA-Z]\):\(.*\)', '["\1","\2"]', 'g')
  let [scope, name]  = eval(scope_and_name)

  call alpaca#let_g:(name, {})

  for key in keys(a:dict)
    execute 'let ' . a:name . '.' . key . ' = "' . a:dict[key] . '"'
  endfor
endfunction"}}}

function! alpaca#print_error(string) "{{{
  echohl Error | echomsg a:string | echohl None
endfunction"}}}
function! alpaca#parse_arg(arg) "{{{
  let arg = type(a:arg) == type([]) ?  string(a:arg) : '[' . a:arg . ']'
  sandbox let args = eval(arg)

  if empty(args)
    return {}
  endif

  return args
endfunction"}}}
