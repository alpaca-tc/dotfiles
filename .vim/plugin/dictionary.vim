if exists('g:loaded_mac_dictionary')
  finish
endif
let g:loaded_mac_dictionary = 1

let s:save_cpo = &cpo
set cpo&vim

command! -nargs=1 Dict call alpaca#function#macdict#search(<q-args>)

let &cpo = s:save_cpo
unlet s:save_cpo
