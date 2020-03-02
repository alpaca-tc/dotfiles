let g:tagbar_type_go = {
      \ 'ctagstype': 'go',
      \ 'kinds' : [
      \ 'p:package',
      \ 'f:function',
      \ 'v:variables',
      \ 't:type',
      \ 'c:const'
      \ ]}

if executable('gotags')
  let g:tagbar_type_go = {
        \ 'ctagstype' : 'go',
        \ 'kinds'     : [
        \ 'p:package',
        \ 'i:imports:1',
        \ 'c:constants',
        \ 'v:variables',
        \ 't:types',
        \ 'n:interfaces',
        \ 'w:fields',
        \ 'e:embedded',
        \ 'm:methods',
        \ 'r:constructor',
        \ 'f:functions'
        \ ],
        \ 'sro' : '.',
        \ 'kind2scope' : {
        \ 't' : 'ctype',
        \ 'n' : 'ntype'
        \ },
        \ 'scope2kind' : {
        \ 'ctype' : 't',
        \ 'ntype' : 'n'
        \ },
        \ 'ctagsbin'  : 'gotags',
        \ 'ctagsargs' : '-sort -silent'
        \ }
endif

let b:remove_dust_enable = 0
setl nolist

augroup Go
  autocmd!

  if exists(':GoFmt')
    autocmd BufWritePre <buffer> :GoFmt
  endif
augroup END
