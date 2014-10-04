setl dict+=~/.vim/dict/jquery.dict
setl foldmethod=marker

if executable('fixjsstyle')
  command! FixJsStyle !fixjsstyle %
endif
