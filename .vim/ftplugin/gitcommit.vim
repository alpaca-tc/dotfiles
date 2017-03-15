function! s:get_root()
  return substitute(expand('%:p'), '/.git/PULLREQ_EDITMSG$', '', 'g')
endfunction

function! s:append_template(template_path)
  if file_readable(a:template_path)
    read `=a:template_path`
    call append(0, '') " 先頭に一行追加
    call cursor(1, 1) " 先頭に移動
  endif
endfunction

function! s:append_pull_request_template()
  let template_path = s:get_root() . '/PULL_REQUEST_TEMPLATE.md'
  call s:append_template(template_path)
endfunction

if expand('%') == 'PULLREQ_EDITMSG'
  call s:append_pull_request_template()
endif
