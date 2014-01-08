if exists('g:loaded_html_entities') || !has('ruby')
  finish
endif
let g:loaded_html_entities = 1

let s:save_cpo = &cpo
set cpo&vim

command -nargs=1 HtmlDecode call htlmentities#decode('')
command -nargs=1 HtmlEncode call htlmentities#encode('')

let &cpo = s:save_cpo
unlet s:save_cpo
