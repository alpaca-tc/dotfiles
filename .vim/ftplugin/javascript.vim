if exists('b:did_ftplugin')
  finish
endif

setl dict+=~/.vim/dict/jquery.dict
setl foldmethod=marker

if executable('fixjsstyle')
  command! FixJsStyle !fixjsstyle %
endif

let g:tagbar_type_javascript = {
      \ 'ctagsbin' : expand('/usr/local/bin/jsctags')
      \ }
