if exists("b:did_ftplugin")
  finish
endif

setl dict+=~/.vim/dict/jquery.dict
" setl omnifunc=javascriptcomplete#CompleteJS

" js{{{
if !exists('g:tagbar_type_javascript')
  if executable('jsctags')
    let g:tagbar_type_javascript = {
          \ 'ctagsbin' : substitute(system('where jsctags'), '\n$', '', 'g')
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
  endif
endif
"}}}
