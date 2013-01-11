source ~/.vim/config/.vimrc

if has('gui_macvim')
  " set guifont=Recty:h12
  set lines=100 columns=160
  " set transparency=10
  set cmdheight=1
  set guioptions-=BLRT

  " 暫く触らないと、画面を薄くする
  " let g:visible = 0
  " function! SetShow()
  "   if g:visible == 1
  "     setl transparency=0
  "     let g:visible = 0
  "   endif
  " endfunction
  " function! SetVisible()
  "   setl transparency=98
  "   let g:visible = 1
  " endfunction
  " au CursorHold * call SetVisible()
  " au CursorMoved,CursorMovedI,WinLeave * call SetShow()
  " nnoremap <silent>_ :exec g:visible == 0 ? ":call SetVisible()" : ":call SetShow()"<CR>
endif

