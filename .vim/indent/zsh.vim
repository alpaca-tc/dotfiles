" Vim indent file
" Language:      Zsh Shell Script
" Maintainer:       Nikolai Weibull <now@bitwi.se>
" Latest Revision:  2006-04-19
if exists("b:did_indent")
  finish
endif
setl sw=2 sts=2 ts=2 et

" Same as sh indenting for now.
runtime! indent/sh.vim
