" XXX vimprocが読み込まれているか、動的に判別
let s:is_vimproc = 1
function! s:let(scope, name, value) "{{{
  let global_variable_name = a:scope . ':' . a:name
  if !exists(global_variable_name)
    let cmd = 'let ' . global_variable_name . ' = ' . string( a:value )
    exe cmd
  endif
endfunction"}}}

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

" TODO scopeを修正 vitalみたいにオブジェクト化しようか。
function! alpaca#let_g:(name, value) "{{{
  call s:let('g', a:name, a:value)
endfunction"}}}
" TODO 意味ない
function! alpaca#let_s:(name, value) "{{{
  call s:let('s', a:name, a:value)
endfunction"}}}
function! alpaca#let_b:(name, value) "{{{
  call s:let('b', a:name, a:value)
endfunction"}}}
function! alpaca#let_t:(name, value) "{{{
  call s:let('t', a:name, a:value)
endfunction"}}}
function! alpaca#let_dict(name, dict) "{{{
  let scope_and_name = substitute(a:name, '\([a-zA-Z]\):\(.*\)', '["\1","\2"]', 'g')
  let [scope, name]  = eval(scope_and_name)

  " initialize
  call alpaca#let_g:(name, {})

  for key in keys( a:dict )
    " call s:let( scope, name, a:dict[key])
    " やっぱり上書きするようにする
    execute 'let ' . a:name . '.'.key.' = "'. a:dict[key]. '"'
  endfor
endfunction"}}}

function! alpaca#print_error(string) "{{{
  echohl Error | echomsg a:string | echohl None
endfunction"}}}
function! alpaca#init() "{{{
endfunction"}}}
function! alpaca#parse_arg(arg) "{{{
  let arg = type(a:arg) == type([]) ?
        \ string(a:arg) : '[' . a:arg . ']'

  sandbox let args = eval(arg)

  if empty(args)
    return {}
  endif

  return args
endfunction"}}}

" vimrc用
command! -nargs=+ SmartHighlight
      \ call alpaca#syntax#smart_define(
      \   substitute(<q-args>, '\s"[^"]\+$', '', ''))
