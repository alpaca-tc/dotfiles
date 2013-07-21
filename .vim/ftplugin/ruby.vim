aug MyRubyAutoCmd
  autocmd!
  " autocmd ColorScheme <buffer> source ~/.vim/syntax/ruby.gem.vim
aug END

" ruby {{{
  let g:tagbar_type_ruby = {
        \ 'ctagstype' : 'Ruby',
        \ 'kinds' : [
        \   'm:modules',
        \   'c:classes',
        \   'f:methods',
        \   'F:singleton methods',
        \   'd:describes',
        \   'e:contexts',
        \   'i:it',
        \   's:its',
        \   'a:association',
        \ ],
        \ 'sro' : '.',
        \ }
  " let g:tagbar_type_ruby = {
  "       \ 'ctagstype' : 'ruby',
  "       \ 'kinds' : [
  "       \   'm:modules',
  "       \   'c:classes',
  "       \   'd:describes',
  "       \   'C:contexts',
  "       \   'f:methods',
  "       \   'F:singleton methods'
  "       \ ]
  "       \ }
"}}}

" setl foldmethod=syntax
