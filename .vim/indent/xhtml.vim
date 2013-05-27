if exists('b:did_indent')
  finish
endif
runtime indent/html.vim
setl indentexpr=HtmlIndentGet(v:lnum)

setl sw=2 sts=2 ts=2 et
