setl omnifunc=csscomplete#CompleteCSS
" css {{{
let g:tagbar_type_css = {
      \ 'ctagstype' : 'css',
      \ 'kinds' : [
      \   's:selectors',
      \   'i:identities',
      \   't:Tags(Elements)',
      \   'o:Objects(ID)',
      \   'c:Classes',
      \ ]
      \ }
"}}}

augroup CssGroup
  autocmd!
  autocmd FileType <buffer> autocmd! CssGroup
  autocmd BufWritePre <buffer> silent! %substitute/:$/;/g
augroup END
