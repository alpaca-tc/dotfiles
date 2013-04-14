" scala {{{
" let g:tagbar_type_scala = {
"       \ "ctagstype" : 'Scala',
"       \ 'sro' : '.',
"       \ 'kinds' : [
"       \   'p:packages:1',
"       \   'V:values',
"       \   'v:variables',
"       \   'T:types',
"       \   't:traits',
"       \   'o:objects',
"       \   'a:aclasses',
"       \   'c:classes',
"       \   'r:cclasses',
"       \   'm:methods',
"       \ ],
"       \ 'kind2scope' : {
"       \   'T' : 'type',
"       \   't' : 'trait',
"       \   'o' : 'object',
"       \   'a' : 'abstract class',
"       \   'c' : 'class',
"       \   'r' : 'case class',
"       \ },
"       \}
let g:tagbar_type_scala = {
    \ 'ctagstype' : 'Scala',
    \ 'kinds'     : [
        \ 'p:packages:1',
        \ 'V:values',
        \ 'v:variables',
        \ 'T:types',
        \ 't:traits',
        \ 'o:objects',
        \ 'a:aclasses',
        \ 'c:classes',
        \ 'r:cclasses',
        \ 'm:methods'
    \ ]
\ }
"}}}
