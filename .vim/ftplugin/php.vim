if exists('b:did_ftplugin')
  finish
endif

setl makeprg=php\ -l\ %\ $*
setl errorformat=%EPHP\ Parse\ error:\ %m\ in\ %f\ on\ line\ %l
                       \%WNotice:\ %m\ in\ %f\ on\ line\ %l,
                       \%EParse\ error:\ %m\ in\ %f\ on\ line\ %l,
                       \%WNotice:\ %m\ in\ %f\ on\ line\ %l,
                       \%-G%.%#
setl omnifunc=phpcomplete#CompletePHP

" php {{{
let g:tagbar_type_php = {
      \ 'kinds' : [
      \ 'c:classes',
      \ 'f:functions',
      \ 'v:variables:1'
      \ ]
      \ }
"}}}
