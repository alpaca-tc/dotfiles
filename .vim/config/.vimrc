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
set formatoptions+=lmoqmM
set helplang=ja,en
set modelines=0
set nobackup
set scrolloff=0
set scrolljump=-50
set showcmd
set showmode
set timeout timeoutlen=400 ttimeoutlen=100
set vb t_vb=
set viminfo='100,<800,s300,\"300

autocmd FileType help nnoremap <buffer> q <C-w>c
nmap <Space>h :<C-u>help<Space><C-r><C-w><CR>
nmap <Space><Space>s :<C-U>so ~/.vimrc<CR>
"}}}

"----------------------------------------
"StatusLine"{{{
" source ~/.vim/config/.vimrc.statusline
"}}}

"----------------------------------------
"編集"{{{
set autoread
" set textwidth=100
set textwidth=0
set hidden
set nrformats-=octal

" コンマの後に自動的にスペースを挿入
"inoremap , ,<Space>
"開いているファイルのディレクトリに自動で移動
au BufEnter * execute ":lcd " . expand("%:p:h")

"<Space>w or <Space>qで画面を閉じる
nmap <Space>w :wq<CR>
nmap <Space>q :q!<CR>
nmap <Space>s :w sudo:%<CR>

"削除の標準キーマップを逆に。
"また、レジスタに入れないようにする
" nmap x <BS>
"nmap X <Del>
imap <C-@> <BS>
imap <C-H> <BS>
imap <C-Space> <BS>

" 括弧を自動補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
au FileType ruby,eruby inoremap <buffer>\| \|\|<LEFT>

" 一括インデント
vnoremap < <gv
vnoremap > >gv

"コメントを書くときに便利
inoremap <leader>* ****************************************
inoremap <leader>- ----------------------------------------
inoremap <leader>h <!--/--><left><left><left>

"保存時に無駄な文字を消す
function! s:remove_dust()
    let cursor = getpos(".")

    %s/\s\+$//ge
    %s/\t/    /ge
    call setpos(".", cursor)
    unlet cursor
endfunction
au BufWritePre * call <SID>remove_dust()
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
map $ g_

nmap <silent>h <Left>
nmap <silent>l <Right>
nmap <silent>j gj
nmap <silent>k gk
nmap <silent><Down> gj
nmap <silent><Up>   gk

imap <silent><C-L> <Right>
imap <silent><C-L><C-L> <Esc>A
" imap <silent><C-H> <Left>
" imap <silent><C-H><C-H> <Left><Esc>I
imap <silent><C-O> <Esc>o
vnoremap v G
inoremap jj <Esc>

"よくミスキータッチするから削除
nnoremap H <Nop>
vnoremap H <Nop>

" マークを使い易くする
nmap <silent>; :<C-U>echo "マーク"<CR><ESC>'

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" windowの操作
" ****************
" 画面の移動
nmap <C-L> <C-W><C-W>
nmap <C-W><C-H> <C-W>H
nmap <C-W><C-K> <C-W>K
nmap <C-W><C-L> <C-W>L
nmap <C-W><C-J> <C-W>J

" tabを使い易く
nnoremap t  <Nop>
nnoremap tn  :tabn<CR>
nnoremap tp  :tabprevious<CR>
nnoremap tc  :tabnew<CR>
nnoremap tx  :tabclose<CR>
" nnoremap to  :tabo<CR>
nnoremap te  :execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
"tabを次のtabへ移動
nnoremap tg  gT

nnoremap t1  :tabnext 1<CR>
nnoremap t2  :tabnext 2<CR>
nnoremap t3  :tabnext 3<CR>
nnoremap t4  :tabnext 4<CR>
nnoremap t5  :tabnext 5<CR>
nnoremap t6  :tabnext 6<CR>
"}}}

"----------------------------------------
"encoding"{{{
set fileformats=unix,dos,mac
set encoding=utf-8
set fileencodings=utf-8,sjis,shift-jis,euc-jp,utf-16,ascii,ucs-bom,cp932,iso-2022-jp

autocmd FileType cvs  :set fileencoding=euc-jp

function! b:newFileEncoding()
  autocmd FileType svn    :setl fileencoding=utf-8
  autocmd FileType js     :setl fileencoding=utf-8
  autocmd FileType css    :setl fileencoding=utf-8
  autocmd FileType html   :setl fileencoding=utf-8
  autocmd FileType xml    :setl fileencoding=utf-8
  autocmd FileType java   :setl fileencoding=utf-8
  autocmd FileType scala  :setl fileencoding=utf-8
endfunction
au BufNewFile * call b:newFileEncoding()

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
" set tabstop=4
" set softtabstop=4
" set shiftwidth=4
if has("autocmd")
  filetype indent on
  " 無効にしたい場合
  " autocmd FileType html filetype indent off

  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
  autocmd FileType conf       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType eruby      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType html       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scss       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType less,sass  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType lisp       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
endif
autocmd InsertLeave * set nopaste
"}}}

"----------------------------------------
"表示"{{{
set showmatch         " 括弧の対応をハイライト
set number            " 行番号表示
set noequalalways     " 画面の自動サイズ調整解除
" set relativenumber    " 相対表示
set list              " 不可視文字表示
"set listchars=tab:,trail:,extends:,precedes:  " 不可視文字の表示形式
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set listchars=tab:␣.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
" set listchars=tab:✃.,trail:_,extends:>,precedes:< " 不可視文字の表示形式

"set display=uhex      " 印字不可能文字を16進数で表示
set t_Co=256          " 確かカラーコード
set lazyredraw        " コマンド実行中は再描画しない
set ttyfast           " 高速ターミナル接続を行う
" set scrolloff=999     " 常にカーソルを真ん中に
syntax on

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/
"au BufRead,BufNew * match JpSpace /　/

" カーソル行をハイライト
set cursorline

" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

"折り畳み
function! ChangeFoldMethod()
  if g:foldMethodCount == 0
    set foldmethod=marker "{{ { という感じの文字が入る
    echo "foldmethod is marker"
  elseif g:foldMethodCount == 1
    set foldmethod=manual "手動
    echo "foldmethod is manual"
  elseif g:foldMethodCount == 2
    set foldmethod=indent "indent
    echo "foldmethod is indent"
  endif
  let g:foldMethodCount = ( g:foldMethodCount + 1 ) % 3
endfunction

let g:foldMethodCount = 0
set foldmethod=marker
nmap <Space><Space>f :<C-U>call ChangeFoldMethod()<CR>

" 設定を上書きしない為に、最後に書く
" colorscheme darkblue
" colorscheme pyte
" colorscheme solarized
colorscheme molokai

"****************************************
"titanium用のsyntax
"****************************************
function! TitaniumSyn()
  hi def link titanium Define
  syn match titanium '\s*\(Ti\|Titanium\)\.[a-zA-Z0-9_\.]\+'
endfunction
au FileType javascript,javascript.titanium call TitaniumSyn()

"****************************************
"zend用のsyntax
"****************************************
function! ZendSyn()
  hi def link zend Define
"  syn match zend '\s*Zend_[a-zA-Z0-9_\.]\+'
  syn match zend '\s*Zend'
endfunction
au FileType php call ZendSyn()

"****************************************
" コマンドラインの色を修正する
"****************************************
" function! RefrashCmdColor()
"   hi Pmenu ctermbg=0
"   hi PmenuSel ctermbg=4
"   hi PmenuSbar ctermbg=2
"   hi PmenuThumb ctermfg=3
" endfunction
" au FileType * call RefrashCmdColor()

"****************************************
" Rspec
"****************************************
function! RSpecSyntax()
  hi def link rubyRailsTestMethod Function
  syn keyword rubyRailsTestMethod describe context it its specify shared_examples_for it_should_behave_like before after around subject fixtures controller_name helper_name
  syn match rubyRailsTestMethod '\<let\>!\='
  syn keyword rubyRailsTestMethod violated pending expect double mock mock_model stub_model
  syn match rubyRailsTestMethod '\.\@<!\<stub\>!\@!'
endfunction
autocmd BufReadPost *_spec.rb call RSpecSyntax()

"****************************************
" tmux
"****************************************
" augroup filetypedetect
"   au BufNewFile,BufRead  *.tmux.conf setl ft = tmux
" augroup END

"****************************************
" less
"****************************************
au BufNewFile,BufRead *.less setf less

"}}}

"----------------------------------------
" neobundle"{{{
filetype plugin indent off     " required!

if has('vim_starting')
  set runtimepath+=~/.bundle/neobundle.vim
  call neobundle#rc(expand('~/.bundle/'))
endif

"bundle"{{{
"----------------------------------------
"vim基本機能拡張"{{{
" NeoBundle 'Shougo/neobundle'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'mac' : 'make -f make_mac.mak',
      \    },
      \ }
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'vim-jp/vital.vim'
NeoBundle 'edsono/vim-matchit'
NeoBundle 'taichouchou2/surround.vim' " 独自の実装のものを使用、ruby用カスタマイズ、<C-G>のimap削除
NeoBundle 'tpope/vim-fugitive'
" NeoBundle 'yuroyoro/vim-autoclose'                          " 自動閉じタグ
NeoBundle 'taichouchou2/alpaca'       " 個人的なカラーやフォントなど
NeoBundle 'kana/vim-arpeggio'         " 同時押しキーマップを使う
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'othree/eregex.vim'         " %S 正規表現を拡張
" NeoBundle 'vim-scripts/SearchComplete' " /で検索をかけるときでも\tで補完が出来る
" 遅延読み込み

"}}}

"----------------------------------------
" vim拡張"{{{
NeoBundle 'tomtom/tcomment_vim'
NeoBundle 'vim-scripts/tlib' " tcommentで使用

NeoBundle 'Shougo/neocomplcache'
NeoBundle 'thinca/vim-quickrun' "<Leader>rで簡易コンパイル
" NeoBundle 'scrooloose/nerdtree' "プロジェクト管理用 tree filer
NeoBundle 'grep.vim'
NeoBundle 'smartword'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
" NeoBundle 'yuroyoro/vimdoc_ja'
NeoBundle 'camelcasemotion'
" NeoBundle 'taku-o/vim-toggle' "true<=>false など、逆の意味のキーワードを切り替えられる
NeoBundle 'Lokaltog/vim-easymotion'

NeoBundle 'mattn/zencoding-vim' "Zencodingを使う
NeoBundle 'vim-scripts/sudo.vim' "vimで開いた後にsudoで保存
NeoBundle 'taichouchou2/vim-endwise.git' "end endifなどを自動で挿入
NeoBundle 'nathanaelkane/vim-indent-guides' "indentに色づけ
" NeoBundle 'kien/ctrlp.vim' "ファイルを絞る

NeoBundle 'taglist.vim' "関数、変数を画面横にリストで表示する
" NeoBundle 'majutsushi/tagbar'

"コメントアウト
" NeoBundle 'hrp/EnhancedCommentify'

"ヤンクの履歴を管理し、順々に参照、出力できるようにする
" NeoBundle 'YankRing.vim'

" /で検索をかけるときでも\tで補完が出来る
" NeoBundle 'vim-scripts/SearchComplete'

"関連するファイルを切り替えれる
" NeoBundle 'kana/vim-altr'

"----------------------------------------
" text-object拡張"{{{
" operator拡張の元
" NeoBundle 'operator-camelize' "operator-camelize : camel-caseへの変換
NeoBundle 'emonkak/vim-operator-comment'
NeoBundle 'https://github.com/kana/vim-textobj-jabraces.git'
NeoBundle 'kana/vim-operator-user'
NeoBundle 'kana/vim-textobj-datetime'      " d 日付
NeoBundle 'kana/vim-textobj-fold.git'      " z 折りたたまれた{{ {をtext-objectに
NeoBundle 'kana/vim-textobj-function.git'  " f 関数をtext-objectに
NeoBundle 'kana/vim-textobj-indent.git'    " i I インデントをtext-objectに
NeoBundle 'kana/vim-textobj-lastpat.git'   " /? 最後に検索されたパターンをtext-objectに
NeoBundle 'kana/vim-textobj-syntax.git'    " y syntax hilightされたものをtext-objectに
NeoBundle 'kana/vim-textobj-user'          " textobject拡張の元
NeoBundle 'textobj-entire'                 " e buffer全体をtext-objectに
NeoBundle 'textobj-rubyblock'              " r rubyの、do-endまでをtext-objectに
NeoBundle 'thinca/vim-textobj-comment'     " c commentをtext-objectに
" NeoBundle 'thinca/vim-textobj-plugins.git' " vim-textobj-plugins : いろんなものをtext-objectにする

NeoBundle 'tyru/operator-html-escape.vim'
"}}}
"}}}

"----------------------------------------
" 他のアプリを呼び出す"{{{
"URL上で操作することで、URLを開いたり
"キーワード上で操作することで、ぐぐることができる
NeoBundle 'open-browser.vim'
NeoBundle 'thinca/vim-openbuf'

"各種リファレンスを引いたり、英和辞書を読む
NeoBundle 'thinca/vim-ref'
" NeoBundle 'soh335/vim-ref-jquery'
" NeoBundle 'soh335/vim-ref-jquery'
" NeoBundle 'ujihisa/ref-hoogle'
" NeoBundle 'pekepeke/ref-javadoc'

"gitをvim内から操作する
NeoBundle 'Shougo/git-vim'
NeoBundle 'mattn/gist-vim' "gistを利用する

"保存と同時にブラウザをリロードする
NeoBundle 'tell-k/vim-browsereload-mac'

"markdownでメモを管理
NeoBundle 'glidenote/memolist.vim'

"vimでwordpress
" NeoBundle 'vim-scripts/VimRepress'

"vモードで選択
"<Leader>seでsqlを実行
NeoBundle 'vim-scripts/dbext.vim'

"tagsを利用したソースコード閲覧・移動補助機能 tagsファイルの自動生成
" NeoBundle 'vim-scripts/Source-Explorer-srcexpl.vim'
"}}}

" syntax checking plugins exist for eruby, haml, html, javascript, php, python, ruby and sass.
NeoBundle 'scrooloose/syntastic'
" templeteを作れる
" NeoBundle 'thinca/vim-template'

" NeoBundle 'c9s/cascading.vim' "メソッドチェーン整形
NeoBundle 'kana/vim-smartchr' "smartchr.vim : ==()などの前後を整形

NeoBundle 'mattn/webapi-vim' "vim Interface to Web API
" NeoBundle 'tyru/urilib.vim' "urilib.vim : vim scriptからURLを扱うライブラリ
" NeoBundle 'cecutil' "cecutil.vim : 他のpluginのためのutillity1

NeoBundle 'taichouchou2/alpaca-look'
" NeoBundle 'L9' "utillity

"unite.vim : - すべてを破壊し、すべてを繋げ - vim scriptで実装されたanythingプラグイン
" NeoBundle 'tsukkee/unite-help'
" NeoBundle 'h1mesuke/unite-outline'
NeoBundle 'basyura/unite-rails'
NeoBundle 'thinca/vim-unite-history'
" NeoBundle 'Shougo/unite-ssh'
NeoBundle 'tsukkee/unite-tag'
NeoBundle 'tacroe/unite-mark'
" NeoBundle 'ujihisa/unite-gem'
" NeoBundle 'sgur/unite-qf'
" NeoBundle 'choplin/unite-vim_hacks'
" NeoBundle 'ujihisa/unite-colorscheme'
NeoBundle 'kmnk/vim-unite-giti'
" NeoBundle 'joker1007/unite-git_grep'
" NeoBundle 'mattn/unite-source-simplenote'

NeoBundle 'basyura/TweetVim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/bitly.vim'
NeoBundle 'daisuzu/facebook.vim'

NeoBundle 'thinca/vim-qfreplace'
NeoBundle 'yuratomo/w3m.vim'
NeoBundle 'TeTrIs.vim'
"}}}

" bundle.lang"{{{
" function! HtmlSetting()
" NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
NeoBundle 'hail2u/vim-css3-syntax'
NeoBundle 'pasela/unite-webcolorname'
" NeoBundle 'jQuery'
NeoBundle 'taichouchou2/html5.vim'
NeoBundle 'tpope/vim-haml'
NeoBundle 'xmledit'
" endfunction
" au FileType html,php,eruby,ruby,javascript,markdown call HtmlSetting()
" au FileType * call HtmlSetting()

"  js / coffee
" ----------------------------------------
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'claco/jasmine.vim'
NeoBundle 'taichouchou2/vim-javascript' " syntaxが無駄に入っているので、インストール後削除
NeoBundle 'hallettj/jslint.vim'
" NeoBundle 'pekepeke/titanium-vim' " Titaniumを使うときに

"  markdown
" ----------------------------------------
" markdownでの入力をリアルタイムでチェック
" NeoBundle 'mattn/mkdpreview-vim'
NeoBundle 'tpope/vim-markdown'

" sassのコンパイル
NeoBundle 'AtsushiM/sass-compile.vim'

"  php
" ----------------------------------------
NeoBundle 'oppara/vim-unite-cake'
" NeoBundle 'violetyk/cake.vim' " cakephpを使いやすく

"  binary
" ----------------------------------------
" NeoBundle 'Shougo/vinarise'

" objective-c
" ----------------------------------------
" NeoBundle 'msanders/cocoa.vim'

" ruby
" ----------------------------------------
" NeoBundle 'ujihisa/neco-ruby'
" NeoBundle 'astashov/vim-ruby-debugger'
NeoBundle 'taichouchou2/vim-rails'
NeoBundle 'taichouchou2/vim-ref-ri'
NeoBundle 'taichouchou2/neco-rubymf' " gem install methodfinder
NeoBundle 'romanvbabenko/rails.vim' " Rfactoryメソッドなど追加
NeoBundle 'ruby-matchit'
NeoBundle 'taq/vim-rspec'
NeoBundle 'ujihisa/unite-rake'
NeoBundle 'taichouchou2/vim-rsense'
" NeoBundle 'vim-ruby/vim-ruby'

" python
" ----------------------------------------
" NeoBundle 'Pydiction'
" NeoBundle 'yuroyoro/vim-python'

" scala
" ----------------------------------------
" NeoBundle 'yuroyoro/vim-scala'

" SQLUtilities : SQL整形、生成ユーティリティ
" NeoBundle 'SQLUtilities'

" C言語など<Leader>;で全行に;を挿入できる
" NeoBundle 'vim-scripts/teol.vim'

" shellscript indnt
" NeoBundle 'sh.vim'
"}}}

" Installation check.
if neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Please execute ":NeoBundleInstall" command.'
  " finish
endif

filetype plugin indent on
"}}}

"----------------------------------------
"個別のプラグイン"{{{
" jk同時押しで<ESC>
call arpeggio#map('i', '', 0, 'jk', '<Esc>')

"------------------------------------
" Align
"------------------------------------
" Alignを日本語環境で使用するための設定"{{{
let g:Align_xstrlen = 3
vmap <C-N> :Align<Space>
"}}}

"------------------------------------
" surround.vim
"------------------------------------
function! SetSurroundMapping()"{{{
  nmap ,( csw(
  nmap ,) csw)
  nmap ,{ csw{
  nmap ,} csw}
  nmap ,[ csw[
  nmap ,] csw]
  nmap ,' csw'
  nmap ," csw"
endfunction
" au FileType eruby call SetErubyMapping()
if exists("g:loaded_surround")
  if !exists("b:surround_35") " #
    let b:surround_35 = "#{ \r }"
  endif
end
"}}}

" ------------------------------------
" grep.vim
"------------------------------------
"{{{
" カーソル下の単語をgrepする
nnoremap <silent><C-g><C-g> :<C-u>Rgrep<Space><C-r><C-w> *<Enter><CR>
nnoremap <silent><C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><ENTER>

" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs = '.svn .git .hg .swp'
let Grep_Skip_Files = '*.bak *~'

" qf内でファイルを開いた後画面を閉じる
function! OpenInQF()
  .cc
  ccl
  "  filetype on
endfunction

"rgrepなどで開いたqfを編修可にする
"また、Enterで飛べるようにする
function! OpenGrepQF()
  "QuickFixをqだけで閉じる
  nnoremap <buffer> q :q!<CR>

  " cw
  set nowrap "折り返ししない
  set modifiable "編修可

  " gfで開くときに、新しいTabで開く
  nmap <buffer>gf <C-W>gf

  " C-Mで開ける
  nmap <C-M> :call OpenInQF()<CR>

  "Enterで開ける
  nmap <CR> :call OpenInQF()<CR>
endfunction
autocmd Filetype qf call OpenGrepQF()
"}}}

"------------------------------------
" taglist.Vim
"------------------------------------
"{{{
let Tlist_Ctags_Cmd = '~/local/bin/jctags' " ctagsのパス
let Tlist_Show_One_File = 1               " 現在編集中のソースのタグしか表示しない
let Tlist_Exit_OnlyWindow = 1             " taglistのウィンドーが最後のwindowならばVimを閉じる
let Tlist_Use_Right_Window = 1            " 右側でtaglistのウィンドーを表示
let Tlist_Enable_Fold_Column = 1          " 折りたたみ
let Tlist_Auto_Open = 0                   " 自動表示
let Tlist_Auto_Update = 1
let Tlist_WinWidth = 20
let g:tlist_javascript_settings = 'javascript;c:class;m:method;f:function'
let tlist_objc_settings='objc;P:protocols;i:interfaces;I:implementations;M:instance methods;C:implementation methods;Z:protocol methods'
let g:tlist_coffee_settings = 'coffee;f:function;v:variable'
nmap <Space>t :Tlist<CR>
"}}}

"------------------------------------
" tagbar.vim
"------------------------------------
"{{{
" nnoremap <Space>t :TagbarToggle<CR>
let g:tagbar_ctags_bin="~/local/bin/jctags"
"}}}

"------------------------------------
" open-blowser.vim
"------------------------------------
"{{{
" カーソル下のURLをブラウザで開く
nmap <Leader>o <Plug>(openbrowser-open)
vmap <Leader>o <Plug>(openbrowser-open)
" ググる
nnoremap <Leader>g :<C-u>OpenBrowserSearch<Space><C-r><C-w><Enter>
"}}}

"------------------------------------
" unite.vim
"------------------------------------
"{{{
" 入力モードで開始する
let g:unite_enable_start_insert=1
let g:unite_source_history_yank_enable = 1
let g:unite_source_file_mru_limit = 400     "最大数
let g:unite_winheight = 20
let g:unite_source_file_rec_min_cache_files = 300
let g:unite_source_file_mru_filename_format = ''

" nmap <C-J><C-U> :<C-u>UniteWithCurrentDir -buffer-name=file file buffer file_mru directory_mru bookmark<CR>
" nmap <C-J><C-J> :Unite file_mru<CR>
" nmap <C-J><C-R> :Unite -buffer-name=register register<CR>
" nmap <silent><Space>b :<C-u>UniteBookmarkAdd<CR>

"unite prefix key.
nnoremap [unite] <Nop>
nmap <C-J> [unite]

"unite general settings
"インサートモードで開始

nnoremap <silent> [unite]<C-U> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
nnoremap <silent> [unite]<C-R> :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]<C-J> :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]<C-B> :<C-u>Unite bookmark<CR>
nnoremap <silent> <Space>b :<C-u>UniteBookmarkAdd<CR>

function! s:unite_my_settings()"{{{
  " nmap <buffer> <ESC> <Plug>(unite_exit)
  " imap <buffer> jj <Plug>(unite_insert_leave)
  imap <buffer> <C-w> <Plug>(unite_delete_backward_path)
  " nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  " nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  " nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
  hi CursorLine                    guibg=#3E3D32
  hi CursorColumn                  guibg=#3E3D32
endfunction
autocmd FileType unite call s:unite_my_settings()
"}}}

function! UniteSetting()"{{{
  " 動き
  imap <buffer><C-K> <Up>
  imap <buffer><C-L> <Left>
  imap <buffer><C-H> <Right>
  imap <buffer><C-J> <Down>
  " 開き方
  " nnoremap <silent><buffer><expr><C-K> unite#do_action('split')
  " nnoremap <silent><buffer><expr><C-L> unite#do_action('vsplit')
  " inoremap <silent><buffer><expr><C-V> unite#do_action('vsplit')
  " inoremap <silent><buffer><expr><C-E> unite#do_action('split')
  nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
endfunction
au FileType unite call UniteSetting()
"}}}

"}}}

"------------------------------------
" Unite-mark.vim
"------------------------------------
"{{{
let g:unite_source_mark_marks =
      \   "abcdefghijklmnopqrstuvwxyz"
      \ . "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      \ . "0123456789.'`^<>[]{}()\""
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
autocmd BufEnter *
      \   if empty(&buftype)
      \|     noremap <silent> [unite]<C-K> :<C-u>UniteWithCursorWord -immediately tag<CR>
      \|  endif
"}}}

"------------------------------------
" VimFiler
"------------------------------------
"{{{
" 起動コマンド
" default <leader><leader>
nnoremap <Leader><leader> :VimFilerBufferDir<CR>

let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_sort_type = "filename"
let g:vimfiler_sendto = {
      \   'unzip' : 'unzip'
      \ , 'gedit' : 'gedit'
      \ }

aug VimFilerKeyMapping
  au!
  autocmd FileType vimfiler call s:vimfiler_local()

  function! s:vimfiler_local()
    if has('unix')
      " 開き方
      call vimfiler#set_execute_file('sh', 'sh')
      call vimfiler#set_execute_file('mp3', 'iTunes')
    endif

    " Unite bookmark連携
    nmap <buffer>B :<C-U>Unite bookmark<CR>
    nmap <buffer>b :<C-U>UniteBookmarkAdd<CR>
    nmap <buffer><silent><C-J>
    nmap <buffer><silent><C-J><C-J> :<C-U>Unite file_mru<CR>
    nmap <buffer><silent><C-J><C-U> :<C-U>Unite file<CR>
    nmap <buffer><silent><C-J><C-U> :<C-U>UniteWithBufferDir -buffer-name=files file<CR>

    " Unite bookmarkのアクションをVimFilerに
    call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')
  endfunction
aug END

"gitの場合、ルートディレクトリに移動
" function! s:git_root_dir()
"   if(system('git rev-parse --is-inside-work-tree') == "true\n")
"     return ':VimFiler ' . system('git rev-parse --show-cdup') . '\<CR>'
"   else
"     echoerr '!!!current directory is outside git working tree!!!'
"   endif
" endfunction

"}}}

"------------------------------------
" quickrun.vim
"------------------------------------
"{{{
"<Leader>r で、php,js,cなどのコンパイル、テスト出来る
let g:quickrun_config = {}
let g:quickrun_config._ = {'runner' : 'vimproc'}
let g:quickrun_no_default_key_mappings = 1
nmap <Leader>r <Plug>(quickrun)

" lisp
let g:quickrun_config['lisp'] = {
      \   'command': 'clisp'
      \ }

" coffee
let g:quickrun_config['coffee'] = {
      \'command' : 'coffee',
      \'exec' : ['%c -cbp %s']
      \}

" should gem install bluecloth
let markdownCss = '<link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>'
let markdownHead = '<!DOCTYPE HTML> <html lang=\"ja\"> <head> <meta charset=\"UTF-8\">'.markdownCss.'</head><body>'
let markdownFoot = "</body> </html>"
let g:quickrun_config['markdown'] = {
      \ 'command'   : 'bluecloth',
      \ 'exec'      : ["echo \'" . markdownHead. "'", '%c  %s', "echo \'" . markdownFoot. "'"],
      \ 'outputter' : 'browser',
      \ }

" ruby
let g:quickrun_config['ruby'] = {
      \   'command': 'ruby'
      \ }

" Rspec
let g:quickrun_config['ruby.rspec'] = {
      \ 'type' : 'ruby.rspec',
      \ 'command': 'rspec',
      \ 'exec': 'bundle exec %c %o %s',
      \ 'outputter' : 'rspec_outputter'
      \}

let rspec_outputter = quickrun#outputter#buffer#new()
function! rspec_outputter.init(session)
  call call(quickrun#outputter#buffer#new().init, [a:session], self)
endfunction

" syntax color
function! rspec_outputter.finish(session)
  " 文字に色をつける。
  highlight default RSpecGreen   ctermfg=White ctermbg=Green guifg=White guibg=Green
  highlight default RSpecRed     ctermfg=White ctermbg=Red   guifg=White guibg=Red

  call matchadd("RSpecGreen", "^[\.F]*\.[\.F]*$")
  call matchadd("RSpecGreen", "^.*, 0 failures$")
  call matchadd("RSpecRed", "F")
  call matchadd("RSpecRed", "^.*, [1-9]* failures.*$")
  call matchadd("RSpecRed", "^.*, 1 failure.*$")
  call matchadd("RSpecRed", "^ *(.*$")
  call matchadd("RSpecRed", "^ *expected.*$")
  call matchadd("RSpecRed", "^ *got.*$")
  call matchadd("RSpecRed", "Failure/Error:.*$")
  call matchadd("RSpecRed", "^.*(FAILED - [0-9]*)$")
  call matchadd("NonText", "Failures:")
  call matchadd("NonText", "Finished")
  call matchadd("NonText", "Failed")
  call call(quickrun#outputter#buffer#new().finish,  [a:session], self)
endfunction
call quickrun#register_outputter("rspec_outputter", rspec_outputter)

" ファイル名が_spec.rbで終わるファイルを読み込んだ時に上記の設定を自動で読み込む
function! RSpecQuickrun()
  nmap <silent><buffer><Leader>lr :<C-U>QuickRun ruby.rspec.oneline<CR>
  let b:quickrun_config = {'type' : 'ruby.rspec'}
  " nnoremap <silent><buffer><Leader>lr :QuickRun ruby.rspec line('.')<CR>
  nnoremap <expr><silent><buffer><Leader>lr "<Esc>:QuickRun ruby.rspec -cmdopt \"-l" .  line('.') . "\"<CR>"
endfunction
au BufReadPost *_spec.rb call RSpecQuickrun()

"javascriptの実行をnode.jsで
let $JS_CMD='node'
"}}}

"------------------------------------
" toggle.vim
"------------------------------------
"{{{
"<C-T>で、true<->falseなど切り替えられる
" imap <C-D> <Plug>ToggleI
" nmap <C-D> <Plug>ToggleN
" vmap <C-D> <Plug>ToggleV
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
" nmap rt :Ref timobileref<Space>
"}}}

"----------------------------------------
" zencoding
"----------------------------------------
"{{{
" codaのデフォルトと一緒にする
imap <C-E> <C-Y>,
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
" let g:ref_no_default_key_mappings = 'K'
let g:ref_open                    = 'split'
let g:ref_cache_dir               = expand('~/.Trash')
let g:ref_refe_cmd               = expand('~/.vim/ref/ruby-ref1.9.2/refe-1_9_2')
let g:ref_phpmanual_path          = expand('~/.vim/ref/php-chunked-xhtml')
let g:ref_ri_cmd                  = expand('~/.rbenv/versions/1.9.3-p125/bin/ri')

"リファレンスを簡単に見れる。
" nmap K <Nop>

nmap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
autocmd FileType ruby,eruby,ruby.rspec nmap <silent><buffer>KK :<C-u>Unite -no-start-insert ref/ri -input=<C-R><C-W><CR>
autocmd FileType ruby,eruby,ruby.rspec nmap <silent><buffer>K :<C-u>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>

" refビューワー内の設定
" vim-ref内の移動を楽に
function! s:initialize_ref_viewer()
  nmap <buffer><CR> <Plug>(ref-keyword)
  nmap <buffer>th  <Plug>(ref-back)
  nmap <buffer>tl  <Plug>(ref-forward)
  " nmap <buffer> q<C-w>c
  nmap <buffer>q :q!<CR>
  setlocal nonumber
endfunction
autocmd FileType ref call s:initialize_ref_viewer()

"alc
nmap ra :<C-U>Ref alc<Space>
nmap rp :<C-U>Ref phpmanual<Space>
" nmap rr :<C-U>Ref refe<Space>
" nmap ri :<C-U>Ref ri<Space>
nmap rr :<C-U>Unite ref/refe -input=
nmap ri :<C-U>Unite ref/ri -input=
nmap rm :<C-U>Unite ref/man -input=
nmap rpy :<C-U>Unite ref/pydoc -input=
nmap rpe :<C-U>Unite ref/perldoc -input=

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
" nmap <Space>gd :<C-U>Gdiff<CR>
" nmap <Space>gs :<C-U>Gstatus<CR>
" nmap <Space>gl :<C-U>Glog<CR>
" nmap <Space>ga :<C-U>Gwrite<CR>
nmap <Space>gm :<C-U>Gcommit<CR>
nmap <Space>gM :<C-U>Git commit --amend<CR>
nmap <Space>gb :<C-U>Gblame<CR>
nmap <Space>gg :<C-U>Ggrep<Space>
au FileType fugitiveblame vertical res 25
"}}}

"----------------------------------------
" vim-git
"----------------------------------------
" "{{{
" "vim上からgitを使う 便利
let g:git_no_default_mappings = 1
let g:git_use_vimproc = 1
let g:git_command_edit = 'rightbelow vnew'
" nmap <silent><Space>gb :GitBlame<CR>
" nmap <silent><Space>gB :Gitblanch
" nmap <silent><Space>gp :GitPush<CR>
nmap <silent><Space>gd :GitDiff --cached<CR>
" nmap <silent><Space>gD :GitDiff<CR>
" " nmap <silent><Space>gs :GitStatus<CR>
" " nmap <silent><Space>gl :GitLog -10<CR>
" " nmap <silent><Space>gL :<C-u>GitLog -u \| head -10000<CR>
nmap <silent><Space>ga :GitAdd<CR>
" nmap <silent><Space>gA :<C-u>GitAdd <cfile><CR>
" nmap <silent><Space>gm :GitCommit<CR>
" nmap <silent><Space>gM :GitCommit --amend<CR>
nmap <silent><Space>gp :Git push<Space>
" nmap <silent><Space>gt :Git tag<Space>
" "}}}

"----------------------------------------
" unite-giti
"----------------------------------------
"{{{
nmap <silent><Space>gl :Unite giti/log<CR>
nmap <silent><Space>gs :Unite giti/status<CR>
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
" nmap dw d,w

nmap diw di,w
nmap dib di,b
nmap die di,e

" nmap viw vi,w
" nmap vib vi,b
" nmap vie vi,e

nmap ciw ci,w
nmap cib ci,b
nmap cie ci,e

nmap daw da,w
nmap dab da,b
nmap dae da,e

" text-objectで使用できるように
omap <silent> iw <Plug>CamelCaseMotion_iw
xmap <silent> iw <Plug>CamelCaseMotion_iw
omap <silent> ib <Plug>CamelCaseMotion_ib
xmap <silent> ib <Plug>CamelCaseMotion_ib
omap <silent> ie <Plug>CamelCaseMotion_ie
xmap <silent> ie <Plug>CamelCaseMotion_ie
"}}}

"------------------------------------
" matchit.zip
"------------------------------------
"{{{
" % での移動出来るタグを増やす
let b:match_words = '<div.*>:</div>,<ul.*>:</ul>,<li.*>:</li>,<head.*>:</head>,<a.*>:</a>,<p.*>:</p>,<form.*>:</form>,<span.*>:</span>,<iflame.*>:</iflame>:<if>:<endif>,<while>:<endwhile>,<foreach>:<endforeach>'

let b:match_ignorecase = 1
" let b:match_debug = ?
" let b:match_skip
"}}}

"------------------------------------
" powerline
"------------------------------------
"{{{
">の形をを許可する
"ちゃんと/.vim/fontsのfontを入れていないと動かないよ
"set guifont=Ricty_for_Powerline:h10
set guifontwide=Ricty:h10
let g:Powerline_symbols = 'fancy'
"let g:Powerline_symbols = 'compatible'
"}}}

"------------------------------------
" vimshell
"------------------------------------
"{{{
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

autocmd FileType vimshell call s:vimshell_settings()
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
    VimShellAlterCommand df df -h
    VimShellAlterCommand diff diff --unified
    VimShellAlterCommand du du -h
    VimShellAlterCommand free free -m -l -t
    VimShellAlterCommand j jobs -l
    VimShellAlterCommand jobs jobs -l
    " VimShellAlterCommand l. ls -d .*
    " VimShellAlterCommand l ls -lh
    VimShellAlterCommand ll ls -lh
    VimShellAlterCommand la ls -A
    VimShellAlterCommand less less -r
    VimShellAlterCommand sc screen
    VimShellAlterCommand whi which
    VimShellAlterCommand whe where
    VimShellAlterCommand go gopen
    VimShellAlterCommand termtter iexe termtter
    VimShellAlterCommand sudo iexe sudo

    call vimshell#set_alias('l.', 'ls -d .*')

    " Abbrev
    inoreabbrev <buffer> l@ <Bar> less
    inoreabbrev <buffer> g@ <Bar> grep
    inoreabbrev <buffer> p@ <Bar> perl
    inoreabbrev <buffer> s@ <Bar> sort
    inoreabbrev <buffer> u@ <Bar> sort -u
    inoreabbrev <buffer> c@ <Bar> xsel --input --clipboard
    inoreabbrev <buffer> x@ <Bar> xargs --no-run-if-empty
    inoreabbrev <buffer> n@ >/dev/null 2>/dev/null
    inoreabbrev <buffer> e@ 2>&1
    inoreabbrev <buffer> h@ --help 2>&1 <Bar> less
    inoreabbrev <buffer> H@ --help 2>&1

    if executable('perldocjp')
        VimShellAlterCommand perldoc perldocjp
    endif

    let less_sh = s:globpath(&rtp, 'macros/less.sh')
    if !empty(less_sh)
        call vimshell#altercmd#define('vless', less_sh[0])
    endif

    " Hook
    function! s:chpwd_ls(args, context)
        call vimshell#execute('ls')
    endfunction
    call vimshell#hook#set('chpwd', [s:SNR('chpwd_ls')])

    " Add/Remove some mappings.
    " unmap [n] -buffer <C-n>
    " Unmap [n] -buffer <C-p>
    " Unmap [i] -buffer <C-k>
    " Map [i] -buffer -force <C-l> <Space><Bar><Space>
    " Unmap [i] -buffer <Tab>
    " Map [i] -remap -buffer -force <Tab><Tab> <Plug>(vimshell_command_complete)

    " Misc.
    " setlocal backspace-=eol
    setlocal updatetime=1000

    NeoComplCacheEnable
endfunction "}}}

nmap <Leader>v :VimShell<CR>
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
map <Space>mn  :MemoNew<CR>
" map <Space>ml  :MemoList<CR>
nmap <silent> <Space>ml :Unite file:<C-r>=g:memolist_path."/"<CR><CR>
map <Space>mg  :MemoGrep<CR>
"}}}

"------------------------------------
" coffee script
"------------------------------------
"{{{
" 保存するたびに、コンパイル
autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!
"}}}

"------------------------------------
" browsereload-mac
"------------------------------------
"{{{
" リロード後に戻ってくるアプリ
let g:returnApp = "iTerm"
nmap <Space>bc :ChromeReloadStart<CR>
nmap <Space>bC :ChromeReloadStop<CR>
nmap <Space>bf :FirefoxReloadStart<CR>
nmap <Space>bF :FirefoxReloadStop<CR>
nmap <Space>bs :SafariReloadStart<CR>
nmap <Space>bS :SafariReloadStop<CR>
nmap <Space>bo :OperaReloadStart<CR>
nmap <Space>bO :OperaReloadStop<CR>
nmap <Space>ba :AllBrowserReloadStart<CR>
nmap <Space>bA :AllBrowserReloadStop<CR>
"}}}

"------------------------------------
" t_comment
"------------------------------------
" let g:tcommentMapLeader1 = "<C-_>""{{{
" mappingを消費するので、段々デフォルトになれるべし。
" nmap <Leader>x <C-_><C-_>
" nmap <Leader>b <C-_>p
" vmap <Leader>x <C-_><C-_>

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
  nmap <buffer> <C-_>c :TCommentAs eruby_surround<CR><Right><Right><Right>
  nmap <buffer> <C-_><C-C> :TCommentAs eruby_surround<CR><Right><Right><Right>
  nmap <buffer> <C-_>- :TCommentAs eruby_surround_minus<CR><Right><Right><Right>
  nmap <buffer> <C-_>= :TCommentAs eruby_surround_equality<CR><Right><Right><Right><Right>
  nmap <buffer> <C-_>d :TCommentAs eruby_block<CR><Right><Right><Right><Right>
  nmap <buffer> <C-_>n :TCommentAs eruby_nodoc_block<CR><Right><Right><Right><Right>

  imap <buffer> <C-_>c <%  %><ESC><Left><Left>i
  imap <buffer> <C-_><C-C> <%  %><ESC><Left><Left>i
  imap <buffer> <C-_>- <%  -%><ESC><Left><Left><Left>i
  imap <buffer> <C-_>= <%=  %><ESC><Left><Left>i
  imap <buffer> <C-_>d <%=begin rdoc=end%><ESC><Left><Left>i
  imap <buffer> <C-_>n <%=begin=end%><ESC><Left><Left>i

  vmap <buffer> <C-_>c :TCommentAs eruby_surround<CR>
  vmap <buffer> <C-_><C-C> :TCommentAs eruby_surround<CR>
  vmap <buffer> <C-_>- :TCommentAs eruby_surround_minus<CR>
  vmap <buffer> <C-_>= :TCommentAs eruby_surround_equality<CR>
  nmap <buffer> <C-j>c :TCommentAs eruby_surround<CR><Right><Right><Right>
  nmap <buffer> <C-j><C-C> :TCommentAs eruby_surround<CR><Right><Right><Right>
  nmap <buffer> <C-j>- :TCommentAs eruby_surround_minus<CR><Right><Right><Right>
  nmap <buffer> <C-j>= :TCommentAs eruby_surround_equality<CR><Right><Right><Right><Right>
  nmap <buffer> <C-j>d :TCommentAs eruby_block<CR><Right><Right><Right><Right>
  nmap <buffer> <C-j>n :TCommentAs eruby_nodoc_block<CR><Right><Right><Right><Right>
  imap <buffer> <C-j>c <%  %><ESC><Left><Left>i
  imap <buffer> <C-j><C-C> <%  %><ESC><Left><Left>i
  imap <buffer> <C-j>- <%  -%><ESC><Left><Left><Left>i
  imap <buffer> <C-j>= <%=  %><ESC><Left><Left>i
  imap <buffer> <C-j>d <%=begin rdoc=end%><ESC><Left><Left>i
  imap <buffer> <C-j>n <%=begin=end%><ESC><Left><Left>i
  vmap <buffer> <C-j>c :TCommentAs eruby_surround<CR>
  vmap <buffer> <C-j><C-C> :TCommentAs eruby_surround<CR>
  vmap <buffer> <C-j>- :TCommentAs eruby_surround_minus<CR>
  vmap <buffer> <C-j>= :TCommentAs eruby_surround_equality<CR>
endfunction
function! SetRubyMapping()
  nmap <buffer> <C-j>b :TCommentAs ruby_block<CR><Right><Right><Right><Right>
  nmap <buffer> <C-j>n :TCommentAs ruby_nodoc_block<CR><Right><Right><Right><Right>
  imap <buffer> <C-j>b <%=begin rdoc=end%><ESC><Left><Left>i
  imap <buffer> <C-j>n <%=begin=end%><ESC><Left><Left>i
  nmap <buffer> <C-_>b :TCommentAs ruby_block<CR><Right><Right><Right><Right>
  nmap <buffer> <C-_>n :TCommentAs ruby_nodoc_block<CR><Right><Right><Right><Right>
  imap <buffer> <C-_>b <%=begin rdoc=end%><ESC><Left><Left>i
  imap <buffer> <C-_>n <%=begin=end%><ESC><Left><Left>i
endfunction
"}}}

au FileType eruby call SetErubyMapping2()
au FileType ruby,ruby.rspec call SetRubyMapping()
au FileType php nmap <buffer><C-_>c :TCommentAs php_surround<CR><Right><Right><Right>
au FileType php vmap <buffer><C-_>c :TCommentAs php_surround<CR><Right><Right><Right>

"}}}

"------------------------------------
" ctrlp
"------------------------------------
" ctrlp"{{{
let g:ctrlp_map = '<Nul>'
let g:ctrlp_regexp = 1
let g:ctrlp_tabpage_position = 'al'
let g:ctrlp_clear_cache_on_exit = 0
let g:ctrlp_custom_ignore = {
      \ 'dir':  '\.\(hg\|git\|sass-cache\|svn\)$',
      \ 'file': '\.\(dll\|exe\|gif\|jpg\|png\|psd\|so\|woff\)$' }
let g:ctrlp_open_new_file = 't'
let g:ctrlp_open_multiple_files = 'tj'
let g:ctrlp_lazy_update = 1

let g:ctrlp_mruf_max = 1000
let g:ctrlp_mruf_exclude = '\(\\\|/\)\(Temp\|Downloads\)\(\\\|/\)\|\(\\\|/\)\.\(hg\|git\|svn\|sass-cache\)'
let g:ctrlp_mruf_case_sensitive = 0
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

nnoremap <C-H><C-B> :CtrlPBuffer<Return>
nnoremap <C-H><C-D> :CtrlPClearCache<Return>:CtrlP ~/Dropbox/Drafts<Return>
nnoremap <C-H><C-G> :CtrlPClearCache<Return>:call <SID>CallCtrlPBasedOnGitStatus()<Return>
"}}}

"------------------------------------
" vim-ruby
"------------------------------------
"{{{
" function! s:vimRuby()
"   " let g:rubycomplete_buffer_loading = 1
"   let g:rubycomplete_classes_in_global = 0
"   let g:rubycomplete_rails = 0
" endfunction
" au FileType ruby,eruby,ruby.rspec call s:vimRuby()
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
" let g:rails_ctags_arguments = ''
function! SetUpRailsSetting()
  nmap <buffer><C-C> <Nop>
  imap <buffer><C-C> <Nop>
  map <buffer><C-_><C-C> <Nop>

  nmap <buffer><Space>r :R<CR>
  nmap <buffer><Space>a :A<CR>
  nmap <buffer><Space>m :Rmodel<Space>
  nmap <buffer><Space>c :Rcontroller<Space>
  nmap <buffer><Space>v :Rview<Space>
  nmap <buffer><Space>s :Rspec<Space>
  nmap <buffer><Space>m :Rgen model<Space>
  nmap <buffer><Space>c :Rgen contoller<Space>
  nmap <buffer><Space>s :Rgen scaffold<Space>
  nmap <buffer><Space>p :Rpreview<CR>
endfunction
autocmd User Rails call SetUpRailsSetting()
"}}}

"------------------------------------
" vim-rsense
"------------------------------------
"{{{
" Rsense
let g:rsenseUseOmniFunc = 1
let g:rsenseHome = expand('~/.vim/ref/rsense-0.3')
let g:rsenseMatchFunc = "[a-zA-Z_?]"

function! SetUpRubySetting()
  nmap <buffer>tj :RSenseJumpToDefinition<CR>
  nmap <buffer>tk :RSenseWhereIs<CR>
  nmap <buffer>td :RSenseTypeHelp<CR>
endfunction
autocmd FileType ruby,eruby,ruby.rspec call SetUpRubySetting()
"}}}

"------------------------------------
" gist.vim
"------------------------------------
"{{{
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:gist_browser_command = 'w3m %URL%'
let g:github_user = 'taichouchou'

nnoremap <C-H>g :Gist<CR>
nnoremap <C-H>gp :Gist -p<CR>
nnoremap <C-H>ge :Gist -e<CR>
nnoremap <C-H>gd :Gist -d<CR>
nnoremap <C-H>gl :Gist -l<CR>
"}}}

"------------------------------------
" twitvim
"------------------------------------
"{{{
nnoremap <silent><C-H><C-N>  :Unite tweetvim<CR>
nnoremap <silent><C-H><C-M>  :TweetVimSay<CR>

" you can display tweet's source.
let g:tweetvim_display_source = 1
let g:tweetvim_display_time = 1
let g:tweetvim_open_buffer_cmd = 'tabnew'
"}}}

"------------------------------------
" alter
"------------------------------------
"{{{
"specの設定
" au User Rails nmap <buffer><Space>s <Plug>(altr-forward)
" au User Rails nmap <buffer><Space>s <Plug>(altr-back)

" call altr#define('%.rb', 'spec/%_spec.rb')
" " For rails tdd
" call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
" call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
" call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')
"}}}

"------------------------------------
" php indent
"------------------------------------
"{{{
" let g:PHP_autoformatcomment = 1
" let g:PHP_outdentSLComments = N
" let g:PHP_default_indenting = 1
" let g:PHP_outdentphpescape = 1
" let g:PHP_removeCRwhenUnix = 1
" let g:PHP_BracesAtCodeLevel = 1
" let g:PHP_vintage_case_default_indent = 1
"
"}}}

"------------------------------------
" php indent
"------------------------------------
let g:sh_indent_case_labels=1

"------------------------------------
" neocomplcache-snippets
"------------------------------------
au FileType snippet nmap <buffer><Space>e :e #<CR>

" nmap <C-H><C-H><C-R> :<C-U>CompassCreate<CR>
" nmap <C-H><C-H><C-B> :<C-U>BourbonInstall<CR>

"------------------------------------
" sass
"------------------------------------
""{{{
let g:sass_compile_aftercmd = ""
let g:sass_compile_auto = 1
let g:sass_compile_beforecmd = ""
let g:sass_compile_cdloop = 5
let g:sass_compile_cssdir = ['css', 'stylesheet']
let g:sass_compile_file = ['scss', 'sass']
let g:sass_started_dirs = []
" function! Sass_start()
"   let current_dir = expand('%:p:h')
"   if match(g:sass_started_dirs, '^'.current_dir.'$') == -1
"     call add(g:sass_started_dirs, current_dir)
"     call system('sass --watch ' . current_dir . ' &')
"   endif
" endfunction
" au! BufRead *.scss,*sass call Sass_start()
" au! Filetype scss,sass call Sass_start()

au! BufWritePost sass,scss SassCompile
"}}}

"------------------------------------
" im_controll.vim
"------------------------------------
"{{{
" 「日本語入力固定モード」切替キー
" inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>
" PythonによるIBus制御指定
" let IM_CtrlIBusPython = 1
"}}}

"------------------------------------
" jasmine.vim
"------------------------------------
"{{{
function! JasmineSetting()
  au BufRead,BufNewFile *Helper.js,*Spec.js  set filetype=jasmine.javascript
  au BufRead,BufNewFile,BufReadPre *.coffee   set filetype=coffee
  au BufRead,BufNewFile *Helper.coffee,*Spec.coffee  set filetype=jasmine.coffee
  au BufRead,BufNewFile,BufReadPre *Helper.coffee,*Spec.coffee  let b:quickrun_config = {'type' : 'coffee'}
  map <buffer> <leader>m :JasmineRedGreen<CR>
  call jasmine#load_snippets()
  command! JasmineRedGreen :call jasmine#redgreen()
  command! JasmineMake :call jasmine#make()
endfunction
au BufRead,BufNewFile,BufReadPre *.coffee,*.js call JasmineSetting()
"}}}

"------------------------------------
" Pydiction
"------------------------------------
"let g:pydiction_location = '~/.vim/bundle/pydiction/complete-dict'

"------------------------------------
" cascading.vim
"------------------------------------
"--でメソッドチェーンを整形 $this->aa()->bb()->
"nmap <Leader>c :Cascading<CR>

"------------------------------------
" YankRing.vim
"------------------------------------
" Yankの履歴参照"{{{
nmap <Leader>y :YRShow<CR>

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
map <Leader>u <Plug>(operator-camelize)
map <Leader>U <Plug>(operator-decamelize)

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

if g:smartchr_enable == 1
  inoremap <expr> , smartchr#one_of(', ', ',')
  inoremap <expr> ? smartchr#one_of('?', '? ')
  " Smart =.
  " inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
  "       \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
  "       \ : smartchr#one_of(' = ', '=', ' == ')
  augroup MyAutoCmd
    " Substitute .. into -> .
    autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
    autocmd FileType perl,php imap <buffer> <expr> . smartchr#loop(' . ', '->', '.')
    autocmd FileType perl,php imap <buffer> <expr> - smartchr#loop('-', '->')
    autocmd FileType vim imap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')

    autocmd FileType haskell,int-ghci
          \ inoremap <buffer> <expr> + smartchr#loop('+', ' ++ ')
          \| inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
          \| inoremap <buffer> <expr> $ smartchr#loop(' $ ', '$')
          \| inoremap <buffer> <expr> \ smartchr#loop('\ ', '\')
          \| inoremap <buffer> <expr> : smartchr#loop(':', ' :: ', ' : ')
          \| inoremap <buffer> <expr> . smartchr#loop('.', ' . ', '..')

    autocmd FileType scala
          \ inoremap <buffer> <expr> - smartchr#loop('-', ' -> ', ' <- ')
          \| inoremap <buffer> <expr> = smartchr#loop(' = ', '=', ' => ')
          \| inoremap <buffer> <expr> : smartchr#loop(': ', ':', ' :: ')
          \| inoremap <buffer> <expr> . smartchr#loop('.', ' => ')

    autocmd FileType eruby
          \ inoremap <buffer> <expr> > smartchr#loop('>', '%>')
          \| inoremap <buffer> <expr> < smartchr#loop('<', '<%', '<%=')
  augroup END
endif
"}}}

"------------------------------------
" Srcexp
"------------------------------------
" [Srcexpl] tagsを利用したソースコード閲覧・移動補助機能"{{{
let g:SrcExpl_UpdateTags    = 0         " tagsをsrcexpl起動時に自動で作成（更新）
let g:SrcExpl_RefreshTime   = 0         " 自動表示するまでの時間(0:off)
let g:SrcExpl_WinHeight     = 2         " プレビューウインドウの高さ
let g:SrcExpl_gobackKey = "<SPACE>"
let g:SrcExpl_jumpKey = "<ENTER>"
" let g:SrcExpl_searchLocalDef = 1
" let g:SrcExpl_isUpdateTags = 0
" let g:SrcExpl_updateTagsKey = "<C-H><C-U>"
let g:SrcExpl_RefreshMapKey = "<C-S>"   " 手動表示のMAP
let g:SrcExpl_GoBackMapKey  = "<C-Q>"   " 戻る機能のMAP
" let g:SrcExpl_updateTagsCmd = "jctags -R"

" Source Explorerの機能ON/OFF
nmap <C-H><C-E> :SrcExplToggle<CR>
"}}}

"------------------------------------
" The Nerd Tree
"------------------------------------
"{{{
"プロジェクト管理用ファイラー？
"自動起動
" autocmd FileType * NERDTreeToggle

"閉じる<->開くのキーマップ
nmap <C-H><C-F> :NERDTreeToggle<CR>

function! NerdSetting()
  nmap <buffer>l o
  nmap <buffer>h x
  " autocmd WinLeave * NERDTreeClose " nerdtreeから離れたら閉じる

  "画面が残り一つになったら自動で閉じる
  autocmd bufEnter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif
endfunction
au FileType nerdtree call NerdSetting()

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
      \ 'active_filetypes'  : ['ruby', 'php', 'js', 'javascript', 'scss', 'less' ],
      \ 'passive_filetypes' : ['puppet', 'html']
      \}
" let g:syntastic_mode_map = {
"   \ 'mode'              : 'active',
"   \ 'active_filetypes'  : [],
"   \ 'passive_filetypes' : ['html']
" \}

" let g:syntastic_ruby_checker = "mri"
"}}}

"------------------------------------
" jslint
"------------------------------------
" javascriptファイルのsyntaxエラーをハイライトする
let g:JSLintHighlightErrorLine = 0

"------------------------------------
" vimrepress
"------------------------------------
"{{{
" nmap <Space>bl :BlogList<CR>
" nmap <Space>bn :BlogNew<CR>
" nmap <Space>bs :BlogSave<CR>
" nmap <Space>bp :BlogPreview<CR>
" nmap <Space>bo :BlogOpen<CR>
" nmap <Space>bw :BlogSwitch<CR>
" nmap <Space>bu :BlogUpload<CR>
" nmap <Space>bc :BlogCode<CR>
"}}}

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
  nmap <buffer><CR>        <Plug>(w3m-click)
  nmap <buffer>i           <Plug>(w3m-click)
  nmap <buffer><S-CR>      <Plug>(w3m-shift-click)
  nmap <buffer><TAB>       <Plug>(w3m-next-link)
  nmap <buffer><S-TAB>     <Plug>(w3m-prev-link)
  nmap <buffer><BS>        <Plug>(w3m-back)
  nmap <buffer>th          <Plug>(w3m-back)
  nmap <buffer>tl          <Plug>(w3m-forward)
  nmap <buffer>s           <Plug>(w3m-toggle-syntax)
  nmap <buffer>c           <Plug>(w3m-toggle-use-cookie)
  nmap <buffer>=           <Plug>(w3m-show-link)
  nmap <buffer>/           <Plug>(w3m-search-start)
  nmap <buffer>*           *<Plug>(w3m-search-end)
  nmap <buffer>#           #<Plug>(w3m-search-end)
  nmap <buffer>a           <Plug>(w3m-address-bar)
endfunction
au FileType w3m call W3mSetting()
"}}}

"------------------------------------
" Easy motion
"------------------------------------
"{{{
let g:EasyMotion_do_shade = 1
let g:EasyMotion_do_mapping = 0 " マッピングは自分で行う

nmap <silent> f      :call EasyMotion#WB(0, 0)<CR>
" nnoremap <silent> j<Tab>      :call EasyMotion#JK(0, 0)<CR>
" nnoremap <silent> N<Tab>      :call EasyMotion#Search(0, 1)<CR>
" nnoremap <silent> n<Tab>      :call EasyMotion#Search(0, 0)<CR>
" nnoremap <silent> T<Tab>      :call EasyMotion#T(0, 1)<CR>
" nmap <silent> F<Tab>      :call EasyMotion#F(0, 1)<CR>
nmap <silent> <C-S>      :call EasyMotion#F(0, 0)<CR>
"}}}

"------------------------------------
" Facebook
"------------------------------------
"{{{
let g:facebook_timezone = '+0900'
let g:facebook_access_token_file = expand('~/.fb_access_token')
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
au FileType coffee,ruby,javascript,python IndentGuidesEnable
nmap <silent><Leader>ig <Plug>IndentGuidesToggle
"}}}

"}}}

"----------------------------------------
"補完・履歴 Complete "{{{
set wildmenu                 " コマンド補完を強化
set wildchar=<tab>           " コマンド補完を開始するキー
set wildmode=longest:full,full
set history=1000             " コマンド・検索パターンの履歴数
set complete+=k,U,kspell,t,d " 補完を充実
set completeopt=menu,menuone,preview
set infercase

" FileType毎のOmni補完を設定
au FileType css                  setlocal omnifunc=csscomplete#CompleteCSS
au FileType html,markdown        setlocal omnifunc=htmlcomplete#CompleteTags
au FileType javascript           setlocal omnifunc=javascriptcomplete#CompleteJS
au FileType python               setlocal omnifunc=pythoncomplete#Complete
au FileType xml                  setlocal omnifunc=xmlcomplete#CompleteTags
au FileType php                  setlocal omnifunc=phpcomplete#CompletePHP
au FileType c                    setlocal omnifunc=ccomplete#Complete
au FileType ruby,eruby,ruby.rpec setlocal dict+=~/.vim/dict/ruby.dict
au FileType ruby.rpec            setlocal dict+=~/.vim/dict/rspec.dict
au FileType jasmine.coffee,jasmine.js setlocal dict+=~/.vim/dict/js.jasmine.dict
au FileType coffee                setlocal dict+=~/.vim/dict/coffee.dict
au FileType html,php,eruby        setlocal dict+=~/.vim/dict/html.dict
au User Rails          set dict+=~/.vim/dict/rails.dict

"----------------------------------------
" neocomplcache
" default config"{{{
let g:neocomplcache_use_vimproc=1
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_max_list = 300
" let g:neocomplcache_max_keyword_width = 40
" let g:neocomplcache_max_menu_width = 19
" let g:neocomplcache_auto_completion_start_length = 2
" let g:neocomplcache_manual_completion_start_length = 0
" let g:neocomplcache_min_keyword_length = 2
" let g:neocomplcache_min_syntax_length = 4
let g:neocomplcache_cursor_hold_i_time = 300
" let g:neocomplcache_enable_insert_char_pre = 0
" let g:neocomplcache_enable_auto_select = 1
" let g:neocomplcache_enable_auto_delimiter = 0
let g:neocomplcache_caching_limit_file_size=1000000
let g:neocomplcache_tags_caching_limit_file_size=1000000
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_ctags_program = "ctags"

" default config snippet
let g:neocomplcache_snippets_dir=expand('~/.vim/snippet')
" let g:neocomplcache_text_mode_filetypes = { 'markdown' : 1, }
let g:neocomplcache_ignore_composite_filetype_lists = {
      \ 'ruby.spec'          : 'ruby',
      \ 'javascirpt.jasmine' : 'javascript',
      \ 'coffee.jasmine'     : 'coffee',
      \ }
"}}}

" ファイルタイプ毎の辞書ファイルの場所"{{{
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default'    : '',
      \ 'java'       : $HOME.'/.vim/dict/java.dict',
      \ 'ruby'       : $HOME.'/.vim/dict/ruby.dict',
      \ 'eruby'      : $HOME.'/.vim/dict/ruby.dict',
      \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
      \ 'coffee'     : $HOME.'/.vim/dict/javascript.dict',
      \ 'lua'        : $HOME.'/.vim/dict/lua.dict',
      \ 'ocaml'      : $HOME.'/.vim/dict/ocaml.dict',
      \ 'perl'       : $HOME.'/.vim/dict/perl.dict',
      \ 'c'          : $HOME.'/.vim/dict/c.dict',
      \ 'php'        : $HOME.'/.vim/dict/php.dict',
      \ 'scheme'     : $HOME.'/.vim/dict/scheme.dict',
      \ 'vim'        : $HOME.'/.vim/dict/vim.dict',
      \ 'jasmine'    : $HOME.'/.vim/dict/js.jasmine.dict',
      \ 'timobile'   : $HOME.'/.vim/dict/timobile.dict',
      \ }

function! SetUpMarkDownSetting()
  let g:source_look_length = 3
  let g:source_look_rank = 400
endfunction
let g:source_look_length = 4
let g:source_look_rank = 5
au FileType markdown,text call SetUpMarkDownSetting()
"}}}

let g:neocomplcache_dictionary_patterns = {
      \'php': expand('~/.vim/dict/zendphp.dict'),
      \'javascript': expand('~/.vim/dict/timobile.dict'),
      \}

" Define keyword.
if !exists('g:neocomplcache_keyword_patterns')
  let g:neocomplcache_keyword_patterns = {}
endif
let g:neocomplcache_keyword_patterns['default'] = '\h\w*'

" rubyの設定
if !exists('g:neocomplcache_omni_functions')
  let g:neocomplcache_omni_functions = {}
endif
let g:neocomplcache_omni_functions.ruby = 'RSenseCompleteFunction'

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby       = '[^. *\t]\.\w*\|\h\w*::'

let g:neocomplcache_vim_completefuncs = {
      \ 'Ref' : 'ref#complete',
      \ 'Unite' : 'unite#complete_source',
      \ 'VimShellExecute' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShellInteractive' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShellTerminal' :
      \      'vimshell#vimshell_execute_complete',
      \ 'VimShell' : 'vimshell#complete',
      \ 'VimFiler' : 'vimfiler#complete',
      \ 'Vinarise' : 'vinarise#complete',
      \}

if has('conceal')
  set conceallevel=2 concealcursor=i
endif

" keymap"{{{
" Plugin key-mappings.
imap <C-F>     <Plug>(neocomplcache_snippets_expand)
smap <C-F>     <Plug>(neocomplcache_snippets_expand)
imap <C-U>     <Esc>:Unite snippet<CR>
inoremap <expr><C-g>     neocomplcache#undo_completion()
" inoremap <expr><C-L>     neocomplcache#complete_common_string()

" imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ?
"       \"\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" snippetの編集
nmap <Space>e :<C-U>NeoComplCacheEditSnippets<CR>
au FileType ruby,eruby nmap <buffer><Space>d :<C-U>e ~/.vim/dict/ruby.dict
au User Rails          nmap <buffer><Space>dd :<C-U>e ~/.vim/dict/rails.dict
au BufRead,BufNewFile *.snip  set filetype=snippet

" let g:neocomplcache_enable_auto_select = 1
inoremap <silent><expr><TAB>  pumvisible() ? "\<C-N>" : "\<TAB>"
inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-P>" : "\<S-TAB>"
inoremap <silent><expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplcache#close_popup()
" inoremap <expr><C-e>  neocomplcache#cancel_popup()
" inoremap <silent><CR>  <C-R>=neocomplcache#smart_close_popup()<CR><CR>
inoremap <silent><CR>  <CR><C-R>=neocomplcache#smart_close_popup()<CR>
" inoremap <silent><expr><CR> neocomplcache#smart_close_popup() . "\<CR>"
" inoremap <silent><expr><CR>   neocomplcache#smart_close_popup()."\<C-h>"
"}}}

"}}}

"----------------------------------------
"Tags関連 cTags使う場合は有効化"{{{
"http://vim-users.jp/2010/06/hack154/

setl tags=""
let current_dir = expand("%:p:h")

if has('path_extra')
  " setl tags=*4/tags
endif

" rtagsは独自shコマンドrtags -Rで作成
" if filereadable(expand('~/tags'))
au FileType ruby,eruby setl tags+=~/gtags
" else
  " let res = system('ctags', '-R --langmap=Ruby:.rb --ruby-typescfFm =~/.rvm/rubies/default -f ~/rtags')
"   au FileType ruby,eruby setl tags+=~/rtags
" endif


"tags_jumpを使い易くする
"「飛ぶ」
nnoremap tt  <C-]>
"「進む」
nnoremap tl  :<C-u>tag<CR>
nnoremap tk  :<C-u>tn<CR>
nnoremap tj  :<C-u>tp<CR>
"「戻る」
nnoremap th  :<C-u>pop<CR>
"履歴一覧
nnoremap ts  :<C-u>ts<CR>
" nnoremap tk  :<C-u>tags<CR>
"}}}

"----------------------------------------
"外部コマンドの実行"{{{

"----------------------------------------
" phptohtml
"----------------------------------------
au Filetype php nmap <Leader>R :! phptohtml<CR>

"----------------------------------------
" 独自関数
"----------------------------------------
function! Today()
  return strftime("%Y/%m/%d")
endfunction
inoremap <C-D><C-D> <C-R>=Today()<CR>

function! s:smart_split(cmd)
  if winwidth(0) > winheight(0) * 2
    vsplit
  else
    split
  endif

  if !empty(a:cmd)
    execute a:cmd
  endif
endfunction
command! -nargs=? -complete=command SmartSplit call <SID>smart_split(<q-args>)
nnoremap <silent><C-w><Space> :<C-u>SmartSplit<CR>

if executable('pdftotext')
  command! -complete=file -nargs=1 Pdf :r !pdftotext -nopgbrk -layout <q-args> -
endif
au BufRead *.pdf call Pdf

" カーソル下のgemのrdocを開く
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
\   -nargs=* -complete=file
\   OpenYard
\   call OpenYard(<q-args>)

" マッピング
nmap <Space>y :<C-U>OpenYard <C-R><C-W><CR>

"}}}

set secure
