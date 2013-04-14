if exists('g:loaded_lazy_load_vimfiler')
  finish
endif
let g:loaded_lazy_load_vimfiler = 1

let s:save_cpo = &cpo
set cpo&vim

" VimFiler の読み込みを遅延しつつデフォルトのファイラに設定
" Netrw 無効化
augroup DisableNetrw
  autocmd!
  autocmd MyAutoCmd BufEnter,BufCreate,BufWinEnter * call <SID>disable_netrw()
augroup END

function! s:disable_netrw()
  autocmd! FileExplorer
  autocmd! DisableNetrw
endfunction

" :edit {dir} や unite.vim などでディレクトリを開こうとした場合
augroup LoadVimFiler
  autocmd!
  autocmd MyAutoCmd BufEnter,BufCreate,BufWinEnter * call <SID>load_vimfiler(expand('<amatch>'))
augroup END

function! s:load_vimfiler(path) "{{{
  let path = a:path
  " For ":edit ~".
  if fnamemodify(path, ':t') ==# '~'
    let path = '~'
  endif

  if isdirectory(expand(path))
    NeoBundleSource vimfiler
  endif

  autocmd! LoadVimFiler
endfunction "}}}

" 起動時にディレクトリを指定した場合
for arg in argv()
  if isdirectory(getcwd().'/'.arg)
    NeoBundleSource vimfiler
    autocmd! LoadVimFiler
    break
  endif
endfor

let &cpo = s:save_cpo
unlet s:save_cpo
