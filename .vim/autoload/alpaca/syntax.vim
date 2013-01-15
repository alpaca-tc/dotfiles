function! s:define_highlight(args) "{{{
  " TODO Co256の振り分け
  let args = a:args
  let highlight_opts = []
  call add( highlight_opts, 'highlight!' )
  call add( highlight_opts, args.name )

  if has_key(args, 'guifg')
    call add(highlight_opts, "guifg=" . args.guifg)
  endif

  if has_key(args, 'ctermfg')
    call add(highlight_opts, "ctermfg=" . args.ctermfg)
  endif

  if has_key(args, 'style')
    call add(highlight_opts, 'gui=' . args.style)
    call add(highlight_opts, 'cterm=' . args.style)
  endif

  execute join( highlight_opts, ' ' )
endfunction"}}}

function! alpaca#syntax#smart_define(arg) "{{{
  let highlight_define = alpaca#parse_arg(a:arg)
  let define = highlight_define[1]
  let define.name = highlight_define[0]

  call s:define_highlight(define)
endfunction"}}}

" vimrc用
command! -nargs=+ SmartHighlight
      \ call alpaca#syntax#smart_define(
      \   substitute(<q-args>, '\s"[^"]\+$', '', ''))


