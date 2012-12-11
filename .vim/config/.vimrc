au!

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
set formatoptions+=lcoqmM
au VimEnter * set formatoptions-=ro
set helplang=ja,en
set modelines=0
set nobackup
set showmode
set timeout timeoutlen=400 ttimeoutlen=100
set vb t_vb=
set viminfo='100,<800,s300,\"300
set updatetime=4000 " swpを作るまでの時間(au CursorHoldの時間)
set norestorescreen=off
if v:version >= 703
  " Set undofile.
  set undofile
  let &undodir=&directory
endif

let PATH='/Users/taichou/.autojump/bin:/Users/taichou/.rbenv/shims:/Users/taichou/.rbenv/bin/:/Users/taichou/.rbenv:/Users/taichou/.rbenv/shims:/Users/taichou/.rbenv/bin:/Users/taichou/.rbenv:/Users/taichou/.autojump/bin:/Users/taichou/local/bin:/Users/taichou/local/sbin:/usr/local/bin:/Users/taichou/.vim/ref/rsense-0.3/bin:/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home/bin:/Applications/XAMPP/xamppfiles/bin:/bin:/sbin:/usr/sbin:/usr/bin:/Applications/XAMPP/xamppfiles/bin:/Users/taichou/.vim/ref/rsense-0.3/bin:/bin:/sbin:/usr/sbin:/usr/bin'
let $PATH='/Users/taichou/.autojump/bin:/Users/taichou/.rbenv/shims:/Users/taichou/.rbenv/bin/:/Users/taichou/.rbenv:/Users/taichou/.rbenv/shims:/Users/taichou/.rbenv/bin:/Users/taichou/.rbenv:/Users/taichou/.autojump/bin:/Users/taichou/local/bin:/Users/taichou/local/sbin:/usr/local/bin:/Users/taichou/.vim/ref/rsense-0.3/bin:/Library/Java/JavaVirtualMachines/1.7.0.jdk/Contents/Home/bin:/Applications/XAMPP/xamppfiles/bin:/bin:/sbin:/usr/sbin:/usr/bin:/Applications/XAMPP/xamppfiles/bin:/Users/taichou/.vim/ref/rsense-0.3/bin:/bin:/sbin:/usr/sbin:/usr/bin'

autocmd FileType help nnoremap <buffer> q <C-w>c
nmap <Space>h :<C-u>help<Space><C-r><C-w><CR>
nmap <Space><Space>s :<C-U>so ~/.vimrc<CR>
nmap <Space><Space>v :<C-U>e ~/.vim/config/.vimrc<CR>
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

"開いているファイルのディレクトリに自動で移動
" au BufEnter * execute ":lcd " . expand("%:p:h")

" 便利キーマップ追記
nmap <silent><Space>w :wq<CR>
nmap <silent><Space>q :q!<CR>
nmap <Space>s :w sudo:%<CR>
nmap sub :%s!\v
vmap sub y:%s!<C-r>=substitute(@0, '!', '\\!', 'g')<Return>!!g<Left><Left>
nmap <Leader>s :set ft=

" デフォルトキーマップの変更
nmap / /\v
nmap ? ?\v
" nmap p [p
" nmap P [P
imap <C-H> <BS>

" 新しいバッファを開くときに、rubyか同じファイルタイプで開く{{{
function! NewBuffer(type)
  let old_ft = &ft
  new
  if a:type == "new"
    setl ft=ruby
  else
    exec 'setl ft='.old_ft
  endif
endfunction
nmap <silent><C-W>n :call NewBuffer("new")<CR>
nmap <silent><C-W><C-N> :call NewBuffer("copy")<CR>
"}}}

" 括弧を自動補完
inoremap { {}<LEFT>
inoremap [ []<LEFT>
inoremap ( ()<LEFT>
inoremap " ""<LEFT>
inoremap ' ''<LEFT>
au FileType ruby,eruby,haml inoremap <buffer>\| \|\|<LEFT>

" 一括インデント
xmap < <gv
xmap > >gv
xmap <TAB>  >
xmap <S-TAB>  <
xmap <C-M> :sort<CR>

" HTML/XMLの閉じタグを </ が入力されたときに補完
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype html inoremap <buffer> </ </<C-x><C-o>
  autocmd Filetype eruby inoremap <buffer> </ </<C-x><C-o>
augroup END

"コメントを書くときに便利
inoremap <leader>* ****************************************
inoremap <leader>- ----------------------------------------

"保存時に無駄な文字を消す{{{
function! s:remove_dust()
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

function! HtmlFunctions()
  inoremap <leader>h <!--/--><left><left><left>
  xnoremap <silent> <space>e :call <SID>HtmlEscape()<CR>
  xnoremap <silent> <space>ue :call <SID>HtmlUnEscape()<CR>
endfunction
au FileType php,eruby,html,haml call HtmlFunctions()
" }}}

" 変なマッピングを修正 "{{{
if has('gui_macvim')
  map ¥ \
  imap ¥ \
  nmap ¥ \
  cmap ¥ \
  smap ¥ \
endif
"}}}

" Improved visual selection.{{{
" http://labs.timedia.co.jp/2012/10/vim-more-useful-blockwise-insertion.html
xnoremap <expr> I  <SID>force_blockwise_visual('I')
xnoremap <expr> A  <SID>force_blockwise_visual('A')

function! s:force_blockwise_visual(next_key)
  if mode() ==# 'v'
    return "\<C-v>" . a:next_key
  elseif mode() ==# 'V'
    return "\<C-v>0o$" . a:next_key
  else  " mode() ==# "\<C-v>"
    return a:next_key
  endif
endfunction
"}}}

" Improved increment.{{{
nmap <C-a> <SID>(increment)
nmap <C-x> <SID>(decrement)
nnoremap <silent> <SID>(increment)    :AddNumbers 1<CR>
nnoremap <silent> <SID>(decrement)   :AddNumbers -1<CR>
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

" nmap <silent>h <Left>
" nmap <silent>l <Right>
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
" nmap <silent>; :<C-U>echo "マーク"<CR><ESC>'

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif
nnoremap g: `.zz
nnoremap g, g;
nnoremap g; g,

" windowの操作
" ****************
" 画面の移動
nmap <C-L> <C-W><C-W>
" nmap <C-W><C-H> <C-W>h
nmap <C-W><C-J><C-h> <C-W>j<C-W>h
nmap <C-W><C-H><C-j> <C-W>h<C-W>j
nmap <C-W><C-H><C-k> <C-W>h<C-W>k
nmap <C-W><C-K><C-H> <C-W>k<C-W>h
nmap <C-W><C-K><C-L> <C-W>k<C-W>l
nmap <C-W><C-l><C-j> <C-W>l<C-W>j
nmap <C-W><C-l><C-k> <C-W>l<C-W>k

" 画面のサイズ変更とともに均等化
nmap <C-W>K <C-W>K<C-W>=
nmap <C-W>L <C-W>L<C-W>=
nmap <C-W>J <C-W>J<C-W>=
nmap <C-W>H <C-W>H<C-W>=
nmap <C-W>s :<C-U>split<CR><C-W>=
nmap <C-W>v :<C-U>vsplit<CR><C-W>=

" A .vimrc snippet that allows you to move around windows beyond tabs
nnoremap <silent> <Tab> :call <SID>NextWindow()<CR>
nnoremap <silent> <S-Tab> :call <SID>PreviousWindowOrTab()<CR>

"{{{
function! s:smart_close()
  if winnr('$') != 1
    close
  endif
endfunction

function! s:NextWindow()
  if winnr('$') == 1
    silent! normal! ``z.
  else
    wincmd w
  endif
endfunction

function! s:NextWindowOrTab()
  if tabpagenr('$') == 1 && winnr('$') == 1
    call s:split_nicely()
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

nnoremap <silent> [Window]<Space>  :<C-u>call <SID>ToggleSplit()<CR>

function! s:MovePreviousWindow()
  let prev_name = winnr()
  silent! wincmd p
  if prev_name == winnr()
    silent! wincmd w
  endif
endfunction

" If window isn't splited, split buffer.
function! s:ToggleSplit()
  let prev_name = winnr()
  silent! wincmd w
  if prev_name == winnr()
    split
  else
    call s:smart_close()
  endif
endfunction

command! SplitNicely call s:split_nicely()
function! s:split_nicely()
  " Split nicely.
  if winwidth(0) > 2 * &winwidth
    vsplit
  else
    split
  endif
  wincmd p
endfunction
"}}}

" tabを使い易く{{{
nmap <silent>t  <Nop>
nmap <silent>tn  :tabn<CR>
nmap <silent>tp  :tabprevious<CR>
nmap <silent>tc  :tabnew<CR>
nmap <silent>tx  :tabclose<CR>
" nnoremap to  :tabo<CR>
nmap <silent>te  :execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
"tabを次のtabへ移動
nmap tg  gT

nmap <silent>t1  :tabnext 1<CR>
nmap <silent>t2  :tabnext 2<CR>
nmap <silent>t3  :tabnext 3<CR>
nmap <silent>t4  :tabnext 4<CR>
nmap <silent>t5  :tabnext 5<CR>
nmap <silent>t6  :tabnext 6<CR>
"}}}
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
set tabstop=2
set softtabstop=2
set shiftwidth=2
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
  autocmd FileType less,sass  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType lisp       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType markdown   setlocal sw=4 sts=4 ts=4 et
  autocmd FileType perl       setlocal sw=4 sts=4 ts=4 et
  " autocmd FileType php        setlocal sw=4 sts=4 ts=4 et
  autocmd FileType php        setlocal sw=2 sts=2 ts=2 et
  autocmd FileType python     setlocal sw=4 sts=4 ts=4 et
  autocmd FileType ruby       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType gitcommit  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType gitconfig  setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scala      setlocal sw=2 sts=2 ts=2 et
  autocmd FileType scss       setlocal sw=2 sts=2 ts=2 et
  autocmd FileType sh         setlocal sw=4 sts=4 ts=4 et
  autocmd FileType snippet    setlocal sw=2 sts=2 ts=2 et
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
set title
set titlelen=95
set linebreak
set showfulltag
set spelllang=en_us
" set showbreak=>\
set breakat=\\;:,!?
set showmatch         " 括弧の対応をハイライトa
set number            " 行番号表示
set noequalalways     " 画面の自動サイズ調整解除
" set relativenumber    " 相対表示
set list              " 不可視文字表示
"set listchars=tab:,trail:,extends:,precedes:  " 不可視文字の表示形式
" set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set listchars=tab:␣.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
" set listchars=tab:✃.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set scrolloff=5
" set scrolljump=-50
set showcmd
au FileType haml,coffee,ruby,eruby,php,javascript,javascript.jasmine,ruby.spec,ruby.rails,ruby.rails.model,ruby.rails.controller,ruby.rspec,c,json,vim set colorcolumn=80

"set display=uhex      " 印字不可能文字を16進数で表示
set t_Co=256          " 確かカラーコード
set lazyredraw        " コマンド実行中は再描画しない
set ttyfast           " 高速ターミナル接続を行う
set matchpairs+=<:>
set cdpath+=~
" カーソル行をハイライト
set cursorline
" set scrolloff=999     " 常にカーソルを真ん中に

if has('gui_macvim')
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
  function! ToggleVisible()

  endfunction

  nmap <silent>_ :exec g:visible == 0 ? ":call SetVisible()" : ":call SetShow()"<CR>
  " au CursorHold * call SetVisible()
  " au CursorMoved,CursorMovedI,WinLeave * call SetShow()
endif

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
set foldcolumn=1
set foldenable
set commentstring=%s
set foldmethod=marker
nmap <Space><Space>f :<C-U>call ChangeFoldMethod()<CR>

" vimを使っているときはtmuxのステータスラインを隠す
if !has('gui_running') && $TMUX !=# ''
  augroup Tmux
    autocmd!
    au VimEnter,FocusGained * silent !tmux set status off
    au VimLeave,FocusLost * silent !tmux set status on
  augroup END
endif

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


"}}}

"----------------------------------------
" ファイルタイプ"{{{
au BufNewFile,BufRead *Helper.js,*Spec.js  setl filetype=jasmine.javascript
au BufNewFile,BufRead *.coffee   setl filetype=coffee
au BufNewFile,BufRead *Helper.coffee,*Spec.coffee  setl filetype=jasmine.coffee

au BufNewFile,BufRead *.less setf less
au BufNewFile,BufRead *.dict setf dict
au BufNewFile,BufRead Gemfile set filetype=Gemfile
au BufNewFile,BufRead .gitignore setl ft=conf
au BufNewFile,BufRead *.css set ft=css syntax=css3
au BufNewFile,BufRead *.json set filetype=json
au BufNewFile,BufRead *.go set filetype=go
au BufNewFile,BufRead *.mkd,*.markdown,*.md,*.mdown,*.mkdn   setlocal filetype=markdown autoindent formatoptions=tcroqn2 comments=n:>
au BufNewFile,BufRead .tmux.conf*,tmux.conf* set filetype=tmux
au BufNewFile,BufRead .htaccess,httpd.conf set filetype=apache
au BufNewFile,BufRead *.pcap set filetype=pcap
if expand("%:p")  =~ 'conf.d'
  au BufNewFile,BufRead *.conf set filetype=apache
endif
au FileType php.wordpress au! ProgramFiles

" Wordpress の設定"{{{
function! s:WordpressSetting()
  if expand("%:p")  =~ 'wp-'
    setl ft=php.wordpress noexpandtab nolist syntax=wordpress
  endif
endfunction
au FileType php call s:WordpressSetting()
"}}}

"}}}

" commitメッセージの編集時には余分なプラグインを読み込まない
if expand("%") =~ "COMMIT_EDITMSG"
  finish
endif

"----------------------------------------
" neobundle"{{{
filetype plugin indent off     " required!

if has('vim_starting')
  set runtimepath+=~/.bundle/neobundle.vim
  call neobundle#rc(expand('~/.bundle/'))
endif

"bundle"{{{
"----------------------------------------
" "vim基本機能拡張"{{{
" NeoBundle 'Shougo/neobundle'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundle 'Lokaltog/vim-powerline'
" NeoBundle 'vim-jp/vital.vim'
NeoBundle 'edsono/vim-matchit'
NeoBundle 'taichouchou2/surround.vim' " 独自の実装のものを使用、ruby用カスタマイズ、<C-G>のimap削除
NeoBundle 'tpope/vim-fugitive'
" NeoBundle 'yuroyoro/vim-autoclose'                          " 自動閉じタグ
NeoBundle 'taichouchou2/alpaca'       " 個人的なカラーやフォントなど
NeoBundle 'kana/vim-arpeggio'         " 同時押しキーマップを使う
NeoBundle 'rhysd/accelerated-jk'      " jkの移動を高速化
NeoBundle 'h1mesuke/vim-alignta'
" NeoBundle 'othree/eregex.vim'         " %S 正規表現を拡張
" NeoBundle 'vim-scripts/SearchComplete' " /で検索をかけるときでも\tで補完が出来る
" 遅延読み込み
"}}}

"----------------------------------------
" vim拡張"{{{
NeoBundle 'tomtom/tcomment_vim'
" NeoBundle 'vim-scripts/tlib' " tcommentで使用

NeoBundle 'Shougo/neocomplcache'
NeoBundle 'thinca/vim-quickrun' "<Leader>rで簡易コンパイル
" NeoBundle 'scrooloose/nerdtree' "プロジェクト管理用 tree filer
" NeoBundle 'grep.vim'
NeoBundle 'smartword'
NeoBundle 'Shougo/neosnippet'
NeoBundle 'Shougo/vimshell'
NeoBundle 'Shougo/unite.vim'
NeoBundle 'Shougo/vimfiler'
" NeoBundle 'yuroyoro/vimdoc_ja'
NeoBundle 'camelcasemotion'
" NeoBundle 'taku-o/vim-toggle' "true<=>false など、逆の意味のキーワードを切り替えられる
" NeoBundle 'Lokaltog/vim-easymotion'

NeoBundle 'mattn/zencoding-vim' "Zencodingを使う
NeoBundle 'vim-scripts/sudo.vim' "vimで開いた後にsudoで保存
NeoBundle 'taichouchou2/vim-endwise.git' "end endifなどを自動で挿入
NeoBundle 'nathanaelkane/vim-indent-guides' "indentに色づけ
" NeoBundle 'kien/ctrlp.vim' "ファイルを絞る

" NeoBundle 'taglist.vim' "関数、変数を画面横にリストで表示する
NeoBundle 'majutsushi/tagbar'

" Ascii color code対応
" NeoBundle 'vim-scripts/AnsiEsc.vim'
"コメントアウト
" NeoBundle 'hrp/EnhancedCommentify'

"ヤンクの履歴を管理し、順々に参照、出力できるようにする
" NeoBundle 'YankRing.vim'

" /で検索をかけるときでも\tで補完が出来る
" NeoBundle 'vim-scripts/SearchComplete'

" 関連するファイルを切り替えれる
" NeoBundle 'kana/vim-altr'

" visualモードで、文字列を直感的に移動
NeoBundle 't9md/vim-textmanip'

" undo履歴をツリー表示
NeoBundle 'sjl/gundo.vim'

"----------------------------------------
" text-object拡張"{{{
" operator拡張の元
NeoBundle 'operator-camelize' "operator-camelize : camel-caseへの変換
" NeoBundle 'emonkak/vim-operator-comment'
" NeoBundle 'https://github.com/kana/vim-textobj-jabraces.git'
NeoBundle 'kana/vim-operator-user'
" NeoBundle 'kana/vim-textobj-datetime'      " d 日付
" NeoBundle 'kana/vim-textobj-fold.git'      " z 折りたたまれた{{ {をtext-objectに
" NeoBundle 'kana/vim-textobj-function.git'  " f 関数をtext-objectに
" NeoBundle 'kana/vim-textobj-indent.git'    " i I インデントをtext-objectに
" NeoBundle 'kana/vim-textobj-lastpat.git'   " /? 最後に検索されたパターンをtext-objectに
" NeoBundle 'kana/vim-textobj-syntax.git'    " y syntax hilightされたものをtext-objectに
NeoBundle 'kana/vim-textobj-user'          " textobject拡張の元
" NeoBundle 'textobj-entire'                 " e buffer全体をtext-objectに
" NeoBundle 'textobj-rubyblock'              " r rubyの、do-endまでをtext-objectに
" NeoBundle 'thinca/vim-textobj-comment'     " c commentをtext-objectに
NeoBundle 'thinca/vim-textobj-plugins.git' " vim-textobj-plugins : いろんなものをtext-objectにする

" NeoBundle 'tyru/operator-html-escape.vim'
"}}}
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
NeoBundle 'Shougo/unite-ssh'
NeoBundle 'ujihisa/vimshell-ssh'
NeoBundle 'fsouza/go.vim'
" NeoBundle 'tsukkee/unite-tag'
" NeoBundle 'tacroe/unite-mark'
" NeoBundle 'ujihisa/unite-gem'
" NeoBundle 'sgur/unite-qf'
" NeoBundle 'choplin/unite-vim_hacks'
" NeoBundle 'ujihisa/unite-colorscheme'
" NeoBundle 'kmnk/vim-unite-giti'
NeoBundle 'taichouchou2/vim-unite-giti'
" NeoBundle 'joker1007/unite-git_grep'
" NeoBundle 'mattn/unite-source-simplenote'

NeoBundle 'basyura/TweetVim'
NeoBundle 'basyura/twibill.vim'
NeoBundle 'basyura/bitly.vim'
NeoBundle 'tyru/eskk.vim'
" NeoBundle 'daisuzu/facebook.vim'

" NeoBundle 'yuratomo/w3m.vim'
" NeoBundle 'TeTrIs.vim'
" NeoBundle 'mattn/qiita-vim'

" NeoBundle 'osyo-manga/vim-itunes'

" NeoBundle 'benmills/vimux'
"}}}

" bundle.lang"{{{
" NeoBundle 'rstacruz/sparkup', {'rtp': 'vim/'}
NeoBundle 'hail2u/vim-css3-syntax'
" NeoBundle 'pasela/unite-webcolorname'
" NeoBundle 'jQuery'
NeoBundle 'taichouchou2/html5.vim'
NeoBundle 'tpope/vim-haml'
" NeoBundle 'xmledit'
" au FileType html,php,eruby,ruby,javascript,markdown call HtmlSetting()
" au FileType * call HtmlSetting()

"  js / coffee
" ----------------------------------------
NeoBundle 'kchmck/vim-coffee-script'
NeoBundle 'claco/jasmine.vim'
NeoBundle 'taichouchou2/vim-javascript' " syntaxが無駄に入っているので、インストール後削除
" NeoBundle 'hallettj/jslint.vim'
" NeoBundle 'pekepeke/titanium-vim' " Titaniumを使うときに

"  markdown
" ----------------------------------------
" markdownでの入力をリアルタイムでチェック
" NeoBundle 'mattn/mkdpreview-vim'
NeoBundle 'tpope/vim-markdown'

" sassのコンパイル
" NeoBundle 'AtsushiM/sass-compile.vim'
" NeoBundle 'taichouchou2/sass-compile.vim'
" NeoBundle 'taichouchou2/sass-async-compile.vim'

"  php
" ----------------------------------------
" NeoBundle 'oppara/vim-unite-cake'
" NeoBundle 'violetyk/cake.vim' " cakephpを使いやすく

"  binary
" ----------------------------------------
NeoBundle 'Shougo/vinarise'
NeoBundle 's-yukikaze/vinarise-plugin-peanalysis'

" objective-c
" ----------------------------------------
" NeoBundle 'msanders/cocoa.vim'

" ruby
" ----------------------------------------
NeoBundle 'ujihisa/neco-ruby'
" NeoBundle 'astashov/vim-ruby-debugger'
NeoBundle 'taichouchou2/vim-rails'
NeoBundle 'taka84u9/vim-ref-ri'
" NeoBundle 'taichouchou2/neco-rubymf' " gem install methodfinder
NeoBundle 'ruby-matchit'
NeoBundle 'skwp/vim-rspec'
NeoBundle 'ujihisa/unite-rake'
" NeoBundle 'taichouchou2/vim-rsense'
NeoBundle 'vim-ruby/vim-ruby'
NeoBundle 'skalnik/vim-vroom'
NeoBundle 'taichouchou2/unite-reek',
      \{  'depends' : 'Shougo/unite.vim' }
NeoBundle 'taichouchou2/unite-rails_best_practices',
      \{ 'depends' : 'Shougo/unite.vim' }
" NeoBundle 'taichouchou2/alpaca_complete'
NeoBundle 'Shougo/neocomplcache-rsense'
NeoBundle 'rhysd/unite-ruby-require.vim'
NeoBundle 'rhysd/neco-ruby-keyword-args'
NeoBundle 'rhysd/vim-textobj-ruby'

" python
" ----------------------------------------
" NeoBundle 'Pydiction'
" NeoBundle 'yuroyoro/vim-python'
" NeoBundle 'davidhalter/jedi-vim', {
"       \ 'build' : {
"       \     'mac' : 'git submodule update --init',
"       \     'unix' : 'git submodule update --init',
"       \    },
"       \ }
" NeoBundle 'kevinw/pyflakes-vim'

" scala
" ----------------------------------------
" NeoBundle 'yuroyoro/vim-scala'

" SQLUtilities : SQL整形、生成ユーティリティ
" NeoBundle 'SQLUtilities'
" NeoBundle 'Align'

" C言語など<Leader>;で全行に;を挿入できる
" NeoBundle 'vim-scripts/teol.vim'

" shellscript indnt
" NeoBundle 'sh.vim'
"}}}

" 他のアプリを呼び出す"{{{
"URL上で操作することで、URLを開いたり
"キーワード上で操作することで、ぐぐることができる
NeoBundle 'open-browser.vim'
" NeoBundle 'thinca/vim-openbuf'

"各種リファレンスを引いたり、英和辞書を読む
NeoBundle 'thinca/vim-ref'
" NeoBundle 'soh335/vim-ref-jquery'
" NeoBundle 'soh335/vim-ref-jquery'
" NeoBundle 'ujihisa/ref-hoogle'
" NeoBundle 'pekepeke/ref-javadoc'

" gitをvim内から操作する
NeoBundle 'Shougo/git-vim'
NeoBundle 'mattn/gist-vim' "gistを利用する

" 保存と同時にブラウザをリロードする
NeoBundle 'tell-k/vim-browsereload-mac'

" markdownでメモを管理
NeoBundle 'glidenote/memolist.vim'

" vimでwordpress
" NeoBundle 'vim-scripts/VimRepress'

" vモードで選択
"<Leader>seでsqlを実行
" NeoBundle 'vim-scripts/dbext.vim'

" tagsを利用したソースコード閲覧・移動補助機能 tagsファイルの自動生成
" NeoBundle 'vim-scripts/Source-Explorer-srcexpl.vim'
" NeoBundleLazy 'tsukkee/lingr-vim'

let s:neobundle_filetype_plugins = {}
let s:neobundle_filetype_plugins.html = []

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
call arpeggio#map('i', '', 0, 'jk', '<Esc>:noh<CR>')
" call arpeggio#map('n', '', 0, 'jk', '<Esc>:noh<CR>')
call arpeggio#map('v', '', 0, 'jk', '<Esc>:noh<CR>')

"------------------------------------
" Align / alignta
"------------------------------------
"{{{
" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3
" let g:alignta_default_options="=<<<1:1"
" let g:alignta_default_arguments="="
vmap <C-N> :Align<Space>
vmap <C-N><C-N> :Align =<CR>
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
" nmap <Space>t :Tlist<CR>
"}}}

"------------------------------------
" tagbar.vim
"------------------------------------
"{{{
nnoremap <Space>t :TagbarToggle<CR>
let g:tagbar_ctags_bin="/Applications/MacVim.app/Contents/MacOS/ctags"

" gem ins coffeetags
if executable('coffeetags')
  let g:tagbar_type_coffee = {
        \ 'ctagsbin' : 'coffeetags',
        \ 'ctagsargs' : '',
        \ 'kinds' : [
        \ 'f:functions',
        \ 'o:object',
        \ ],
        \ 'sro' : ".",
        \ 'kind2scope' : {
        \ 'f' : 'object',
        \ 'o' : 'object',
        \ }
        \ }
endif
" let g:tagbar_type_javascript = {
"     \'ctagstype' : 'JavaScript',
"     \'kinds'     : [
"     \   'o:objects',
"     \   'f:functions',
"     \   'a:arrays',
"     \   's:strings'
"   \]
" \}
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
let g:unite_enable_split_vertically=1
let g:unite_enable_start_insert=1
let g:unite_source_file_mru_filename_format = ''
let g:unite_source_file_mru_limit = 400     "最大数
let g:unite_source_file_rec_min_cache_files = 300
let g:unite_source_history_yank_enable = 1
let g:unite_winheight = 20

"unite prefix key.
nnoremap [unite] <Nop>
nmap <C-J> [unite]

nnoremap <silent> [unite]<C-U> :<C-u>UniteWithBufferDir -buffer-name=files file<CR>
" nnoremap <silent> [unite]<C-R> :<C-u>Unite -buffer-name=register register<CR>
nnoremap <silent> [unite]<C-R> :<C-u>Unite -no-quit reek<CR>
nnoremap <silent> [unite]<C-R><C-R> :<C-u>Unite -no-quit rails_best_practices<CR>
nnoremap <silent> [unite]<C-J> :<C-u>Unite file_mru<CR>
nnoremap <silent> [unite]<C-B> :<C-u>Unite bookmark<CR>
nnoremap <silent> <Space>b :<C-u>UniteBookmarkAdd<CR>
let g:unite_quick_match_table = {
      \'a' : 1, 's' : 2, 'd' : 3, 'f' : 4, 'g' : 5, 'h' : 6, 'j' : 7, 'k' : 8, 'l' : 9, ':' : 10,
      \'q' : 11, 'w' : 12, 'e' : 13, 'r' : 14, 't' : 15, 'y' : 16, 'u' : 17, 'i' : 18, 'o' : 19, 'p' : 20,
      \'1' : 21, '2' : 22, '3' : 23, '4' : 24, '5' : 25, '6' : 26, '7' : 27, '8' : 28, '9' : 29, '0' : 30,
      \}

function! s:unite_my_settings()"{{{
  " nmap <buffer> <ESC> <Plug>(unite_exit)
  " imap <buffer> jj <Plug>(unite_insert_leave)
  imap <buffer><C-w> <Plug>(unite_delete_backward_path)

  nmap <buffer><C-L> <C-W><C-W>
  " nnoremap <silent> <buffer> <expr> <C-j> unite#do_action('split')
  " nnoremap <silent> <buffer> <expr> <C-l> unite#do_action('vsplit')
  " nnoremap <silent> <buffer> <expr> <C-o> unite#do_action('open')
  call unite#custom_default_action('ref', 'split')
  " hi CursorLine                    guibg=#3E3D32
  " hi CursorColumn                  guibg=#3E3D32
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
  nnoremap <silent><buffer><expr><C-W>s unite#do_action('split')
  nnoremap <silent><buffer><expr><C-W>v unite#do_action('vsplit')
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
" Unite-rails.vim
"------------------------------------
"{{{
function! UniteRailsSetting()
  nmap <buffer><C-H>m           :<C-U>Unite rails/model<CR>
  nmap <buffer><C-H><C-H><C-H>  :<C-U>Unite rails/model<CR>
  nmap <buffer><C-H>v           :<C-U>Unite rails/view<CR>
  nmap <buffer><C-H><C-H>       :<C-U>Unite rails/view<CR>
  nmap <buffer><C-H>c           :<C-U>Unite rails/controller<CR>
  nmap <buffer><C-H>            :<C-U>Unite rails/controller<CR>
  nmap <buffer><C-H>f           :<C-U>Unite rails/config<CR>
  nmap <buffer><C-H>sp           :<C-U>Unite rails/spec<CR>
  nmap <buffer><C-H>d           :<C-U>Unite rails/db<CR>
  nmap <buffer><expr><C-H>g     '<Esc>:e ' . RailsRoot() . '/Gemfile<CR>'
  nmap <buffer><expr><C-H>lo    '<Esc>:e ' . RailsRoot() . '/config/locales<CR>'
  nmap <buffer><expr><C-H>ro    '<Esc>:e ' . RailsRoot() . '/config/routes.rb<CR>'
  nmap <buffer><expr><C-H>se    '<Esc>:e ' . RailsRoot() . '/db/seeds.rb<CR>'
  nmap <buffer><C-H>ra          :<C-U>Unite rails/rake<CR>
  nmap <buffer><C-H>ds          :<C-U>Unite rails/destroy<CR>
  nmap <buffer><C-H>h           :<C-U>Unite rails/heroku<CR>
endfunction
au User Rails call UniteRailsSetting()
"}}}

"------------------------------------
" VimFiler
"------------------------------------
"{{{
" 起動コマンド
" default <leader><leader>
nnoremap <Leader><leader> :VimFilerBufferDir<CR>
" nnoremap <C-H><C-F> :VimFilerExplorer<CR>
nnoremap <C-H><C-F> :call VimFilerExplorerGit()<CR>

" lean more [ utf8 glyph ]( http://sheet.shiar.nl/unicode )
let g:vimfiler_safe_mode_by_default = 0
let g:vimfiler_as_default_explorer = 1
let g:vimfiler_sort_type = "filename"
" let g:vimfiler_split_action = "right"
" let g:vimfiler_edit_action = "open"
let g:vimfiler_preview_action = ""
let g:vimfiler_max_directories_history = 100
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
  autocmd FileType vimfiler call s:vimfiler_local()

  function! s:vimfiler_local()
    if has('unix')
      " 開き方
      call vimfiler#set_execute_file('sh', 'sh')
      call vimfiler#set_execute_file('mp3', 'iTunes')
    endif
    setl nonumber

    " Unite bookmark連携
    nmap <buffer>B :<C-U>Unite bookmark<CR>
    nmap <buffer>b :<C-U>UniteBookmarkAdd<CR>
    nmap <buffer><C-L> <C-W><C-W>
    nmap <buffer><CR> <Plug>(vimfiler_edit_file)
    nmap <buffer>v <Plug>(vimfiler_view_file)
    " nmap <buffer><silent><C-J>
    nmap <buffer><silent><C-J><C-J> :<C-U>Unite file_mru<CR>
    " nmap <buffer><silent><C-J><C-U> :<C-U>Unite file<CR>
    nmap <buffer><silent><C-J><C-U> :<C-U>UniteWithBufferDir -buffer-name=files file<CR>

    " Unite bookmarkのアクションをVimFilerに
    call unite#custom_default_action('source/bookmark/directory' , 'vimfiler')
  endfunction
aug END
"}}}

" VimFilerExplorerを自動起動
" gitの場合はgit_rootかつ、バッファの有無でフォーカス変える
" XXX 関数内でsystemを呼ぶと、なぜか^]];95;cという文字が出る。。。今は外に出し
" 原因不明
function! VimFilerExplorerGit()"{{{
  let cmd = bufname("%") != "" ? "2wincmd w" : ""
  let s:git_root = system('git rev-parse --show-cdup')

  if(system('git rev-parse --is-inside-work-tree') == "true\n")
    if s:git_root == "" |let g:git_root = "."| endif
    exe 'VimFilerExplorer -simple ' . substitute( s:git_root, '\n', "", "g" )
  else
    exe 'VimFilerExplorer -simple .'
  endif

  let s:vimfiler_enable = 1

  autocmd BufWinLeave <buffer> let s:vimfiler_enable = 0

  " vimfilerが最後のbufferならばvimを終了
  autocmd BufEnter <buffer> if (winnr('$') == 1 && &filetype ==# 'vimfiler' && s:vimfiler_enable == 1) | q | endif

  exe cmd
endfunction"}}}

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
let g:quickrun_config['coffee_compile'] = {
      \'command' : 'coffee',
      \'exec' : ['%c -cbp %s']
      \}

" should gem install bluecloth
" let markdownCss = '<link href="http://kevinburke.bitbucket.org/markdowncss/markdown.css" rel="stylesheet"></link>'
" let markdownHead = '<!DOCTYPE HTML> <html lang=\"ja\"> <head> <meta charset=\"UTF-8\">'.markdownCss.'</head><body>'
" let markdownFoot = "</body> </html>"
"       " \ 'command'   : 'bluecloth',
" let g:quickrun_config['markdown'] = {
"       \ 'exec'      : ["echo \'" . markdownHead. "'", '%c  %s', "echo \'" . markdownFoot. "'"],
"       \ }
let g:quickrun_config['markdown'] = {
      \ 'outputter': 'browser',
      \ 'cmdopt': '-s'
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
      \}
      " \ 'outputter' : 'rspec_outputter'
      " \ 'exec': 'bundle exec %c --color --tty %o %s',
      " \ 'outputter' : 'ansi_buffer'

let ansi_buffer = quickrun#outputter#buffer#new()
function! ansi_buffer.init(session)
  call call(quickrun#outputter#buffer#new().init,  [a:session],  self)
endfunction

function! ansi_buffer.finish(session)
  AnsiEsc
  call call(quickrun#outputter#buffer#new().finish,  [a:session], self)
endfunction
call quickrun#register_outputter("ansi_buffer", ansi_buffer)

" ファイル名が_spec.rbで終わるファイルを読み込んだ時に上記の設定を自動で読み込む
function! RSpecQuickrun()
  let b:quickrun_config = {'type' : 'ruby.rspec'}
  setl ft=ruby.rspec
  nnoremap <expr><silent><buffer><Leader>lr "<Esc>:QuickRun ruby.rspec -cmdopt \"-l" .  line('.') . "\"<CR>"
endfunction
au BufReadPost *_spec.rb call RSpecQuickrun()

function! s:quickrun_auto_close()
  autocmd WinEnter,BufRead <buffer> if (winnr('$') == 1) | q | endif
endfunction
autocmd FileType quickrun call s:quickrun_auto_close()

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
let g:ref_refe_cmd                = expand('~/.vim/ref/ruby-ref1.9.2/refe-1_9_2')
let g:ref_phpmanual_path          = expand('~/.vim/ref/php-chunked-xhtml')
let g:ref_ri_cmd                  = expand('~/.rbenv/versions/1.9.3-p125/bin/ri')

"リファレンスを簡単に見れる。
" nmap K <Nop>

nmap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
vmap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
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
nmap rr :<C-U>Unite ref/refe     -default-action=split -input=
nmap ri :<C-U>Unite ref/ri       -default-action=split -input=
nmap rm :<C-U>Unite ref/man      -default-action=split -input=
nmap rpy :<C-U>Unite ref/pydoc   -default-action=split -input=
nmap rpe :<C-U>Unite ref/perldoc -default-action=split -input=

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
nmap <silent>gm :<C-U>Gcommit<CR>
nmap <silent>gM :<C-U>Gcommit --amend<CR>

nmap <silent>gb :<C-U>Gblame<CR>
nmap <silent>gr :<C-U>Ggrep<Space>
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
au FileType git-diff nmap<buffer>q :q<CR>
" nmap <silent><Space>gb :GitBlame<CR>
" nmap <silent><Space>gB :Gitblanch
" nmap <silent><Space>gp :GitPush<CR>
nmap <silent>gd :<C-U>GitDiff HEAD<CR>
nmap <silent>gD :GitDiff<Space>
" " nmap <silent><Space>gs :GitStatus<CR>
" " nmap <silent><Space>gl :GitLog -10<CR>
" " nmap <silent><Space>gL :<C-u>GitLog -u \| head -10000<CR>
nmap <silent>ga :GitAdd -A<CR>
nmap <silent>gA :GitAdd<Space>
" nmap <silent><Space>gA :<C-u>GitAdd <cfile><CR>
" nmap <silent><Space>gm :GitCommit<CR>
" nmap <silent>gm :GitCommit --amend<CR>
nmap <silent>gp :Git push<Space>
" nmap <silent><Space>gt :Git tag<Space>
" "}}}

"----------------------------------------
" unite-giti
"----------------------------------------
"{{{
nmap <silent>gl :<C-U>Unite giti/log<CR>
nmap <silent>gs :<C-U>Unite giti/status<CR>
nmap <silent>gh :<C-U>Unite giti/branch_all<CR>
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
" vim-powerline
"------------------------------------
"{{{
">の形をを許可する
"ちゃんと/.vim/fontsのfontを入れていないと動かないよ
set guifontwide=Ricty:h10
let g:Powerline_colorscheme='molokai'
let g:Powerline_symbols = 'fancy'

"{{{
call Pl#Hi#Allocate({
    \ 'black'          : 16,
    \ 'white'          : 231,
    \
    \ 'darkestgreen'   : 22,
    \ 'darkgreen'      : 28,
    \ 'mediumgreen'    : 70,
    \ 'brightgreen'    : 148,
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
    \ 'darkestpurple'  : 55,
    \ 'mediumpurple'   : 98,
    \ 'brightpurple'   : 189,
    \
    \ 'brightorange'   : 208,
    \ 'brightestorange': 214,
    \
    \ 'gray0'          : 233,
    \ 'gray1'          : 235,
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

" {{{
let g:Powerline#Colorschemes#molokai#colorscheme = Pl#Colorscheme#Init([
      \ Pl#Hi#Segments(['SPLIT'], {
      \ 'n': ['white', 'gray2'],
      \ 'N': ['white', 'gray0'],
      \ 'i': ['white', 'darkestblue'],
      \ }),
      \
      \ Pl#Hi#Segments(['mode_indicator'], {
      \ 'n': ['darkestgreen', 'brightgreen', ['bold']],
      \ 'i': ['darkestcyan', 'white', ['bold']],
      \ 'v': ['darkred', 'brightorange', ['bold']],
      \ 'r': ['white', 'brightred', ['bold']],
      \ 's': ['white', 'gray5', ['bold']],
      \ }),
      \
      \ Pl#Hi#Segments(['branch', 'scrollpercent', 'raw', 'filesize'], {
      \ 'n': ['gray9', 'gray4'],
      \ 'N': ['gray4', 'gray1'],
      \ 'i': ['mediumcyan', 'darkblue'],
      \ }),
      \
      \ Pl#Hi#Segments(['fileinfo', 'filename'], {
      \ 'n': ['white', 'gray4', ['bold']],
      \ 'N': ['gray7', 'gray0', ['bold']],
      \ 'i': ['white', 'darkblue', ['bold']],
      \ }),
      \
      \ Pl#Hi#Segments(['fileinfo.filepath'], {
      \ 'n': ['gray10'],
      \ 'N': ['gray5'],
      \ 'i': ['mediumcyan'],
      \ }),
      \
      \ Pl#Hi#Segments(['static_str'], {
      \ 'n': ['white', 'gray4'],
      \ 'N': ['gray7', 'gray1'],
      \ 'i': ['white', 'darkblue'],
      \ }),
      \
      \ Pl#Hi#Segments(['fileinfo.flags'], {
      \ 'n': ['brightestred', ['bold']],
      \ 'N': ['darkred'],
      \ 'i': ['brightestred', ['bold']],
      \ }),
      \
      \ Pl#Hi#Segments(['currenttag', 'fullcurrenttag', 'fileformat', 'fileencoding', 'pwd', 'filetype', 'rvm:string', 'rvm:statusline', 'virtualenv:statusline', 'charcode', 'currhigroup'], {
      \ 'n': ['gray8', 'gray2'],
      \ 'i': ['mediumcyan', 'darkestblue'],
      \ }),
      \
      \ Pl#Hi#Segments(['lineinfo'], {
      \ 'n': ['gray2', 'gray10', ['bold']],
      \ 'N': ['gray7', 'gray1', ['bold']],
      \ 'i': ['darkestcyan', 'mediumcyan', ['bold']],
      \ }),
      \
      \ Pl#Hi#Segments(['errors'], {
      \ 'n': ['brightestorange', 'gray2', ['bold']],
      \ 'i': ['brightestorange', 'darkestblue', ['bold']],
      \ }),
      \
      \ Pl#Hi#Segments(['lineinfo.line.tot'], {
      \ 'n': ['gray6'],
      \ 'N': ['gray5'],
      \ 'i': ['darkestcyan'],
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
      \
      \ Pl#Hi#Segments(['lustyexplorer:static_str.name', 'minibufexplorer:static_str.name', 'nerdtree:raw.name', 'tagbar:static_str.name'], {
      \ 'n': ['white', 'mediumgreen', ['bold']],
      \ 'N': ['mediumgreen', 'darkestgreen', ['bold']],
      \ }),
      \
      \ Pl#Hi#Segments(['lustyexplorer:static_str.buffer', 'tagbar:static_str.buffer'], {
      \ 'n': ['brightgreen', 'darkgreen'],
      \ 'N': ['mediumgreen', 'darkestgreen'],
      \ }),
      \
      \ Pl#Hi#Segments(['lustyexplorer:SPLIT', 'minibufexplorer:SPLIT', 'nerdtree:SPLIT', 'tagbar:SPLIT'], {
      \ 'n': ['white', 'darkgreen'],
      \ 'N': ['white', 'darkestgreen'],
      \ }),
      \
      \ Pl#Hi#Segments(['ctrlp:focus', 'ctrlp:byfname'], {
      \ 'n': ['brightpurple', 'darkestpurple'],
      \ }),
      \
      \ Pl#Hi#Segments(['ctrlp:prev', 'ctrlp:next', 'ctrlp:pwd'], {
      \ 'n': ['white', 'mediumpurple'],
      \ }),
      \
      \ Pl#Hi#Segments(['ctrlp:item'], {
      \ 'n': ['darkestpurple', 'white', ['bold']],
      \ }),
      \
      \ Pl#Hi#Segments(['ctrlp:marked'], {
      \ 'n': ['brightestred', 'darkestpurple', ['bold']],
      \ }),
      \
      \ Pl#Hi#Segments(['ctrlp:count'], {
      \ 'n': ['darkestpurple', 'white'],
      \ }),
      \
      \ Pl#Hi#Segments(['ctrlp:SPLIT'], {
      \ 'n': ['white', 'darkestpurple'],
      \ }),
\ ])
" }}}

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
    VimShellAlterCommand ssh iexe ssh

    call vimshell#set_alias('l.', 'ls -d .*')

    " Abbrev
    " inoreabbrev <buffer> h@ --help 2>&1 <Bar> less

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
    nmap <C-L> <C-W><C-W>
    imap <C-L> <Nop>
    " Unmap [i] -buffer <Tab>
    " Map [i] -remap -buffer -force <Tab><Tab> <Plug>(vimshell_command_complete)

    " Misc.
    " setlocal backspace-=eol
    setlocal updatetime=1000

    NeoComplCacheEnable
    let g:vimshell_escape_colors = [
      \'#3c3c3c', '#ff6666', '#66ff66', '#ffd30a', '#1e95fd', '#ff13ff', '#1bc8c8', '#C0C0C0',
      \'#686868', '#ff6666', '#66ff66', '#ffd30a', '#6699ff', '#f820ff', '#4ae2e2', '#ffffff'
      \]


endfunction "}}}
autocmd FileType vimshell call s:vimshell_settings()

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
function! AutoCoffeeCompile()
  autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!
endfunction
nnoremap <Leader>w :CoffeeCompile watch vert<CR>
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
" " ctrlp"{{{
" let g:ctrlp_map = '<Nul>'
" let g:ctrlp_regexp = 1
" let g:ctrlp_tabpage_position = 'al'
" let g:ctrlp_clear_cache_on_exit = 0
" let g:ctrlp_custom_ignore = {
"       \ 'dir':  '\.\(hg\|git\|sass-cache\|svn\)$',
"       \ 'file': '\.\(dll\|exe\|gif\|jpg\|png\|psd\|so\|woff\)$' }
" let g:ctrlp_open_new_file = 't'
" let g:ctrlp_open_multiple_files = 'tj'
" let g:ctrlp_lazy_update = 1
"
" let g:ctrlp_mruf_max = 1000
" let g:ctrlp_mruf_exclude = '\(\\\|/\)\(Temp\|Downloads\)\(\\\|/\)\|\(\\\|/\)\.\(hg\|git\|svn\|sass-cache\)'
" let g:ctrlp_mruf_case_sensitive = 0
" let g:ctrlp_prompt_mappings = {
"       \ 'AcceptSelection("t")': ['<c-n>'],
"       \ }
"
" hi link CtrlPLinePre NonText
" hi link CtrlPMatch IncSearch
"
" function! s:CallCtrlPBasedOnGitStatus()
"   let s:git_status = system('git status')
"
"   if v:shell_error == 128
"     execute 'CtrlPCurFile'
"   else
"     execute 'CtrlP'
"   endif
" endfunction
"
" nnoremap <C-H><C-B> :CtrlPBuffer<Return>
" nnoremap <C-H><C-D> :CtrlPClearCache<Return>:CtrlP ~/Dropbox/Drafts<Return>
" nnoremap <C-H><C-G> :CtrlPClearCache<Return>:call <SID>CallCtrlPBasedOnGitStatus()<Return>
" "}}}

"------------------------------------
" vim-ruby
"------------------------------------
"{{{
function! s:vimRuby()
  let g:rubycomplete_buffer_loading = 0
  let g:rubycomplete_classes_in_global = 0
  let g:rubycomplete_rails = 0
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
let g:dbext_default_SQLITE_bin = 'mysql2'
let g:rails_default_file='config/database.yml'
let g:rails_mappings=1
let g:rails_modelines=1
let g:rails_gnu_screen=1
" let g:rails_ctags_arguments='--languages=-javascript'
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
  " nmap <buffer><Space>s :Rspec<Space>
  " nmap <buffer><Space>m :Rgen model<Space>
  " nmap <buffer><Space>c :Rgen contoller<Space>
  " nmap <buffer><Space>s :Rgen scaffold<Space>
  nmap <buffer><Space>p :Rpreview<CR>
endfunction
autocmd User Rails call SetUpRailsSetting()
"}}}

"------------------------------------
" vim-rsense
"------------------------------------
"{{{
" Rsense
" let g:rsenseUseOmniFunc = 1
let g:rsenseUseOmniFunc = 1
let g:rsenseHome = expand('~/.vim/ref/rsense-0.3')
" let g:rsenseMatchFunc = "[a-zA-Z_?]"

function! SetUpRubySetting()
  nmap <buffer>rj :RSenseJumpToDefinition<CR>
  nmap <buffer>rw :RSenseWhereIs<CR>
  nmap <buffer>rt :RSenseTypeHelp<CR>
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
" neosnippet
"------------------------------------
"{{{
au FileType snippet nmap <buffer><Space>e :e #<CR>

" nmap <C-H><C-H><C-R> :<C-U>CompassCreate<CR>
" nmap <C-H><C-H><C-B> :<C-U>BourbonInstall<CR>
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
" function! Sass_start()
"   let current_dir = expand('%:p:h')
"   if match(g:sass_started_dirs, '^'.current_dir.'$') == -1
"     call add(g:sass_started_dirs, current_dir)
"     call system('sass --watch ' . current_dir . ' &')
"   endif
" endfunction
" au! BufRead *.scss,*sass call Sass_start()
" au! Filetype scss,sass call Sass_start()

" au! BufWritePost sass,scss SassCompile
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
  let b:quickrun_config = {'type' : 'coffee'}
  nmap <buffer> <leader>m :JasmineRedGreen<CR>
  call jasmine#load_snippets()
  command! JasmineRedGreen :call jasmine#redgreen()
  command! JasmineMake :call jasmine#make()
endfunction
au BufRead,BufNewFile,BufReadPre *Helper.coffee,*Spec.coffee  call JasmineSetting()
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
let g:smartchr_enable = 1

" Smart =.

if g:smartchr_enable == 1
  " inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
  "       \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
  "       \ : smartchr#one_of(' = ', '=', ' == ')
  imap <expr> , smartchr#one_of(',', ', ')
  imap <expr> ? smartchr#one_of('?', '? ')
  " imap <expr> = smartchr#one_of(' = ', '=')

  " Smart =.
  " inoremap <expr> = search('\(&\<bar><bar>\<bar>+\<bar>-\<bar>/\<bar>>\<bar><\) \%#', 'bcn')? '<bs>= '
  "       \ : search('\(*\<bar>!\)\%#', 'bcn') ? '= '
  "       \ : smartchr#one_of(' = ', '=', ' == ')
  augroup MyAutoCmd
    " Substitute .. into -> .
    autocmd FileType c,cpp inoremap <buffer> <expr> . smartchr#loop('.', '->', '...')
    autocmd FileType perl,php imap <buffer> <expr> . smartchr#loop('.', '->', '..')
    autocmd FileType perl,php imap <buffer> <expr> - smartchr#loop('-', '->')
    autocmd FileType vim imap <buffer> <expr> . smartchr#loop('.', ' . ', '..', '...')
    autocmd FileType coffee <buffer> <expr> . smartchr#loop('-', '->', '=>')

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
" nmap <C-H><C-F> :NERDTreeToggle<CR>

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
      \ 'active_filetypes'  : ['ruby', 'php', 'js', 'javascript', 'less', 'coffee', 'scss', 'haml' ],
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
" let g:EasyMotion_do_shade = 1
" let g:EasyMotion_do_mapping = 0 " マッピングは自分で行う

" nmap <silent> f      :call EasyMotion#WB(0, 0)<CR>
" " nnoremap <silent> j<Tab>      :call EasyMotion#JK(0, 0)<CR>
" " nnoremap <silent> N<Tab>      :call EasyMotion#Search(0, 1)<CR>
" " nnoremap <silent> n<Tab>      :call EasyMotion#Search(0, 0)<CR>
" " nnoremap <silent> T<Tab>      :call EasyMotion#T(0, 1)<CR>
" " nmap <silent> F<Tab>      :call EasyMotion#F(0, 1)<CR>
" nmap <silent> <C-S>      :call EasyMotion#F(0, 0)<CR>
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
au FileType html,php,haml,scss,sass,less,coffee,ruby,javascript,python IndentGuidesEnable
nmap <silent><Leader>ig <Plug>IndentGuidesToggle
"}}}

"------------------------------------
" vimux
"------------------------------------
"{{{
" " Prompt for a command to run
" map <Leader>rp :VimuxPromptCommand<CR>
"
" " Run last command executed by VimuxRunCommand
" map <Leader>rl :VimuxRunLastCommand<CR>
"
" " Inspect runner pane
" map <Leader>ri :VimuxInspectRunner<CR>
"
" " Close all other tmux panes in current window
" map <Leader>rx :VimuxClosePanes<CR>
"
" " Close vim tmux runner opened by VimuxRunCommand
" map <Leader>rq :VimuxCloseRunner<CR>
"
" " Interrupt any command running in the runner pane
" map <Leader>rs :VimuxInterruptRunner<CR>
"
" " Prompt for a command to run
" nmap <LocalLeader>vp :VimuxPromptCommand<CR>
"
" " If text is selected, save it in the v buffer and send that buffer it to tmux
" vmap <LocalLeader>vs "vy :call VimuxRunCommand(@v . "\n", 0)<CR>
"
" " Select current paragraph and send it to tmux
" nmap <LocalLeader>vs vip<LocalLeader>vs<CR>
"}}}

"------------------------------------
" qiita
"------------------------------------
"{{{
nmap <C-H><C-Q> :unite qiita<CR>
"}}}

"------------------------------------
" webapi.vim
"------------------------------------
" nmap <C-J><C-L> :<C-U>call

"------------------------------------
" SQLUtils
"------------------------------------
"{{{
" let g:sqlutil_syntax_elements = 'Constant,sqlString'
let g:sqlutil_default_menu_mode = 3
let g:sqlutil_menu_priority = 30
" let g:sqlutil_menu_root = 'MyPlugin.&SQLUtil'
let g:sqlutil_use_syntax_support = 1
" let g:sqlutil_<tab> to cycle through the various option names.
" let g:sqlutil_cmd_terminator = "\ngo"
" let g:sqlutil_cmd_terminator = "\ngo\n"
" let g:sqlutil_cmd_terminator = ';'
let g:sqlutil_load_default_maps = 0
" let g:sqlutil_stmt_keywords = 'select,insert,update,delete,with,merge'
let g:sqlutil_use_tbl_alias = 'd|a|n'

let g:sqlutil_align_where = 1
let g:sqlutil_keyword_case = '\U'
let g:sqlutil_align_keyword_right = 0
let g:sqlutil_align_first_word = 1
let g:sqlutil_align_comma = 1
" vmap <leader>sf    <Plug>SQLU_Formatter<CR>
" nmap <leader>scl   <Plug>SQLU_CreateColumnList<CR>
" nmap <leader>scd   <Plug>SQLU_GetColumnDef<CR>
" nmap <leader>scdt  <Plug>SQLU_GetColumnDataType<CR>
" nmap <leader>scp   <Plug>SQLU_CreateProcedure<CR>
vmap sf :SQLUFormatter<CR>
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
autocmd FileType python let b:did_ftplugin = 1
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
let g:eskk#dictionary = { 'path': expand( "~/.eskk_jisyo" ), 'sorted': 0, 'encoding': 'utf-8', }
let g:eskk#large_dictionary = { 'path':  expand("~/.eskk_dict/SKK-JISYO.L"), 'sorted': 1, 'encoding': 'euc-jp', }
let g:eskk#cursor_color = {
      \   'ascii': ['#8b8b83', '#bebebe'],
      \   'hira': ['#8b3e2f', '#ffc0cb'],
      \   'kata': ['#228b22', '#00ff00'],
      \   'abbrev': '#4169e1',
      \   'zenei': '#ffd700',
      \}
imap <C-J> <Plug>(eskk:toggle)
" "}}}
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
au FileType css                  setl omnifunc=csscomplete#CompleteCSS
au FileType html,markdown        setl omnifunc=htmlcomplete#CompleteTags
au FileType javascript           setl omnifunc=javascriptcomplete#CompleteJS
au FileType sql                  setl omnifunc=sqlcomplete#Complete
au FileType python               setl omnifunc=pythoncomplete#Complete
au FileType xml                  setl omnifunc=xmlcomplete#CompleteTags
au FileType php                  setl omnifunc=phpcomplete#CompletePHP
au FileType c                    setl omnifunc=ccomplete#Complete

au FileType ruby.rspec           setl dict+=~/.vim/dict/rspec.dict
au FileType jasmine.coffee,jasmine.js setl dict+=~/.vim/dict/js.jasmine.dict
au FileType coffee,javascript    setl dict+=~/.vim/dict/jquery.dict
au FileType coffee               setl dict+=~/.vim/dict/coffee.dict,~/.vim/dict/javascript.dict
au FileType html,php,eruby       setl dict+=~/.vim/dict/html.dict

au FileType * nmap <buffer><expr><Space>d ':<C-U>e ~/.vim/dict/' . &filetype . '.dict<CR>'
au FileType dict nmap <buffer><Space>d :<C-U>e #<CR>

" 読み込む辞書をファイルによって変更
function! s:railsSetting()
  setl dict+=~/.vim/dict/rails.dict

  let filepath = expand("%:p")
  if filepath =~ 'app\/models/[/a-zA-Z_]\+.rb$'
    setl dict+=~/.vim/dict/rails.models.dict
  elseif filepath =~ 'app\/views\/[/a-zA-Z_.]\+.erb$'
    setl dict+=~/.vim/dict/rails.views.dict
  elseif filepath =~ 'app\/controllers\/[/a-zA-Z_]\+.rb$'
    setl dict+=~/.vim/dict/rails.controllers.dict
  elseif filepath =~ 'db\/migrate\/[/0-9a-zA-Z_]\+.rb$'
    setl dict+=~/.vim/dict/rails.migrate.dict
  else
    nmap <buffer><Space>d :<C-U>e ~/.vim/dict/rails.dict
  endif
endfunction
au User BufEnterRails call s:railsSetting()

" カスタムファイルタイプでも、自動でdictを読み込む
" そして、編集画面までさくっと移動。
func! s:auto_dict_setting()
  let dict_name = split( &ft, '.' )
  if !empty( dict_name )
    exe  "setl dict+=~/.vim/dict/".dict_name[0].".dict"
  endif

  exe  "setl dict+=~/.vim/dict/".&ft.".dict"
  nmap <buffer><expr><Space>dd ":e ~/.vim/dict/" . &ft .".dict<CR>"
endfunc
au FileType * call s:auto_dict_setting()

"----------------------------------------
" neocomplcache
" default config"{{{
let g:neocomplcache_use_vimproc=1
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_lock_buffer_name_pattern = '\*ku\*'
let g:neocomplcache_max_list = 300
" let g:neocomplcache_max_keyword_width = 40
" let g:neocomplcache_max_menu_width = 19
let g:neocomplcache_auto_completion_start_length = 1
" let g:neocomplcache_manual_completion_start_length = 0
" let g:neocomplcache_min_keyword_length = 2
" let g:neocomplcache_min_syntax_length = 4
let g:neocomplcache_cursor_hold_i_time = 300
" let g:neocomplcache_enable_insert_char_pre = 0
" let g:neocomplcache_enable_auto_select = 1
" let g:neocomplcache_enable_auto_delimiter = 1
let g:neocomplcache_caching_limit_file_size=1000000
let g:neocomplcache_tags_caching_limit_file_size=1000000
let g:neocomplcache_enable_camel_case_completion = 1
let g:neocomplcache_enable_underbar_completion = 1
let g:neocomplcache_ctags_program = "ctags"

" default config snippet
let g:neosnippet#snippets_directory = '~/.bundle/neosnippet/autoload/neosnippet/snippets,~/.vim/snippet'
let g:neocomplcache_snippets_disable_runtime_snippets=1
" let g:neocomplcache_text_mode_filetypes = { 'markdown' : 1, }
let g:neocomplcache_ignore_composite_filetype_lists = {
      \ 'ruby.spec'          : 'ruby',
      \ 'ruby.rails'          : 'ruby',
      \ 'javascirpt.jasmine' : 'javascript',
      \ 'coffee.jasmine'     : 'coffee',
      \ }
"}}}

" ファイルタイプ毎の辞書ファイルの場所"{{{
let g:neocomplcache_dictionary_filetype_lists = {
      \ 'default'    : '',
      \ 'java'       : $HOME.'/.vim/dict/java.dict',
      \ 'ruby'       : $HOME.'/.vim/dict/ruby.dict',
      \ 'ruby.rails' : $HOME.'/.vim/dict/rails.dict',
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
      \'ruby': expand('~/.vim/dict/ruby.dict'),
      \'ruby.rails': expand('~/.vim/dict/rails.dict'),
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
let g:neocomplcache_omni_patterns.coffee     = '[^. *\t](.\| )\w*\|\h\w*::'

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
nmap <Space>e :<C-U>NeoSnippetEdit -split<CR>
" imap <C-B> <Plug>(neosnippet_jump)
" smap <C-B> <Plug>(neosnippet_jump)
" nmap <C-B> a<C-\>
au BufRead,BufNewFile *.snip  setl filetype=snippet
au FileType dict nmap <buffer><Space>e :e #<CR>

inoremap <silent><expr><TAB>  pumvisible() ? "\<C-N>" : "\<TAB>"
inoremap <silent><expr><S-TAB> pumvisible() ? "\<C-P>" : "\<S-TAB>"
inoremap <silent><expr><BS>   neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><C-h>  neocomplcache#smart_close_popup()."\<C-h>"
" inoremap <expr><C-y>  neocomplcache#close_popup()
" inoremap <expr><C-e>  neocomplcache#cancel_popup()
" inoremap <silent><CR>  <C-R>=neocomplcache#smart_close_popup()<CR><CR>
" endwiseを使わない場合はこちら
" inoremap <silent><expr><CR>  neocomplcache#smart_close_popup() . "\<CR>"
" endwiseを使う場合はこちら
imap <expr><CR> neocomplcache#smart_close_popup() . "<CR>" . "<Plug>DiscretionaryEnd"
"}}}
"}}}

"----------------------------------------
"Tags関連 cTags使う場合は有効化"{{{
"http://vim-users.jp/2010/06/hack154/

let current_dir = expand("%:p:h")
set tags& tags-=tags tags+=./tags;

function! SetTags()
  if has('path_extra')
    set tags=./**/tags
    setl tags+=./../tags
    setl tags+=./../../tags
    setl tags+=./../../../tags
    setl tags+=./../../../../tags
    setl tags+=./../../../../../tags
    setl tags+=./../../../../../../tags
    setl tags+=./../../../../../../../tags
  endif
endfunction
au BufReadPost * call SetTags()

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
" コマンドの実行"{{{

"----------------------------------------
" phptohtml
"----------------------------------------
au Filetype php nmap <Leader>R :! phptohtml<CR>

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
" open window
" 画面分割を抽象的に行う
" ----------------------------------------
"{{{
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
nmap <Space>y :<C-U>OpenYard <C-R><C-W><CR>

" 指定したgemを開く
au User Rails nmap <buffer><C-J><C-B> :!bundle open<Space>
"}}}

" ----------------------------------------
" haml2html
" ----------------------------------------
"{{{
function! ConvertHamlToHtml(fileType)
  " 同じディレクトリに、pathというファイルを作り
  " `cat path` -> `../`
  " となっていれば、その相対パスディレクトリに保存する

  " 設定ファイルを読み込む
  let dir_name = expand("%:p:h")
  let save_path = ''
  if filereadable(dir_name . '/path')
    let save_path = readfile("path")[0]
  endif

  " 2html
  let current_file = expand("%")
  let target_file  = substitute(current_file, '.html', '', 'g')
  let target_file  = dir_name.'/'.save_path.substitute(target_file, '.'.expand("%:e").'$', '.html', 'g')

  " コマンドの分岐
  if a:fileType == 'eruby'
    " exec ":call vimproc#system('rm " .target_file"')"
    let convert_cmd  = 'erb ' . current_file . ' > ' . target_file
  elseif a:fileType == 'haml'
    " let convert_cmd  = 'haml_with_ruby2html ' . current_file . ' > ' . target_file
    let convert_cmd  = 'haml --format html4 ' . current_file . ' > ' . target_file
  endif

  echo "convert " . a:fileType . ' to ' . target_file
  exec ":call vimproc#system('" . convert_cmd . "')"
endfunction

function! HamlSetting()
  nmap <buffer><Leader>R :<C-U>call ConvertHamlToHtml("haml")<CR>
  au BufWritePost *.haml silent call ConvertHamlToHtml("haml")
endfunction
" au Filetype haml call HamlSetting()

function! ErubySetting()
  nmap <buffer><Leader>R :<C-U>call ConvertHamlToHtml("eruby")<CR>
  au BufWritePost *.erb silent call ConvertHamlToHtml("eruby")
endfunction
" au Filetype eruby call ErubySetting()
"}}}
" au Filetype eruby call ErubySetting()

" ----------------------------------------
" sass async compile
" ----------------------------------------

" function! ScssAsyncCompile()
"   let cmd = 'compass compile '. expand("%:p:h")
"   call vimproc#system_bg('apachectl stop')
" endfunction
" au BufWritePost *.scss call ScssAsyncCompile()


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

    nnoremap <silent>mm :<C-u>MacDictCWord<CR>
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

" ----------------------------------------
" プラットフォーム依存
" ----------------------------------------
" "{{{
"
if exists( 's:is_windows' )
  " For Windows"{{{

  " In Windows, can't find exe, when $PATH isn't contained $VIM.
  if $PATH !~? '\(^\|;\)' . escape($VIM, '\\') . '\(;\|$\)'
    let $PATH = $VIM . ';' . $PATH
  endif

  " Shell settings.
  " Use NYAOS.
  "set shell=nyaos.exe
  "set shellcmdflag=-e
  "set shellpipe=\|&\ tee
  "set shellredir=>%s\ 2>&1
  "set shellxquote=\"

  " Use bash.
  "set shell=bash.exe
  "set shellcmdflag=-c
  "set shellpipe=2>&1\|\ tee
  "set shellredir=>%s\ 2>&1
  "set shellxquote=\"

  " Change colorscheme.
  " Don't override colorscheme.
  if !exists('g:colors_name') && !has('gui_running')
    colorscheme darkblue
  endif
  " Disable error messages.
  let g:CSApprox_verbose_level = 0

  " Popup color.
  hi Pmenu ctermbg=8
  hi PmenuSel ctermbg=1
  hi PmenuSbar ctermbg=0
  "}}}
else
  " For Linux"{{{
  if exists('$WINDIR')
    " Cygwin.

    " Use bash.
    set shell=bash
  else
    " Use zsh.
    set shell=zsh
  endif

  " Set path.
  let $PATH = expand('~/bin').':/usr/local/bin/:'.$PATH

  " For non GVim.
  if !has('gui_running')
    " Enable 256 color terminal.
    if !exists('$TMUX')
      set t_Co=256

      " For screen."{{{
      if &term =~ '^screen'
        augroup MyAutoCmd
          " Show filename on screen statusline.
          " But invalid 'another' screen buffer.
          autocmd BufEnter * if $WINDOW != 0 &&  bufname("") !~ "[A-Za-z0-9\]*://"
                \ | silent! exe '!echo -n "kv:%:t\\"' | endif
          " When 'mouse' isn't empty, Vim will freeze. Why?
          autocmd VimLeave * :set mouse=
        augroup END

        " For Vim inside screen.
        set ttymouse=xterm2
      endif

      " For prevent bug.
      autocmd MyAutoCmd VimLeave * set term=screen
      "}}}
    endif

    if has('gui')
      " Use CSApprox.vim
      NeoBundleSource CSApprox

      " Convert colorscheme in Konsole.
      let g:CSApprox_konsole = 1
      let g:CSApprox_attr_map = {
            \ 'bold' : 'bold',
            \ 'italic' : '', 'sp' : ''
            \ }
      if !exists('g:colors_name')
        colorscheme candy
      endif
    else
      " Use guicolorscheme.vim
      NeoBundleSource guicolorscheme.vim

      autocmd MyAutoCmd VimEnter,BufAdd *
            \ if !exists('g:colors_name') | GuiColorScheme candy

      " Disable error messages.
      let g:CSApprox_verbose_level = 0
    endif

    " Change cursor shape.
    if &term =~ "xterm"
      let &t_SI = "\<Esc>]12;lightgreen\x7"
      let &t_EI = "\<Esc>]12;white\x7"
    endif
  endif

  "}}}
endif

"}}}
"}}}

set secure
