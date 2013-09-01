if exists("b:did_ftplugin")
  finish
endif

setl omnifunc=htmlcomplete#CompleteTags indentexpr=HtmlIndentGet()

" html {{{
let g:tagbar_type_html = {
      \ 'ctagstype' : 'html',
      \ 'kinds' : [
      \ 'h:Headers',
      \ 'o:Objects(ID)',
      \ 'c:Classes'
      \ ]
      \ }
"}}}
