let g:tagbar_type_go = {
      \ 'ctagstype': 'go',
      \ 'kinds' : [
      \ 'p:package',
      \ 'f:function',
      \ 'v:variables',
      \ 't:type',
      \ 'c:const'
      \ ]}

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

      set completeopt=menu,menuone,preview
      execute 'set runtimepath+=' . globpath($GOPATH, 'src/github.com/nsf/gocode/vim')
    endif
  endif
endif
