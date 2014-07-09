if exists('b:did_ftplugin')
  finish
endif

setl dict+=~/.vim/dict/jquery.dict
setl foldmethod=marker

if executable('fixjsstyle')
  command! FixJsStyle !fixjsstyle %
endif

" npm install -g git://github.com/ramitos/jsctags.git
" let g:tagbar_type_javascript = { 'ctagsbin' : 'jsctags', 'ctagsargs': '-f' }
