if exists('g:pixiv_kintai')
  finish
endif
let g:pixiv_kintai = 1

let s:save_cpo = &cpo
set cpo&vim

let &cpo = s:save_cpo
unlet s:save_cpo

let s:morning = {
      \ 'url' : 'http://report.office/report/submit.php',
      \ 'body': "■本日の予定\n○大項目\n・詳細の説明\n○大項目\n・詳細の説明\n○大項目\n・詳細の説明\n",
      \ }
let s:night = {
      \ 'url' : 'http://report.office/report/report.php',
      \ 'body' : "■業務内容\n○大項目\n・詳細の説明\n■明日やること\n○大項目\n・詳細の説明\n■やり残していること\n○大項目\n・詳細の説明\n■一言",
      \ }

function! s:create_body() "{{{
  let config = s:get_configuration()
  let temp = tempname()
  call writefile(split(config.body, '\n'), temp)
  new `=temp`

  setlocal filetype=markdown
  setlocal syntax=markdown
  setlocal bufhidden=hide
  setlocal buftype=acwrite
  setlocal nolist
  setlocal nobuflisted
  if has('cursorbind')
    setlocal nocursorbind
  endif
  setlocal noscrollbind
  setlocal noswapfile
  setlocal nospell
  setlocal noreadonly
  setlocal nofoldenable
  setlocal nomodeline
  setlocal foldcolumn=0
  setlocal iskeyword+=-,+,\\,!,~
  setlocal matchpairs-=<:>

  if has('conceal')
    setlocal conceallevel=3
    setlocal concealcursor=n
  endif
  if exists('+cursorcolumn')
    setlocal nocursorcolumn
  endif
  if exists('+colorcolumn')
    setlocal colorcolumn=0
  endif
  if exists('+relativenumber')
    setlocal norelativenumber
  endif

  augroup AlpacaTemplateConfiguration
    autocmd BufWriteCmd <buffer> call s:create_request()
  augroup END
endfunction"}}}

function! s:get_configuration() "{{{
  let hours = str2nr(strftime("%H"))

  if hours < 12
    return s:morning
  else
    return s:night
  endif
endfunction"}}}

function! s:create_request() "{{{
  let config = s:get_configuration()
  %yank
  execute 'OpenBrowser' config.url
endfunction"}}}

command! CreateKintai call s:create_body()
