setl dict+=~/.vim/dict/javascript.dict,~/.vim/dict/jquery.dict

augroup MyCoffee
  autocmd!
  autocmd BufWritePost <buffer> %s/;$//g
  autocmd FileType <buffer> autocmd! MyCoffee
augroup END

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
" let g:tagbar_type_coffee = {
"   \ 'ctagstype' : 'coffee',
"   \ 'kinds' : [
"   \   'n:namespace',
"   \   'c:class',
"   \   'o:object',
"   \   'm:methods',
"   \   'f:functions',
"   \   'i:instance variables',
"   \   'v:var:1',
"   \ ],
"   \ 'sro' : ".",
"   \ 'scope2kind' : {
"   \   'o' : 'object',
"   \   'f' : 'function',
"   \   'm' : 'method',
"   \   'v' : 'var',
"   \   'i' : 'ivar'
"   \ },
"   \ 'kind2scope' : {
"   \  'function' : 'f',
"   \  'method' : 'm',
"   \  'var' : 'v',
"   \  'ivar' : 'i',
"   \ 'object' : 'o'
"   \},
"   \ 'deffile' : expand('<sfile>:p:h') . '/.vim/coffee.ctags'
" \ }
"}}}
