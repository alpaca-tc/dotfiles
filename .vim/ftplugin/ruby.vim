aug MyRubyAutoCmd
  autocmd!
  " autocmd ColorScheme <buffer> source ~/.vim/syntax/ruby.gem.vim
aug END

" ruby {{{
if expand("%:p") =~ '_spec\.rb$'
  let g:tagbar_type_ruby = {
        \ 'ctagstype' : 'RubySpec',
        \ 'kinds' : [
        \   'm:modules',
        \   'c:classes',
        \   'd:describes',
        \   'C:contexts',
        \   'f:methods',
        \   'F:singleton methods'
        \ ]
        \ }
else
  let g:tagbar_type_ruby = {
        \ 'ctagstype' : 'Ruby',
        \ 'kinds' : [
        \   'm:modules',
        \   'c:classes',
        \   'd:describes',
        \   'C:contexts',
        \   'f:methods',
        \   'F:singleton methods'
        \ ]
        \ }
endif
"}}}

" setl foldmethod=syntax
