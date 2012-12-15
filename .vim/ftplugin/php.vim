setl makeprg=php\ -l\ %\ $*
setl errorformat=%EPHP\ Parse\ error:\ %m\ in\ %f\ on\ line\ %l
                       \%WNotice:\ %m\ in\ %f\ on\ line\ %l,
                       \%EParse\ error:\ %m\ in\ %f\ on\ line\ %l,
                       \%WNotice:\ %m\ in\ %f\ on\ line\ %l,
                       \%-G%.%#
setl omnifunc=phpcomplete#CompletePHP

