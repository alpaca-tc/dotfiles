aug MyAutoCmd
  au!
aug END
source ~/.vim/config/.vimrc.commands

"----------------------------------------
" initialize"{{{
let g:my_settings = {}
let g:my_settings.initialize = 0
let g:my_settings.keyboard_type = 'jis'

let g:my_settings.date = Today()
let g:my_settings.author = 'Ishii Hiroyuki'

let g:my_settings.dir = {}
let g:my_settings.dir.trash_dir = expand('~/.Trash/')
let g:my_settings.dir.swap_dir  = expand('~/.Trash/vimswap')
let g:my_settings.dir.bundle    = expand('~/.bundle')
let g:my_settings.dir.vimref    = expand('~/.Trash/vim-ref')
let g:my_settings.dir.memolist  = expand('~/.memolist')
let g:my_settings.dir.ctrlp     = expand('~/.Trash/ctrlp')
let g:my_settings.dir.rsense    = expand('~/.vim/ref/rsense-0.3')
let g:my_settings.dir.snippets  = expand('~/.vim/snippet')

let g:my_settings.bin = {}
let g:my_settings.bin.ri = expand('~/.rbenv/versions/1.9.3-p125/bin/ri')

let g:my_settings.ft               = {}
let g:my_settings.ft.html_files    = ['eruby', 'html', 'php', 'haml']
let g:my_settings.ft.ruby_files    = ['ruby', 'Gemfile', 'haml', 'eruby']
let g:my_settings.ft.python_files  = ['python']
let g:my_settings.ft.scala_files   = ['scala']
let g:my_settings.ft.sh_files      = ['sh']
let g:my_settings.ft.program_files = ['ruby', 'php', 'python', 'eruby', 'vim']

let g:my_settings.github = {}
let g:my_settings.github.url = 'https://github.com/'
let g:my_settings.github.user = 'taichouchou2'

if  g:my_settings.initialize
  source ~/.vim/config/.vimrc.initialize
endif

let s:is_windows = has('win32') || has('win64')
let s:is_mac     = has('mac')
let s:is_unix    = has('unix')
"}}}

"----------------------------------------
"基本"{{{
let mapleader = ","
set backspace=indent,eol,start
set browsedir=buffer
set clipboard+=autoselect
set clipboard+=unnamed
exe "set directory=".g:my_settings.dir.swap_dir
set formatoptions+=lcqmM formatoptions-=ro
set helplang=ja,en
set modelines=0
set nobackup
set showmode
set timeout timeoutlen=300 ttimeoutlen=100
set vb t_vb=
set viminfo='100,<800,s300,\"300
set updatetime=4000 " swpを作るまでの時間(au CursorHoldの時間)
set norestorescreen=off
if v:version >= 703
  set undofile
  let &undodir=&directory
endif

nnoremap <Space>h :<C-u>help<Space><C-r><C-w><CR>
nnoremap <Space><Space>s :<C-U>source ~/.vimrc<CR>
nnoremap <Space><Space>v :<C-U>tabnew ~/.vim/config/.vimrc<CR>
"}}}

"----------------------------------------
"StatusLine" {{{
" source ~/.vim/config/.vimrc.statusline
" }}}

"----------------------------------------
"編集"{{{
" set textwidth=100
set autoread
set hidden
set nrformats-=octal
set textwidth=0

"開いているファイルのディレクトリに自動で移動
aug MyAutoCmd
  au BufEnter * execute ":lcd " . expand("%:p:h")
aug END

" 新しいバッファを開くときに、rubyか同じファイルタイプで開く {{{
" 引数は何でもいい. あるか無いかのみ判断
function! s:new_buffer(...)
  let old_ft = &ft

  " set filetype
  if a:1 != 'copy' || empty(old_ft)
    let ft = 'ruby'
    echo "new buffer"
  else
    let ft = old_ft
    echo "copy ft"
  endif
  let cmd = 'setl ft='.ft

  call <SID>smart_split_new(cmd)
endfunction
command! -nargs=* NewBuffer call <SID>new_buffer(<q-args>)

nnoremap <silent><C-W>n     :<C-U>NewBuffer<CR>
nnoremap <silent><C-W><C-N> :<C-U>NewBuffer copy<CR>
"}}}
" 対応を自動補完 {{{
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
aug MyAutoCmd
  au FileType ruby,eruby,haml inoremap <buffer>\| \|\|<Left>
aug END
augroup MyXML
  autocmd!
  autocmd Filetype xml,html,eruby inoremap <buffer> </ </<C-x><C-o>
augroup END
"}}}
" 整列系 {{{
" xnoremap <S-TAB>  <
" xnoremap <TAB>  >
xnoremap < <gv
xnoremap <C-M> :sort<CR>
xnoremap > >gv
"}}}
" 便利系 {{{
nnoremap <silent><Space>w :wq<CR>
nnoremap <silent><Space><Space>w :wall!<CR>
nnoremap <silent><Space>q :q!<CR>
nnoremap <silent><Space><Space>q :qall!<CR>
nnoremap <silent><Space>s :w sudo:%<CR>
nnoremap re :%s!
xnoremap re :s!
vnoremap rep y:%s!<C-r>=substitute(@0, '!', '\\!', 'g')<Return>!!g<Left><Left>
nnoremap <Leader>f :setl ft=
"}}}
" コメントを書くときに便利 {{{
inoremap <leader>* ****************************************
inoremap <leader>- ----------------------------------------
inoremap <leader>h <!-- / --><left><left><left><Left>
"}}}
" 変なマッピングを修正 "{{{
if has('gui_macvim')
  map ¥ \
  inoremap ¥ \
  nnoremap ¥ \
  cmap ¥ \
  smap ¥ \

  inoremap [ [
endif

" キーボードの自動判別はできないのかね。。。
if g:my_settings.keyboard_type == 'us'
  cnoremap : ;
  cnoremap ; :
  xnoremap ; :
  xnoremap : ;
  inoremap : ;
  inoremap ; :
  noremap : ;
  noremap ; :
endif
"}}}

" 保存時に無駄な文字を消す {{{
function! s:remove_dust()
  if !exists('b:remove_dust_enable')
    return
  endif

  if b:remove_dust_enable == 0|return|endif

  let cursor = getpos(".")
  let space_length = &ts > 0? &ts : 2
  let space  = ""
  while space_length > 0
    let space .= " "
    let space_length -= 1
  endwhile

  %s/\s\+$//ge
  exec "%s/\t/".space."/ge"
  call setpos(".", cursor)
  unlet cursor
endfunction

command! RemoveDustEnable  let b:remove_dust_enable=1
command! RemoveDustDisable let b:remove_dust_enable=0
command! RemoveDustRun call <SID>remove_dust()

let g:remove_dust_enable=1
augroup RemoveDust
  au!
  au BufWritePre * call <SID>remove_dust()
  au BufEnter    * let b:remove_dust_enable = g:remove_dust_enable
augroup END
"}}}

" htmlを変換 {{{
function! s:HtmlEscape()
  silent s/&/\&amp;/eg
  silent s/</\&lt;/eg
  silent s/>/\&gt;/eg
endfunction
function! s:HtmlUnEscape()
  silent s/&lt;/</eg
  silent s/&gt;/>/eg
  silent s/&amp;/\&/eg
endfunction

xmap <silent>eh :call <SID>HtmlEscape()<CR>
xmap <silent>dh :call <SID>HtmlUnEscape()<CR>
" }}}

" Improved increment.{{{
nmap <C-A> <SID>(increment)
nmap <C-X> <SID>(decrement)
nmap <silent> <SID>(increment) :AddNumbers 1<CR>
nmap <silent> <SID>(decrement) :AddNumbers -1<CR>
function! s:add_numbers(num)
  let prev_line = getline('.')[: col('.')-1]
  let next_line = getline('.')[col('.') :]
  let prev_num = matchstr(prev_line, '\d\+$')
  if prev_num != ''
    let next_num = matchstr(next_line, '^\d\+')
    let new_line = prev_line[: -len(prev_num)-1] .
          \ printf('%0'.len(prev_num).'d',
          \    max([0, prev_num . next_num + a:num])) . next_line[len(next_num):]
  else
    let new_line = prev_line . substitute(next_line, '\d\+',
          \ "\\=printf('%0'.len(submatch(0)).'d',
          \         max([0, submatch(0) + a:num]))", '')
  endif

  if getline('.') !=# new_line
    call setline('.', new_line)
  endif
endfunction
command! -range -nargs=1 AddNumbers
      \ call <SID>add_numbers((<line2>-<line1>+1) * eval(<args>))
"}}}
"}}}

"----------------------------------------
"検索"{{{
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch
nnoremap <silent> n nvv
nnoremap <silent> N Nvv

let Grep_Skip_Dirs = '.svn .git .swp'
let Grep_Skip_Files = '*.bak *~'
let Grep_Find_Use_Xargs = 0
let Grep_Xargs_Options = '--print0'

"grepをしたときにQuickFixで表示するようにする
set grepprg=grep\ -nH
"}}}

"----------------------------------------
"移動"{{{
set ww=b,s,h,l,~,<,>,[,]
set virtualedit+=block
" set virtualedit=all " 仮想端末

" 基本的な動き {{{
inoremap <silent><C-K> <End>
inoremap <silent><C-L> <Right>
inoremap <silent><C-O> <Esc>o
inoremap jj <Esc>
nnoremap $ g_
vnoremap $ g_
nnoremap <silent><Down> gj
nnoremap <silent><Up>   gk
nnoremap <silent>j gj
nnoremap <silent>k gk

vnoremap H <Nop>
vnoremap v G
"}}}
" 画面の移動 {{{
nnoremap <C-L> <C-T>
nnoremap <C-W><C-J><C-h> <C-W>j<C-W>h
nnoremap <C-W><C-H><C-j> <C-W>h<C-W>j
nnoremap <C-W><C-H><C-k> <C-W>h<C-W>k
nnoremap <C-W><C-K><C-H> <C-W>k<C-W>h
nnoremap <C-W><C-K><C-L> <C-W>k<C-W>l
nnoremap <C-W><C-l><C-j> <C-W>l<C-W>j
nnoremap <C-W><C-l><C-k> <C-W>l<C-W>k
nnoremap <silent>L            :call <SID>NextWindowOrTab()<CR>
nnoremap <silent>H            :call <SID>PreviousWindowOrTab()<CR>
nnoremap <silent><C-W>]       :call PreviewWord()<CR>
nnoremap <silent><C-W><Space> :<C-u>SmartSplit<CR>
"}}}
" tabを使い易く{{{

nmap [tag_or_tab] <Nop>
nmap t [tag_or_tab]
nnoremap <silent>[tag_or_tab]n  :tabn<CR>
nnoremap <silent>[tag_or_tab]p  :tabprevious<CR>
nnoremap <silent>[tag_or_tab]c  :tabnew<CR>
nnoremap <silent>[tag_or_tab]x  :tabclose<CR>
nnoremap <silent>[tag_or_tab]o  <C-W>T
nnoremap <silent>[tag_or_tab]w  :call <SID>CloseTabAndOpenBufferIntoPreviousWindow()<CR>
nnoremap <silent>[tag_or_tab]e  :execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>

nnoremap <silent>[tag_or_tab]1  :tabnext 1<CR>
nnoremap <silent>[tag_or_tab]2  :tabnext 2<CR>
nnoremap <silent>[tag_or_tab]3  :tabnext 3<CR>
nnoremap <silent>[tag_or_tab]4  :tabnext 4<CR>
nnoremap <silent>[tag_or_tab]5  :tabnext 5<CR>
nnoremap <silent>[tag_or_tab]6  :tabnext 6<CR>
" }}}

" 前回終了したカーソル行に移動
aug MyAutoCmd
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
aug END

function! PreviewWord() "{{{
  if &previewwindow | return | endif

  let w = expand("<cword>")
  if w =~ '\a'
    silent! wincmd P
    if &previewwindow
      match none
      wincmd p
    endif

    try
      exe "ptag " . w
    catch
      return
    endtry

    silent! wincmd P
    if &previewwindow
      if has("folding")
        silent! .foldopen
      endif
      call search("$", "b")
      let w = substitute(w, '\\', '\\\\', "")
      call search('\<\V' . w . '\>')

      wincmd p
    endif
  endif
endfunction "}}}
" smart split window {{{
function! s:smart_close() "{{{
  if winnr('$') != 1
    close
  endif
endfunction"}}}
function! s:NextWindowOrTab() "{{{
  if tabpagenr('$') == 1 && winnr('$') == 1
    call s:smart_split()
  elseif winnr() < winnr("$")
    wincmd w
  else
    tabnext
    1wincmd w
  endif
endfunction"}}}
function! s:PreviousWindowOrTab() "{{{
  if winnr() > 1
    wincmd W
  else
    tabprevious
    execute winnr("$") . "wincmd w"
  endif
endfunction"}}}
function! s:smart_split_how() "{{{
  if winwidth(0) > winheight(0) * 2
    return 'v'
  else
    return 's'
  endif
endfunction
function! s:smart_split(...) "{{{
  if <SID>smart_split_how() == 'v'
    vsplit
  else
    split
  endif

  if a:0 > 0
    execute a:1
  endif
endfunction"}}}
function! s:smart_split_new(...) "{{{
  if <SID>smart_split_how() == 'v'
    vnew
  else
    new
  endif

  if a:0 > 0
    execute a:1
  endif
endfunction "}}}

command! -nargs=? -complete=command SmartSplit call <SID>smart_split(<q-args>)
"}}}

" 現在開いているタブとバッファを閉じて
" 一つ前のタブと統合する
function! s:CloseTabAndOpenBufferIntoPreviousWindow() "{{{
  let buffer = bufnr('%')
  if ( tabpagenr("$") != 1)
    q
  endif

  tablast
  call s:smart_split()
  exec 'buffer '.buffer
endfunction"}}}
"}}}
"}}}

"----------------------------------------
"encoding"{{{
set fileformats=unix,dos,mac
set encoding=utf-8
set fileencodings=utf-8,sjis,shift-jis,euc-jp,utf-16,ascii,ucs-bom,cp932,iso-2022-jp

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932     edit ++enc=cp932
command! Eucjp     edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8      edit ++enc=utf-8
command! Sjis      edit ++enc=sjis
"}}}

"----------------------------------------
"インデント"{{{
set autoindent
set smartindent
set expandtab
set tabstop=2
set softtabstop=2
set shiftwidth=2
filetype indent on
"}}}

"----------------------------------------
"表示"{{{
" set noequalalways     " 画面の自動サイズ調整解除
" set relativenumber    " 相対表示
" set scrolljump=-50
" set scrolloff=999     " 常にカーソルを真ん中に
set breakat=\\;:,!?
set cdpath+=~
set cmdheight=1
set cursorline
set equalalways       " 画面の自動サイズ調整
set laststatus=2
set lazyredraw
set linebreak
set list
set listchars=tab:␣.,trail:_,extends:>,precedes:<
set matchpairs+=<:>
set number
set scrolloff=5
set showcmd
set showfulltag
set showmatch
set spelllang=en_us
set t_Co=256
set title
set titlelen=95
set ttyfast

au FileType coffee,ruby,eruby,php,javascript,c,json,vim set colorcolumn=80

"折り畳み
" set commentstring=%s
" set foldlevelstart=1
" set foldminlines=3
" set foldopen=all
set foldcolumn=1
set foldenable
set foldmethod=marker
set foldnestmax=5

syntax on

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/
"au BufRead,BufNew * match JpSpace /　/

" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

colorscheme molokai
"}}}

"----------------------------------------
" Tags関連 cTags使う場合は有効化 "{{{
" http://vim-users.jp/2010/06/hack154/

set tags& tags-=tags tags+=./tags;
set tags+=./**/tags

function! SetTags()
  let g:current_git_root = system('git rev-parse --show-cdup')
  let g:current_dir = expand("%:p:h")
  if filereadable(g:current_dir.'/tags')
    let tags = expand(g:current_dir.'/tags')
    execute 'setl tags+='.tags
  endif
  if filereadable(g:current_git_root.'/tags')
    let tags = expand(g:current_git_root.'/tags')
    execute 'setl tags+='.tags
  endif
endfunction
aug MyAutoCmd
  au BufEnter * call SetTags()
aug END

" よくわかんね
function! s:TagsUpdate()
  setlocal tags=
  for filename in neocomplcache#sources#include_complete#get_include_files(bufnr('%'))
    execute 'setlocal tags+='.neocomplcache#cache#encode_name('tags_output', filename)
  endfor
endfunction

command!  -nargs=? PopupTags call <SID>TagsUpdate() |call BundleWithCmd('unite-tag unite.vim', 'Unite tag:'<args>)

"tags_jumpを使い易くする
nnoremap [tag_or_tab]t  <C-]>
nnoremap [tag_or_tab]h  :<C-u>pop<CR>
nnoremap [tag_or_tab]l  :<C-u>tag<CR>
nnoremap [tag_or_tab]j  :<C-u>tprevious<CR>
nnoremap [tag_or_tab]k  :<C-u>tags<CR>
nnoremap [tag_or_tab]s  :<C-u>tselect<CR>
"}}}

"----------------------------------------
" neobundle"{{{
filetype plugin indent off     " required!

" initialize"{{{
if has('vim_starting')
  let bundle_dir = g:my_settings.dir.bundle
  if !isdirectory(bundle_dir.'/neobundle.vim')
    call system( 'git clone https://github.com/Shougo/neobundle.vim.git '.bundle_dir.'/neobundle.vim')
  endif

  exe 'set runtimepath+='.bundle_dir.'/neobundle.vim'
  call neobundle#rc(bundle_dir)
endif

augroup MyNeobundle
  au!
  au Syntax vim syntax keyword vimCommand NeoBundle NeoBundleLazy NeoBundleSource NeoBundleFetch
augroup END
"}}}

" 暫定customize {{{
function! Neo_al(ft) "{{{
  return { 'autoload' : {
      \ 'filetype' : a:ft
      \ }}
endfunction"}}}
function! Neo_operator(mappings) "{{{
  return {
        \ 'depends' : 'kana/vim-textobj-user',
        \ 'autoload' : {
        \   'mappings' : a:mappings
        \ }}
endfunction"}}}
function! BundleLoadDepends(bundle_names) "{{{
  if !exists('g:loaded_bundles')
    let g:loaded_bundles = {}
  endif

  " bundleの読み込み
  if !has_key( g:loaded_bundles, a:bundle_names )
    execute 'NeoBundleSource '.a:bundle_names
    let g:loaded_bundles[a:bundle_names] = 1
  endif
endfunction"}}}
"}}}

" コマンドを伴うやつの遅延読み込み
function! BundleWithCmd(bundle_names, cmd) "{{{
  call BundleLoadDepends(a:bundle_names)

  " コマンドの実行
  if !empty(a:cmd)
    execute a:cmd
  endif
endfunction "}}}
"}}}
"bundle"{{{
"----------------------------------------
" vim基本機能拡張 {{{
NeoBundleLazy 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
" NeoBundle 'yuroyoro/vim-autoclose'                          " 自動閉じタグ
NeoBundleLazy 'edsono/vim-matchit', { 'autoload' : {
      \ 'mappings' : '%' }}
NeoBundleLazy 'kana/vim-arpeggio', { 'autoload': { 'functions': ['arpeggio#map'] }}
" 同時押しキーマップを使う
NeoBundleLazy 'rhysd/accelerated-jk', {
      \ 'autoload' : {
      \   'mappings' : [
      \     ['n', '<Plug>(accelerated_jk_gj)'], ['n', '<Plug>(accelerated_jk_gk)']
      \ ]}}
" NeoBundle 'vim-scripts/Smooth-Scroll'
NeoBundle g:my_settings.github.url.'taichouchou2/alpaca'   " 個人的なカラーやフォントなど
NeoBundleLazy 'tpope/vim-surround', {
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>Dsurround'], ['nx', '<Plug>Csurround'],
      \     ['nx', '<Plug>Ysurround'], ['nx', '<Plug>YSurround'],
      \     ['nx', '<Plug>Yssurround'], ['nx', '<Plug>YSsurround'],
      \     ['nx', '<Plug>YSsurround'], ['vx', '<Plug>VgSurround'],
      \     ['vx', '<Plug>VSurround']
      \ ]}}
NeoBundleLazy 'tpope/vim-fugitive', { 'autoload' : { 'commands': ['Gcommit', 'Gblame', 'Ggrep', 'Gdiff'] }}
" NeoBundleLazy 'Lokaltog/vim-powerline', {
"       \ 'depends': ['majutsushi/tagbar', 'tpope/vim-fugitive'] }
NeoBundleLazy 'taichouchou2/alpaca_powerline', {
      \ 'depends': ['majutsushi/tagbar', 'tpope/vim-fugitive'],
      \ 'autoload' : { 'functions': ['Pl#UpdateStatusline', 'Pl#Hi#Allocate', 'Pl#Hi#Segments', 'Pl#Colorscheme#Init',]  }}
function! s:startup_powerline() "{{{
  aug PowerlineMain
    au!
    au BufEnter,WinEnter,FileType,BufUnload,CmdWinEnter * call Pl#UpdateStatusline(1)
    au BufLeave,WinLeave,CmdWinLeave * call Pl#UpdateStatusline(0)
  aug END

  call Pl#UpdateStatusline(1)
  au! StartUpPowerline
endfunction
aug StartUpPowerline
  au VimEnter * call s:startup_powerline()
aug END
"}}}
NeoBundle 'h1mesuke/vim-alignta', { 'autoload' : { 'commands' : ['Align'] } }
"}}}
" vim拡張"{{{
" NeoBundle 'taku-o/vim-toggle' "true<=>false など、逆の意味のキーワードを切り替えられる
" NeoBundle 'yuroyoro/vimdoc_ja'
" NeoBundle 'kana/vim-altr' " 関連するファイルを切り替えれる
NeoBundleLazy 'Shougo/unite.vim', {
      \ 'autoload': { 'commands': [ 'Unite', 'UniteBookmarkAdd', 'UniteClose', 'UniteResume', 'UniteWithBufferDir', 'UniteWithCurrentDir', 'UniteWithCursorWord', 'UniteWithInput', 'UniteWithInputDirectory' ] }
      \ }
NeoBundleLazy 'vim-scripts/sudo.vim', {
      \ 'autoload': { 'commands': ['SudoRead', 'SudoWrite'], 'insert': 1 }
      \ }
NeoBundleLazy 'Shougo/vimfiler', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload': { 'commands': [
      \   'VimFiler', 'VimFilerBufferDir', 'VimFilerClose', 'VimFilerCreate', 'VimFilerCurrentDir', 'VimFilerDetectDrives', 'VimFilerDouble', 'VimFilerExplorer', 'VimFilerExplorerGit', 'VimFilerSimple'
      \ ]}
      \ }
" VimFiler の読み込みを遅延しつつデフォルトのファイラに設定 "{{{
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
function! s:load_vimfiler(path)
  let path = a:path
  " For ":edit ~".
  if fnamemodify(path, ':t') ==# '~'
    let path = '~'
  endif

  if isdirectory(expand(path))
    NeoBundleSource vimfiler
  endif

  autocmd! LoadVimFiler
endfunction

" 起動時にディレクトリを指定した場合
for arg in argv()
  if isdirectory(getcwd().'/'.arg)
    NeoBundleSource vimfiler
    autocmd! LoadVimFiler
    break
  endif
endfor
"}}}
NeoBundleLazy 'grep.vim', { 'autoload' : { 'commands': ["Grep", "Rgrep"] }}
NeoBundleLazy 'kien/ctrlp.vim', { 'autoload' : { 'commands' : ['CtrlPBuffer', 'CtrlPDir']}}
NeoBundleLazy 'sjl/gundo.vim', { 'autoload' : { 'commands': ["GundoToggle", 'GundoRenderGraph'] }}
NeoBundleLazy 'Shougo/git-vim', { 'autoload' : { 'commands': ["GitDiff", "GitLog", "GitAdd", "Git", "GitCommit", "GitBlame", "GitBranch", "GitPush"] }}
NeoBundleLazy 'Shougo/neocomplcache', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}

NeoBundleLazy 'Shougo/neosnippet', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}

NeoBundleLazy 'camelcasemotion', { 'autoload' : {
      \ 'mappings' : ['<Plug>CamelCaseMotion_w', '<Plug>CamelCaseMotion_b', '<Plug>CamelCaseMotion_e', '<Plug>CamelCaseMotion_iw', '<Plug>CamelCaseMotion_ib', '<Plug>CamelCaseMotion_ie']
      \ }}
NeoBundleLazy 'majutsushi/tagbar', { 'autoload' : { 'commands': ['TagbarToggle'], 'fuctions': ['tagbar#currenttag'] }}
NeoBundleLazy 'mattn/zencoding-vim', {
      \ 'autoload': {
      \   'functions': ['zencoding#expandAbbr'],
      \   'filetypes': g:my_settings.ft.html_files,
      \ }}
NeoBundleLazy 'nathanaelkane/vim-indent-guides', {
      \ 'autoload': {
      \   'commands': ['IndentGuidesEnable'],
      \   'filetypes': g:my_settings.ft.program_files,
      \ }}
NeoBundleLazy 'open-browser.vim', { 'autoload' : {
      \ 'mappings' : [ '<Plug>(open-browser-wwwsearch)', '<Plug>(openbrowser-open)',  ],
      \ 'commands' : ['OpenBrowserSearch']
      \ }}
NeoBundleLazy 'kana/vim-smartword', '', 'same', { 'autoload' : {
      \ 'mappings' : [
      \   '<Plug>(smartword-w)', '<Plug>(smartword-b)', '<Plug>(smartword-ge)']
      \ }}
NeoBundleLazy 't9md/vim-textmanip', { 'autoload' : {
      \ 'mappings' : ['<Plug>(textmanip-move-down)', '<Plug>(textmanip-move-up)', '<Plug>(textmanip-move-left)', '<Plug>(textmanip-move-right)']
      \ }}
NeoBundleLazy 'thinca/vim-ref', { 'autoload' : {
      \ 'commands' : 'Ref'
      \ }}
NeoBundle 'tomtom/tcomment_vim', { 'autoload' : { 'commands' : ['TComment', 'TCommentAs', 'TCommentMaybeInline'] } }
NeoBundleLazy 'Shougo/vimshell', { 'autoload': {
      \   'commands': ['VimShell']
      \ }}
" NeoBundleLazy 'yomi322/vim-gitcomplete', Neo_al('vimshell')
NeoBundleLazy 'mattn/gist-vim', {
      \ 'depends': ['mattn/webapi-vim' ],
      \ 'autoload' : {
      \ 'commands' : 'Gist'
      \ }}
NeoBundleLazy 'thinca/vim-quickrun', { 'autoload' : {
      \ 'mappings' : [
      \   ['nxo', '<Plug>(quickrun)']],
      \ }}

"----------------------------------------
" text-object拡張"{{{
" operator拡張の元
" NeoBundle 'emonkak/vim-operator-comment'
" NeoBundle 'https://github.com/kana/vim-textobj-jabraces.git'
" NeoBundle 'kana/vim-textobj-datetime'      " d 日付
" NeoBundle 'kana/vim-textobj-fold.git'      " z 折りたたまれた{{ {をtext-objectに
" NeoBundle 'kana/vim-textobj-lastpat.git'   " /? 最後に検索されたパターンをtext-objectに
" NeoBundle 'kana/vim-textobj-syntax.git'    " y syntax hilightされたものをtext-objectに
" NeoBundle 'textobj-entire'                 " e buffer全体をtext-objectに
" NeoBundle 'thinca/vim-textobj-comment'     " c commentをtext-objectに
" NeoBundle 'kana/vim-textobj-function.git'  " f 関数をtext-objectに
NeoBundle 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-textobj-indent.git', Neo_operator([
      \ ['nx', '<Plug>(textobj-indent-a)' ], ['nx', '<Plug>(textobj-indent-i)'], ['nx', '<Plug>(textobj-indent-same-a)'], ['nx', '<Plug>(textobj-indent-same-i)']
      \ ])
NeoBundleLazy 'kana/vim-textobj-user'
NeoBundle 'operator-camelize', Neo_operator([
      \ ['nx', '<Plug>(operator-camelize)'], ['nx', '<Plug>(operator-decamelize)']
      \ ])
" NeoBundle 'tyru/operator-html-escape.vim'
"}}}
"}}}
" その他 {{{
" NeoBundle 'tyru/urilib.vim' "urilib.vim : vim scriptからURLを扱うライブラリ
" NeoBundle 'kana/vim-smartchr' "smartchr.vim : ==()などの前後を整形
NeoBundleLazy 'mattn/webapi-vim' "vim Interface to Web API
NeoBundleLazy 'scrooloose/syntastic', Neo_al(g:my_settings.ft.program_files)
NeoBundleLazy g:my_settings.github.url.'taichouchou2/alpaca_look.git', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}
NeoBundleLazy 'rhysd/clever-f.vim', { 'autoload' : {
      \ 'mappings' : 'f',
      \ }}
" NeoBundle 'choplin/unite-vim_hacks'
" NeoBundle 'h1mesuke/unite-outline'
" NeoBundle 'tacroe/unite-mark'
" NeoBundleLazy 'yuratomo/w3m.vim'
NeoBundleLazy 'tsukkee/unite-tag', { 'depends' :
      \ ['Shougo/unite.vim'] }
NeoBundleLazy 'glidenote/memolist.vim', { 'depends' :
      \ ['Shougo/unite.vim'],
      \ 'autoload' : { 'commands' : ['MemoNew', 'MemoGrep'] }}
NeoBundleLazy 'Shougo/unite-ssh'
NeoBundleLazy 'taichouchou2/vim-unite-giti'
NeoBundleLazy 'thinca/vim-unite-history'
NeoBundleLazy 'ujihisa/vimshell-ssh', { 'autoload' : {
      \ 'filetypes' : 'vimshell',
      \ }}
NeoBundleLazy 'basyura/TweetVim', { 'depends' :
      \ ['basyura/twibill.vim', 'tyru/open-browser.vim', 'Shougo/unite.vim'],
      \ 'autoload' : { 'commands' : 'TweetVimHomeTimeline' }}
NeoBundleLazy 'basyura/bitly.vim'
NeoBundleLazy 'basyura/twibill.vim'
NeoBundleLazy 'tyru/eskk.vim', { 'autoload' : {
      \ 'mappings' : [['i', '<Plug>(eskk:toggle)']],
      \ }}
"}}}
" bundle.lang"{{{

" css
" ----------------------------------------
NeoBundleLazy 'hail2u/vim-css3-syntax',
      \ Neo_al(['css', 'scss', 'sass'])

" html
" ----------------------------------------
NeoBundleLazy 'taichouchou2/html5.vim',
      \ Neo_al(['html', 'haml', 'erb', 'php'])

" haml
" ----------------------------------------
NeoBundleLazy 'tpope/vim-haml',
      \ Neo_al(['haml'])

"  js / coffee
" ----------------------------------------
NeoBundleLazy 'kchmck/vim-coffee-script',
      \ Neo_al(['coffee'])
NeoBundleLazy 'claco/jasmine.vim',
      \ Neo_al(['javascript', 'coffee'])
NeoBundleLazy 'taichouchou2/vim-javascript',
      \ Neo_al(['javascript'])
NeoBundleLazy g:my_settings.github.url.'taichouchou2/vim-json',
      \ Neo_al("json")
NeoBundleLazy 'teramako/jscomplete-vim',
      \ Neo_al(['javascript', 'coffee'])
NeoBundleLazy 'leafgarland/typescript-vim',
      \ Neo_al(['typescript'])

"  go
" ----------------------------------------
NeoBundleLazy 'fsouza/go.vim',
      \ Neo_al(['go'])

"  markdown
" ----------------------------------------
" markdownでの入力をリアルタイムでチェック
" NeoBundle 'mattn/mkdpreview-vim'
NeoBundleLazy 'tpope/vim-markdown',
      \ Neo_al( ['markdown'] )

" sassのコンパイル
NeoBundleLazy 'AtsushiM/sass-compile.vim',
      \ Neo_al( ['sass', 'scss'] )

"  php
" ----------------------------------------
" NeoBundle 'oppara/vim-unite-cake'
NeoBundleLazy g:my_settings.github.url.'taichouchou2/alpaca_wordpress.vim',
      \ Neo_al(['php'])

"  binary
" ----------------------------------------
NeoBundleLazy 'Shougo/vinarise', {
      \ 'depends': ['s-yukikaze/vinarise-plugin-peanalysis'],
      \ 'autoload': { 'commands': 'Vinarise'}}

" objective-c
" ----------------------------------------
" NeoBundle 'msanders/cocoa.vim'

" ruby
" ----------------------------------------
NeoBundle 'tpope/vim-rails'
NeoBundleLazy g:my_settings.github.url.'taichouchou2/vim-endwise.git', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}

" rails
NeoBundleLazy 'basyura/unite-rails'
NeoBundleLazy g:my_settings.github.url.'taichouchou2/unite-rails_best_practices', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'build' : {
      \    'mac': 'gem install rails_best_practices',
      \    'unix': 'gem install rails_best_practices',
      \   }
      \ }
NeoBundleLazy 'ujihisa/unite-rake', {
      \ 'depends' : 'Shougo/unite.vim', }
NeoBundleLazy g:my_settings.github.url.'taichouchou2/alpaca_complete', {
      \ 'depends' : 'tpope/vim-rails',
      \ 'build' : {
      \    'mac':  'gem install alpaca_complete',
      \    'unix': 'gem install alpaca_complete',
      \   }
      \ }

let s:bundle_rails = 'unite-rails unite-rails_best_practices unite-rake alpaca_complete'
aug MyAutoCmd
  au User Rails call BundleLoadDepends(s:bundle_rails)
aug END

" ruby全般
" NeoBundleLazy 'skalnik/vim-vroom'
NeoBundleLazy 'ruby-matchit',
      \ Neo_al(g:my_settings.ft.ruby_files)
NeoBundleLazy 'skwp/vim-rspec',
      \ Neo_al(g:my_settings.ft.ruby_files)
NeoBundleLazy 'taka84u9/vim-ref-ri', {
      \ 'depends': ['Shougo/unite.vim', 'thinca/vim-ref'],
      \ 'autoload': { 'filetypes': g:my_settings.ft.ruby_files } }
NeoBundleLazy 'vim-ruby/vim-ruby',
      \ Neo_al(g:my_settings.ft.ruby_files)
NeoBundleLazy g:my_settings.github.url.'taichouchou2/unite-reek', {
      \ 'build' : {
      \    'mac': 'gem install reek',
      \    'unix': 'gem install reek',
      \ },
      \ 'autoload': { 'filetypes': g:my_settings.ft.ruby_files },
      \ 'depends' : 'Shougo/unite.vim' }
NeoBundleLazy 'Shougo/neocomplcache-rsense', {
      \ 'depends': 'Shougo/neocomplcache',
      \ 'autoload': { 'filetypes': g:my_settings.ft.ruby_files }}
NeoBundleLazy 'rhysd/unite-ruby-require.vim',
      \ Neo_al(g:my_settings.ft.ruby_files)
NeoBundleLazy 'rhysd/vim-textobj-ruby', { 'depends': 'kana/vim-textobj-user' }
NeoBundleLazy 'deris/vim-textobj-enclosedsyntax',
      \ Neo_al(g:my_settings.ft.ruby_files)
NeoBundleLazy 'ujihisa/unite-gem', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload': { 'filetypes': g:my_settings.ft.ruby_files }}
NeoBundleLazy 'rhysd/neco-ruby-keyword-args',
      \ Neo_al(g:my_settings.ft.ruby_files)

NeoBundleLazy 'tpope/vim-cucumber',
      \ Neo_al("cucumber")
NeoBundleLazy 'mutewinter/nginx.vim',
      \ Neo_al(["nginx"])

" python
" ----------------------------------------
" NeoBundle 'Pydiction'
NeoBundleLazy 'yuroyoro/vim-python',
      \ Neo_al(g:my_settings.ft.python_files)
NeoBundleLazy 'davidhalter/jedi-vim', {
      \ 'build' : {
      \     'mac' : 'git submodule update --init',
      \     'unix' : 'git submodule update --init',
      \    },
      \ 'autoload' : { 'filetypes': g:my_settings.ft.python_files }
      \ }
" NeoBundleLazy 'kevinw/pyflakes-vim'

" scala
" ----------------------------------------
NeoBundleLazy g:my_settings.github.url.'taichouchou2/vim-scala',
      \ Neo_al(g:my_settings.ft.scala_files)
" https://github.com/derekwyatt/vim-scala.git

" sh
" ----------------------------------------
NeoBundleLazy 'sh.vim',
      \ Neo_al(g:my_settings.ft.sh_files)
"}}}
" 他のアプリを呼び出すetc "{{{
" NeoBundle 'thinca/vim-openbuf'
" NeoBundle 'vim-scripts/dbext.vim' "<Leader>seでsqlを実行
NeoBundleLazy 'tsukkee/lingr-vim', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload': {
      \ 'commands': ['LingrLaunch', 'LingrExit']}}
NeoBundleLazy 'mattn/excitetranslate-vim', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload' : { 'commands': ['ExciteTranslate']}
      \ }

"}}}
" Installation check. "{{{
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Install Plugins'
  NeoBundleInstall
endif
"}}}
filetype plugin indent on
"}}}

"----------------------------------------
"個別のプラグイン " {{{
" jk同時押しで<ESC>
" nofの表示を無くして、カーソル移動も無くしたかったので、大分ださい
call arpeggio#map('i', '', 0, 'jk', '<Esc>:noh<CR>:echo ""<CR>')
call arpeggio#map('v', '', 0, 'jk', '<C-[>:noh<CR>:echo ""<CR>')
" call arpeggio#map('n', '', 0, 'jk', '<Esc>:noh<CR>')

"------------------------------------
" vim-alignta
"------------------------------------
"{{{
" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3
vnoremap <C-N> :Align<Space>
vnoremap <C-N><C-N> :Align =<CR>
"}}}

"------------------------------------
" vim-surround
"------------------------------------
" {{{
nmap ds  <Plug>Dsurround
nmap cs  <Plug>Csurround
nmap ys  <Plug>Ysurround
nmap yS  <Plug>YSurround
nmap yss <Plug>Yssurround
nmap ySs <Plug>YSsurround
nmap ySS <Plug>YSsurround
xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround
vmap s   <Plug>VSurround

" surround_custom_mappings.vim"{{{
let g:surround_custom_mapping = {}
let g:surround_custom_mapping._ = {
      \ 'p':  "<pre> \r </pre>",
      \ 'w':  "%w(\r)",
      \ }
let g:surround_custom_mapping.help = {
      \ 'p':  "> \r <",
      \ }
let g:surround_custom_mapping.ruby = {
      \ '-':  "<% \r %>",
      \ '=':  "<%= \r %>",
      \ '9':  "(\r)",
      \ '5':  "%(\r)",
      \ '%':  "%(\r)",
      \ 'w':  "%w(\r)",
      \ '#':  "#{\r}",
      \ '3':  "#{\r}",
      \ 'e':  "begin \r end",
      \ 'E':  "<<EOS \r EOS",
      \ 'i':  "if \1if\1 \r end",
      \ 'u':  "unless \1unless\1 \r end",
      \ 'c':  "class \1class\1 \r end",
      \ 'm':  "module \1module\1 \r end",
      \ 'd':  "def \1def\1\2args\r..*\r(&)\2 \r end",
      \ 'p':  "\1method\1 do \2args\r..*\r|&| \2\r end",
      \ 'P':  "\1method\1 {\2args\r..*\r|&|\2 \r }",
      \ }
let g:surround_custom_mapping.javascript = {
      \ 'f':  "function(){ \r }"
      \ }
let g:surround_custom_mapping.lua = {
      \ 'f':  "function(){ \r }"
      \ }
let g:surround_custom_mapping.python = {
      \ 'p':  "print( \r)",
      \ '[':  "[\r]",
      \ }
let g:surround_custom_mapping.vim= {
      \'f':  "function! \r endfunction"
      \ }
"}}}
"}}}

" ------------------------------------
" grep.vim
"------------------------------------
"{{{
" カーソル下の単語をgrepする
nnoremap <silent><C-g><C-g> :<C-u>Rgrep<Space><C-r><C-w> *<Enter><CR>
nnoremap <silent><C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><ENTER>

" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs  = '.svn .git .hg .swp'
let Grep_Skip_Files = '*.bak *~'

" qf内でファイルを開いた後画面を閉じる
function! OpenInQF()
  .cc
  ccl
  "  filetype on
endfunction

" rgrepなどで開いたqfを編修可にする
" また、Enterで飛べるようにする
function! OpenGrepQF()
  " cw
  set nowrap "折り返ししない
  " set modifiable "編修可

  " gfで開くときに、新しいTabで開く
  nnoremap <buffer>gf <C-W>gf
  nnoremap <buffer><CR> :call OpenInQF()<CR>
  nnoremap <buffer> q :q!<CR>
endfunction
aug MyAutoCmd
  autocmd Filetype qf call OpenGrepQF()
aug END
"}}}

"------------------------------------
" taglist.Vim
"------------------------------------
"{{{
" let Tlist_Ctags_Cmd = '~/local/bin/jctags' " ctagsのパス
" let Tlist_Show_One_File = 1               " 現在編集中のソースのタグしか表示しない
" let Tlist_Exit_OnlyWindow = 1             " taglistのウィンドーが最後のwindowならばVimを閉じる
" let Tlist_Use_Right_Window = 1            " 右側でtaglistのウィンドーを表示
" let Tlist_Enable_Fold_Column = 1          " 折りたたみ
" let Tlist_Auto_Open = 0                   " 自動表示
" let Tlist_Auto_Update = 1
" let Tlist_WinWidth = 20
" let g:tlist_javascript_settings = 'javascript;c:class;m:method;f:function'
" let tlist_objc_settings='objc;P:protocols;i:interfaces;I:implementations;M:instance methods;C:implementation methods;Z:protocol methods'
" let g:tlist_coffee_settings = 'coffee;f:function;v:variable'
" nnoremap <Space>t :Tlist<CR>
"}}}

"------------------------------------
" tagbar.vim
"------------------------------------
"{{{
nnoremap <Space>t :TagbarToggle<CR>
let g:tagbar_ctags_bin="/Applications/MacVim.app/Contents/MacOS/ctags"
let g:tagbar_compact    = 1
let g:tagbar_autofocus  = 1
let g:tagbar_autoshowtag= 1
let g:tagbar_iconchars  =  ['▸', '▾']

" gem ins coffeetags
if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \   'f:functions',
        \   'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \   'f' : 'object',
        \   'o' : 'object',
        \ }
        \ }
endif

let g:tagbar_type_javascript = {
      \'ctagstype' : 'JavaScript',
      \'kinds'     : [
      \   'o:objects',
      \   'f:functions',
      \   'a:arrays',
      \   's:strings'
      \]
      \}
let g:tagbar_type_php = {
      \ 'kinds' : [
      \ 'c:classes',
      \ 'f:functions',
      \ 'v:variables:1'
      \ ]
      \ }
" let g:tagbar_type_markdown = {
"   \ 'ctagstype' : 'markdown',
"   \ 'kinds' : [
"     \ 'h:Heading_L1',
"     \ 'i:Heading_L2',
"     \ 'k:Heading_L3'
"   \ ]
" \ }
let g:tagbar_type_ruby = {
      \ 'kinds' : [
      \ 'm:modules',
      \ 'c:classes',
      \ 'd:describes',
      \ 'C:contexts',
      \ 'f:methods',
      \ 'F:singleton methods'
      \ ]
      \ }

let g:tagbar_type_html = {
      \ 'ctagstype' : 'html',
      \ 'kinds' : [
      \ 'h:Headers',
      \ 'o:Objects(ID)',
      \ 'c:Classes'
      \ ]
      \ }
let g:tagbar_type_css = {
      \ 'ctagstype' : 'css',
      \ 'kinds' : [
      \ 't:Tags(Elements)',
      \ 'o:Objects(ID)',
      \ 'c:Classes'
      \ ]
      \ }
"}}}

"------------------------------------
" open-blowser.vim
"------------------------------------
"{{{
" カーソル下のURLをブラウザで開く
nmap <Leader>o <Plug>(openbrowser-open)
vmap <Leader>o <Plug>(openbrowser-open)
nnoremap <Leader>g :<C-u>OpenBrowserSearch<Space><C-r><C-w><CR>
"}}}

"------------------------------------
" unite.vim
"------------------------------------
"{{{
" 入力モードで開始する
let g:unite_enable_split_vertically=1
let g:unite_enable_start_insert=1
let g:unite_winheight = 20

"unite prefix key.
nmap [unite] <Nop>
nmap <C-J> [unite]

nmap <silent> [unite]<C-U>   :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nmap <silent> [unite]<C-J>   :<C-u>Unite file_mru<CR>
nmap <silent> [unite]b       :<C-u>Unite bookmark<CR>
nmap <silent> [unite]<C-B>   :<C-u>Unite buffer<CR>
nmap <silent> <Space>b       :<C-u>UniteBookmarkAdd<CR>
let g:unite_quick_match_table = {
      \'a' : 1, 's' : 2, 'd' : 3, 'f' : 4, 'g' : 5, 'h' : 6, 'j' : 7, 'k' : 8, 'l' : 9, ';' : 10,
      \'q' : 11, 'w' : 12, 'e' : 13, 'r' : 14, 't' : 15, 'y' : 16, 'u' : 17, 'i' : 18, 'o' : 19, 'p' : 20,
      \'1' : 21, '2' : 22, '3' : 23, '4' : 24, '5' : 25, '6' : 26, '7' : 27, '8' : 28, '9' : 29, '0' : 30,
      \}
"}}}
function! UniteSetting() "{{{
  inoremap <buffer><C-K> <Up>
  inoremap <buffer><C-J> <Down>
  nnoremap <silent><buffer><expr><C-W>s unite#do_action('split')
  nnoremap <silent><buffer><expr><C-W>v unite#do_action('vsplit')
endfunction
aug MyAutoCmd
  au FileType unite call UniteSetting()
aug END
"}}}

"------------------------------------
" Unite-mark.vim
"------------------------------------
"{{{
" let g:unite_source_mark_marks =
"       \   "abcdefghijklmnopqrstuvwxyz"
"       \ . "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
"       \ . "0123456789.'`^<>[]{}()\""
"}}}

"------------------------------------
" Unite-grep.vim
"------------------------------------
"{{{
let g:unite_source_grep_command = "grep"
let g:unite_source_grep_recursive_opt = "-R"
"}}}

"------------------------------------
" Unite-tag.vim
"------------------------------------
"{{{
" aug MyAutoCmd
"   au BufEnter *
"         \   if empty(&buftype)
"         \|     nnoremap <silent>[unite]<C-K>  :call BundleWithCmd('unite-tag', 'Unite tag -input'<C-R><C-W>)<CR>
"         \|  endif
" aug END
nnoremap <silent>[unite]<C-K>  :call BundleWithCmd('unite-tag unite.vim', 'Unite tag')<CR>
"}}}

"------------------------------------
" Unite-rails.vim
"------------------------------------
"{{{
function! UniteRailsSetting()
  nnoremap <buffer><C-H><C-H><C-H>  :<C-U>Unite rails/view<CR>
  nnoremap <buffer><C-H><C-H>       :<C-U>Unite rails/model<CR>
  nnoremap <buffer><C-H>            :<C-U>Unite rails/controller<CR>

  nnoremap <buffer><C-H>c           :<C-U>Unite rails/config<CR>
  nnoremap <buffer><C-H>s           :<C-U>Unite rails/spec<CR>
  nnoremap <buffer><C-H>m           :<C-U>Unite rails/db -input=migrate<CR>
  nnoremap <buffer><C-H>l           :<C-U>Unite rails/lib<CR>
  nnoremap <buffer><expr><C-H>g     ':e '.b:rails_root.'/Gemfile<CR>'
  nnoremap <buffer><expr><C-H>r     ':e '.b:rails_root.'/config/routes.rb<CR>'
  nnoremap <buffer><expr><C-H>se    ':e '.b:rails_root.'/db/seeds.rb<CR>'
  nnoremap <buffer><C-H>ra          :<C-U>Unite rails/rake<CR>
  nnoremap <buffer><C-H>h           :<C-U>Unite rails/heroku<CR>
endfunction
aug MyAutoCmd
  au User Rails call UniteRailsSetting()
aug END
"}}}

"------------------------------------
" Unite-reek, Unite-rails_best_practices
"------------------------------------
" {{{
nnoremap <silent> [unite]<C-R>      :<C-u>Unite -no-quit reek<CR>
nnoremap <silent> [unite]<C-R><C-R> :<C-u>Unite -no-quit rails_best_practices<CR>
" }}}

"------------------------------------
" VimFiler
"------------------------------------
"{{{
nnoremap <silent><C-H><C-F>  :call VimFilerExplorerGit()<CR>
nnoremap <silent><Leader><Leader>  :VimFilerCreate<CR>
" nnoremap <silent><Leader><Leader>  :VimFilerBufferDir<CR>

" lean more [ utf8 glyph ]( http://sheet.shiar.nl/unicode )
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_sort_type = "filename"
let g:vimfiler_preview_action = ""
let g:vimfiler_enable_auto_cd= 1
let g:vimfiler_file_icon = "-"
let g:vimfiler_readonly_file_icon = "x"
let g:vimfiler_tree_closed_icon = "‣"
let g:vimfiler_tree_leaf_icon = " "
let g:vimfiler_tree_opened_icon = "▾"
let g:vimfiler_marked_file_icon = "✓"

"VimFilerKeyMapping{{{
aug VimFilerKeyMapping
  au!
  au FileType vimfiler call s:vimfiler_local()

  function! s:vimfiler_local()
    if has('unix')
      " 開き方
      call vimfiler#set_execute_file('sh', 'sh')
      call vimfiler#set_execute_file('mp3', 'iTunes')
    endif

    setl nonumber

    " Unite bookmark連携
    nmap <buffer>B :<C-U>UniteBookmarkAdd<CR>
    nmap <buffer><CR> <Plug>(vimfiler_edit_file)
    nmap <buffer>v <Plug>(vimfiler_view_file)

    nmap <buffer><C-J> [unite]
  endfunction
aug END
"}}}

" VimFilerExplorerを自動起動
" gitの場合はgit_rootかつ、バッファの有無でフォーカス変える
function! VimFilerExplorerGit() "{{{
  " TODO 開いているファイルのパスまで、Uniteも開く
  let cmd = bufname("%") != "" ? "2wincmd w" : ""
  let s:git_root = system('git rev-parse --show-cdup')

  if(system('git rev-parse --is-inside-work-tree') == "true\n")
    if s:git_root == "" |let g:git_root = "."| endif
    exe 'VimFilerExplorer -simple ' . substitute( s:git_root, '\n', "", "g" )
  else
    exe 'VimFilerExplorer -simple .'
  endif

  let s:vimfiler_enable = 1

  aug MyGitFiler
    au!
    au BufWinLeave <buffer> let s:vimfiler_enable = 0
    " vimfilerが最後のbufferならばvimを終了
    au BufEnter <buffer> if (winnr('$') == 1 && &filetype ==# 'vimfiler' && s:vimfiler_enable == 1) | q | endif
  aug END

  exe cmd
endfunction "}}}

command! VimFilerExplorerGit call VimFilerExplorerGit()
" VimFilerExplorer自動起動
" au VimEnter * call VimFilerExplorerGit()
"}}}

"------------------------------------
" quickrun.vim
"------------------------------------
"{{{
let g:quickrun_config = {}
let g:quickrun_no_default_key_mappings = 1
"javascriptの実行をnode.jsで
let $JS_CMD='node'
nnoremap <silent><Leader>r :call BundleWithCmd('vim-quickrun', 'QuickRun')<CR>

let g:quickrun_config.lisp = {
      \ 'command': 'clisp'
      \ }

let g:quickrun_config.coffee_compile = {
      \ 'command' : 'coffee',
      \ 'exec' : ['%c -cbp %s']
      \ }

let g:quickrun_config.markdown = {
      \ 'outputter': 'browser',
      \ 'cmdopt': '-s'
      \ }

let g:quickrun_config.ruby = {
      \ 'command': 'ruby'
      \ }

let g:quickrun_config.applescript = {
      \ 'command' : 'osascript' , 'output' : '_'}

let g:quickrun_config['ruby.rspec'] = {
      \ 'type' : 'ruby.rspec',
      \ 'command': 'rspec',
      \ 'exec': 'bundle exec %c %o %s',
      \}

function! s:quickrun_auto_close()
  aug MyQuickRun
    au!
    au WinEnter,BufRead <buffer> if (winnr('$') == 1) | q | endif
  aug END
endfunction

aug MyAutoCmd
  au FileType quickrun call s:quickrun_auto_close()
aug END

"}}}

"------------------------------------
" toggle.vim
"------------------------------------
"{{{
"<C-T>で、true<->falseなど切り替えられる
" inoremap <C-D> <Plug>ToggleI
" nnoremap <C-D> <Plug>ToggleN
" vnoremap <C-D> <Plug>ToggleV
"
" let g:toggle_pairs = { 'and':'or', 'or':'and', 'if':'unless', 'unless':'if', 'yes':'no', 'no':'yes', 'enable':'disable', 'disable':'enable', 'pick':'reword', 'reword':'fixup', 'fixup':'squash', 'squash':'edit', 'edit':'exec', 'exec':'pick'}
"}}}

"----------------------------------------
" zencoding
"----------------------------------------
"{{{
" codaのデフォルトと一緒にする
inoremap <C-E> <ESC>:<C-U>call zencoding#expandAbbr(0, "")<CR>

let g:loaded_zencoding_vim = 1
let g:user_zen_leader_key = '<C-Y>'
let g:zencoding_debug = 0
let g:user_zen_settings = {
      \  'lang' : 'ja',
      \  'html' : {
      \    'filters' : 'html',
      \    'indentation' : ' '
      \  },
      \  'css' : {
      \    'filters' : 'fc',
      \  },
      \}
"}}}

"----------------------------------------
" vim-ref
"----------------------------------------
"{{{
let g:ref_alc_start_linenumber    = 47
let g:ref_open                    = 'split'
let g:ref_cache_dir               = g:my_settings.dir.vimref
let g:ref_refe_cmd                = expand('~/.vim/ref/ruby-ref1.9.2/refe-1_9_2')
let g:ref_phpmanual_path          = expand('~/.vim/ref/php-chunked-xhtml')
let g:ref_ri_cmd                  = g:my_settings.bin.ri

nnoremap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
vnoremap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
nnoremap ra :<C-U>Ref alc<Space>
nnoremap rp :<C-U>Ref phpmanual<Space>
nnoremap rr :<C-U>Unite ref/refe     -default-action=split -input=
nnoremap ri :<C-U>Unite ref/ri       -default-action=split -input=
nnoremap rm :<C-U>Unite ref/man      -default-action=split -input=
nnoremap rpy :<C-U>Unite ref/pydoc   -default-action=split -input=
nnoremap rpe :<C-U>Unite ref/perldoc -default-action=split -input=

aug MyAutoCmd
  au FileType ruby,eruby,ruby.rspec nnoremap <silent><buffer>KK :<C-U>Unite -no-start-insert ref/ri   -input=<C-R><C-W><CR>
  au FileType ruby,eruby,ruby.rspec nnoremap <silent><buffer>K  :<C-U>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
aug END

function! s:initialize_ref_viewer()
  nmap <buffer><CR> <Plug>(ref-keyword)
  nmap <buffer>[tag_or_tab]t   <Plug>(ref-keyword)
  nmap <buffer>[tag_or_tab]h   <Plug>(ref-back)
  nmap <buffer>[tag_or_tab]l   <Plug>(ref-forward)
  setlocal nonumber
endfunction
aug MyAutoCmd
  autocmd FileType ref call s:initialize_ref_viewer()
aug END
"}}}

"----------------------------------------
" vim-fugitive
"----------------------------------------
"{{{
nmap g <Nop>
nmap g g
" nnoremap <Space>gd :<C-U>Gdiff<CR>
" nnoremap <Space>gs :<C-U>Gstatus<CR>
" nnoremap <Space>gl :<C-U>Glog<CR>
" nnoremap <Space>ga :<C-U>Gwrite<CR>
nnoremap <silent>gm :<C-U>Gcommit<CR>
nnoremap <silent>gM :<C-U>Gcommit --amend<CR>
nnoremap <silent>gb :<C-U>Gblame<CR>
nnoremap <silent>gr :<C-U>Ggrep<Space>

aug MyAutoCmd
  au FileType fugitiveblame vertical res 25
aug END
"}}}

"----------------------------------------
" vim-git
"----------------------------------------
" "{{{
" let g:git_command_edit = 'rightbelow vnew'
let g:git_command_edit = 'vnew'
let g:git_no_default_mappings = 1

aug MyAutoCmd
  au FileType git-diff nnoremap<buffer>q :q<CR>
aug END
" " nnoremap <silent><Space>gL :<C-u>GitLog -u \| head -10000<CR>
" " nnoremap <silent><Space>gs :GitStatus<CR>
" nnoremap <silent><Space>gA :<C-u>GitAdd <cfile><CR>
" nnoremap <silent><Space>gB :Gitblanch
" nnoremap <silent><Space>gb :GitBlame<CR>
" nnoremap <silent><Space>gm :GitCommit<CR>
" nnoremap <silent><Space>gp :GitPush<CR>
" nnoremap <silent><Space>gt :Git tag<Space>
" nnoremap <silent>gL :GitLog -10<CR>
" nnoremap <silent>gm :GitCommit --amend<CR>
nnoremap <silent>gA :<C-U>GitAdd<Space>
nnoremap <silent>ga :<C-U>GitAdd -A<CR>
nnoremap <silent>gd :<C-U>GitDiff HEAD<CR>
nnoremap <silent>gD :<C-U>GitDiff<Space>
nnoremap <silent>gp :<C-U>Git push<Space>
"}}}

"----------------------------------------
" unite-giti
"----------------------------------------
"{{{
nnoremap <silent>gl :<C-U>call BundleWithCmd('vim-unite-giti', 'Unite giti/log')<CR>
nnoremap <silent>gs :<C-U>call BundleWithCmd('vim-unite-giti', 'Unite giti/status')<CR>
nnoremap <silent>gh :<C-U>call BundleWithCmd('vim-unite-giti', 'Unite giti/branch_all')<CR>
"}}}

"----------------------------------------
" html5.vim
"----------------------------------------
"{{{
"html5のシンタックスを有効化
"Disable event-handler attributes support:
let g:html5_event_handler_attributes_complete = 0
"Disable RDFa attributes support:
let g:html5_rdfa_attributes_complete = 0
"Disable microdata attributes support:
let g:html5_microdata_attributes_complete = 0
"Disable WAI-ARIA attribute support:
let g:html5_aria_attributes_complete = 0

" HTML 5 tags
syn keyword htmlTagName contained article aside audio bb canvas command
syn keyword htmlTagName contained datalist details dialog embed figure
syn keyword htmlTagName contained header hgroup keygen mark meter nav output
syn keyword htmlTagName contained progress time ruby rt rp section time
syn keyword htmlTagName contained source figcaption
syn keyword htmlArg contained autofocus autocomplete placeholder min max
syn keyword htmlArg contained contenteditable contextmenu draggable hidden
syn keyword htmlArg contained itemprop list sandbox subject spellcheck
syn keyword htmlArg contained novalidate seamless pattern formtarget
syn keyword htmlArg contained formaction formenctype formmethod
syn keyword htmlArg contained sizes scoped async reversed sandbox srcdoc
syn keyword htmlArg contained hidden role
syn match   htmlArg "\<\(aria-[\-a-zA-Z0-9_]\+\)=" contained
syn match   htmlArg contained "\s*data-[-a-zA-Z0-9_]\+"

"}}}

"------------------------------------
" smartword.vim
"------------------------------------
"{{{
map W  <Plug>(smartword-w)
map B  <Plug>(smartword-b)
map E  <Plug>(smartword-e)
"}}}

"------------------------------------
" camelcasemotion.vim
"------------------------------------
"{{{
" <Shift-wbe>でCameCaseやsnake_case単位での単語移動
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
sunmap w
sunmap b
sunmap e
" nnoremap dw d,w

nnoremap diw di,w
nnoremap dib di,b
nnoremap die di,e

" nnoremap viw vi,w
" nnoremap vib vi,b
" nnoremap vie vi,e

nnoremap ciw ci,w
nnoremap cib ci,b
nnoremap cie ci,e

nnoremap daw da,w
nnoremap dab da,b
nnoremap dae da,e

" text-objectで使用できるように
omap <silent>iw <Plug>CamelCaseMotion_iw
xmap <silent>iw <Plug>CamelCaseMotion_iw
omap <silent>ib <Plug>CamelCaseMotion_ib
xmap <silent>ib <Plug>CamelCaseMotion_ib
omap <silent>ie <Plug>CamelCaseMotion_ie
xmap <silent>ie <Plug>CamelCaseMotion_ie
"}}}

"------------------------------------
" matchit.zip
"------------------------------------
"{{{
" % での移動出来るタグを増やす
let b:match_ignorecase = 1
let b:match_words = '<div.*>:</div>,<ul.*>:</ul>,<li.*>:</li>,<head.*>:</head>,<a.*>:</a>,<p.*>:</p>,<form.*>:</form>,<span.*>:</span>,<iflame.*>:</iflame>'
let b:match_words .= ':<if>:<endif>,<while>:<endwhile>,<foreach>:<endforeach>'
"}}}

"------------------------------------
" vim-powerline / alpaca_powerline
"------------------------------------
"{{{
set guifontwide=Ricty:h10
let g:Powerline_cache_enabled = 0
" let g:Powerline_cache_file = expand('/tmp/Powerline.cache')
let g:Powerline_symbols = 'fancy'


" {{{

"{{{
call Pl#Hi#Allocate({
  \ 'black'          : 16,
  \ 'white'          : 231,
  \
  \ 'darkestgreen'   : 22,
  \ 'darkgreen'      : 28,
  \
  \ 'darkestcyan'    : 23,
  \ 'mediumcyan'     : 117,
  \
  \ 'darkestblue'    : 24,
  \ 'darkblue'       : 31,
  \
  \ 'darkestred'     : 52,
  \ 'darkred'        : 88,
  \ 'mediumred'      : 124,
  \ 'brightred'      : 160,
  \ 'brightestred'   : 196,
  \
  \
  \ 'darkestyellow'  : 59,
  \ 'darkyellow'     : 100,
  \ 'darkestpurple'  : 55,
  \ 'mediumpurple'   : 98,
  \ 'brightpurple'   : 189,
  \
  \ 'brightorange'   : 208,
  \ 'brightestorange': 214,
  \
  \ 'gray0'          : 233,
  \ 'gray1'          : 234,
  \ 'gray2'          : 236,
  \ 'gray3'          : 239,
  \ 'gray4'          : 240,
  \ 'gray5'          : 241,
  \ 'gray6'          : 244,
  \ 'gray7'          : 245,
  \ 'gray8'          : 247,
  \ 'gray9'          : 250,
  \ 'gray10'         : 252,
  \ })
"}}}

" 'n': normal mode
" 'i': insert mode
" 'v': visual mode
" 'r': replace mode
" 'N': not active

"{{{
let g:Powerline#Colorschemes#my#colorscheme = Pl#Colorscheme#Init([
  \ Pl#Hi#Segments(['SPLIT'], {
    \ 'n': ['white', 'gray1'],
    \ 'N': ['gray0', 'gray1'],
    \ }),
  \
  \ Pl#Hi#Segments(['mode_indicator'], {
    \ 'i': ['darkestgreen', 'white', ['bold']],
    \ 'n': ['darkestcyan', 'white', ['bold']],
    \ 'v': ['darkestpurple', 'white', ['bold']],
    \ 'r': ['mediumred', 'white', ['bold']],
    \ 's': ['white', 'gray5', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo', 'filename'], {
    \ 'i': ['white', 'darkestgreen', ['bold']],
    \ 'n': ['white', 'darkestblue', ['bold']],
    \ 'v': ['white', 'darkestpurple', ['bold']],
    \ 'r': ['white', 'mediumred', ['bold']],
    \ 'N': ['gray0', 'gray2', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['branch', 'scrollpercent', 'raw', 'filesize'], {
    \ 'n': ['gray2', 'gray7'],
    \ 'N': ['gray0', 'gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo.filepath', 'status'], {
    \ 'n': ['gray10'],
    \ 'N': ['gray5'],
    \ }),
  \
  \ Pl#Hi#Segments(['static_str'], {
    \ 'n': ['white', 'gray4'],
    \ 'N': ['gray1', 'gray1'],
    \ }),
  \
  \ Pl#Hi#Segments(['fileinfo.flags'], {
    \ 'n': ['white'],
    \ 'N': ['gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['currenttag', 'fileformat', 'fileencoding', 'pwd', 'filetype', 'rvm:string', 'rvm:statusline', 'virtualenv:statusline', 'charcode', 'currhigroup'], {
    \ 'n': ['gray9', 'gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['lineinfo'], {
    \ 'n': ['gray2', 'gray10'],
    \ 'N': ['gray2', 'gray4'],
    \ }),
  \
  \ Pl#Hi#Segments(['errors'], {
    \ 'n': ['white', 'gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['lineinfo.line.tot'], {
    \ 'n': ['gray2'],
    \ 'N': ['gray2'],
    \ }),
  \
  \ Pl#Hi#Segments(['paste_indicator', 'ws_marker'], {
    \ 'n': ['white', 'brightred', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:static_str.name', 'command_t:static_str.name'], {
    \ 'n': ['white', 'mediumred', ['bold']],
    \ 'N': ['brightred', 'darkestred', ['bold']],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:static_str.buffer', 'command_t:raw.line'], {
    \ 'n': ['white', 'darkred'],
    \ 'N': ['brightred', 'darkestred'],
    \ }),
  \
  \ Pl#Hi#Segments(['gundo:SPLIT', 'command_t:SPLIT'], {
    \ 'n': ['white', 'darkred'],
    \ 'N': ['white', 'darkestred'],
    \ }),
  \ ])
"}}}
" let g:Powerline_colorscheme='my'
" }}}
"}}}

"------------------------------------
" vimshell
"------------------------------------
"{{{
nnoremap <silent><Leader>v  :<C-U>VimShell<CR>
let g:vimshell_user_prompt  = '"(" . getcwd() . ")" '
let g:vimshell_prompt       = '$ '
let g:vimshell_ignore_case  = 1
let g:vimshell_smart_case   = 1

" vimshell altercommand"{{{
function! s:SID() "{{{
  return matchstr(expand('<sfile>'), '<SNR>\zs\d\+\ze_SID$')
endfunction "}}}
function! s:SNR(map) "{{{
  return printf("<SNR>%d_%s", s:SID(), a:map)
endfunction "}}}
function! s:skip_spaces(q_args) "{{{
  return substitute(a:q_args, '^\s*', '', '')
endfunction "}}}
function! s:parse_one_arg_from_q_args(q_args) "{{{
  let arg = s:skip_spaces(a:q_args)
  let head = matchstr(arg, '^.\{-}[^\\]\ze\([ \t]\|$\)')
  let rest = strpart(arg, strlen(head))

  return [head, rest]
endfunction "}}}
function! s:eat_n_args_from_q_args(q_args, n) "{{{
  let rest = a:q_args
  for _ in range(1, a:n)
    let rest = s:parse_one_arg_from_q_args(rest)[1]
  endfor
  let rest = s:skip_spaces(rest)    " for next arguments.
  return rest
endfunction "}}}

"}}}
function! s:globpath(path, expr) "{{{
  return split(globpath(a:path, a:expr), "\n")
endfunction "}}}

function! s:vimshell_settings() "{{{
  command! -buffer -nargs=+ VimShellAlterCommand
        \   call vimshell#altercmd#define(
        \       s:parse_one_arg_from_q_args(<q-args>)[0],
        \       s:eat_n_args_from_q_args(<q-args>, 1)
        \   )
  VimShellAlterCommand vi vim
  VimShellAlterCommand v vim
  VimShellAlterCommand g git
  VimShellAlterCommand r rails
  VimShellAlterCommand diff diff --unified
  VimShellAlterCommand du du -h
  VimShellAlterCommand free free -m -l -t
  VimShellAlterCommand ll ls -lh
  VimShellAlterCommand la ls -a
  VimShellAlterCommand sudo iexe sudo
  VimShellAlterCommand ssh iexe ssh

  " let g:vimshell_escape_colors = [
  "       \'#3c3c3c', '#ff6666', '#66ff66', '#ffd30a', '#1e95fd', '#ff13ff', '#1bc8c8', '#C0C0C0',
  "       \'#686868', '#ff6666', '#66ff66', '#ffd30a', '#6699ff', '#f820ff', '#4ae2e2', '#ffffff'
  "       \]
endfunction "}}}

aug MyAutoCmd
  au FileType vimshell call s:vimshell_settings()
aug END

"}}}

"------------------------------------
" memolist.vim
"------------------------------------
""{{{
let g:memolist_path              = g:my_settings.dir.memolist
let g:memolist_template_dir_path = g:my_settings.dir.memolist
let g:memolist_memo_suffix       = "mkd"
let g:memolist_memo_date         = "%Y-%m-%d %H:%M"
let g:memolist_memo_date         = "epoch"
let g:memolist_memo_date         = "%D %T"
let g:memolist_vimfiler          = 1

nnoremap <silent><Space>mn  :<C-U>MemoNew<CR>
nnoremap <silent><Space>ml  :<C-U>VimFiler file:~/.memolist/<CR>
nnoremap <silent><Space>mg  :<C-U>MemoGrep<CR>
"}}}

"------------------------------------
" coffee script
"------------------------------------
"{{{
" 保存するたびに、コンパイル
function! AutoCoffeeCompile()
  aug MyAutoCmd
    autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!
  aug END
endfunction
nnoremap <Leader>w :CoffeeCompile watch vert<CR>
"}}}

"------------------------------------
" browsereload-mac
"------------------------------------
"{{{
" リロード後に戻ってくるアプリ
" let g:returnApp = "iTerm"
" nnoremap <Space>bc :ChromeReloadStart<CR>
" nnoremap <Space>bC :ChromeReloadStop<CR>
" nnoremap <Space>bf :FirefoxReloadStart<CR>
" nnoremap <Space>bF :FirefoxReloadStop<CR>
" nnoremap <Space>bs :SafariReloadStart<CR>
" nnoremap <Space>bS :SafariReloadStop<CR>
" nnoremap <Space>bo :OperaReloadStart<CR>
" nnoremap <Space>bO :OperaReloadStop<CR>
" nnoremap <Space>ba :AllBrowserReloadStart<CR>
" nnoremap <Space>bA :AllBrowserReloadStop<CR>
"}}}

"------------------------------------
" t_comment
"------------------------------------
" let g:tcommentMapLeader1 = "<C-_>""{{{
" mappingを消費するので、段々デフォルトになれるべし。
" nnoremap <Leader>x <C-_><C-_>
" nnoremap <Leader>b <C-_>p
" vnoremap <Leader>x <C-_><C-_>

if !exists('g:tcomment_types')
  let g:tcomment_types = {}
endif
let g:tcommentmaps=0

nmap <C-_> [tcomment]
nmap gc [tcomment]
noremap <silent>[tcomment]<c-_> :TComment<CR>
vnoremap <silent>[tcomment]<C-_> :TCommentMaybeInline<CR>

noremap <silent>[tcomment]c :TComment<CR>
vnoremap <silent>[tcomment]c :TCommentMaybeInline<CR>

let g:tcomment_types = {
      \'php_surround'            : "<?php %s ?>",
      \'eruby_surround'          : "<%% %s %%>",
      \'eruby_surround_minus'    : "<%% %s -%%>",
      \'eruby_surround_equality' : "<%%= %s %%>",
      \'eruby_block'             : "<%%=begin rdoc%s=end%%>",
      \'eruby_nodoc_block'       : "<%%=begin%s=end%%>"
      \}
"{{{
function! SetErubyMapping2()
  nnoremap <buffer> <C-_>c :TCommentAs eruby_surround<CR><Right><Right><Right>
  nnoremap <buffer> <C-_><C-C> :TCommentAs eruby_surround<CR><Right><Right><Right>
  nnoremap <buffer> <C-_>- :TCommentAs eruby_surround_minus<CR><Right><Right><Right>
  nnoremap <buffer> <C-_>= :TCommentAs eruby_surround_equality<CR><Right><Right><Right><Right>
  nnoremap <buffer> <C-_>d :TCommentAs eruby_block<CR><Right><Right><Right><Right>
  nnoremap <buffer> <C-_>n :TCommentAs eruby_nodoc_block<CR><Right><Right><Right><Right>

  inoremap <buffer> <C-_>c <%  %><ESC><Left><Left>i
  inoremap <buffer> <C-_><C-C> <%  %><ESC><Left><Left>i
  inoremap <buffer> <C-_>- <%  -%><ESC><Left><Left><Left>i
  inoremap <buffer> <C-_>= <%=  %><ESC><Left><Left>i
  inoremap <buffer> <C-_>d <%=begin rdoc=end%><ESC><Left><Left>i
  inoremap <buffer> <C-_>n <%=begin=end%><ESC><Left><Left>i

  vnoremap <buffer> <C-_>c :TCommentAs eruby_surround<CR>
  vnoremap <buffer> <C-_><C-C> :TCommentAs eruby_surround<CR>
  vnoremap <buffer> <C-_>- :TCommentAs eruby_surround_minus<CR>
  vnoremap <buffer> <C-_>= :TCommentAs eruby_surround_equality<CR>
  nnoremap <buffer> <C-j>c :TCommentAs eruby_surround<CR><Right><Right><Right>
  nnoremap <buffer> <C-j><C-C> :TCommentAs eruby_surround<CR><Right><Right><Right>
  nnoremap <buffer> <C-j>- :TCommentAs eruby_surround_minus<CR><Right><Right><Right>
  nnoremap <buffer> <C-j>= :TCommentAs eruby_surround_equality<CR><Right><Right><Right><Right>
  nnoremap <buffer> <C-j>d :TCommentAs eruby_block<CR><Right><Right><Right><Right>
  nnoremap <buffer> <C-j>n :TCommentAs eruby_nodoc_block<CR><Right><Right><Right><Right>
  inoremap <buffer> <C-j>c <%  %><ESC><Left><Left>i
  inoremap <buffer> <C-j><C-C> <%  %><ESC><Left><Left>i
  inoremap <buffer> <C-j>- <%  -%><ESC><Left><Left><Left>i
  inoremap <buffer> <C-j>= <%=  %><ESC><Left><Left>i
  inoremap <buffer> <C-j>d <%=begin rdoc=end%><ESC><Left><Left>i
  inoremap <buffer> <C-j>n <%=begin=end%><ESC><Left><Left>i
  vnoremap <buffer> <C-j>c :TCommentAs eruby_surround<CR>
  vnoremap <buffer> <C-j><C-C> :TCommentAs eruby_surround<CR>
  vnoremap <buffer> <C-j>- :TCommentAs eruby_surround_minus<CR>
  vnoremap <buffer> <C-j>= :TCommentAs eruby_surround_equality<CR>
endfunction
function! SetRubyMapping()
  nnoremap <buffer> <C-j>b :TCommentAs ruby_block<CR><Right><Right><Right><Right>
  nnoremap <buffer> <C-j>n :TCommentAs ruby_nodoc_block<CR><Right><Right><Right><Right>
  inoremap <buffer> <C-j>b <%=begin rdoc=end%><ESC><Left><Left>i
  inoremap <buffer> <C-j>n <%=begin=end%><ESC><Left><Left>i
  nnoremap <buffer> <C-_>b :TCommentAs ruby_block<CR><Right><Right><Right><Right>
  nnoremap <buffer> <C-_>n :TCommentAs ruby_nodoc_block<CR><Right><Right><Right><Right>
  inoremap <buffer> <C-_>b <%=begin rdoc=end%><ESC><Left><Left>i
  inoremap <buffer> <C-_>n <%=begin=end%><ESC><Left><Left>i
endfunction
"}}}

aug MyAutoCmd
  au FileType eruby call SetErubyMapping2()
  au FileType ruby,ruby.rspec call SetRubyMapping()
  au FileType php nnoremap <buffer><C-_>c :TCommentAs php_surround<CR><Right><Right><Right>
  au FileType php vnoremap <buffer><C-_>c :TCommentAs php_surround<CR><Right><Right><Right>
aug END
"}}}

"------------------------------------
" ctrlp
"------------------------------------
" {{{
let g:ctrlp_cache_dir = g:my_settings.dir.ctrlp
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_lazy_update = 1
" let g:ctrlp_open_new_file = 't'
let g:ctrlp_regexp = 1
let g:ctrlp_show_hidden = 1
let g:ctrlp_use_caching = 1
" let g:ctrlp_mruf_case_sensitive = 0
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.\(hg\|git\|sass-cache\|svn\)$',
      \ 'file': '\.\(dll\|exe\|gif\|jpg\|png\|psd\|so\|woff\)$' }
let g:ctrlp_mruf_exclude = '\(\\\|/\)\(Temp\|Downloads\)\(\\\|/\)\|\(\\\|/\)\.\(hg\|git\|svn\|sass-cache\)'
let g:ctrlp_prompt_mappings = {
      \ 'AcceptSelection("t")': ['<c-n>'],
      \ }

hi link CtrlPLinePre NonText
hi link CtrlPMatch IncSearch

function! s:CallCtrlPBasedOnGitStatus()
  let s:git_status = system('git status')

  if v:shell_error == 128
    execute 'CtrlPCurFile'
  else
    execute 'CtrlP'
  endif
endfunction
nnoremap <silent><C-H><C-B> :CtrlPBuffer<CR>
nnoremap <silent><C-H><C-D> :CtrlPDir<CR>
" nnoremap <silent><C-H><C-G> :CtrlPClearCache<Return>:call <SID>CallCtrlPBasedOnGitStatus()<Return>
" "}}}

"------------------------------------
" vim-ruby
"------------------------------------
"{{{
" function! s:vimRuby()
"   let g:rubycomplete_buffer_loading = 0
"   let g:rubycomplete_classes_in_global = 0
"   let g:rubycomplete_rails = 0
" endfunction
" aug MyAutoCmd
"   au FileType ruby,eruby,ruby.rspec call s:vimRuby()
" aug END
"}}}

"------------------------------------
" vim-rails.vim
"------------------------------------
""{{{
"有効化
let g:dbext_default_SQLITE_bin = 'mysql2'
let g:rails_default_file='config/database.yml'
let g:rails_gnu_screen=1
let g:rails_level = 4
let g:rails_mappings=1
let g:rails_modelines=0
" let g:rails_some_option = 1
" let g:rails_statusline = 1
" let g:rails_subversion=0
" let g:rails_syntax = 1
let g:rails_url='http://localhost:3000'
" let g:rails_ctags_arguments='--languages=-javascript'
" let g:rails_ctags_arguments = ''
function! SetUpRailsSetting()
  nnoremap <buffer><Space>r :R<CR>
  nnoremap <buffer><Space>a :A<CR>
  nnoremap <buffer><Space>m :Rmodel<Space>
  nnoremap <buffer><Space>c :Rcontroller<Space>
  nnoremap <buffer><Space>v :Rview<Space>
  nnoremap <buffer><Space>p :Rpreview<CR>
endfunction

aug MyAutoCmd
  au User Rails call SetUpRailsSetting()
aug END

aug RailsDictSetting
  au!
  " 別の関数に移そうか..
  au User Rails.controller*           let b:file_type_name="rails.controller.ruby"
  au User Rails.view*erb              let b:file_type_name="rails.view.ruby"
  au User Rails.view*haml             let b:file_type_name="rails.view.haml"
  au User Rails.model*                let b:file_type_name="rails.model.ruby"
  au User Rails/db/migrate/*          let b:file_type_name="rails.migrate.ruby"
  au User Rails/config/environment.rb let b:file_type_name="rails.environment.ruby"
  au User Rails/config/routes.rb      let b:file_type_name="rails.routes.ruby"
  au User Rails/config/database.rb    let b:file_type_name="rails.database.ruby"
  au User Rails/config/boot.rb        let b:file_type_name="rails.boot.ruby"
  au User Rails/config/locales/*      let b:file_type_name="rails.locales.ruby"
  au User Rails/config/initializes    let b:file_type_name="rails.initializes.ruby"
  au User Rails/config/environments/* let b:file_type_name="rails.environments.ruby"
  au User Rails set dict+=~/.vim/dict/ruby.rails.dict syntax=ruby | nnoremap <buffer><Space>dd  :<C-U>SmartSplit e ~/.vim/dict/ruby.rails.dict<CR>
aug END
"}}}

"------------------------------------
" gist.vim
"------------------------------------
"{{{
let g:gist_browser_command = 'w3m %URL%'
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:github_user = g:my_settings.github.user
nnoremap <silent><C-H>g :<C-U>Gist<CR>
nnoremap <silent><C-H>gl :<C-U>Gist -l<CR>
"}}}

"------------------------------------
" twitvim
"------------------------------------
"{{{
let g:tweetvim_display_source = 1
let g:tweetvim_display_time = 1
let g:tweetvim_open_buffer_cmd = 'tabnew'
nnoremap <silent>[unite]<C-N>  :call BundleWithCmd('TweetVim bitly.vim twibill.vim', 'Unite tweetvim')<CR>
nnoremap <silent>[unite]<C-M>  :call BundleWithCmd('TweetVim bitly.vim twibill.vim', 'TweetVimSay')<CR>
"}}}

"------------------------------------
" alter
"------------------------------------
"{{{
"specの設定
" au User Rails nnoremap <buffer><Space>s <Plug>(altr-forward)
" au User Rails nnoremap <buffer><Space>s <Plug>(altr-back)

" call altr#define('%.rb', 'spec/%_spec.rb')
" " For rails tdd
" call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
" call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
" call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')
"}}}

"------------------------------------
" sass
"------------------------------------
""{{{
let g:sass_compile_aftercmd = ""
let g:sass_compile_auto = 1
let g:sass_compile_beforecmd = ""
let g:sass_compile_cdloop = 1
let g:sass_compile_cssdir = ['css', 'stylesheet']
let g:sass_compile_file = ['scss', 'sass']
let g:sass_started_dirs = []
function! AutoSassCompile()
  aug MyAutoCmd
    au BufWritePost <buffer> SassCompile
  aug END
endfunction
"}}}

"------------------------------------
" jasmine.vim
"------------------------------------
"{{{
aug MyAutoCmd
  au BufRead,BufNewFile,BufReadPre *Helper.coffee,*Spec.coffee let b:quickrun_config = {'type' : 'coffee'}
aug END
"}}}

"------------------------------------
" YankRing.vim
"------------------------------------
" " Yankの履歴参照"{{{
" nnoremap <Leader>y :YRShow<CR>
"
" let g:yankring_enabled             = 1  " Disables the yankring
" let g:yankring_max_history         = 100
" let g:yankring_min_element_length  = 2
" let g:yankring_max_element_length  = 4194304 " 4M
" let g:yankring_max_display         = 70
" let g:yankring_dot_repeat_yank     = 0
" let g:yankring_window_use_separate = 0
" let g:yankring_window_auto_close   = 1
" let g:yankring_window_height       = 8
" let g:yankring_window_width        = 30
" let g:yankring_window_use_bottom   = 0
" let g:yankring_window_use_right    = 0
" let g:yankring_window_increment    = 5
" let g:yankring_history_dir         = '~/.yankring'
" let g:yankring_history_file        = 'yankring_text' . $USER
" let g:yankring_ignore_operator     = 'g~ gu gU ! = g? < > zf zo zc g@ @'
" let g:yankring_n_keys              = ''
" let g:yankring_o_keys              = ''
" let g:yankring_zap_keys            = ''
" let g:yankring_v_key               = ''
" let g:yankring_del_v_key           = ''
" let g:yankring_paste_n_bkey        = ''
" let g:yankring_paste_n_akey        = ''
" let g:yankring_paste_v_key         = ''
" let g:yankring_replace_n_pkey      = ''
" let g:yankring_replace_n_nkey      = ''
" let  g:yankring_default_menu_mode = 0
" "}}}

"------------------------------------
" operator-camelize.vim
"------------------------------------
" camel-caseへの変換"{{{
xmap <Leader>u <Plug>(operator-camelize)
xmap <Leader>U <Plug>(operator-decamelize)
"}}}

"------------------------------------
" smartchr.vim
"------------------------------------
" "{{{
" let g:smartchr_enable = 0
"
" " Smart =.
"
" if g:smartchr_enable == 1
"   " inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
"   "       \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
"   "       \ : smartchr#one_of(' = ', '=', ' == ')
"   inoremap <expr> , smartchr#one_of(',', ', ')
"   inoremap <expr> ? smartchr#one_of('?', '? ')
"   " inoremap <expr> = smartchr#one_of(' = ', '=')
"
"   " Smart =.
"   " inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
"   "       \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
"   "       \ : smartchr#one_of(' = ', '=', ' == ')
"   augroup MyAutoCmd
"     " Substitute .. into -> .
"     au FileType c,cpp    inoremap <buffer><expr> . smartchr#loop('.', '->', '...')
"     au FileType perl,php inoremap <buffer><expr> - smartchr#loop('-', '->')
"     au FileType vim      inoremap <buffer><expr> . smartchr#loop('.', ' . ', '..', '...')
"     au FileType coffee   inoremap <buffer><expr> - smartchr#loop('-', '->', '=>')
"
"     " 使わない
"     " autocmd FileType haskell,int-ghci
"     "       \ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
"     "       \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
"     "       \| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
"     "       \| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
"     "       \| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
"     "       \| inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..')
"
"     " autocmd FileType scala
"     "       \ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
"     "       \| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
"     "       \| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
"     "       \| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')
"
"     autocmd FileType eruby
"           \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
"           \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
"   augroup END
" endif
" "}}}

"------------------------------------
" Syntastic
"------------------------------------
"{{{
"loadのときに、syntaxCheckをする
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=0
let g:syntastic_check_on_open=0
let g:syntastic_echo_current_error=1
let g:syntastic_enable_balloons = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_enable_signs = 1
let g:syntastic_loc_list_height=3
let g:syntastic_quiet_warnings=0

" let g:syntastic_error_symbol='>'
" let g:syntastic_warning_symbol='='
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

let g:syntastic_mode_map = {
      \ 'mode'              : 'active',
      \ 'active_filetypes'  : ['ruby', 'php', 'javascript', 'less', 'coffee', 'scss', 'haml', 'vim' ],
      \ 'passive_filetypes' : ['html']
      \}
"}}}

"------------------------------------
" w3m.vim
"------------------------------------
"{{{
let g:w3m#command = '/usr/local/bin/w3m'
let g:w3m#external_browser = 'chrome'
let g:w3m#hit_a_hint_key = 'f'
let g:w3m#homepage = "http://www.google.co.jp/"
let g:w3m#search_engine =
      \ 'http://search.yahoo.co.jp/search?search.x=1&fr=top_ga1_sa_124&tid=top_ga1_sa_124&ei=' . &encoding . '&aq=&oq=&p='
let g:w3m#disable_default_keymap = 1
let g:w3m#hover_delay_time = 100
function! W3mSetting()
  nnoremap <buffer><CR>        <Plug>(w3m-click)
  nnoremap <buffer>i           <Plug>(w3m-click)
  nnoremap <buffer><S-CR>      <Plug>(w3m-shift-click)
  nnoremap <buffer><TAB>       <Plug>(w3m-next-link)
  nnoremap <buffer><S-TAB>     <Plug>(w3m-prev-link)
  nnoremap <buffer><BS>        <Plug>(w3m-back)
  nnoremap <buffer>th          <Plug>(w3m-back)
  nnoremap <buffer>tl          <Plug>(w3m-forward)
  nnoremap <buffer>s           <Plug>(w3m-toggle-syntax)
  nnoremap <buffer>c           <Plug>(w3m-toggle-use-cookie)
  nnoremap <buffer>=           <Plug>(w3m-show-link)
  nnoremap <buffer>/           <Plug>(w3m-search-start)
  nnoremap <buffer>*           *<Plug>(w3m-search-end)
  nnoremap <buffer>#           #<Plug>(w3m-search-end)
  nnoremap <buffer>a           <Plug>(w3m-address-bar)
endfunction
aug MyAutoCmd
  au FileType w3m call W3mSetting()
aug END
"}}}

"------------------------------------
" indent_guides
"------------------------------------
"{{{
" let g:indent_guides_guide_size=&tabstop
let g:indent_guides_auto_colors=0
let g:indent_guides_color_change_percent = 20
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_space_guides = 1
let g:indent_guides_start_level = 2
hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=233
" aug MyAutoCmd
"   au FileType html,php,haml,scss,sass,less,coffee,ruby,javascript,python IndentGuidesEnable
" aug END
nnoremap <silent><Leader>ig <Plug>IndentGuidesToggle
"}}}

"------------------------------------
" qiita
"------------------------------------
"{{{
" nnoremap [unite]<C-Q> :unite qiita<CR>
"}}}

"------------------------------------
" SQLUtils
"------------------------------------
"{{{
" " let g:sqlutil_syntax_elements = 'Constant,sqlString'
" let g:sqlutil_default_menu_mode = 3
" let g:sqlutil_menu_priority = 30
" " let g:sqlutil_menu_root = 'MyPlugin.&SQLUtil'
" let g:sqlutil_use_syntax_support = 1
" " let g:sqlutil_<tab> to cycle through the various option names.
" " let g:sqlutil_cmd_terminator = "\ngo"
" " let g:sqlutil_cmd_terminator = "\ngo\n"
" " let g:sqlutil_cmd_terminator = ';'
" let g:sqlutil_load_default_maps = 0
" " let g:sqlutil_stmt_keywords = 'select,insert,update,delete,with,merge'
" let g:sqlutil_use_tbl_alias = 'd|a|n'
"
" let g:sqlutil_align_where = 1
" let g:sqlutil_keyword_case = '\U'
" let g:sqlutil_align_keyword_right = 0
" let g:sqlutil_align_first_word = 1
" let g:sqlutil_align_comma = 1
" " vnoremap <leader>sf    <Plug>SQLU_Formatter<CR>
" " nnoremap <leader>scl   <Plug>SQLU_CreateColumnList<CR>
" " nnoremap <leader>scd   <Plug>SQLU_GetColumnDef<CR>
" " nnoremap <leader>scdt  <Plug>SQLU_GetColumnDataType<CR>
" " nnoremap <leader>scp   <Plug>SQLU_CreateProcedure<CR>
" vnoremap sf :SQLUFormatter<CR>
"}}}

"------------------------------------
" vim-endwise
"------------------------------------
let g:endwise_no_mappings=1

"------------------------------------
" jedi-vim
"------------------------------------
"{{{
let g:jedi#auto_initialization = 1
let g:jedi#get_definition_command = "<leader>d"
let g:jedi#goto_command = "<leader>g"
let g:jedi#popup_on_dot = 0
let g:jedi#pydoc = "K"
let g:jedi#related_names_command = "<leader>n"
let g:jedi#rename_command = "<leader>R"
let g:jedi#use_tabs_not_buffers = 0
let g:vinarise_objdump_command='gobjdump' " homebrew
aug MyAutoCmd
  au FileType python let b:did_ftplugin = 1
  au MyAutoCmd FileType python*
        \ NeoBundleSource jedi-vim | let b:did_ftplugin = 1
aug END
"}}}

"------------------------------------
" text-manipvim
"------------------------------------
"{{{
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-l> <Plug>(textmanip-move-right)
"}}}

"------------------------------------
" Gundo.vim
"------------------------------------
"{{{
nnoremap U      :<C-u>GundoToggle<CR>
"}}}

"------------------------------------
" accelerated-jk
"------------------------------------
"{{{
nmap <silent>j <Plug>(accelerated_jk_gj)
nmap gj j
nmap <silent>k <Plug>(accelerated_jk_gk)
nmap gk k
"}}}

"------------------------------------
" eskk.vim
"------------------------------------
" "{{{
" set imdisable
let g:eskk#debug = 0
" let g:eskk#egg_like_newline = 1
" let g:eskk#revert_henkan_style = "okuri"
let g:eskk#enable_completion = 1
let g:eskk#directory = "~/.eskk"
let g:eskk#dont_map_default_if_already_mapped=1
let g:eskk#dictionary = { 'path': expand( "~/.eskk_jisyo" ), 'sorted': 0, 'encoding': 'utf-8', }
let g:eskk#large_dictionary = { 'path':  expand("~/.eskk_dict/SKK-JISYO.L"), 'sorted': 1, 'encoding': 'euc-jp', }
let g:eskk#cursor_color = {
      \   'ascii': ['#8b8b83', '#bebebe'],
      \   'hira': ['#8b3e2f', '#ffc0cb'],
      \   'kata': ['#228b22', '#00ff00'],
      \   'abbrev': '#4169e1',
      \   'zenei': '#ffd700',
      \}
" let g:eskk#marker_henkan="~"
" let g:eskk#marker_henkan_select="`"
let g:eskk#marker_henkan=""
let g:eskk#marker_henkan_select=""
let g:eskk#marker_jisyo_touroku="?"
let g:eskk#marker_okuri='*'
imap <C-J> <Plug>(eskk:toggle)
" "}}}

"------------------------------------
" alpaca_wordpress.vim
"------------------------------------
"{{{
let g:alpaca_wordpress_syntax = 1
let g:alpaca_wordpress_use_default_setting = 1
"}}}

"------------------------------------
" vim-textobj-enclosedsyntax
"------------------------------------
"{{{
let g:textobj_enclosedsyntax_no_default_key_mappings = 1

" ax、ixにマッピングしたい場合
omap ax <Plug>(textobj-enclosedsyntax-a)
vmap ax <Plug>(textobj-enclosedsyntax-a)
omap ix <Plug>(textobj-enclosedsyntax-i)
vmap ix <Plug>(textobj-enclosedsyntax-i)
"}}}

"------------------------------------
" excitetranslate
"------------------------------------
" {{{
vnoremap e :ExciteTranslate<CR>
" }}}

"------------------------------------
" qtmplsel.vim
"------------------------------------
"{{{
" let g:qts_templatedir=expand( '~/.vim/template' )
"}}}

"------------------------------------
" qtmplsel.vim
"------------------------------------
"{{{
let g:lingr_vim_user='alpaca_taichou'
"}}}

"------------------------------------
"  jscomplete-vim
"------------------------------------
" {{{
autocmd FileType javascript setlocal omnifunc=jscomplete#CompleteJS
let g:jscomplete_use = ['dom', 'moz', 'ex6th']
" }}}

"------------------------------------
"  typescript
"------------------------------------
" {{{
set updatetime=50
" let s:system = neobundle#is_installed('vimproc') ? 'vimproc#system_bg' : 'system'
"
" augroup vim-auto-typescript
"   autocmd!
"   autocmd CursorHold,CursorMoved *.ts :checktime
"   autocmd BufWritePost *.ts :call {s:system}('tsc ' . expand('%'))
" augroup END
" autocmd QuickFixCmdPost [^l]* nested cwindow
" autocmd QuickFixCmdPost    l* nested lwindow
" }}}

"}}}

"----------------------------------------
" 辞書:dict "{{{
augroup DictSetting
  au!
  au FileType coffee.jasmine,javascript.jasmine setl dict+=~/.vim/dict/js.jasmine.dict
  au FileType html,php,eruby       setl dict+=~/.vim/dict/html.dict
  au FileType ruby.rspec           setl dict+=~/.vim/dict/rspec.dict
augroup END

" カスタムファイルタイプでも、自動でdictを読み込む
" そして、編集画面までさくっと移動。
func! s:auto_dict_setting()
  let file_type_name = &ft
  if exists('b:file_type_name')
    let file_type_name = b:file_type_name
  endif

  let dict_name = split( file_type_name, '.' )
  if !empty( dict_name )
    exe  "setl dict+=~/.vim/dict/".dict_name[0].".dict"
  endif

  let b:dict_path = expand('~/.vim/dict/'.file_type_name.'.dict')
  exe  "setl dict+=".b:dict_path
  nnoremap <buffer><expr><Space>d ':<C-U>SmartSplit e '.b:dict_path.'<CR>'
endfunc

aug MyAutoCmd
  au FileType * call s:auto_dict_setting()
aug END
"}}}

"----------------------------------------
" 補完・履歴 neocomplcache "{{{
set wildmenu                 " コマンド補完を強化
set wildchar=<tab>           " コマンド補完を開始するキー
set wildmode=longest:full,full
set history=1000             " コマンド・検索パターンの履歴数
set complete+=k,U,kspell,t,d " 補完を充実
set completeopt=menu,menuone,preview
set infercase

"----------------------------------------
" neocomplcache
let g:neocomplcache_enable_at_startup = 1

" default config"{{{
" let g:neocomplcache_auto_completion_start_length = 2
" let g:neocomplcache_caching_limit_file_size = 1000000
" let g:neocomplcache_disable_auto_select_buffer_name_pattern = '\[Command Line\]'
" let g:neocomplcache_disable_caching_buffer_name_pattern = '[\[*]\%(unite\)[\]*]'
" let g:neocomplcache_lock_buffer_name_pattern = '\.txt'
" let g:neocomplcache_manual_completion_start_length = 0
" let g:neocomplcache_max_list = 120
" let g:neocomplcache_min_keyword_length = 2
" let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_force_overwrite_completefunc = 1
let g:neocomplcache#sources#rsense#home_directory = g:my_settings.dir.rsense
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_skip_auto_completion_time = '0.3'

" initialize "{{{
if $USER ==# 'root'
  let g:neocomplcache_temporary_dir       = expand( '~/.neocon' )
endif
let s:neocomplcache_initialize_lists = [
      \ 'g:neocomplcache_wildcard_characters',
      \ 'g:neocomplcache_omni_patterns',
      \ 'g:neocomplcache_force_omni_patterns',
      \ 'g:neocomplcache_keyword_patterns',
      \ 'g:neocomplcache_source_completion_length',
      \ 'g:neocomplcache_vim_completefuncs',
      \ 'g:neocomplcache_dictionary_filetype_lists',]
for initialize_variable in s:neocomplcache_initialize_lists
  if !exists(initialize_variable)
    exe 'let '. initialize_variable .' = {}'
  endif
endfor
"}}}
" Define force omni patterns"{{{
let g:neocomplcache_force_omni_patterns.c      = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp    = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.python = '[^. \t]\.\w*'
"}}}
" Define keyword pattern. "{{{
" let g:neocomplcache_keyword_patterns.default = '[0-9a-zA-Z:#_-]\+'
" let g:neocomplcache_omni_patterns.mail = '^\s*\w\+'
" let g:neocomplcache_omni_patterns.php = '[^. *\t]\.\w*\|\h\w*::'
" let g:neocomplcache_keyword_patterns.filename = '\%(\\.\|[/\[\][:alnum:]()$+_\~.-]\|[^[:print:]]\)\+'
" let g:neocomplcache_omni_patterns.c = '[^.[:digit:]*\t]\%(\.\|->\)'
"}}}
" Define completefunc"{{{
let g:neocomplcache_vim_completefuncs.Ref                 = 'ref#complete'
let g:neocomplcache_vim_completefuncs.Unite               = 'unite#complete_source'
let g:neocomplcache_vim_completefuncs.VimFiler            = 'vimfiler#complete'
let g:neocomplcache_vim_completefuncs.VimShell            = 'vimshell#complete'
let g:neocomplcache_vim_completefuncs.VimShellExecute     = 'vimshell#vimshell_execute_complete'
let g:neocomplcache_vim_completefuncs.VimShellInteractive = 'vimshell#vimshell_execute_complete'
let g:neocomplcache_vim_completefuncs.VimShellTerminal    = 'vimshell#vimshell_execute_complete'
let g:neocomplcache_vim_completefuncs.Vinarise            = 'vinarise#complete'
"}}}
" define completion length"{{{
let g:neocomplcache_source_completion_length.alpaca_look = 4
" let g:neocomplcache_source_completion_length.rsense      = 2
"}}}
" ファイルタイプ毎の辞書ファイルの場所 {{{
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default'    : '',
      \ 'timobile.javascript'   : $HOME.'/.vim/dict/timobile.dict',
      \ 'timobile.coffee'   : $HOME.'/.vim/dict/timobile.dict',
      \ }
for s:dict in split(glob($HOME.'/.vim/dict/*.dict'))
  let s:ft = matchstr(s:dict, '\w\+\ze\.dict$')
  let g:neocomplcache_dictionary_filetype_lists[s:ft] = s:dict
endfor
"}}}
"}}}

" keymap {{{
imap <expr><C-g>     neocomplcache#undo_completion()
imap <expr><CR>      neocomplcache#smart_close_popup() . "<CR>" . "<Plug>DiscretionaryEnd"
imap <silent><expr><S-TAB> pumvisible() ? "\<C-P>" : "\<S-TAB>"
" imap <silent><expr><TAB>   pumvisible() ? "\<C-N>" : "\<TAB>"
imap <expr><TAB> neosnippet#expandable() ? "\<Plug>(neosnippet_jump_or_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" }}}
"}}}

"----------------------------------------
" neosnippet"{{{
let g:neosnippet#snippets_directory = g:my_settings.dir.bundle . '/neosnippet/autoload/neosnippet/snippets,' . g:my_settings.dir.snippets
aug MyAutoCmd
  au FileType snippet nnoremap <buffer><Space>e :e #<CR>
aug END
imap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
inoremap <silent><C-U>            <ESC>:<C-U>Unite snippet<CR>
nnoremap <silent><Space>e         :<C-U>NeoSnippetEdit -split<CR>
nnoremap <silent><expr><Space>ee  ':NeoSnippetEdit -split'.split(&ft, '.')[0].'<CR>'
smap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
" xmap <silent><C-F>                <Plug>(neosnippet_start_unite_snippet_target)
xmap <silent>o                    <Plug>(neosnippet_register_oneshot_snippet)
"}}}

set secure
