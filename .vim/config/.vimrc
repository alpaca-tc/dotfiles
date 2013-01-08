aug MyAutoCmd
  au!
aug END
"----------------------------------------
"基本"{{{
" let $SHELL="/usr/local/bin/zsh"
" set shell=/usr/local/bin/zsh
let mapleader = ","
set backspace=indent,eol,start
set browsedir=buffer
set clipboard+=autoselect
set clipboard+=unnamed
set directory=~/.vim.swapfile
set formatoptions=lcqmM
" aug MyAutoCmd
"   au VimEnter * set formatoptions-=ro
" aug END
set helplang=ja,en
set modelines=0
set nobackup
set showmode
set timeout timeoutlen=300 ttimeoutlen=100
set vb t_vb=
set viminfo='100,<800,s300,\"300
set updatetime=4000 " swpを作るまでの時間(au CursorHoldの時間)
set norestorescreen=off
" if v:version >= 703
"   set undofile
"   let &undodir=&directory
" endif

aug MyAutoCmd
  au FileType help nnoremap <buffer> q <C-w>c
aug END
nnoremap <Space>h :<C-u>help<Space><C-r><C-w><CR>
nnoremap <Space><Space>s :<C-U>so ~/.vimrc<CR>
nnoremap <Space><Space>v :<C-U>tabnew ~/.vim/config/.vimrc<CR>
"}}}

"----------------------------------------
"StatusLine" {{{
" source ~/.vim/config/.vimrc.statusline
" }}}

"----------------------------------------
"編集"{{{
set autoread
" set textwidth=100
set textwidth=0
set hidden
set nrformats-=octal

"開いているファイルのディレクトリに自動で移動
aug MyAutoCmd
  au BufEnter * execute ":lcd " . expand("%:p:h")
aug END

" 便利キーマップ追記
nnoremap <silent><Space>w :wq<CR>
nnoremap <silent><Space>q :q!<CR>
nnoremap <Space>s :w sudo:%<CR>
nnoremap re :%s!
xnoremap re :s!
vnoremap rep y:%s!<C-r>=substitute(@0, '!', '\\!', 'g')<Return>!!g<Left><Left>
nnoremap <Leader>f :setl ft=

" 新しいバッファを開くときに、rubyか同じファイルタイプで開く{{{
function! NewBuffer(type)
  let old_ft = &ft

  " 分割
  if winwidth(0) > winheight(0) * 2
    vnew
  else
    new
  endif

  if a:type == "new"
    let cmd = "setl ft=ruby"
  else
    let cmd = 'setl ft='.old_ft
  endif

  exec cmd
endfunction
"}}}
nmap <silent><C-W>n :call NewBuffer("new")<CR>
nmap <silent><C-W><C-N> :call NewBuffer("copy")<CR>

" 括弧を自動補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>

aug MyAutoCmd
  au FileType ruby,eruby,haml inoremap <buffer>\| \|\|<LEFT>
aug END

" 一括インデント
xnoremap < <gv
xnoremap > >gv
xnoremap <TAB>  >
xnoremap <S-TAB>  <
xnoremap <C-M> :sort<CR>

" HTML/XMLの閉じタグを </ が入力されたときに補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype eruby inoremap <buffer> </ </<C-x><C-o>
augroup END

" コメントを書くときに便利
inoremap <leader>* ****************************************
inoremap <leader>- ----------------------------------------
inoremap <leader>h <!-- / --><left><left><left><Left>

" 保存時に無駄な文字を消す{{{
function! s:remove_dust()
  if g:remove_dust_enable == 0|return|endif

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
let g:remove_dust_enable=1
command! RemoveDustEnable let g:remove_dust_enable=1
command! RemoveDustDisable let g:remove_dust_enable=0

augroup ProgramFiles
  au BufWritePre * call <SID>remove_dust()
augroup END
"}}}

" html {{{
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

xnoremap <silent> eh :call <SID>HtmlEscape()<CR>
xnoremap <silent> dh :call <SID>HtmlUnEscape()<CR>
" }}}

" 変なマッピングを修正 "{{{
if has('gui_macvim')
  map ¥ \
  inoremap ¥ \
  nnoremap ¥ \
  cmap ¥ \
  smap ¥ \
endif

" キーボードの自動判別はできないのかね。。。
let g:vim_keybind_type = 'us'
if g:vim_keybind_type == 'us'
  noremap ; :
  cnoremap ; :
  inoremap ; :

  noremap : ;
  cnoremap : ;
  inoremap : ;
endif
"}}}

" Improved increment.{{{
nmap <C-A> <SID>(increment)
nmap <C-X> <SID>(decrement)
nmap <silent> <SID>(increment)    :AddNumbers 1<CR>
nmap <silent> <SID>(decrement)   :AddNumbers -1<CR>
command! -range -nargs=1 AddNumbers
      \ call s:add_numbers((<line2>-<line1>+1) * eval(<args>))
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
endfunction "}}}
"}}}

"----------------------------------------
"検索"{{{
set wrapscan
set ignorecase
set smartcase
set incsearch
set hlsearch
" nnoremap <silent> n nvv
" nnoremap <silent> N Nvv

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
map $ g_

" nnoremap <silent>h <Left>
" nnoremap <silent>l <Right>
nnoremap <silent>j gj
nnoremap <silent>k gk
nnoremap <silent><Down> gj
nnoremap <silent><Up>   gk

inoremap <silent><C-L> <Right>
inoremap <silent><C-L><C-L> <Esc>A
inoremap <silent><C-O> <Esc>o
vnoremap v G
inoremap jj <Esc>

"よくミスキータッチするから削除
" nnoremap H <Nop>
vnoremap H <Nop>

" マークを使い易くする
" nnoremap <silent>; :<C-U>echo "マーク"<CR><ESC>'

" 前回終了したカーソル行に移動
aug MyAutoCmd
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
aug END

" nnoremap g: `.zz
" nnoremap g, g;
" nnoremap g; g,

" windowの操作
" ****************
" 画面の移動
nnoremap <C-L> <C-T>
nnoremap <C-W><C-J><C-h> <C-W>j<C-W>h
nnoremap <C-W><C-H><C-j> <C-W>h<C-W>j
nnoremap <C-W><C-H><C-k> <C-W>h<C-W>k
nnoremap <C-W><C-K><C-H> <C-W>k<C-W>h
nnoremap <C-W><C-K><C-L> <C-W>k<C-W>l
nnoremap <C-W><C-l><C-j> <C-W>l<C-W>j
nnoremap <C-W><C-l><C-k> <C-W>l<C-W>k

nnoremap <silent>L :call <SID>NextWindowOrTab()<CR>
nnoremap <silent>H :call <SID>PreviousWindowOrTab()<CR>
nnoremap <silent><C-W>] :call PreviewWord()<CR>
nnoremap <silent><C-W><Space> :<C-u>SmartSplit<CR>
func! PreviewWord() "{{{
  if &previewwindow      " プレビューウィンドウ内では実行しない
    return
  endif
  let w = expand("<cword>")    " カーソル下の単語を得る
  if w =~ '\a'      " その単語が文字を含んでいるなら
    " 別のタグを表示させる前にすでに存在するハイライトを消去する
    silent! wincmd P      " プレビューウィンドウにジャンプ
    if &previewwindow      " すでにそこにいるなら
      match none      " 存在するハイライトを消去する
      wincmd p      " もとのウィンドウに戻る
    endif

    " カーソル下の単語にマッチするタグを表示してみる
    try
      exe "ptag " . w
    catch
      return
    endtry

    silent! wincmd P      " プレビューウィンドウにジャンプ
    if &previewwindow    " すでにそこにいるなら
      if has("folding")
        silent! .foldopen    " 閉じた折り畳みを開く
      endif
      call search("$", "b")    " 前の行の最後へ
      let w = substitute(w, '\\', '\\\\', "")
      call search('\<\V' . w . '\>')  " カーソルをマッチしたところへ
      " ここで単語にハイライトをつける
      " exe 'match previewWord "\%' . line(".") . 'l\%' . col(".") . 'c\k*"'
      wincmd p      " もとのウィンドウへ戻る
    endif
  endif
endfun "}}}
" smart split window {{{
function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

function! s:NextWindowOrTab()
  if tabpagenr('$') == 1 && winnr('$') == 1
    call s:smart_split()
  elseif winnr() < winnr("$")
    wincmd w
  else
    tabnext
    1wincmd w
  endif
endfunction

function! s:PreviousWindowOrTab()
  if winnr() > 1
    wincmd W
  else
    tabprevious
    execute winnr("$") . "wincmd w"
  endif
endfunction

function! s:smart_split(...)
  if winwidth(0) > winheight(0) * 2
    vsplit
  else
    split
  endif

  if a:0 > 0
    execute a:1
  endif
endfunction
command! -nargs=? -complete=command SmartSplit call <SID>smart_split(<q-args>)
"}}}

" tabを使い易く{{{
" nnoremap <silent>t  <Nop>
nnoremap <silent>tn  :tabn<CR>
nnoremap <silent>tp  :tabprevious<CR>
nnoremap <silent>tc  :tabnew<CR>
nnoremap <silent>tx  :tabclose<CR>
nnoremap <silent>to  :call <SID>OpenWindowWithTab()<CR>
nnoremap <silent>tw  :call <SID>CloseTabAndOpenBufferIntoPreviousWindow()<CR>
nnoremap <silent>te  :execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>

nnoremap <silent>t1  :tabnext 1<CR>
nnoremap <silent>t2  :tabnext 2<CR>
nnoremap <silent>t3  :tabnext 3<CR>
nnoremap <silent>t4  :tabnext 4<CR>
nnoremap <silent>t5  :tabnext 5<CR>
nnoremap <silent>t6  :tabnext 6<CR>
" }}}

" 現在開いているバッファをタブで開く
function! s:OpenWindowWithTab() "{{{
  let buffer = bufnr('%')
  if (winnr("$") != 1)
    q
  endif
  tabnew
  exec 'buffer '.buffer
endfunction"}}}

" 現在開いているタブとバッファを閉じて
" 一つ前のタブと統合する
function! s:CloseTabAndOpenBufferIntoPreviousWindow() "{{{
  let buffer = bufnr('%')
  if ( tabpagenr("$") != 1)
    q
  endif

  tablast
  vsplit
  exec 'buffer '.buffer
endfunction"}}}
"}}}

"----------------------------------------
"encoding"{{{
set fileformats=unix,dos,mac
set encoding=utf-8
set fileencodings=utf-8,sjis,shift-jis,euc-jp,utf-16,ascii,ucs-bom,cp932,iso-2022-jp

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Sjis edit ++enc=sjis
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
set equalalways       " 画面の自動サイズ調整
" set relativenumber    " 相対表示
" set scrolljump=-50
set breakat=\\;:,!?
set linebreak
set list              " 不可視文字表示
set listchars=tab:␣.,trail:_,extends:>,precedes:<
set number            " 行番号表示
set scrolloff=5
set showcmd
set showfulltag
set showmatch         " 括弧の対応をハイライトa
set spelllang=en_us
set title
set titlelen=95
au FileType coffee,ruby,eruby,php,javascript,c,json,vim set colorcolumn=80

"set display=uhex      " 印字不可能文字を16進数で表示
set cdpath+=~
set cursorline
set lazyredraw        " コマンド実行中は再描画しない
set matchpairs+=<:>
set t_Co=256          " 確かカラーコード
set ttyfast           " 高速ターミナル接続を行う
" set scrolloff=999     " 常にカーソルを真ん中に

if has('gui_macvim') "{{{
  " set transparency=10
  " set guifont=Recty:h12
  " set lines=90 columns=200
  set guioptions-=T
  set guioptions-=L
  set guioptions-=R
  set guioptions-=B
  set cmdheight=1

  " 暫く触らないと、画面を薄くする
  let g:visible = 0
  function! SetShow()
    if g:visible == 1
      setl transparency=0
      let g:visible = 0
    endif
  endfunction
  function! SetVisible()
    setl transparency=98
    let g:visible = 1
  endfunction
  " au CursorHold * call SetVisible()
  " au CursorMoved,CursorMovedI,WinLeave * call SetShow()

  nnoremap <silent>_ :exec g:visible == 0 ? ":call SetVisible()" : ":call SetShow()"<CR>
endif "}}}

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

"折り畳み
" set commentstring=%s
set foldcolumn=1
set foldenable
" set foldlevelstart=1
set foldmethod=marker
" set foldminlines=3
set foldnestmax=5
" set foldopen=all
" set showbreak=>\

" vimを使っているときはtmuxのステータスラインを隠す"{{{
" if !has('gui_running') && $TMUX !=# ''
"   augroup Tmux
"     autocmd!
"     " au VimEnter,FocusGained * silent !tmux set status off
"     " au VimLeave,FocusLost * silent !tmux set status on
"   augroup END
" endif "}}}

" 設定を上書きしない為に、最後に書く
colorscheme molokai
"}}}

" commitメッセージの編集時には余分なプラグインを読み込まない
if expand("%") =~ "COMMIT_EDITMSG"
  finish
endif

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
  au BufReadPost * call SetTags()
aug END

"tags_jumpを使い易くする
nnoremap tt  <C-]>
nnoremap th  :<C-u>pop<CR>
nnoremap tl  :<C-u>tag<CR>
nnoremap tj  :<C-u>tp<CR>
nnoremap tk  :<C-u>tags<CR>
nnoremap tn  :<C-u>tn<CR>
nnoremap ts  :<C-u>ts<CR>
"}}}

"----------------------------------------
" neobundle"{{{
filetype plugin indent off     " required!

" initialize"{{{
if has('vim_starting')
  let s:bundle_dir = expand("~/.bundle")
  if !isdirectory(s:bundle_dir)
    call mkdir(s:bundle_dir)
    call system( 'git clone https://github.com/Shougo/neobundle.vim.git '.s:bundle_dir.'/neobundle.vim')
  endif

  exe 'set runtimepath+='.s:bundle_dir.'/neobundle.vim'
  call neobundle#rc(s:bundle_dir)
endif
augroup neobundle
  " au!
  au Syntax vim syntax keyword vimCommand NeoBundle NeoBundleLazy NeoBundleSource
augroup END
"}}}

function! BundleLoadDepends(bundle_names)
  if !exists('g:loaded_bundles')
    let g:loaded_bundles = {}
  endif

  " bundleの読み込み
  if !has_key( g:loaded_bundles, a:bundle_names )
    execute 'NeoBundleSource '.a:bundle_names
    let g:loaded_bundles[a:bundle_names] = 1
  endif
endfunction

" コマンドを伴うやつの遅延読み込み
function! BundleWithCmd(bundle_names, cmd) "{{{
  call BundleLoadDepends(a:bundle_names)

  " コマンドの実行
  if !empty(a:cmd)
    execute a:cmd
  endif
endfunction "}}}

"bundle"{{{
"----------------------------------------
" "vim基本機能拡張"{{{
NeoBundle 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
" NeoBundle 'vim-jp/vital.vim'
" NeoBundle 'yuroyoro/vim-autoclose'                          " 自動閉じタグ
NeoBundle 'edsono/vim-matchit'        " %の拡張
NeoBundle 'kana/vim-arpeggio'         " 同時押しキーマップを使う
NeoBundle 'rhysd/accelerated-jk'      " jkの移動を高速化
NeoBundle 'taichouchou2/alpaca'   " 個人的なカラーやフォントなど
NeoBundle 'Lokaltog/vim-powerline'    " StatusLineの拡張
NeoBundle 'tpope/vim-surround'
NeoBundle 'tpope/vim-fugitive'        " gitを表示
NeoBundle 'h1mesuke/vim-alignta'      " 整形
"}}}

"----------------------------------------
" vim拡張"{{{
" NeoBundle 'Lokaltog/vim-easymotion'
NeoBundle 'grep.vim'
NeoBundle 'kien/ctrlp.vim' "ファイルを絞る
" NeoBundle 'scrooloose/nerdtree' "プロジェクト管理用 tree filer
" NeoBundle 'taglist.vim' "関数、変数を画面横にリストで表示する
" NeoBundle 'taku-o/vim-toggle' "true<=>false など、逆の意味のキーワードを切り替えられる
" NeoBundle 'yuroyoro/vimdoc_ja'
" NeoBundle 'YankRing.vim' "ヤンクの履歴を管理
" NeoBundle 'hrp/EnhancedCommentify' "コメントアウト
" NeoBundle 'kana/vim-altr' " 関連するファイルを切り替えれる
" NeoBundle 'vim-scripts/AnsiEsc.vim' " Ascii color code対応
" NeoBundle 'vim-scripts/SearchComplete' " /で検索をかけるときでも\tで補完が出来る
NeoBundleLazy 'sjl/gundo.vim', { 'autoload' : { 'commands': ["GundoToggle"] }}                   " undo履歴をツリー表示
NeoBundle 'Shougo/git-vim'
NeoBundle 'Shougo/neocomplcache'            " 補完
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'camelcasemotion'
NeoBundle 'majutsushi/tagbar'
NeoBundle 'mattn/zencoding-vim'             " Zencodingを使う
NeoBundle 'nathanaelkane/vim-indent-guides' " indentに色づけ
NeoBundle 'open-browser.vim'
NeoBundle 'smartword'
NeoBundle 't9md/vim-textmanip'              " visualモードで、文字列を直感的に移動
NeoBundle 'thinca/vim-ref'
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'vim-scripts/sudo.vim'            " vimで開いた後にsudoで保存
NeoBundle 'Shougo/vimfiler'
NeoBundleLazy 'Shougo/vimshell'
NeoBundle 'taichouchou2/vimshell_custom'
NeoBundleLazy 'mattn/gist-vim' "gistを利用する
NeoBundleLazy 'thinca/vim-quickrun'             " <Leader>rで簡易コンパイル

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
NeoBundle 'kana/vim-operator-user'
" NeoBundle 'kana/vim-textobj-function.git'  " f 関数をtext-objectに
NeoBundle 'kana/vim-textobj-indent.git'    " i I インデントをtext-objectに
NeoBundle 'kana/vim-textobj-user'          " textobject拡張の元
NeoBundle 'operator-camelize' "operator-camelize : camel-caseへの変換
" NeoBundle 'thinca/vim-textobj-plugins.git' " vim-textobj-plugins : いろんなものをtext-objectにする
" NeoBundle 'tyru/operator-html-escape.vim'
"}}}
"}}}

" NeoBundle 'L9' "utillity
" NeoBundle 'c9s/cascading.vim' "メソッドチェーン整形
" NeoBundle 'cecutil' "cecutil.vim : 他のpluginのためのutillity1
" NeoBundle 'thinca/vim-template' " templeteを作れる
" NeoBundle 'tyru/urilib.vim' "urilib.vim : vim scriptからURLを扱うライブラリ
" NeoBundle 'kana/vim-smartchr' "smartchr.vim : ==()などの前後を整形
NeoBundle 'mattn/webapi-vim' "vim Interface to Web API
NeoBundle 'scrooloose/syntastic'
NeoBundle 'taichouchou2/alpaca_look'
NeoBundle 'rhysd/clever-f.vim'

" unite.vim : - すべてを破壊し、すべてを繋げ - vim scriptで実装されたanythingプラグイン
" NeoBundle 'choplin/unite-vim_hacks'
" NeoBundle 'h1mesuke/unite-outline'
" NeoBundle 'joker1007/unite-git_grep'
" NeoBundle 'kmnk/vim-unite-giti'
" NeoBundle 'mattn/unite-source-simplenote'
" NeoBundle 'sgur/unite-qf'
" NeoBundle 'tacroe/unite-mark'
" NeoBundle 'tsukkee/unite-help'
" NeoBundle 'tsukkee/unite-tag'
" NeoBundle 'ujihisa/unite-colorscheme'
NeoBundleLazy 'Shougo/unite-ssh'
NeoBundle 'taichouchou2/vim-unite-giti'
NeoBundleLazy 'thinca/vim-unite-history'
NeoBundleLazy 'ujihisa/vimshell-ssh'
NeoBundleLazy 'glidenote/memolist.vim'

" NeoBundle 'TeTrIs.vim'
" NeoBundle 'benmills/vimux'
" NeoBundle 'daisuzu/facebook.vim'
" NeoBundle 'mattn/qiita-vim'
" NeoBundle 'osyo-manga/vim-itunes'
" NeoBundle 'yuratomo/w3m.vim'
NeoBundleLazy 'basyura/TweetVim'
NeoBundleLazy 'basyura/bitly.vim'
NeoBundleLazy 'basyura/twibill.vim'
NeoBundle 'tyru/eskk.vim'
" }}}

" bundle.lang"{{{

" css
" ----------------------------------------
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'autoload' : { 'filetypes' : ['css', 'scss', 'sass']}}

" html
" ----------------------------------------
NeoBundleLazy 'taichouchou2/html5.vim', { 'autoload' : { 'filetypes' : ['html', 'haml', 'erb', 'php']}}

" haml
" ----------------------------------------
NeoBundleLazy 'tpope/vim-haml', { 'autoload' : { 'filetypes' : ['haml']}}
" NeoBundle 'xmledit'

"  js / coffee
" ----------------------------------------
NeoBundleLazy 'kchmck/vim-coffee-script', { 'autoload' : { 'filetypes' : ['coffee']}}
NeoBundleLazy 'claco/jasmine.vim', { 'autoload' : { 'filetypes' : ['javascript', 'coffee']}}
NeoBundleLazy 'taichouchou2/vim-javascript', { 'autoload' : { 'filetypes' : ['javascript']}}
" NeoBundle 'hallettj/jslint.vim'
" NeoBundle 'pekepeke/titanium-vim' " Titaniumを使うときに

"  go
" ----------------------------------------
NeoBundleLazy 'fsouza/go.vim', { 'autoload' : { 'filetypes' : ['go']}}

"  markdown
" ----------------------------------------
" markdownでの入力をリアルタイムでチェック
" NeoBundle 'mattn/mkdpreview-vim'
NeoBundleLazy 'tpope/vim-markdown', { 'autoload' : { 'filetypes' : ['markdown']}}

" sassのコンパイル
NeoBundleLazy 'AtsushiM/sass-compile.vim', { 'autoload' : { 'filetypes' : ['sass', 'scss']}}

"  php
" ----------------------------------------
" NeoBundle 'oppara/vim-unite-cake'
" NeoBundle 'violetyk/cake.vim' " cakephpを使いやすく
NeoBundleLazy 'taichouchou2/alpaca_wordpress.vim', { 'autoload' : { 'filetypes' : ['php']}}

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
NeoBundle 'taichouchou2/vim-endwise.git' "end endifなどを自動で挿入
NeoBundle 'tpope/vim-rails'

" rails
NeoBundleLazy 'basyura/unite-rails'
NeoBundleLazy 'taichouchou2/unite-rails_best_practices', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'build' : {
      \    'mac': 'gem install rails_best_practices',
      \    'unix': 'gem install rails_best_practices',
      \   }
      \ }
NeoBundleLazy 'ujihisa/unite-rake'
NeoBundleLazy 'taichouchou2/alpaca_complete'
let s:bundle_rails = 'unite-rails unite-rails_best_practices unite-rake alpaca_complete'
aug MyAutoCmd
  au User Rails call BundleLoadDepends(s:bundle_rails)
aug END

" ruby全般
NeoBundleLazy 'ruby-matchit'
" NeoBundleLazy 'skalnik/vim-vroom'
NeoBundleLazy 'skwp/vim-rspec'
NeoBundleLazy 'taka84u9/vim-ref-ri'
NeoBundleLazy 'vim-ruby/vim-ruby'
NeoBundleLazy 'taichouchou2/unite-reek', {
      \ 'build' : {
      \    'mac': 'gem install reek',
      \    'unix': 'gem install reek',
      \ },
      \ 'depends' : 'Shougo/unite.vim' }
NeoBundle 'Shougo/neocomplcache-rsense'
NeoBundleLazy 'rhysd/unite-ruby-require.vim'
NeoBundleLazy 'rhysd/vim-textobj-ruby'
NeoBundleLazy 'deris/vim-textobj-enclosedsyntax'
let s:bundle_ruby = 'ruby-matchit vim-rspec vim-ref-ri vim-ruby unite-reek unite-ruby-require.vim neco-ruby-keyword-args vim-textobj-ruby neocomplcache-rsense vim-textobj-enclosedsyntax'
aug MyAutoCmd
  au FileType ruby,Gemfile,haml,eruby call BundleLoadDepends(s:bundle_ruby)
aug END

NeoBundleLazy 'ujihisa/unite-gem'
NeoBundleLazy 'rhysd/neco-ruby-keyword-args'

" python
" ----------------------------------------
" NeoBundle 'Pydiction'
NeoBundle 'yuroyoro/vim-python'
NeoBundle 'davidhalter/jedi-vim', {
      \ 'build' : {
      \     'mac' : 'git submodule update --init',
      \     'unix' : 'git submodule update --init',
      \    },
      \ }
" NeoBundleLazy 'kevinw/pyflakes-vim'
" let s:bundle_python = 'vim-python jedi-vim pyflakes-vim'
" aug MyAutoCmd
"   au FileType python call BundleLoadDepends(s:bundle_python)
" aug END

" scala
" ----------------------------------------
" NeoBundle 'Align'
" NeoBundle 'SQLUtilities' " SQLUtilities : SQL整形、生成ユーティリティ
" NeoBundle 'taichouchou2/teol.vim' " C言語など<Leader>;で全行に;を挿入できる
" NeoBundle 'yuroyoro/vim-scala'

" sh
" ----------------------------------------
NeoBundleLazy 'sh.vim'
aug MyAutoCmd
  au FileType sh call BundleLoadDepends('sh.vim')
aug END
"}}}

" 他のアプリを呼び出すetc "{{{
" NeoBundle 'thinca/vim-openbuf'
" NeoBundle 'tell-k/vim-browsereload-mac' " 保存と同時にブラウザをリロードする
" NeoBundle 'vim-scripts/dbext.vim' "<Leader>seでsqlを実行
" NeoBundleLazy 'tsukkee/lingr-vim'
NeoBundle 'vim-scripts/yanktmp.vim'
NeoBundle 'mattn/excitetranslate-vim', {'depends': 'mattn/webapi-vim'}
" NeoBundle 'qtmplsel.vim'
"}}}

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Install Plugins'
  NeoBundleInstall
  " finish
endif

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
nnoremap <Leader>o <Plug>(openbrowser-open)
vnoremap <Leader>o <Plug>(openbrowser-open)
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

nnoremap <silent> [unite]<C-U> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" nnoremap <silent> [unite]<C-R> :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]<C-J> :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]b :<C-u>Unite bookmark<CR>
nnoremap <silent> [unite]<C-B> :<C-u>Unite buffer<CR>
nnoremap <silent> <Space>b :<C-u>UniteBookmarkAdd<CR>
let g:unite_quick_match_table = {
      \'a' : 1, 's' : 2, 'd' : 3, 'f' : 4, 'g' : 5, 'h' : 6, 'j' : 7, 'k' : 8, 'l' : 9, ';' : 10,
      \'q' : 11, 'w' : 12, 'e' : 13, 'r' : 14, 't' : 15, 'y' : 16, 'u' : 17, 'i' : 18, 'o' : 19, 'p' : 20,
      \'1' : 21, '2' : 22, '3' : 23, '4' : 24, '5' : 25, '6' : 26, '7' : 27, '8' : 28, '9' : 29, '0' : 30,
      \}
"}}}

function! UniteSetting() "{{{
  " 動き
  imap <buffer><C-K> <Up>
  imap <buffer><C-J> <Down>
  " 開き方
  nnoremap <silent><buffer><expr><C-W>s unite#do_action('split')
  nnoremap <silent><buffer><expr><C-W>v unite#do_action('vsplit')
  nnoremap <silent><buffer> <ESC><ESC> :q<CR>
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
"         \|     noremap <silent> [unite]<C-K> :<C-u>UniteWithCursorWord -immediately tag<CR>
"         \|  endif
" aug END
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
nnoremap <silent> [unite]<C-R> :<C-u>Unite -no-quit reek<CR>
nnoremap <silent> [unite]<C-R><C-R> :<C-u>Unite -no-quit rails_best_practices<CR>
" }}}

"------------------------------------
" VimFiler
"------------------------------------
"{{{
" 起動コマンド
" default <leader><leader>
nnoremap <silent><C-H><C-F>  :call VimFilerExplorerGit()<CR>
" nnoremap <silent><Leader><Leader>  :VimFilerBufferDir<CR>

nnoremap <silent><Leader><Leader>  :VimFilerCreate<CR>

" lean more [ utf8 glyph ]( http://sheet.shiar.nl/unicode )
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_sort_type = "filename"
let g:vimfiler_preview_action = ""
let g:vimfiler_enable_auto_cd= 1
let g:vimfiler_file_icon = "-"
" let g:vimfiler_readonly_file_icon = "𐄂"
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
    nnoremap <buffer>B :<C-U>UniteBookmarkAdd<CR>
    nnoremap <buffer><CR> <Plug>(vimfiler_edit_file)
    nnoremap <buffer>v <Plug>(vimfiler_view_file)

    nnoremap <buffer><C-J> [unite]
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

command!
      \   VimFilerExplorerGit
      \   call VimFilerExplorerGit()

" VimFilerExplorer自動起動
" au VimEnter * call VimFilerExplorerGit()
"}}}

"------------------------------------
" quickrun.vim
"------------------------------------
"{{{
let g:quickrun_config = {}
let g:quickrun_config._ = {'runner' : 'vimproc'}
let g:quickrun_no_default_key_mappings = 1
nnoremap <silent><Leader>r :call BundleWithCmd('vim-quickrun', 'QuickRun')<CR>

let g:quickrun_config['lisp'] = {
      \   'command': 'clisp'
      \ }

let g:quickrun_config['coffee_compile'] = {
      \'command' : 'coffee',
      \'exec' : ['%c -cbp %s']
      \}

let g:quickrun_config['markdown'] = {
      \ 'outputter': 'browser',
      \ 'cmdopt': '-s'
      \ }

let g:quickrun_config['ruby'] = {
      \   'command': 'ruby'
      \ }

let g:quickrun_config.applescript = {'command' : 'osascript' , 'output' : '_'}

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

"javascriptの実行をnode.jsで
let $JS_CMD='node'
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
" titanium-vim
"----------------------------------------
"{{{
"g:titanium_android_sdk_path      *g:titanium_android_sdk_path*
"      Android SDK のパスを指定します。
"      設定が行われていない場合、環境変数 ANDROID_HOME の
"      値を使用します。

"g:titanium_complete_head      *g:titanium_complete_head*
"      先頭マッチの Omni 補完を実施するかどうかを制御するフラグ。
"      このフラグがOFFの場合、メソッド名から Titanium API の
"      クラス名を補完します。
"      デフォルトは 0 です。

"g:titanium_method_complete_disabled    *g:titanium_method_complete_disabled*
"      Titanium API に存在するメソッドを Omni 補完する機能を抑止す
"      るためのフラグです。
"      デフォルトは 1 です。

"g:titanium_complete_short_style      *g:titanium_complete_short_style*
"      Omni 補完の候補に表示する項目を Ti prefix にするための
"      フラグです。
"      デフォルトは 1 です。

"g:titanium_desktop_complete_keywords_path  *g:titanium_desktop_complete_keywords_path*
"      Desktop API 補完キーワードファイルパスです。
"      指定がない場合は、*ft-titanium* 付属のファイルから補完
"      キーワードを検索します。

"g:titanium_mobile_complete_keywords_path  *g:titanium_mobile_complete_keywords_path*
"      Mobile API 補完キーワードファイルパスです。
"      指定がない場合は、*ft-titanium* 付属のファイルから補完
"      キーワードを検索します。

"g:titanium_sdk_root_dir        *g:titanium_sdk_root_dir*
"      Titanium SDK が格納されている root ディレクトリです。
"      指定なしの場合は、環境に応じて任意のディレクトリを
"      検索し、発見されたSDKを使用します。

"g:titanium_disable_keymap      *g:titanium_disable_keymap*
"      プラグイン側でのマッピング処理を実施しません。
"      このフラグが有効な場合、omnifunc の設定も
"      実施しません。



"****************************************
"ref-titanium
" let g:ref_timobileref_cmd    = 'w3m -dump %s'
" let g:ref_timobileref_docroot = '~/.vim/dict/'
" nnoremap rt :Ref timobileref<Space>
"}}}

"----------------------------------------
" zencoding
"----------------------------------------
"{{{
" codaのデフォルトと一緒にする
inoremap <C-E> <C-Y>,
let g:user_zen_leader_key = '<C-Y>'
" 言語別に対応させる
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
" make -f ~/.vim/bundle/vimproc/mac_make
" をしなければいけない
let g:ref_use_vimproc             = 1
let g:ref_alc_start_linenumber    = 47
let g:ref_open                    = 'split'
let g:ref_cache_dir               = expand('~/.Trash')
let g:ref_refe_cmd                = expand('~/.vim/ref/ruby-ref1.9.2/refe-1_9_2')
let g:ref_phpmanual_path          = expand('~/.vim/ref/php-chunked-xhtml')
let g:ref_ri_cmd                  = expand('~/.rbenv/versions/1.9.3-p125/bin/ri')

"リファレンスを簡単に見れる。
" nnoremap K <Nop>

nnoremap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
vnoremap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>

aug MyAutoCmd
  au FileType ruby,eruby,ruby.rspec nnoremap <silent><buffer>KK :<C-u>Unite -no-start-insert ref/ri -input=<C-R><C-W><CR>
  au FileType ruby,eruby,ruby.rspec nnoremap <silent><buffer>K :<C-u>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
aug END

" refビューワー内の設定
" vim-ref内の移動を楽に
function! s:initialize_ref_viewer()
  nnoremap <buffer><CR> <Plug>(ref-keyword)
  nnoremap <buffer>th  <Plug>(ref-back)
  nnoremap <buffer>tl  <Plug>(ref-forward)
  " nnoremap <buffer> q<C-w>c
  nnoremap <buffer>q :q!<CR>
  setlocal nonumber
endfunction
aug MyAutoCmd
  autocmd FileType ref call s:initialize_ref_viewer()
aug END

"alc
nnoremap ra :<C-U>Ref alc<Space>
nnoremap rp :<C-U>Ref phpmanual<Space>
" nnoremap rr :<C-U>Ref refe<Space>
" nnoremap ri :<C-U>Ref ri<Space>
nnoremap rr :<C-U>Unite ref/refe     -default-action=split -input=
nnoremap ri :<C-U>Unite ref/ri       -default-action=split -input=
nnoremap rm :<C-U>Unite ref/man      -default-action=split -input=
nnoremap rpy :<C-U>Unite ref/pydoc   -default-action=split -input=
nnoremap rpe :<C-U>Unite ref/perldoc -default-action=split -input=

let g:ref_alc_encoding  = 'utf-8'

"使用するには、lynxかw3mが必要です
"lynxの場合
let g:ref_alc_cmd       = 'lynx -dump -nonumbers -assume_charset=utf-8 -assume_local_charset=utf-8 -assume_unrec_charset=utf-8 -display_charset=utf-8 %s'
let g:ref_phpmanual_cmd = 'lynx -dump -nonumbers -assume_charset=utf-8 -assume_local_charset=utf-8 -assume_unrec_charset=utf-8 -display_charset=utf-8 %s'
" let g:ref_refe_cmd      = 'lynx -dump -nonumbers -assume_charset=utf-8 -assume_local_charset=utf-8 -assume_unrec_charset=utf-8 -display_charset=utf-8 %s'

"w3mの場合
" let g:ref_refe_cmd      = 'w3m -dump %s'
" let g:ref_alc_cmd        = 'w3m -dump %s'
" let g:ref_html_cmd       = 'w3m -dump %s'
" let g:ref_phpmanual_cmd  = 'w3m -dump %s'
" let g:ref_rails_cmd      = 'w3m -dump %s'
"}}}

"----------------------------------------
" vim-fugitive
"----------------------------------------
"{{{
"vim上からgitを使う 便利
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
" "vim上からgitを使う 便利
let g:git_no_default_mappings = 1
let g:git_use_vimproc = 1
" let g:git_command_edit = 'rightbelow vnew'
let g:git_command_edit = 'vnew'

aug MyAutoCmd
  au FileType git-diff nnoremap<buffer>q :q<CR>
aug END
" nnoremap <silent><Space>gb :GitBlame<CR>
" nnoremap <silent><Space>gB :Gitblanch
" nnoremap <silent><Space>gp :GitPush<CR>
nnoremap <silent>gd :<C-U>GitDiff HEAD<CR>
nnoremap <silent>gD :GitDiff<Space>
" " nnoremap <silent><Space>gs :GitStatus<CR>
nnoremap <silent>gL :GitLog -10<CR>
" " nnoremap <silent><Space>gL :<C-u>GitLog -u \| head -10000<CR>
nnoremap <silent>ga :GitAdd -A<CR>
nnoremap <silent>gA :GitAdd<Space>
" nnoremap <silent><Space>gA :<C-u>GitAdd <cfile><CR>
" nnoremap <silent><Space>gm :GitCommit<CR>
" nnoremap <silent>gm :GitCommit --amend<CR>
nnoremap <silent>gp :Git push<Space>
" nnoremap <silent><Space>gt :Git tag<Space>
" "}}}

"----------------------------------------
" unite-giti
"----------------------------------------
"{{{
nnoremap <silent>gl :<C-U>Unite giti/log<CR>
nnoremap <silent>gs :<C-U>Unite giti/status<CR>
nnoremap <silent>gh :<C-U>Unite giti/branch_all<CR>
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
onoremap <silent> iw <Plug>CamelCaseMotion_iw
xnoremap <silent> iw <Plug>CamelCaseMotion_iw
onoremap <silent> ib <Plug>CamelCaseMotion_ib
xnoremap <silent> ib <Plug>CamelCaseMotion_ib
onoremap <silent> ie <Plug>CamelCaseMotion_ie
xnoremap <silent> ie <Plug>CamelCaseMotion_ie
"}}}

"------------------------------------
" matchit.zip
"------------------------------------
"{{{
" % での移動出来るタグを増やす
let b:match_words = '<div.*>:</div>,<ul.*>:</ul>,<li.*>:</li>,<head.*>:</head>,<a.*>:</a>,<p.*>:</p>,<form.*>:</form>,<span.*>:</span>,<iflame.*>:</iflame>'
let b:match_words .= ':<if>:<endif>,<while>:<endwhile>,<foreach>:<endforeach>'

let b:match_ignorecase = 1
"}}}

"------------------------------------
" vim-powerline
"------------------------------------
"{{{
">の形をを許可する
"ちゃんと/.vim/fontsのfontを入れていないと動かないよ
set guifontwide=Ricty:h10
" let g:Powerline_colorscheme='molokai'
let g:Powerline_symbols = 'fancy'
let g:Powerline_cache_enabled = 0
let g:Powerline_cache_file = expand('/tmp/Powerline.cache')
"}}}

"------------------------------------
" vimshell
"------------------------------------
"{{{
" 設定は正直よく分かっていない
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

function! s:globpath(path, expr) "{{{
  return split(globpath(a:path, a:expr), "\n")
endfunction "}}}

" 上の関数の他にもちょくちょく定義されてないExコマンドや関数とかありますが
" それについては
" http://github.com/tyru/dotfiles/blob/master/.vimrc
" とか参照してください

" let g:vimshell_user_prompt  = '"(" . getcwd() . ") --- (" . $USER . "@" . hostname() . ")"'
let g:vimshell_user_prompt  = '"(" . getcwd() . ")" '
let g:vimshell_prompt       = '$ '
" let g:vimshell_right_prompt = '"(" . getcwd() . ") --- (" . $USER . "@" . hostname() . ")"'
let g:vimshell_ignore_case  = 1
let g:vimshell_smart_case   = 1

function! s:vimshell_settings() "{{{

  " No -bar
  command!
        \   -buffer -nargs=+
        \   VimShellAlterCommand
        \   call vimshell#altercmd#define(
        \       s:parse_one_arg_from_q_args(<q-args>)[0],
        \       s:eat_n_args_from_q_args(<q-args>, 1)
        \   )

  " Alias
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

  " append custom mappings
  " call vimshell#custom_mappings#append_mapping()

  " " use custom mappings
  " inoremap <buffer><C-P> <Plug>(vimshell_previous_command)
  " inoremap <buffer><C-N> <Plug>(vimshell_next_command)

  " inoremap <buffer><TAB> <Plug>(vimshell_zsh_complete)
  " nnoremap <buffer><C-L> <C-W><C-W>
  " inoremap <buffer><C-L> <Nop>

  setlocal updatetime=1000

  " let g:vimshell_escape_colors = [
  "       \'#3c3c3c', '#ff6666', '#66ff66', '#ffd30a', '#1e95fd', '#ff13ff', '#1bc8c8', '#C0C0C0',
  "       \'#686868', '#ff6666', '#66ff66', '#ffd30a', '#6699ff', '#f820ff', '#4ae2e2', '#ffffff'
  "       \]
endfunction "}}}

aug MyAutoCmd
  au FileType vimshell call s:vimshell_settings()
aug END

nnoremap <silent><Leader>v  :call BundleWithCmd('vimshell', 'VimShell')<CR>
"}}}

"------------------------------------
" memolist.vim
"------------------------------------
""{{{
let g:memolist_path = "$HOME/.memolist"
let g:memolist_memo_suffix = "mkd"
let g:memolist_memo_date = "%Y-%m-%d %H:%M"
let g:memolist_memo_date = "epoch"
let g:memolist_memo_date = "%D %T"
let g:memolist_prompt_tags = 1
let g:memolist_prompt_categories = 1
let g:memolist_qfixgrep = 0
let g:memolist_vimfiler = 1
let g:memolist_template_dir_path = "$HOME/.memolist"

" mapping
nnoremap <silent><Space>mn  :call BundleWithCmd('memolist.vim', 'MemoNew')<CR>
nnoremap <silent><Space>ml  :call BundleWithCmd('unite.vim', 'Unite file:~/.memolist/')<CR>
nnoremap <silent><Space>mg  :call BundleWithCmd('memolist.vim', 'MemoGrep')<CR>
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
let g:returnApp = "iTerm"
nnoremap <Space>bc :ChromeReloadStart<CR>
nnoremap <Space>bC :ChromeReloadStop<CR>
nnoremap <Space>bf :FirefoxReloadStart<CR>
nnoremap <Space>bF :FirefoxReloadStop<CR>
nnoremap <Space>bs :SafariReloadStart<CR>
nnoremap <Space>bS :SafariReloadStop<CR>
nnoremap <Space>bo :OperaReloadStart<CR>
nnoremap <Space>bO :OperaReloadStop<CR>
nnoremap <Space>ba :AllBrowserReloadStart<CR>
nnoremap <Space>bA :AllBrowserReloadStop<CR>
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
" " ctrlp"{{{
let g:ctrlp_map = '<Nul>'
let g:ctrlp_regexp = 1
" let g:ctrlp_tabpage_position = 'al'
" let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_use_caching = 1
" let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_cache_dir = $HOME.'/.Trashes/.cache/ctrlp'
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.\(hg\|git\|sass-cache\|svn\)$',
      \ 'file': '\.\(dll\|exe\|gif\|jpg\|png\|psd\|so\|woff\)$' }
let g:ctrlp_open_new_file = 't'
" let g:ctrlp_open_multiple_files = 'tj'
" let g:ctrlp_lazy_update = 1
"
" let g:ctrlp_mruf_max = 1000
let g:ctrlp_mruf_exclude = '\(\\\|/\)\(Temp\|Downloads\)\(\\\|/\)\|\(\\\|/\)\.\(hg\|git\|svn\|sass-cache\)'
" let g:ctrlp_mruf_case_sensitive = 0
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
nnoremap <silent><C-H><C-G> :CtrlPClearCache<Return>:call <SID>CallCtrlPBasedOnGitStatus()<Return>
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
let g:rails_some_option = 1
let g:rails_level = 4
let g:rails_syntax = 1
let g:rails_statusline = 1
let g:rails_url='http://localhost:3000'
let g:rails_subversion=0
let g:dbext_default_SQLITE_bin = 'mysql2'
let g:rails_default_file='config/database.yml'
let g:rails_mappings=1
let g:rails_modelines=1
let g:rails_gnu_screen=1
" let g:rails_ctags_arguments='--languages=-javascript'
" let g:rails_ctags_arguments = ''
function! SetUpRailsSetting()
  nnoremap <buffer><Space>r :R<CR>
  nnoremap <buffer><Space>a :A<CR>
  nnoremap <buffer><Space>m :Rmodel<Space>
  nnoremap <buffer><Space>c :Rcontroller<Space>
  nnoremap <buffer><Space>v :Rview<Space>
  " nnoremap <buffer><Space>s :Rspec<Space>
  " nnoremap <buffer><Space>m :Rgen model<Space>
  " nnoremap <buffer><Space>c :Rgen contoller<Space>
  " nnoremap <buffer><Space>s :Rgen scaffold<Space>
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
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'w3m %URL%'
let g:github_user = 'taichouchou2'

nnoremap <silent><C-H>g :call BundleWithCmd('gist-vim', 'Gist')<CR>
nnoremap <silent><C-H>gl :call BundleWithCmd('gist-vim', 'Gist -l')<CR>
"}}}

"------------------------------------
" twitvim
"------------------------------------
"{{{
let g:tweetvim_display_source = 1
let g:tweetvim_display_time = 1
let g:tweetvim_open_buffer_cmd = 'tabnew'
nnoremap <silent><C-H><C-N>  :call BundleWithCmd('TweetVim bitly.vim twibill.vim', 'Unite tweetvim')<CR>
nnoremap <silent><C-H><C-M>  :call BundleWithCmd('TweetVim bitly.vim twibill.vim', 'TweetVimSay')<CR>
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
" let g:sass_compile_cdloop = 5
let g:sass_compile_cssdir = ['css', 'stylesheet']
let g:sass_compile_file = ['scss', 'sass']
let g:sass_started_dirs = []
function! AutoSassCompile()
  aug MyAutoCmd
    au BufWritePost <buffer> SassCompile
  aug END
endfunction
au FileType less,sass,scss  setlocal sw=2 sts=2 ts=2 et syntax=scss
"}}}

"------------------------------------
" jasmine.vim
"------------------------------------
"{{{
" function! JasmineSetting()
"
"   nnoremap <buffer> <leader>m :JasmineRedGreen<CR>
"   call jasmine#load_snippets()
"   command! JasmineRedGreen :call jasmine#redgreen()
"   command! JasmineMake :call jasmine#make()
" endfunction
aug MyAutoCmd
  " au BufRead,BufNewFile,BufReadPre *Helper.coffee,*Spec.coffee  call JasmineSetting()
  au BufRead,BufNewFile,BufReadPre *Helper.coffee,*Spec.coffee let b:quickrun_config = {'type' : 'coffee'}
aug END
"}}}

"------------------------------------
" Pydiction
"------------------------------------
"let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'

"------------------------------------
" cascading.vim
"------------------------------------
"--でメソッドチェーンを整形 $this->aa()->bb()->
"nnoremap <Leader>c :Cascading<CR>

"------------------------------------
" YankRing.vim
"------------------------------------
" Yankの履歴参照"{{{
nnoremap <Leader>y :YRShow<CR>

let g:yankring_enabled             = 1  " Disables the yankring
let g:yankring_max_history         = 100
let g:yankring_min_element_length  = 2
let g:yankring_max_element_length  = 4194304 " 4M
let g:yankring_max_display         = 70
let g:yankring_dot_repeat_yank     = 0
let g:yankring_window_use_separate = 0
let g:yankring_window_auto_close   = 1
let g:yankring_window_height       = 8
let g:yankring_window_width        = 30
let g:yankring_window_use_bottom   = 0
let g:yankring_window_use_right    = 0
let g:yankring_window_increment    = 5
let g:yankring_history_dir         = '~/.yankring'
let g:yankring_history_file        = 'yankring_text' . $USER
let g:yankring_ignore_operator     = 'g~ gu gU ! = g? < > zf zo zc g@ @'
let g:yankring_n_keys              = ''
let g:yankring_o_keys              = ''
let g:yankring_zap_keys            = ''
let g:yankring_v_key               = ''
let g:yankring_del_v_key           = ''
let g:yankring_paste_n_bkey        = ''
let g:yankring_paste_n_akey        = ''
let g:yankring_paste_v_key         = ''
let g:yankring_replace_n_pkey      = ''
let g:yankring_replace_n_nkey      = ''
let  g:yankring_default_menu_mode = 0
"}}}

"------------------------------------
" operator-camelize.vim
"------------------------------------
" camel-caseへの変換
xnoremap <Leader>u <Plug>(operator-camelize)
xnoremap <Leader>U <Plug>(operator-decamelize)

"------------------------------------
" operator-replace.vim
"------------------------------------
" RwなどでYankしてるもので置き換える
" よくわからん！
"map R <Plug>(operator-replace)

"------------------------------------
" operator-comment.vim
"------------------------------------
"{{{
" map C  <Plug>(operator-comment)
" map C  <Plug>(operator-uncomment)
"}}}

"------------------------------------
" smartchr.vim
"------------------------------------
"{{{
let g:smartchr_enable = 0

" Smart =.

if g:smartchr_enable == 1
  " inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
  "       \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
  "       \ : smartchr#one_of(' = ', '=', ' == ')
  inoremap <expr> , smartchr#one_of(',', ', ')
  inoremap <expr> ? smartchr#one_of('?', '? ')
  " inoremap <expr> = smartchr#one_of(' = ', '=')

  " Smart =.
  " inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
  "       \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
  "       \ : smartchr#one_of(' = ', '=', ' == ')
  augroup MyAutoCmd
    " Substitute .. into -> .
    au FileType c,cpp    inoremap <buffer><expr> . smartchr#loop('.', '->', '...')
    au FileType perl,php inoremap <buffer><expr> - smartchr#loop('-', '->')
    au FileType vim      inoremap <buffer><expr> . smartchr#loop('.', ' . ', '..', '...')
    au FileType coffee   inoremap <buffer><expr> - smartchr#loop('-', '->', '=>')

    " 使わない
    " autocmd FileType haskell,int-ghci
    "       \ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
    "       \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
    "       \| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
    "       \| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
    "       \| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
    "       \| inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..')

    " autocmd FileType scala
    "       \ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
    "       \| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
    "       \| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
    "       \| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')

    autocmd FileType eruby
          \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
          \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
  augroup END
endif
"}}}

"------------------------------------
" Srcexp
"------------------------------------
" " [Srcexpl] tagsを利用したソースコード閲覧・移動補助機能"{{{
" let g:SrcExpl_UpdateTags    = 0         " tagsをsrcexpl起動時に自動で作成（更新）
" let g:SrcExpl_RefreshTime   = 0         " 自動表示するまでの時間(0:off)
" let g:SrcExpl_WinHeight     = 2         " プレビューウインドウの高さ
" let g:SrcExpl_gobackKey = "<SPACE>"
" let g:SrcExpl_jumpKey = "<ENTER>"
" " let g:SrcExpl_searchLocalDef = 1
" " let g:SrcExpl_isUpdateTags = 0
" " let g:SrcExpl_updateTagsKey = "<C-H><C-U>"
" let g:SrcExpl_RefreshMapKey = "<C-S>"   " 手動表示のMAP
" let g:SrcExpl_GoBackMapKey  = "<C-Q>"   " 戻る機能のMAP
" " let g:SrcExpl_updateTagsCmd = "jctags -R"
"
" " Source Explorerの機能ON/OFF
" nnoremap <C-H><C-E> :SrcExplToggle<CR>
"}}}

"------------------------------------
" Syntastic
"------------------------------------
"{{{
"loadのときに、syntaxCheckをする
let g:syntastic_check_on_open=0
let g:syntastic_quiet_warnings=0
let g:syntastic_enable_signs = 1
let g:syntastic_enable_highlighting = 1
let g:syntastic_enable_balloons = 1
let g:syntastic_echo_current_error=1
" let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=0
let g:syntastic_loc_list_height=3

" let g:syntastic_error_symbol='>'
" let g:syntastic_warning_symbol='='
let g:syntastic_error_symbol='✗'
let g:syntastic_warning_symbol='⚠'

let g:syntastic_mode_map = {
      \ 'mode'              : 'active',
      \ 'active_filetypes'  : ['ruby', 'php', 'javascript', 'less', 'coffee', 'scss', 'haml', 'vim' ],
      \ 'passive_filetypes' : ['html']
      \}
" let g:syntastic_ruby_checker = "mri"
"}}}

"------------------------------------
" jslint
"------------------------------------
" javascriptファイルのsyntaxエラーをハイライトする
" let g:JSLintHighlightErrorLine = 0

"------------------------------------
" w3m.vim
"------------------------------------
"{{{
let g:w3m#command = '/usr/local/bin/w3m'
let g:w3m#external_browser = 'chrome'
let g:w3m#homepage = "http://www.google.co.jp/"
let g:w3m#hit_a_hint_key = 'f'
let g:w3m#search_engine =
      \ 'http://search.yahoo.co.jp/search?search.x=1&fr=top_ga1_sa_124&tid=top_ga1_sa_124&ei=' . &encoding . '&aq=&oq=&p='
let g:w3m#disable_default_keymap = 1
" unlet g:w3m#set_hover_on
" let g:w3m#hover_set_on = -1
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
" call indent_guides#enable()
" IndentGuidesEnable
let g:indent_guides_start_level = 2
let g:indent_guides_auto_colors=0
let g:indent_guides_enable_on_vim_startup=0
let g:indent_guides_color_change_percent = 20
" let g:indent_guides_guide_size=&tabstop
let g:indent_guides_guide_size=1
let g:indent_guides_space_guides = 1

hi IndentGuidesOdd  ctermbg=235
" hi IndentGuidesEven ctermbg=237
hi IndentGuidesEven ctermbg=233
aug MyAutoCmd
  au FileType html,php,haml,scss,sass,less,coffee,ruby,javascript,python IndentGuidesEnable
aug END
nnoremap <silent><Leader>ig <Plug>IndentGuidesToggle
"}}}

"------------------------------------
" qiita
"------------------------------------
"{{{
" nnoremap <C-H><C-Q> :unite qiita<CR>
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
xnoremap <C-j> <Plug>(textmanip-move-down)
xnoremap <C-k> <Plug>(textmanip-move-up)
xnoremap <C-h> <Plug>(textmanip-move-left)
xnoremap <C-l> <Plug>(textmanip-move-right)
"}}}

"------------------------------------
" Gundo.vim
"------------------------------------
nnoremap U      :<C-u>GundoToggle<CR>

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
onoremap ax <Plug>(textobj-enclosedsyntax-a)
vnoremap ax <Plug>(textobj-enclosedsyntax-a)
onoremap ix <Plug>(textobj-enclosedsyntax-i)
vnoremap ix <Plug>(textobj-enclosedsyntax-i)
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
" let g:qts_templatedir=expand( '~/.vim/template' )

"}}}

"----------------------------------------
" 辞書:dict "{{{
augroup DictSetting
  au!
  " au FileType ruby.rspec           setl dict+=~/.vim/dict/rspec.dict
  " au FileType coffee.jasmine,javascript.jasmine setl dict+=~/.vim/dict/js.jasmine.dict
  au FileType html,php,eruby       setl dict+=~/.vim/dict/html.dict
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
" set infercase

"----------------------------------------
" neocomplcache
let g:neocomplcache_enable_at_startup = 1

" default config"{{{
let g:neocomplcache_auto_completion_start_length = 2
let g:neocomplcache_enable_camel_case_completion = 1

let g:neocomplcache_enable_underbar_completion = 1
" let g:neocomplcache_manual_completion_start_length = 0
let g:neocomplcache_min_keyword_length = 2
let g:neocomplcache_min_syntax_length = 2
let g:neocomplcache_disable_caching_buffer_name_pattern = '[\[*]\%(unite\)[\]*]'
let g:neocomplcache_disable_auto_select_buffer_name_pattern = '\[Command Line\]'
let g:neocomplcache_lock_buffer_name_pattern = '\.txt'
let g:neocomplcache_max_list = 120
let g:neocomplcache_skip_auto_completion_time = '0.3'
" let g:neocomplcache_caching_limit_file_size = 1000000
let g:neocomplcache#sources#rsense#home_directory = expand("~/.vim/ref/rsense-0.3")

" initialize "{{{
" if !exists('g:neocomplcache_wildcard_characters')
"   let g:neocomplcache_wildcard_characters = {}
" endif
" let g:neocomplcache_wildcard_characters._ = '*'
if $USER ==# 'root'
  let g:neocomplcache_temporary_dir       = expand( '~/.neocon' )
endif
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns       = {}
endif
if !exists('g:neocomplcache_force_omni_patterns')
  let g:neocomplcache_force_omni_patterns = {}
endif
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns    = {}
endif
if !exists('g:neocomplcache_same_filetype_lists')
  let g:neocomplcache_same_filetype_lists = {}
endif
"}}}

" For auto select.

let g:neocomplcache_force_omni_patterns.c      = '[^.[:digit:] *\t]\%(\.\|->\)'
let g:neocomplcache_force_omni_patterns.cpp    = '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
let g:neocomplcache_force_omni_patterns.python = '[^. \t]\.\w*'

" let g:clang_complete_auto = 0
" let g:clang_auto_select = 0
" let g:clang_use_library   = 1

" Define keyword pattern. "{{{
" let g:neocomplcache_keyword_patterns.default = '[0-9a-zA-Z:#_-]\+'
" let g:neocomplcache_keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
" let g:neocomplcache_keyword_patterns.perl = '\h\w*->\h\w*\|\h\w*::'
let g:neocomplcache_keyword_patterns.filename = '\%(\\.\|[/\[\][:alnum:]()$+_\~.-]\|[^[:print:]]\)\+'
let g:neocomplcache_snippets_dir = '~/.bundle/neosnippet/autoload/neosnippet/snippets,~/.vim/snippet'
" let g:neocomplcache_omni_patterns.php = '[^. *\t]\.\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.mail = '^\s*\w\+'
let g:neocomplcache_omni_patterns.c = '[^.[:digit:]*\t]\%(\.\|->\)'
"}}}

let g:neocomplcache_vim_completefuncs = {
      \ 'Ref' : 'ref#complete',
      \ 'Unite' : 'unite#complete_source',
      \ 'VimFiler' : 'vimfiler#complete',
      \ 'VimShell' : 'vimshell#complete',
      \ 'VimShellExecute' : 'vimshell#vimshell_execute_complete',
      \ 'VimShellInteractive' : 'vimshell#vimshell_execute_complete',
      \ 'VimShellTerminal' : 'vimshell#vimshell_execute_complete',
      \ 'Vinarise' : 'vinarise#complete',
      \ }

if !exists('g:neocomplcache_source_completion_length')
  let g:neocomplcache_source_completion_length = {
        \ 'alpaca_look' : 4,
        \ }
endif
"}}}

" ファイルタイプ毎の辞書ファイルの場所"{{{
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default'    : '',
      \ 'timobile'   : $HOME.'/.vim/dict/timobile.dict',
      \ }
"}}}

" keymap " {{{
" Plugin key-mappings.
imap <expr><C-g>     neocomplcache#undo_completion()
imap <expr><C-g>     neocomplcache#undo_completion()
" inoremap <expr><C-l>     neocomplcache#complete_common_string()
imap <expr><CR> neocomplcache#smart_close_popup() . "<CR>" . "<Plug>DiscretionaryEnd"
" inoremap <silent><expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
imap <silent><expr><S-TAB> pumvisible() ? "\<C-P>" : "\<S-TAB>"
imap <silent><expr><TAB>  pumvisible() ? "\<C-N>" : "\<TAB>"
" }}}
"}}}

"----------------------------------------
" neosnippet"{{{
let g:neosnippet#snippets_directory = g:neocomplcache_snippets_dir
aug MyAutoCmd
  au FileType snippet nnoremap <buffer><Space>e :e #<CR>
aug END
imap <silent><C-F>     <Plug>(neosnippet_expand_or_jump)
" imap <silent><C-U>     <Plug>(neosnippet_start_unite_snippet)
inoremap <silent><C-U>     <ESC>:<C-U>Unite snippet<CR>
nnoremap <silent><Space>e  :<C-U>NeoSnippetEdit -split<CR>
nnoremap <silent><expr><Space>ee  ':NeoSnippetEdit -split'.split(&ft, '.')[0].'<CR>'
" smap <silent><C-F>     <Plug>(neosnippet_expand_or_jump)
" xnoremap <silent><C-F>     <Plug>(neosnippet_start_unite_snippet_target)
" xnoremap <silent>U         <Plug>(neosnippet_expand_target)
xmap <silent>o         <Plug>(neosnippet_register_oneshot_snippet)
"}}}

"----------------------------------------
" コマンドの実行"{{{

"----------------------------------------
" phptohtml
"----------------------------------------
aug MyAutoCmd
  au Filetype php nnoremap <Leader>R :! phptohtml<CR>
aug END

"----------------------------------------
" 独自関数
"----------------------------------------
" ----------------------------------------
" today
" ----------------------------------------
"{{{
function! Today()
  return strftime("%Y-%m-%d")
endfunction
inoremap <C-D><C-D> <C-R>=Today()<CR>
"}}}

" ----------------------------------------
" open yard
" ----------------------------------------
" カーソル下のgemのrdocを開く
"{{{
function! OpenYard(...)
  let gem = a:1 == "" ? "" : a:1
  if gem == ""
    call OpenBrowser("http://localhost:8808/")
  else
    let url = "http://localhost:8808/docs/" . tolower(gem) . "/frames/"
    call OpenBrowser(url)
  endif
endfunction

command!
      \   -nargs=*
      \   OpenYard
      \   call OpenYard(<q-args>)
" マッピング
nnoremap <Space>y :<C-U>OpenYard <C-R><C-W><CR>

" 指定したgemを開く
aug RailsSetting
  au User Rails nnoremap <buffer><C-J><C-B> :!bundle open<Space>
aug END
"}}}

" ----------------------------------------
" haml2html
" ----------------------------------------
"{{{
" function! ConvertHamlToHtml(fileType)
"   " 同じディレクトリに、pathというファイルを作り
"   " `cat path` -> `../`
"   " となっていれば、その相対パスディレクトリに保存する
"
"   " 設定ファイルを読み込む
"   let dir_name = expand("%:p:h")
"   let save_path = ''
"   if filereadable(dir_name . '/path')
"     let save_path = readfile("path")[0]
"   endif
"
"   " 2html
"   let current_file = expand("%")
"   let target_file  = substitute(current_file, '.html', '', 'g')
"   let target_file  = dir_name.'/'.save_path.substitute(target_file, '.'.expand("%:e").'$', '.html', 'g')
"
"   " コマンドの分岐
"   if a:fileType == 'eruby'
"     " exec ":call vimproc#system('rm " .target_file"')"
"     let convert_cmd  = 'erb ' . current_file . ' > ' . target_file
"   elseif a:fileType == 'haml'
"     " let convert_cmd  = 'haml_with_ruby2html ' . current_file . ' > ' . target_file
"     let convert_cmd  = 'haml --format html4 ' . current_file . ' > ' . target_file
"   endif
"
"   echo "convert " . a:fileType . ' to ' . target_file
"   exec ":call vimproc#system('" . convert_cmd . "')"
" endfunction
"
" function! HamlSetting()
"   nnoremap <buffer><Leader>R :<C-U>call ConvertHamlToHtml("haml")<CR>
"   aug MyAutoCmd
"     au BufWritePost *.haml silent call ConvertHamlToHtml("haml")
"   aug END
" endfunction
" " au Filetype haml call HamlSetting()
"
" function! ErubySetting()
"   nnoremap <buffer><Leader>R :<C-U>call ConvertHamlToHtml("eruby")<CR>
"   aug MyAutoCmd
"     au BufWritePost *.erb silent call ConvertHamlToHtml("eruby")
"   aug END
" endfunction
" au Filetype eruby call ErubySetting()
"}}}
" au Filetype eruby call ErubySetting()

" Mac の辞書.appで開く {{{
if has('mac')
  " 引数に渡したワードを検索
  command! -nargs=1 MacDict      call system('open '.shellescape('dict://'.<q-args>))
  " カーソル下のワードを検索
  command! -nargs=0 MacDictCWord call system('open '.shellescape('dict://'.shellescape(expand('<cword>'))))
  " 辞書.app を閉じる
  command! -nargs=0 MacDictClose call system("osascript -e 'tell application \"Dictionary\" to quit'")
  " 辞書にフォーカスを当てる
  command! -nargs=0 MacDictFocus call system("osascript -e 'tell application \"Dictionary\" to activate'")
  " キーマッピング

  nnoremap <silent>mo :<C-u>MacDictCWord<CR>
  vnoremap <silent>mm y:<C-u>MacDict<Space><C-r>*<CR>
  nnoremap <silent>mc :<C-u>MacDictClose<CR>
  nnoremap <silent>mf :<C-u>MacDictFocus<CR>
endif
"}}}

" ----------------------------------------
" Diff
" ----------------------------------------
"{{{
" Display diff with the file.
command! -nargs=1 -complete=file Diff vertical diffsplit <args>
" Display diff from last save.
command! DiffOrig vert new | setlocal bt=nofile | r # | 0d_ | diffthis | wincmd p | diffthis
" Disable diff mode.
command! -nargs=0 Undiff setlocal nodiff noscrollbind wrap
"}}}
"}}}

set secure
