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
      \   'C:contexts',
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

" augroup MySchemafile
"   autocmd!
"   autocmd BufWritePost Schemafile call s:run_ridgepole()
" augroup END
"
" function! s:run_ridgepole()
"   let current_path = vital#of('vital').import('Prelude').path2project_directory(getcwd())
"   let bin_candidates = [
"         \ current_path . "/bin/ridgepole",
"         \ "bundle exec ridgepole"
"         \ ]
"
"   for bin_candidate in bin_candidates
"     if filereadable(bin_candidate)
"       echo system(join([bin_candidate, '-c', 'config/database.yml', '--apply', '--env', 'development'], ' '))
"       echo system(join([bin_candidate, '-c', 'config/database.yml', '--apply', '--env', 'test'], ' '))
"       return 1
"     endif
"   endfor
" endfunction
