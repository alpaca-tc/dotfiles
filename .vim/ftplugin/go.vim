let g:tagbar_type_go = {
      \ 'ctagstype': 'go',
      \ 'kinds' : [
      \ 'p:package',
      \ 'f:function',
      \ 'v:variables',
      \ 't:type',
      \ 'c:const'
      \ ]}


let b:remove_dust_enable = 0
setl nolist

augroup Go
  autocmd!
  autocmd BufWritePre <buffer> :Fmt
augroup END

if !exists('s:initialized_go') && executable('go')
  let s:initialized_go = 1

  let s:go_root = substitute(system('go env GOROOT'), '\n', '', 'g')
  if isdirectory(s:go_root)
    let $GOROOT = s:go_root
    let $PATH = $PATH . ':' . $GOROOT

    let s:go_user_path = expand($HOME . "/.go")

    if isdirectory(s:go_user_path)
      let $GOPATH = s:go_user_path
    endif

    if executable('gocode')
      let g:neocomplete#sources#omni#functions = get(g:, 'neocomplete#sources#omni#functions', {})
      let g:neocomplete#sources#omni#functions.go = 'gocomplete#Complete'

      execute 'set runtimepath+=' . globpath($GOPATH, 'src/github.com/nsf/gocode/vim')
    endif

    if executable('golint')
      " go get github.com/golang/lint/golint
      execute 'set runtimepath+=' . globpath($GOPATH, 'src/github.com/golang/lint/misc/vim')
    endif
  endif
endif
