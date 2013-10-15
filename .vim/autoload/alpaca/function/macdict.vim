function! s:call_mac_dict(cmd) "{{{
  call alpaca#system("osascript -e 'tell application \"Dictionary\" to ". a:cmd ."'")
endfunction"}}}

function! alpaca#function#macdict#close() "{{{
  call s:call_mac_dict('quit')
endfunction"}}}
function! alpaca#function#macdict#focus() "{{{
  call s:call_mac_dict('activate')
endfunction"}}}
function! alpaca#function#macdict#with_cursor_word() "{{{
  let word = expand('<cword>')
  call alpaca#function#macdict#search(word)
endfunction"}}}
function! alpaca#function#macdict#search(word) "{{{
  let path = 'dict://' . shellescape(a:word)
  echo path
  call alpaca#system('open', path)
endfunction"}}}
