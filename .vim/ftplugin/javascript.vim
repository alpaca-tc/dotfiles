setl dict+=~/.vim/dict/jquery.dict
" setl omnifunc=javascriptcomplete#CompleteJS

" js{{{
if executable('jsctags')
  let g:tagbar_type_javascript = {
        \ 'ctagsbin' : '/path/to/jsctags'
        \ }
else
  let g:tagbar_type_javascript = {
        \'ctagstype' : 'js',
        \'kinds'     : [
        \   'o:objects',
        \   'f:functions',
        \   'a:arrays',
        \   's:strings'
        \]
        \}
  "}}}
endif
