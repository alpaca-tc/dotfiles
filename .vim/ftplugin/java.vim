if exists('b:did_ftplugin')
  finish
endif

setl makeprg=javac\ %
setl errorformat=%A%f:%l:\ %m,%-Z%p^,%-C%.%#
