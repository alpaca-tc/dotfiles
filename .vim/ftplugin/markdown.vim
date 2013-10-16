" Vim filetype plugin
" Language:    Markdown
" Maintainer:    Tim Pope <vimNOSPAM@tpope.org>

if exists('b:did_ftplugin')
  finish
endif

runtime! ftplugin/html.vim ftplugin/html_*.vim ftplugin/html/*.vim

setl omnifunc=htmlcomplete#CompleteTags
setl filetype=markdown autoindent formatoptions=tcroqn2 comments=n:> shiftwidth=2 softtabstop=2 tabstop=2

setlocal comments=fb:*,fb:-,fb:+,n:> commentstring=>\ %s
setlocal formatoptions+=tcqln formatoptions-=r formatoptions-=o
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\|^[-*+]\\s\\+

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= '|setl cms< com< fo< flp<'
else
  let b:undo_ftplugin = 'setl cms< com< fo< flp<'
endif

" markdown {{{
let g:tagbar_type_markdown = {
  \ 'ctagstype' : 'markdown',
  \ 'kinds' : [
    \ 'h:Heading_L1',
    \ 'i:Heading_L2',
    \ 'k:Heading_L3'
  \ ]
\ }
"}}}
