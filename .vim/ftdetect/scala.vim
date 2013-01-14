au BufRead,BufNewFile *.scala,*.sbt set filetype=scala sw=2 sts=2 ts=2 expandtab

fun! s:DetectScala()
  if getline(1) == '#!/usr/bin/env scala'
    set filetype=scala
  endif
endfun
au BufRead,BufNewFile * call s:DetectScala()
