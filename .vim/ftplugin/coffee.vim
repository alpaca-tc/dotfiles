setl dict+=~/.vim/dict/coffee.dict,~/.vim/dict/javascript.dict,~/.vim/dict/jquery.dict

if executable('coffeetags') "{{{
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \   'f:functions',
        \   'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \   'f' : 'object',
        \   'o' : 'object',
        \ }
        \ }
else
  let g:tagbar_type_coffee = {
        \ 'ctagstype' : 'coffee',
        \ 'kinds'     : [
        \ 'c:classes',
        \ 'm:methods',
        \ 'f:functions',
        \ 'v:variables',
        \ 'f:fields',
        \ ]
        \ }
endif
"}}}
