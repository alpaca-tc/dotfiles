setl omnifunc=ccomplete#Complete shiftwidth=2 nocindent
setl noexpandtab

if exists(':RemoveDustDisable')
  RemoveDustDisable
endif

let g:tagbar_type_c = {
      \ 'kinds' : [
      \ 'd:macros:1:0',
      \ 'p:prototypes:1:0',
      \ 'g:enums:1:0',
      \ 'e:enumerators:1:0',
      \ 't:typedefs:1:0',
      \ 's:structs:1:0',
      \ 'u:unions:1:0',
      \ 'm:members:0:0',
      \ 'v:variables:0:0',
      \ 'f:functions',
      \ ]}
