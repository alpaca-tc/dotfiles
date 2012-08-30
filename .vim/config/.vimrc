"----------------------------------------
"基本"{{{
let $SHELL="/usr/local/bin/zsh"
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
set scrolloff=7
set shell=/usr/local/bin/zsh
set showcmd
set showmode
set timeout timeoutlen=400 ttimeoutlen=100
set vb t_vb=
set viminfo='100,<800,s300,\"300

autocmd FileType help nnoremap <buffer> q <C-w>c
nnoremap <Space>h :<C-u>help<Space><C-r><C-w><CR>
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
nmap x <BS>
"nmap X <Del>
imap <C-@> <BS>
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
autocmd BufWritePre * call <SID>remove_dust()

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
imap <silent><C-H> <Left>
imap <silent><C-H><C-H> <Left><Esc>I
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
nnoremap tN  :tabnew<CR>
nnoremap tc  :tabc<CR>
nnoremap to  :tabo<CR>
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
set tabstop=4
set softtabstop=4
set shiftwidth=4
if has("autocmd")
  filetype indent on
  " 無効にしたい場合
  " autocmd FileType html filetype indent off

  autocmd FileType apache     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType conf       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType aspvbs     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType c          setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cpp        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType cs         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType css        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType less,sass,scss setlocal sw=2 sts=2 ts=2 et
  autocmd FileType diff       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType eruby      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType html       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType java       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType javascript setlocal sw=2 sts=2 ts=2 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType haml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType sql        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vb         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType vim        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType wsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xhtml      setlocal sw=4 sts=4 ts=4 et
  autocmd FileType xml        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType yaml       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType zsh        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType coffee     setlocal sw=2 sts=2 ts=2 et
endif
autocmd InsertLeave * set nopaste
"}}}

"----------------------------------------
"表示"{{{
set showmatch         " 括弧の対応をハイライト
set number            " 行番号表示
set list              " 不可視文字表示
"set listchars=tab:,trail:,extends:,precedes:  " 不可視文字の表示形式
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
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
set foldmethod=marker "{{ { という感じの文字が入る
" set foldmethod=manual "手動
"set foldmethod=indent "indent

"画面サイズの変更
"現在のウィンドウ高を減らす
"nnoremap c <C-W>-
"現在のウィンドウ幅を減らす
"nnoremap C <C-W>+

"現在のウィンドウ幅を増やす
"nnoremap b <C-W><
"現在のウィンドウ幅を減らす
"nnoremap B <C-W>>

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
  set runtimepath+=~/.vim/runtime/neobundle.vim
  call neobundle#rc(expand('~/.bundle/'))
endif

"bundle"{{{
"----------------------------------------
"vim基本機能拡張"{{{
" NeoBundle 'Shougo/neobundle'

NeoBundle 'Shougo/vimproc'
NeoBundle 'yuroyoro/vimdoc_ja'
NeoBundle 'grep.vim'
NeoBundle 'smartword'
NeoBundle 'camelcasemotion'
NeoBundle 'Lokaltog/vim-powerline'
NeoBundle 'edsono/vim-matchit'
NeoBundle 'taichouchou2/surround.vim' " 独自の実装のものを使用、ruby用カスタマイズ、<C-G>のimap削除
" NeoBundle 'yuroyoro/vim-autoclose'                          " 自動閉じタグ
NeoBundle 'taichouchou2/alpaca'       " 個人的なカラーやフォントなど
NeoBundle 'h1mesuke/vim-alignta'
NeoBundle 'kana/vim-arpeggio'         " 同時押しキーマップを使う
NeoBundle 'othree/eregex.vim'         " %S 正規表現を拡張
NeoBundle 'vim-scripts/SearchComplete' " /で検索をかけるときでも\tで補完が出来る

"}}}

"----------------------------------------
" vim拡張"{{{
NeoBundle 'Shougo/neocomplcache'
NeoBundle 'Shougo/neocomplcache-snippets-complete'
NeoBundle 'Shougo/vimshell'
NeoBundle 'ujihisa/neco-look'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
NeoBundle 'thinca/vim-quickrun' "<Leader>rで簡易コンパイル
" NeoBundle 'taku-o/vim-toggle' "true<=>false など、逆の意味のキーワードを切り替えられる
NeoBundle 'mattn/zencoding-vim' "Zencodingを使う
NeoBundle 'nathanaelkane/vim-indent-guides' "indentに色づけ
NeoBundle 'kien/ctrlp.vim' "ファイルを絞る
NeoBundle 'scrooloose/nerdtree' "プロジェクト管理用 tree filer
NeoBundle 'vim-scripts/sudo.vim' "vimで開いた後にsudoで保存
NeoBundle 'tpope/vim-endwise.git' "end endifなどを自動で挿入

NeoBundle 'taglist.vim' "関数、変数を画面横にリストで表示する
" NeoBundle 'majutsushi/tagbar'

"コメントアウト
" NeoBundle 'hrp/EnhancedCommentify'
NeoBundle 'tomtom/tcomment_vim'

"ヤンクの履歴を管理し、順々に参照、出力できるようにする
" NeoBundle 'YankRing.vim'

"/で検索をかけるときでも\tで補完が出来る
" NeoBundle 'vim-scripts/SearchComplete'

"関連するファイルを切り替えれる
NeoBundle 'kana/vim-altr'

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

"gitをvim内から操作する
NeoBundle 'tpope/vim-fugitive'
NeoBundle 'Shougo/git-vim'
NeoBundle 'mattn/gist-vim' "gistを利用する

"保存と同時にブラウザをリロードする
" NeoBundle 'tell-k/vim-browsereload-mac'

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
" NeoBundle 'kana/vim-smartchr' "smartchr.vim : ==()などの前後を整形

NeoBundle 'mattn/webapi-vim' "vim Interface to Web API
NeoBundle 'tyru/urilib.vim' "urilib.vim : vim scriptからURLを扱うライブラリ
" NeoBundle 'cecutil' "cecutil.vim : 他のpluginのためのutillity1

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
" NeoBundle 'oppara/vim-unite-cake'
" NeoBundle 'choplin/unite-vim_hacks'
" NeoBundle 'ujihisa/unite-colorscheme'

NeoBundle 'basyura/TweetVim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/bitly.vim'
"}}}

" bundle.lang"{{{
function! HtmlSetting()
  NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
  NeoBundle 'hail2u/vim-css3-syntax'
  NeoBundle 'jQuery'
  NeoBundle 'taichouchou2/html5.vim'
  NeoBundle 'tpope/vim-haml'
  NeoBundleLazy 'xmledit'
endfunction
" au FileType html,php,eruby,ruby,javascript,markdown call HtmlSetting()
au FileType * call HtmlSetting()

"  js / coffee
" ----------------------------------------
function! JsSetting()
  NeoBundle 'kchmck/vim-coffee-script'
  NeoBundle 'claco/jasmine.vim'
  NeoBundle 'pangloss/vim-javascript' " syntaxが無駄に入っているので、インストール後削除
  NeoBundle 'hallettj/jslint.vim'
  NeoBundle 'JavaScript-syntax'
  NeoBundleLazy 'pekepeke/titanium-vim' " Titaniumを使うときに
endfunction
au FileType js,coffee call JsSetting()

"  markdown
" ----------------------------------------
" markdownでの入力をリアルタイムでチェック
function! MarkdownSetting()
  NeoBundle 'mattn/mkdpreview-vim'
  NeoBundle 'tpope/vim-markdown'
endfunction
au FileType markdown call MarkdownSetting()

" sassのコンパイル
function! SassSetting()
  NeoBundle 'AtsushiM/sass-compile.vim'
endfunction
au FileType sass,scss call MarkdownSetting()

"  php
" ----------------------------------------
function! PhpSetting()
  NeoBundle 'oppara/vim-unite-cake'
  NeoBundleLazy 'violetyk/cake.vim' " cakephpを使いやすく
endfunction
au FileType php,phtml call PhpSetting()

"  binary
" ----------------------------------------
NeoBundleLazy 'Shougo/vinarise'

" objective-c
" ----------------------------------------
function! ObjcSetting()
  NeoBundle 'msanders/cocoa.vim'
endfunction
" au FileType c,m,h,objectivec call ObjcSetting()
" au FileType * call ObjcSetting()

" ruby
" ----------------------------------------
function! RubySetting()
  " NeoBundle 'ujihisa/neco-ruby'
  NeoBundle 'basyura/unite-rails'
  NeoBundle 'github:taichouchou2/neco-rubymf' " gem install methodfinder
  NeoBundle 'github:taichouchou2/vim-rails'
  NeoBundle 'github:taichouchou2/vim-ref-ri'
  " NeoBundle 'railstab.vim'
  NeoBundle 'romanvbabenko/rails.vim' " Rfactoryメソッドなど追加
  NeoBundle 'ruby-matchit'
  NeoBundle 'sandeepravi/refactor-rails.vim' " refactor rails
  NeoBundle 'taq/vim-rspec'
  NeoBundle 'ujihisa/unite-rake'
  NeoBundle 'vim-ruby/vim-ruby'
endfunction
NeoBundle 'github:taichouchou2/vim-rsense'
au FileType eruby,ruby,erb,yml call RubySetting()

" python
" ----------------------------------------
function! PythonSetting()
  NeoBundle 'Pydiction'
  NeoBundle 'yuroyoro/vim-python'
endfunction
au FileType python call RubySetting()

" scala
" ----------------------------------------
function! ScalaSetting()
  NeoBundle 'yuroyoro/vim-scala'
endfunction
au FileType scala call RubySetting()

" SQLUtilities : SQL整形、生成ユーティリティ
NeoBundle 'SQLUtilities'

" C言語など<Leader>;で全行に;を挿入できる
" NeoBundle 'vim-scripts/teol.vim'

" shellscript indnt
NeoBundle 'sh.vim'
"}}}

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
""}}}

" ------------------------------------
" grep.vim
"------------------------------------
"{{{
" カーソル下の単語をgrepする
nnoremap <silent> <C-g><C-g> :<C-u>Rgrep<Space><C-r><C-w> *<Enter><CR>
nnoremap <C-g><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><ENTER>

" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs = '.svn .git .hg .swp'
let Grep_Skip_Files = '*.bak *~'

"qf内でファイルを開いた後画面を閉じる
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

" いろいろのせる
nnoremap <C-H><C-U> :<C-u>UniteWithCurrentDir -split -buffer-name=files buffer file_mru bookmark file<CR>

" 現在のバッファのカレントディレクトリからファイル一覧
"nnoremap <C-P><C-P> :<C-u>UniteWithBufferDir file<CR>

" バッファ一覧
"noremap <C-P> :Unite buffer<CR>

" ファイル一覧
"noremap <C-H> :Unite -buffer-name=file file<CR>

" 最近使ったファイルの一覧
noremap <C-H><C-H> :Unite file_mru<CR>

" レジスタ一覧
noremap <C-H><C-R> :Unite -buffer-name=register register<CR>

function! UniteSetting()
  " 動き
  imap <buffer><C-K> <Up>
  imap <buffer><C-L> <Left>
  imap <buffer><C-H> <Right>
  imap <buffer><C-J> <Down>
  " 開き方
  nnoremap <silent><buffer><expr><C-K> unite#do_action('split')
  nnoremap <silent><buffer><expr><C-L> unite#do_action('vsplit')
  " inoremap <silent><buffer><expr><C-V> unite#do_action('vsplit')
  " inoremap <silent><buffer><expr><C-E> unite#do_action('split')
  nnoremap <silent> <buffer> <ESC><ESC> :q<CR>
endfunction

au FileType unite call UniteSetting()

" 初期設定関数を起動する
" au FileType unite call s:unite_my_settings()
let g:unite_source_file_mru_limit = 400     "最大数
"}}}

"------------------------------------
" Unite-mark.vim
"------------------------------------
let g:unite_source_mark_marks =
      \   "abcdefghijklmnopqrstuvwxyz"
      \ . "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
      \ . "0123456789.'`^<>[]{}()\""

"------------------------------------
" Unite-mark.vim
"------------------------------------
let g:unite_source_grep_command = "grep"
let g:unite_source_grep_recursive_opt = "-R"

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
    nmap <buffer> z <C-u>:Unite bookmark<CR>
    nmap <buffer> A <C-u>:UniteBookmarkAdd<CR>

    " Unite bookmarkのアクションをVimFilerに
    call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')

    " incremental search
    nmap <buffer> ? /^\s*\(\|-\\|\|+\\|+\\|-\) \zs
  endfunction
aug END

"gitの場合、ルートディレクトリに移動
function! s:git_root_dir()
  if(system('git rev-parse --is-inside-work-tree') == "true\n")
    return ':VimFiler ' . system('git rev-parse --show-cdup') . '\<CR>'
  else
    echoerr '!!!current directory is outside git working tree!!!'
  endif
endfunction
" nmap <buffer>gg <SID>git_root_dir()

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
  " highlight default RSpecGreen   ctermfg=Green ctermbg=none guifg=Green guibg=none
  " highlight default RSpecRed     ctermfg=Red   ctermbg=none guifg=Red   guibg=none
  " highlight default RSpecComment ctermfg=Cyan  ctermbg=none guifg=Cyan  guibg=none
  " highlight default RSpecNormal  ctermfg=White ctermbg=none guifg=Black guibg=White

  " 背景に色をつける。
  highlight default RSpecGreen   ctermfg=White ctermbg=Green guifg=White guibg=Green
  highlight default RSpecRed     ctermfg=White ctermbg=Red   guifg=White guibg=Red
  " highlight default RSpecComment ctermfg=White ctermbg=Cyan  guifg=White guibg=Cyan
  " highlight default RSpecNormal  ctermfg=Black ctermbg=White guifg=Black guibg=White

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
  " call matchadd("RSpecRed", "^rspec .*:.*$")
  " call matchadd("RSpecComment", " # .*$")
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
"   zencoding
"----------------------------------------
"{{{
"<C-Y>, でzencodingを使える
let g:user_zen_leader_key = '<C-Y>'
let g:user_zen_settings = {
      \  'lang' : 'ja',
      \  'html' : {
      \    'filters' : 'html',
      \    'indentation' : ' '
      \  },
      \  'perl' : {
      \    'indentation' : '  ',
      \    'aliases' : {
      \      'req' : "require '|'"
      \    },
      \    'snippets' : {
      \      'use' : "use strict\nuse warnings\n\n",
      \      'w' : "warn \"${cursor}\";",
      \    },
      \  },
      \  'php' : {
      \    'extends' : 'html',
      \    'filters' : 'html,c',
      \  },
      \  'css' : {
      \    'filters' : 'fc',
      \  },
      \  'javascript' : {
      \    'snippets' : {
      \      'jq' : "$(function() {\n\t${cursor}${child}\n});",
      \      'jq:each' : "$.each(arr, function(index, item)\n\t${child}\n});",
      \      'fn' : "(function() {\n\t${cursor}\n})();",
      \      'tm' : "setTimeout(function() {\n\t${cursor}\n}, 100);",
      \    },
      \  },
      \ 'java' : {
      \  'indentation' : '    ',
      \  'snippets' : {
      \   'main': "public static void main(String[] args) {\n\t|\n}",
      \   'println': "System.out.println(\"|\");",
      \   'class': "public class | {\n}\n",
      \  },
      \ },
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
autocmd FileType ruby,eruby,ruby.rspec nmap <buffer>K :<C-U>Ref refe <Space><C-R><C-W><CR>
autocmd User Rails                     nmap <buffer>KK :<C-U>Ref ri <Space><C-R><C-W><CR>

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
nmap rr :<C-U>Ref refe<Space>
nmap ri :<C-U>Ref ri<Space>
nmap rm :<C-U>Unite ref/man<Space>
nmap rpy :<C-U>Unite ref/pydoc<Space>
nmap rpe :<C-U>Unite ref/perldoc<Space>

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
" nnoremap <Space>gd :<C-u>Gdiff<CR>
" nnoremap <Space>gs :<C-u>Gstatus<CR>
" nnoremap <Space>gl :<C-u>Glog<CR>
" nnoremap <Space>ga :<C-u>Gwrite<CR>
" nnoremap <Space>gm :<C-u>Gcommit<CR>
" nnoremap <Space>gM :<C-u>Git commit --amend<CR>
" nnoremap <Space>gb :<C-u>Gblame<CR>
"}}}


"----------------------------------------
" vim-git
"----------------------------------------
"{{{
"vim上からgitを使う 便利
nmap <Space>gd :GitDiff
nmap <Space>gb :GitBlame<CR>
nmap <Space>gB :Gitblanch
nmap <Space>gp :GitPush<CR>
nmap <Space>gD :GitDiff --cached<CR>
nmap <Space>gs :GitStatus<CR>
nmap <Space>gl :GitLog<CR>
nmap <Space>ga :GitAdd
nmap <Space>gA :GitAdd -A<CR>
nmap <Space>gm :GitCommit<CR>
nmap <Space>gM :GitCommit --amend<CR>
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

nmap viw vi,w
nmap vib vi,b
nmap vie vi,e

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
map <Space>ml  :MemoList<CR>
map <Space>mg  :MemoGrep<CR>
"}}}

"------------------------------------
" coffee script
"------------------------------------
" filetypeを認識させる"{{{
au BufRead,BufNewFile *.coffee  set filetype=coffee
" 保存するたびに、コンパイル
autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!
"}}}

"------------------------------------
" browsereload-mac
"------------------------------------
"{{{
" リロード後に戻ってくるアプリ
let g:returnApp = "iTerm"
nmap Bc :ChromeReloadStart<CR>
nmap BC :ChromeReloadStop<CR>
nmap Bf :FirefoxReloadStart<CR>
nmap BF :FirefoxReloadStop<CR>
nmap Bs :SafariReloadStart<CR>
nmap BS :SafariReloadStop<CR>
nmap Bo :OperaReloadStart<CR>
nmap BO :OperaReloadStop<CR>
nmap Ba :AllBrowserReloadStart<CR>
nmap BA :AllBrowserReloadStop<CR>
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
function! s:vimRuby()"{{{
  " let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_rails = 1
endfunction
au FileType ruby,eruby,ruby.rspec call s:vimRuby()
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
" let g:dbext_default_SQLITE_bin = 'mysql2'
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
  nmap <buffer><Space>gm :Rgen model<Space>
  nmap <buffer><Space>gc :Rgen contoller<Space>
  nmap <buffer><Space>gs :Rgen scaffold<Space>
  nmap <buffer><Space>p :Rpreview<CR>
  autocmd FileType css,scss,less setlocal sw=2 sts=2 ts=2 et
  au FileType ruby,eruby,ruby.rspec let g:neocomplcache_dictionary_filetype_lists = {
        \'ruby' : $HOME.'/.vim/dict/rails.dict',
        \'eruby' : $HOME.'/.vim/dict/rails.dict'
        \}
  setl dict+=~/.vim/dict/rails.dict
  setl dict+=~/.vim/dict/ruby.dict
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

function! SetUpRubySetting()
  setlocal completefunc=RSenseCompleteFunction
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
let g:tweetvim_display_time = 0
let g:tweetvim_open_buffer_cmd = 'tabnew'
"}}}

"------------------------------------
" alter
"------------------------------------
"specの設定
" au User Rails nmap <buffer><Space>s <Plug>(altr-forward)
" au User Rails nmap <buffer><Space>s <Plug>(altr-back)

" call altr#define('%.rb', 'spec/%_spec.rb')
" " For rails tdd
" call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
" call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
" call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')

"------------------------------------
" php indent
"------------------------------------
" let g:PHP_autoformatcomment = 1
" let g:PHP_outdentSLComments = N
" let g:PHP_default_indenting = 1
" let g:PHP_outdentphpescape = 1
" let g:PHP_removeCRwhenUnix = 1
" let g:PHP_BracesAtCodeLevel = 1
" let g:PHP_vintage_case_default_indent = 1
"

"------------------------------------
" php indent
"------------------------------------
let g:sh_indent_case_labels=1

"------------------------------------
" neocomplcache-snippets
"------------------------------------
au FileType snippet nmap <buffer><Space>e :e #<CR>

"------------------------------------
" neocomplcache-snippets
"------------------------------------
nmap <C-H><C-H><C-R> :<C-U>CompassCreate<CR>
nmap <C-H><C-H><C-B> :<C-U>BourbonInstall<CR>

"------------------------------------
" sass
"------------------------------------
let g:sass_compile_aftercmd = ""
let g:sass_compile_auto = 1
let g:sass_compile_beforecmd = ""
let g:sass_compile_cdloop = 5
let g:sass_compile_cssdir = ['css', 'stylesheet']
let g:sass_compile_file = ['scss', 'sass']
let g:sass_started_dirs = []
function! Sass_start()
    let current_dir = expand('%:p:h')
    if match(g:sass_started_dirs, '^'.current_dir.'$') == -1
        call add(g:sass_started_dirs, current_dir)
        call system('sass --watch ' . current_dir . ' &')
    endif
endfunction
" au! BufRead *.scss call Sass_start()

"------------------------------------
" im_controll.vim
"------------------------------------
" 「日本語入力固定モード」切替キー
inoremap <silent> <C-j> <C-r>=IMState('FixMode')<CR>
" PythonによるIBus制御指定
let IM_CtrlIBusPython = 1

"------------------------------------
" jasmine.vim
"------------------------------------
function! JasmineSetting()
  au BufRead,BufNewFile *Helper.js,*Spec.js  set filetype=jasmine.javascript
  au BufRead,BufNewFile *Helper.coffee,*Spec.coffee  set filetype=jasmine.coffee
  au BufRead,BufNewFile *Helper.coffee,*Spec.coffee  let b:quickrun_config = {'type' : 'coffee'}
  map <buffer> <leader>m :JasmineRedGreen<CR>
  call jasmine#load_snippets()
  command! JasmineRedGreen :call jasmine#redgreen()
  command! JasmineMake :call jasmine#make()
endfunction
au FileType js,coffee JasmineSetting()

"-------------------------------------------------------------------------------
" プラグインごとの設定 Plugins2
"-------------------------------------------------------------------------------
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
map <Space>u <Plug>(operator-camelize)
map <Space>U <Plug>(operator-decamelize)

"------------------------------------
" operator-replace.vim
"------------------------------------
" RwなどでYankしてるもので置き換える
" よくわからん！
"map R <Plug>(operator-replace)

"------------------------------------
" operator-comment.vim
"------------------------------------
map C  <Plug>(operator-comment)
map C  <Plug>(operator-uncomment)

"------------------------------------
" smartchr.vim
"------------------------------------
let g:smarchr_enable = 0

function! SmartchrToggle() "{{{
  if g:smarchr_enable == 1
    inoremap <expr> = smartchr#loop('=', '==', '=>')
    inoremap <expr> . smartchr#loop('.',  '->', '=>')

    " 演算子の間に空白を入れる
    inoremap <buffer><expr> + smartchr#one_of(' + ', ' ++ ', '+')
    inoremap <buffer><expr> - smartchr#one_of(' - ', ' -- ', '-')
    inoremap <buffer><expr> / smartchr#one_of(' / ', ' // ', '/')
    inoremap <buffer><expr> * smartchr#one_of(' * ', ' ** ', '*')
    inoremap <buffer><expr> , smartchr#one_of(', ', ',')
    inoremap <buffer><expr> +=  smartchr#one_of(' += ')
    inoremap <buffer><expr> -=  smartchr#one_of(' -= ')
    inoremap <buffer><expr> /=  smartchr#one_of(' /= ')
    inoremap <buffer><expr> *=  smartchr#one_of(' *= ')
    inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
    inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
    inoremap <buffer><expr> =>  smartchr#one_of(' => ')
    inoremap <buffer><expr> <-   smartchr#one_of(' <-  ')
    inoremap <buffer><expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')

    " " 3項演算子の場合は、後ろのみ空白を入れる
    noremap <buffer><expr> ? smartchr#one_of('? ', '?')
    inoremap <buffer><expr> : smartchr#one_of(': ', '::', ':')

    " " =の場合、単純な代入や比較演算子として入力する場合は前後にスペースをいれる。
    " " 複合演算代入としての入力の場合は、直前のスペースを削除して=を入力
    inoremap <buffer><expr> = search('¥(&¥<bar><bar>¥<bar>+¥<bar>-¥<bar>/¥<bar>>¥<bar><¥) ¥%#', 'bcn')? '<bs>= '  : search('¥(*¥<bar>!¥)¥%#', 'bcn') ? '= '  : smartchr#one_of(' = ', ' == ', '=')

    " " 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
    inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
    inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')

    " "()は空白入れる
    inoremap <buffer><expr> ( smartchr#one_of('( ')
    inoremap <buffer><expr> ) smartchr#one_of(' )')

    "()を閉じるときに、一つ右に移動
    " inoremap <buffer><expr> ( search('¥<¥if¥%#', 'bcn')? '(': '('
  else
    inoremap  = =
    inoremap  . .

    " 演算子の間に空白を入れる
    inoremap <buffer> + +
    inoremap <buffer> - -
    inoremap <buffer> / /
    inoremap <buffer> * *
    inoremap <buffer> , ,
    inoremap <buffer> += +=
    inoremap <buffer> -= -=
    inoremap <buffer> /= /=
    inoremap <buffer> *= *=
    inoremap <buffer> & %
    inoremap <buffer> % %
    inoremap <buffer> => =>
    inoremap <buffer> <- <-
    inoremap <buffer> ? ?
    inoremap <buffer> : :
    inoremap <buffer> } }
    inoremap <buffer> ; ;
    inoremap <buffer> ) )
    inoremap { {}<LEFT>
    inoremap [ []<LEFT>
    inoremap ( ()<LEFT>
  endif

  let g:smarchr_enable = !g:smarchr_enable
endfunction
" au BufReadPre * call SmartchrToggle()
" nmap <C-H><C-O> :call SmartchrToggle()<CR>
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
"loadのときに、syntaxCheckをする"{{{
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
nmap <Space>bl :BlogList<CR>
nmap <Space>bn :BlogNew<CR>
nmap <Space>bs :BlogSave<CR>
nmap <Space>bp :BlogPreview<CR>
nmap <Space>bo :BlogOpen<CR>
nmap <Space>bw :BlogSwitch<CR>
nmap <Space>bu :BlogUpload<CR>
nmap <Space>bc :BlogCode<CR>
"}}}

"----------------------------------------
"補完・履歴 Complete "{{{
set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=longest:full,full
set history=1000           " コマンド・検索パターンの履歴数
set complete+=k,U,kspell,t,d " 補完を充実
set completeopt=menu,menuone,preview
set infercase

" FileType毎のOmni補完を設定
autocmd FileType css                  setlocal omnifunc=csscomplete#CompleteCSS
autocmd FileType html,markdown        setlocal omnifunc=htmlcomplete#CompleteTags
autocmd FileType javascript           setlocal omnifunc=javascriptcomplete#CompleteJS
autocmd FileType python               setlocal omnifunc=pythoncomplete#Complete
autocmd FileType xml                  setlocal omnifunc=xmlcomplete#CompleteTags
autocmd FileType php                  setlocal omnifunc=phpcomplete#CompletePHP
autocmd FileType c                    setlocal omnifunc=ccomplete#Complete
autocmd FileType ruby,eruby,yml,ruby.rspec setlocal omnifunc=
autocmd FileType ruby,eruby,yml,ruby.rspec setlocal completefunc+=RSenseCompleteFunction
autocmd FileType ruby,eruby,ruby.rpec setlocal dict+=~/.vim/dict/ruby.dict
autocmd FileType ruby.rpec            setlocal dict+=~/.vim/dict/rspec.dict

"----------------------------------------
" neocomplcache
" default config"{{{
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_max_list = 300
" let g:neocomplcache_max_keyword_width = 40
" let g:neocomplcache_max_menu_width = 19
" let g:neocomplcache_auto_completion_start_length = 2
" let g:neocomplcache_manual_completion_start_length = 2
" let g:neocomplcache_min_keyword_length = 2
" let g:neocomplcache_min_syntax_length = 4
" let g:neocomplcache_cursor_hold_i_time = 300
" let g:neocomplcache_enable_insert_char_pre = 0
" let g:neocomplcache_enable_auto_select = 1
" let g:neocomplcache_enable_auto_delimiter = 0
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_ctags_program = "jctags"

" default config snippet
let g:neocomplcache_snippets_dir=expand('~/.vim/snippet')
"}}}

" ファイルタイプ毎の辞書ファイルの場所"{{{
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default'    : '',
      \ 'java'       : $HOME.'/.vim/dict/java.dict',
      \ 'ruby'       : $HOME.'/.vim/dict/ruby.dict',
      \ 'eruby'      : $HOME.'/.vim/dict/ruby.dict',
      \ 'javascript' : $HOME.'/.vim/dict/javascript.dict',
      \ 'lua'        : $HOME.'/.vim/dict/lua.dict',
      \ 'ocaml'      : $HOME.'/.vim/dict/ocaml.dict',
      \ 'perl'       : $HOME.'/.vim/dict/perl.dict',
      \ 'c'          : $HOME.'/.vim/dict/c.dict',
      \ 'php'        : $HOME.'/.vim/dict/php.dict',
      \ 'scheme'     : $HOME.'/.vim/dict/scheme.dict',
      \ 'vim'        : $HOME.'/.vim/dict/vim.dict',
      \ 'timobile'   : $HOME.'/.vim/dict/timobile.dict',
      \ }
"}}}
"
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
" let g:neocomplcache_omni_functions.ruby = 'RSenseCompleteFunction'

" Enable heavy omni completion.
if !exists('g:neocomplcache_omni_patterns')
  let g:neocomplcache_omni_patterns = {}
endif
let g:neocomplcache_omni_patterns.ruby       = '[^. *\t]\.\w*\|\h\w*::'
let g:neocomplcache_omni_patterns['ruby.rspec'] = '[^. *\t]\.\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.ruby = '[^. *\t]\.\w*'
" let g:neocomplcache_omni_patterns.php = '[^. \t]->\h\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.c = '\%(\.\|->\)\h\w*'
" let g:neocomplcache_omni_patterns.cpp = '\h\w*\%(\.\|->\)\h\w*\|\h\w*::'
" let g:neocomplcache_omni_patterns.perl = '\h\w*->\h\w*\|\h\w*::'

" keymap"{{{
" Plugin key-mappings.
imap <C-F>     <Plug>(neocomplcache_snippets_expand)
smap <C-F>     <Plug>(neocomplcache_snippets_expand)
imap <C-U>     <Esc>:Unite snippet<CR>
inoremap <expr><C-g>     neocomplcache#undo_completion()
" inoremap <expr><C-L>     neocomplcache#complete_common_string()

if has('conceal')
  set conceallevel=2 concealcursor=i
endif
imap <expr><TAB> neocomplcache#sources#snippets_complete#expandable() ?
      \"\<Plug>(neocomplcache_snippets_expand)" : pumvisible() ? "\<C-n>" : "\<TAB>"

" snippetの編集
nmap <Space>e :<C-U>NeoComplCacheEditSnippets<CR>
au BufRead,BufNewFile *.snip  set filetype=snippet

if !exists('g:neocomplcache_auto_completion_start_length')
  inoremap <silent><expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
  " inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
  inoremap <silent><expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
  " inoremap <expr><C-y>  neocomplcache#close_popup()
  " inoremap <expr><C-e>  neocomplcache#cancel_popup()
  inoremap <silent><CR>  <C-R>=neocomplcache#smart_close_popup()<CR><CR>
endif
"}}}
"}}}

"----------------------------------------
"Tags関連 cTags使う場合は有効化"{{{
"http://vim-users.jp/2010/06/hack154/

set tags=""
let current_dir = expand("%:p:h")

if has('path_extra')
  set tags+=tags;**/tags
endif

" rtagsは独自shコマンドrtags -Rで作成
if filereadable(expand('~/tags'))
  au FileType ruby,eruby setl tags+=~/rtags
else
  " let res = system('ctags', '-R --langmap=Ruby:.rb --ruby-typescfFm =~/.rvm/rubies/default -f ~/rtags')
  au FileType ruby,eruby setl tags+=~/rtags
endif

"tags_jumpを使い易くする
"「飛ぶ」
nnoremap tt  <C-]>
"「進む」
nnoremap tl  :<C-u>tag<CR>
"「戻る」
nnoremap th  :<C-u>pop<CR>
"履歴一覧
" nnoremap tk  :<C-u>tags<CR>
"}}}

"----------------------------------------
"外部コマンドの実行"{{{
au Filetype php nmap <Leader>R :! phptohtml<CR>

function! Today()
  return strftime("%Y/%m/%d")
endfunction

function! PhpDoc2()
  set fo=mcroql
  return ""
endfunction

function! PhpDoc()
  set fo=
  let text = ""
        \."/**\n"
        \." *  説明用の関数\n"
        \."*  @param Integer hoge\n"
        \."*\n"
        \."*  @return Integer soge\n"
        \."*  @author "
  " 日付の書き出し
  let text .= Today()
  let text .= " Ikkun\n*/"
  return text
endfunction
inoremap <C-D><C-D> <C-R>=Today()<CR>

function! PrintLine()
  set fo=
  let text = ""
        \."/* \n"
        \."-------------------------------------------------- */"
  return text
endfunction

au FileType * inoremap <silent><C-D><C-P> <C-R>=PhpDoc()<CR><C-R>=PhpDoc2()<CR>
au FileType * inoremap <silent><C-D><C-L> <C-R>=PrintLine()<CR><C-R>=PhpDoc2()<CR>

"}}}

set secure
