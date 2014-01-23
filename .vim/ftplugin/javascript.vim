if exists('b:did_ftplugin')
  finish
endif

setl dict+=~/.vim/dict/jquery.dict
setl foldmethod=marker
" setl omnifunc=javascriptcomplete#CompleteJS

" js{{{
if !exists('g:tagbar_type_javascript')
  let jsctags = neobundle#get('tagbar').path . '/node_modules/jsctags/bin/jsctags.js'
  if executable(jsctags)
    let g:tagbar_type_javascript = {
          \ 'ctagsbin' : jsctags
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
