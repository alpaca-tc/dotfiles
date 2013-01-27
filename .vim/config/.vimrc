aug MyAutoCmd
  au!
aug END

call alpaca#init()

" 学習用
imap <BS> <Nop>
imap <ESC> <Nop>

"----------------------------------------
" initialize"{{{
let g:my = {}

" ユーザー情報"{{{
let g:my.info = {
      \ "date" : alpaca#function#today(),
      \ "author": 'Ishii Hiroyuki',
      \ }

let g:my.github = {
      \ "url" : 'https://github.com/',
      \ "user": 'taichouchou2',
      \ }

let g:my.lingr = {
      \ "user" : 'alpaca_taichou'
      \ }
"}}}
" 設定 {{{
let g:my.conf = {
      \ "initialize" : 1,
      \ "tags": {
      \   "auto_create" : 1,
      \   "append"      : 1,
      \   "ctags_opts"  : '--sort=yes --exclude=log --exclude=.git -R',
      \ },
      \ }
"}}}
" path"{{{
let g:my.bin = {
      \ "ri" : expand('~/.rbenv/versions/1.9.3-p125/bin/ri'),
      \ "ctags" : expand('/Applications/MacVim.app/Contents/MacOS/ctags'),
      \ }

let g:my.dir = {
      \ "trash_dir" : expand('~/.Trash/'),
      \ "swap_dir"  : expand('~/.Trash/vimswap'),
      \ "bundle"    : expand('~/.bundle'),
      \ "vimref"    : expand('~/.Trash/vim-ref'),
      \ "memolist"  : expand('~/.memolist'),
      \ "ctrlp"     : expand('~/.Trash/ctrlp'),
      \ "snippets"  : expand('~/.vim/snippet'),
      \ }
"}}}
" その他設定"{{{
let g:my.ft = {
      \ "html_files"    : ['eruby', 'html', 'php', 'haml'],
      \ "ruby_files"    : ['ruby', 'Gemfile', 'haml', 'eruby', 'yaml'],
      \ "js_files"      : ['javascript', 'coffeescript', 'node', 'json', 'typescript'],
      \ "python_files"  : ['python'],
      \ "scala_files"   : ['scala'],
      \ "sh_files"      : ['sh'],
      \ "php_files"     : ['php', 'phtml'],
      \ "style_files"   : ['css', 'scss', 'sass'],
      \ "markup_files"  : ['html', 'haml', 'erb', 'php'],
      \ "program_files" : ['ruby', 'php', 'python', 'eruby', 'vim'],
      \ "ignore_patterns" : ['vimfiler', 'unite'],
      \ }

" TODO インストールするプログラムを書く
let g:my.install = {
      \ "gem" : ['alpaca_complete', 'CoffeeTags', 'rails', 'bundler', 'i18n', 'coffee-script',],
      \ "homebrew" : ['scala', 'sbt'],
      \ }
"}}}
" OS"{{{
let s:is_windows = has('win32') || has('win64')
let s:is_mac     = has('mac')
let s:is_unix    = has('unix')
"}}}
" XXX コードは見てないけど、uniteのkindに同じ機能があるような。
function! s:current_git() "{{{
  let git_root_dir = alpaca#system('git rev-parse --show-cdup')
  " XXX vimscriptにtrim的なの無いの？
  let git_root_dir = substitute(git_root_dir, '\n', '', 'g')

  return fnamemodify(git_root_dir, ':p')
endfunction"}}}
function! s:git_exists() "{{{
  return aplaca#system('git rev-parse --is-inside-work-tree') == "true\n"
endfunction"}}}

" initialze functions {{{
let g:my.initialize_funcs = {
      \   "directory": {
      \     "active" : 1,
      \   },
      \ }
"}}}
if g:my.conf.initialize "{{{
  call alpaca#initialize#directory()
endif"}}}
"}}}

"----------------------------------------
"基本"{{{
let mapleader = ","
exe "set directory=".g:my.dir.swap_dir
set backspace=indent,eol,start
set browsedir=buffer
set clipboard+=autoselect
set clipboard+=unnamed
set formatoptions+=lcqmM formatoptions-=ro
set helplang=ja,en
set modelines=1
set mouse=a
set nobackup
set norestorescreen=off
set showmode
set timeout timeoutlen=300 ttimeoutlen=100
set viminfo='100,<800,s300,\"300
set visualbell t_vb=

if v:version >= 703
  set undofile
  let &undodir=&directory
endif

nnoremap <Space><Space>s :<C-U>source ~/.vimrc<CR>
nnoremap <Space><Space>v :<C-U>tabnew ~/.vim/config/.vimrc<CR>
"}}}

"----------------------------------------
" neobundle"{{{
filetype plugin indent off     " required!

let g:neobundle#types#git#default_protocol = 'https'

" initialize"{{{
if has('vim_starting')
  let s:bundle_dir = g:my.dir.bundle

  if g:my.conf.initialize && !isdirectory(s:bundle_dir.'/neobundle.vim')
    call system( 'git clone https://github.com/Shougo/neobundle.vim.git '. s:bundle_dir . '/neobundle.vim')
  endif

  exe 'set runtimepath+='.s:bundle_dir.'/neobundle.vim'
  call neobundle#rc(s:bundle_dir)
endif
"}}}

" 暫定customize {{{
function! Neo_al(ft) "{{{
  return { 'autoload' : {
      \ 'filetype' : a:ft
      \ }}
endfunction"}}}
function! BundleLoadDepends(bundle_names) "{{{
  if !exists('s:loaded_bundles')
    let s:loaded_bundles = {}
  endif

  " bundleの読み込み
  if !has_key( s:loaded_bundles, a:bundle_names )
    execute 'NeoBundleSource '.a:bundle_names
    let s:loaded_bundles[a:bundle_names] = 1
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
" 基本 / その他 {{{
NeoBundleFetch 'Shougo/neobundle.vim'
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \     'mac' : 'make -f make_mac.mak',
      \     'unix' : 'make -f make_unix.mak',
      \    },
      \ }
NeoBundleLazy 'taichouchou2/alpaca', {
      \ 'build' : {
      \     'mac'  : 'sh fonts/ricty_generator.sh fonts/Inconsolata.otf fonts/migu-1m-regular.ttf fonts/migu-1m-bold.ttf',
      \     'unix' : 'sh fonts/ricty_generator.sh fonts/Inconsolata.otf fonts/migu-1m-regular.ttf fonts/migu-1m-bold.ttf',
      \    },
      \ }
NeoBundle 'tpope/vim-fugitive', { 'autoload' : { 'commands': ['Gcommit', 'Gblame', 'Ggrep', 'Gdiff'] }}
NeoBundleLazy 'scrooloose/syntastic', { 'autoload': {
      \ 'filetypes' : g:my.ft.program_files}}
NeoBundleLazy 'taichouchou2/alpaca_powerline', {
      \ 'depends': ['majutsushi/tagbar', 'tpope/vim-fugitive', 'basyura/TweetVim', 'basyura/twibill.vim',],
      \ 'autoload' : { 'functions': ['Pl#UpdateStatusline', 'Pl#Hi#Allocate', 'Pl#Hi#Segments', 'Pl#Colorscheme#Init',]  }}
au BufEnter,WinEnter,FileType,BufUnload,CmdWinEnter * call Pl#UpdateStatusline(1)

NeoBundleLazy 'mattn/webapi-vim'
"}}}
" vim拡張"{{{
" NeoBundle 'taku-o/vim-toggle' "true<=>false など、逆の意味のキーワードを切り替えられる
" NeoBundle 'yuroyoro/vimdoc_ja'
" NeoBundle 'kana/vim-altr' " 関連するファイルを切り替えれる

" Shougo"{{{
NeoBundle 'Shougo/unite.vim'
call neobundle#config('unite.vim', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'commands' : [ {
      \     'name' : 'Unite',
      \     'complete' : 'customlist,unite#complete_source'},
      \     'UniteBookmarkAdd', 'UniteClose', 'UniteResume',
      \     'UniteWithBufferDir', 'UniteWithCurrentDir', 'UniteWithCursorWord',
      \     'UniteWithInput', 'UniteWithInputDirectory']
      \ }})

NeoBundleLazy 'Shougo/unite-build', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload': { 'filetypes' : g:my.ft.scala_files }
      \ }
NeoBundleLazy 'Shougo/unite-outline', {
      \ 'depends' : 'Shougo/unite.vim' }
" NeoBundle 'Shougo/vimfiler'
" call neobundle#config('vimfiler', {
"       \ 'lazy' : 1,
"       \ 'depends' : 'Shougo/unite.vim',
"       \ 'autoload' : {
"       \   'commands' : [ {
"       \     'name' : 'VimFiler',
"       \     'complete' : 'customlist,vimfiler#complete' },
"       \     'VimFiler', 'VimFilerBufferDir', 'VimFilerClose', 'VimFilerCreate', 'VimFilerCurrentDir', 'VimFilerDetectDrives', 'VimFilerDouble', 'VimFilerExplorer', 'VimFilerExplorerGit', 'VimFilerSimple'],
"       \   'mappings' : ['<Plug>(vimfiler_switch)']
"       \ }
"       \ })
NeoBundle 'Shougo/vimfiler'
call neobundle#config('vimfiler', {
      \ 'lazy' : 1,
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \    'commands' : [{ 'name' : 'VimFiler',
      \                    'complete' : 'customlist,vimfiler#complete' },
      \                   'VimFilerBufferDir', 'VimFilerExplorer', 'Edit', 'Read', 'Source', 'Write'],
      \    'mappings' : ['<Plug>(vimfiler_switch)']
      \ }
      \ })
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
" }}}
NeoBundleLazy 'Shougo/git-vim', { 'autoload' : { 'commands': ["GitDiff", "GitLog", "GitAdd", "Git", "GitCommit", "GitBlame", "GitBranch", "GitPush"] }}
NeoBundle 'Shougo/neocomplcache'
call neobundle#config('neocomplcache', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'insert' : 1,
      \ }})
NeoBundle 'Shougo/echodoc'
call neobundle#config('echodoc', {
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'insert' : 1,
      \ }})
NeoBundle 'Shougo/neosnippet'
call neobundle#config('neosnippet', {
      \ 'autoload' : {
      \   'commands' : ['NeoSnippetEdit'],
      \   'filetypes' : 'snippet',
      \   'insert' : 1,
      \ }})
NeoBundle 'Shougo/vimshell'
call neobundle#config('vimshell',{
      \ 'lazy' : 1,
      \ 'autoload' : {
      \   'commands' : [{
      \     'name' : 'VimShell',
      \     'complete' : 'customlist,vimshell#complete'},
      \     'VimShellExecute', 'VimShellInteractive', 'VimShellTerminal', 'VimShellPop'],
      \   'mappings' : ['<Plug>(vimshell_switch)']
      \ }})
"}}}
" commands"{{{
NeoBundleLazy 'vim-scripts/sudo.vim', {
      \ 'autoload': { 'commands': ['SudoRead', 'SudoWrite'], 'insert': 1 }
      \ }
NeoBundle 'h1mesuke/vim-alignta', { 'autoload' : { 'commands' : ['Align'] } }
NeoBundleLazy 'grep.vim', { 'autoload' : { 'commands': ["Grep", "Rgrep"] }}
NeoBundleLazy 'kien/ctrlp.vim', { 'autoload' : { 'commands' : ['CtrlPBuffer', 'CtrlPDir', 'CtrlPCurFile']}}
NeoBundleLazy 'sjl/gundo.vim', { 'autoload' : { 'commands': ["GundoToggle", 'GundoRenderGraph'] }}
NeoBundleLazy 'majutsushi/tagbar', {
      \ 'autoload' : {
      \   'commands': ["TagbarToggle", "TagbarTogglePause"],
      \   'fuctions': ['tagbar#currenttag']
      \ }}
NeoBundleLazy 'yuratomo/w3m.vim', {
      \ 'build' : {
      \   'mac' : 'brew install w3m',
      \   'unix': 'sudo yum install w3m',
      \ },
      \ 'autoload' : { 'commands' : 'W3m' }}
NeoBundleLazy 'open-browser.vim', { 'autoload' : {
      \ 'mappings' : [ '<Plug>(open-browser-wwwsearch)', '<Plug>(openbrowser-open)',  ],
      \ 'commands' : ['OpenBrowserSearch']
      \ }}
NeoBundleLazy 'thinca/vim-ref', { 'autoload' : {
      \ 'commands' : 'Ref',
      \ 'mappings' : ['n', 'K'],
      \ }}
NeoBundle 'tomtom/tcomment_vim', { 'autoload' : { 'commands' : ['TComment', 'TCommentAs', 'TCommentMaybeInline'] } }
NeoBundleLazy 'tyru/caw.vim', {
      \ 'autoload' : {
      \   'insert' : 1,
      \   'mappings' : [ '<Plug>(caw:prefix)', '<Plug>(caw:i:toggle)'],
      \ }}
NeoBundleLazy 'mattn/gist-vim', {
      \ 'depends': ['mattn/webapi-vim' ],
      \ 'autoload' : {
      \ 'commands' : 'Gist'
      \ }}
NeoBundleLazy 'thinca/vim-quickrun', { 'autoload' : {
      \ 'mappings' : [
      \   ['nxo', '<Plug>(quickrun)']],
      \ 'commands' : 'QuickRun',
      \ }}
"}}}
" extend mappings"{{{
NeoBundleLazy 'tyru/eskk.vim', { 'autoload' : {
      \ 'mappings' : [['i', '<Plug>(eskk:toggle)']],
      \ }}
NeoBundleLazy 'kana/vim-arpeggio', { 'autoload': { 'functions': ['arpeggio#map'] }}
NeoBundleLazy 'camelcasemotion', { 'autoload' : {
      \ 'mappings' : ['<Plug>CamelCaseMotion_w', '<Plug>CamelCaseMotion_b', '<Plug>CamelCaseMotion_e', '<Plug>CamelCaseMotion_iw', '<Plug>CamelCaseMotion_ib', '<Plug>CamelCaseMotion_ie']
      \ }}
NeoBundleLazy 'rhysd/clever-f.vim', { 'autoload' : {
      \   'mappings' : 'f',
      \ }}
NeoBundleLazy 'mattn/zencoding-vim', {
      \ 'autoload': {
      \   'functions': ['zencoding#expandAbbr'],
      \   'filetypes': g:my.ft.html_files,
      \   'insert'   : 1
      \ }}
NeoBundleLazy 'kana/vim-smartword', '', 'same', { 'autoload' : {
      \ 'mappings' : [
      \   '<Plug>(smartword-w)', '<Plug>(smartword-b)', '<Plug>(smartword-ge)']
      \ }}
NeoBundleLazy 't9md/vim-textmanip', { 'autoload' : {
      \ 'mappings' : [
      \   '<Plug>(textmanip-move-down)', '<Plug>(textmanip-move-up)',
      \   '<Plug>(textmanip-move-left)', '<Plug>(textmanip-move-right)'],
      \ }}
NeoBundle 'edsono/vim-matchit', { 'autoload' : {
      \ 'mappings' : ['nx', '%'] }}
NeoBundleLazy 'rhysd/accelerated-jk', {
      \ 'autoload' : {
      \   'mappings' : [
      \     ['n', '<Plug>(accelerated_jk_gj)'], ['n', '<Plug>(accelerated_jk_gk)']
      \ ]}}
NeoBundleLazy 'tpope/vim-surround', {
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>Dsurround'], ['nx', '<Plug>Csurround'],
      \     ['nx', '<Plug>Ysurround'], ['nx', '<Plug>YSurround'],
      \     ['nx', '<Plug>Yssurround'], ['nx', '<Plug>YSsurround'],
      \     ['nx', '<Plug>YSsurround'], ['vx', '<Plug>VgSurround'],
      \     ['vx', '<Plug>VSurround']
      \ ]}}

" extend vim
" NeoBundle 'kana/vim-fakeclip', { 'autoload' : {
"       \ 'mappings' : [
"       \   ['nv', '<Plug>(fakeclip-y)'], ['nv', '<Plug>(fakeclip-Y)'],
"       \   ['nv', '<Plug>(fakeclip-p)'], ['nv', '<Plug>(fakeclip-P)'],
"       \   ['nv', '<Plug>(fakeclip-gp)']]
"       \ }}
NeoBundleLazy 'nathanaelkane/vim-indent-guides', {
      \ 'autoload': {
      \   'commands': 'IndentGuidesEnable',
      \   'filetypes': g:my.ft.program_files,
      \ }}
"}}}
" 補完"{{{
NeoBundleLazy 'yomi322/vim-gitcomplete', { 'autoload' : {
      \ 'filetype' : 'vimshell'
      \ }}
" NeoBundleLazy 'taichouchou2/alpaca_look.git', {
"       \ 'autoload' : {
"       \   'insert' : 1,
"       \ }}
"}}}
" text-object拡張"{{{
" NeoBundle 'emonkak/vim-operator-comment'
" NeoBundle 'https://github.com/kana/vim-textobj-jabraces.git'
" NeoBundle 'kana/vim-textobj-datetime'      " d 日付
" NeoBundle 'kana/vim-textobj-fold.git'      " z 折りたたまれた{{ {をtext-objectに
" NeoBundle 'kana/vim-textobj-lastpat.git'   " /? 最後に検索されたパターンをtext-objectに
" NeoBundle 'kana/vim-textobj-syntax.git'    " y syntax hilightされたものをtext-objectに
" NeoBundle 'textobj-entire'                 " e buffer全体をtext-objectに
" NeoBundle 'thinca/vim-textobj-comment'     " c commentをtext-objectに
" NeoBundle 'kana/vim-textobj-function.git'  " f 関数をtext-objectに
" NeoBundleLazy 'kana/vim-operator-user'
" NeoBundleLazy 'kana/vim-textobj-user'
"
" NeoBundleLazy 'kana/vim-textobj-indent.git', {
"       \ 'depends' : 'kana/vim-textobj-user',
"       \ 'autoload': {
"       \   'mappings' : [
"       \     ['nx', '<Plug>(textobj-indent-a)' ], ['nx', '<Plug>(textobj-indent-i)'],
"       \     ['nx', '<Plug>(textobj-indent-same-a)'], ['nx', '<Plug>(textobj-indent-same-i)']
"       \ ]}}
NeoBundle 'operator-camelize', {
      \ 'depends' : 'kana/vim-operator-user',
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>(operator-camelize)'], ['nx', '<Plug>(operator-decamelize)']
      \ ]}}
" NeoBundle 'tyru/operator-html-escape.vim'
"}}}
"}}}
" unite"{{{
NeoBundleLazy 'thinca/vim-qfreplace', '', 'same', { 'autoload' : {
      \ 'filetypes' : ['unite', 'quickfix'],
      \ }}
NeoBundleLazy 'tacroe/unite-mark'
NeoBundleLazy 'tsukkee/unite-tag', { 'depends' :
      \ ['Shougo/unite.vim'] }
NeoBundleLazy 'Shougo/unite-ssh', {
      \ 'depends' : ['Shougo/unite.vim', 'Shougo/vimproc', 'Shougo/vimfiler'],
      \ 'autoload' : {
      \   'mappings' : ['n', '[unite]s'],
      \ }
      \ }
NeoBundleLazy 'choplin/unite-vim_hacks'
NeoBundleLazy 'taichouchou2/vim-unite-giti'
NeoBundleLazy 'hrsh7th/vim-versions', {
      \ 'autoload' : {'functions' : 'versions#info', 'commands' : 'UniteVersions'},
      \ }
NeoBundleLazy 'thinca/vim-unite-history'
NeoBundleLazy 'ujihisa/vimshell-ssh', { 'autoload' : {
      \ 'filetypes' : 'vimshell',
      \ }}
NeoBundleLazy 'ujihisa/unite-locate'
NeoBundleLazy 'basyura/TweetVim', { 'depends' :
      \ ['basyura/twibill.vim', 'tyru/open-browser.vim', 'Shougo/unite.vim'],
      \ 'autoload' : { 'commands' : [ 'TweetVimAccessToken', 'TweetVimAddAccount', 'TweetVimBitly', 'TweetVimCommandSay', 'TweetVimCurrentLineSay', 'TweetVimHomeTimeline', 'TweetVimListStatuses', 'TweetVimMentions', 'TweetVimSay', 'TweetVimSearch', 'TweetVimSwitchAccount', 'TweetVimUserTimeline', 'TweetVimVersion' ] }}
NeoBundleLazy 'ujihisa/unite-font', '', 'same', {
      \ 'gui' : 1,
      \ }
"}}}
" その他 / テスト {{{
" NeoBundle 'kana/vim-smartchr' "smartchr.vim : ==()などの前後を整形
NeoBundleLazy 'tyru/restart.vim', '', 'same', {
      \ 'gui' : 1,
      \ 'autoload' : {
      \  'commands' : 'Restart'
      \ }}
NeoBundleLazy 'glidenote/memolist.vim', { 'depends' :
      \ ['Shougo/unite.vim'],
      \ 'autoload' : { 'commands' : ['MemoNew', 'MemoGrep'] }}
NeoBundleLazy 'DirDiff.vim', '', 'same', { 'autoload' : {
      \ 'commands' : 'DirDiff'
      \ }}
"}}}
" bundle.lang"{{{

" css
" ----------------------------------------
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'autoload' : {
      \   'filetypes' : g:my.ft.style_files,
      \ }}

" html
" ----------------------------------------
NeoBundleLazy 'taichouchou2/html5.vim', { 'autoload' : {
      \   'filetypes' : g:my.ft.markup_files,
      \ }}

" haml
" ----------------------------------------
NeoBundleLazy 'tpope/vim-haml', { 'autoload' : {
      \   'filetypes' : ['haml'],
      \ }}

" haskell
" ----------------------------------------
NeoBundleLazy 'ujihisa/neco-ghc', { 'autoload' : {
      \ 'filetypes' : 'haskell'
      \ }}

"  js / coffee
" ----------------------------------------
NeoBundleLazy 'kchmck/vim-coffee-script', { 'autoload' : {
      \ 'filetypes' : 'coffee'
      \ }}
NeoBundleLazy 'claco/jasmine.vim', { 'autoload' : {
      \ 'filetypes' : g:my.ft.js_files
      \ }}
" NeoBundleLazy 'taichouchou2/vim-javascript', { 'autoload' : {
"       \ 'filetypes' : ['javascript']
"       \ }}
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', { 'autoload' : {
      \ 'filetypes' : 'javascript',
      \ }}
NeoBundleLazy 'jelera/vim-javascript-syntax', { 'autoload' : {
      \ 'filetypes' : 'javascript',
      \ }}
NeoBundleLazy 'taichouchou2/vim-json', { 'autoload' : {
      \ 'filetypes' : g:my.ft.js_files
      \ }}
NeoBundleLazy 'teramako/jscomplete-vim', { 'autoload' : {
      \ 'filetypes' : g:my.ft.js_files
      \ }}
NeoBundleLazy 'leafgarland/typescript-vim', { 'autoload' : {
      \ 'filetypes' : ['typescript']
      \ }}

"  go
" ----------------------------------------
NeoBundleLazy 'fsouza/go.vim', { 'autoload' : {
      \ 'filetypes' : ['go'] }}

"  markdown
" ----------------------------------------
" markdownでの入力をリアルタイムでチェック
" NeoBundle 'mattn/mkdpreview-vim'
NeoBundleLazy 'tpope/vim-markdown', { 'autoload' : {
      \ 'filetypes' : ['markdown'] }}

" sassのコンパイル
NeoBundleLazy 'AtsushiM/sass-compile.vim', {
      \ 'autoload': { 'filetypes': ['sass', 'scss'] }}

"  php
" ----------------------------------------
" NeoBundle 'oppara/vim-unite-cake'
NeoBundleLazy 'taichouchou2/alpaca_wordpress.vim', { 'autoload' : {
      \ 'filetypes': 'php' }}

"  binary
" ----------------------------------------
NeoBundleLazy 'Shougo/vinarise', {
      \ 'depends': ['s-yukikaze/vinarise-plugin-peanalysis'],
      \ 'autoload': { 'commands': 'Vinarise'}}

" html
" ----------------------------------------
NeoBundleLazy 'koron/chalice', {
      \ 'depends': ['ynkdir/vim-funlib'],
      \ 'autoload': { 'functions': ['AL_urlencode', 'AL_urldecode'] }}

" objective-c
" ----------------------------------------
" NeoBundle 'msanders/cocoa.vim'

" ruby
" ----------------------------------------
NeoBundle 'taichouchou2/vim-rails'
NeoBundleLazy 'taichouchou2/vim-endwise.git', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}

" rails
NeoBundleLazy 'basyura/unite-rails', {
      \ 'depends' : 'Shougo/unite.vim' }
NeoBundleLazy 'taichouchou2/unite-rails_best_practices', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'build' : {
      \    'mac': 'gem install rails_best_practices',
      \    'unix': 'gem install rails_best_practices',
      \   }
      \ }
NeoBundleLazy 'ujihisa/unite-rake', {
      \ 'depends' : 'Shougo/unite.vim', }
NeoBundleLazy 'taichouchou2/alpaca_complete', {
      \ 'depends' : 'taichouchou2/vim-rails',
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
NeoBundleLazy 'ruby-matchit', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'skwp/vim-rspec', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'taka84u9/vim-ref-ri', {
      \ 'depends': ['Shougo/unite.vim', 'thinca/vim-ref'],
      \ 'autoload': { 'filetypes': g:my.ft.ruby_files } }
NeoBundleLazy 'vim-ruby/vim-ruby', { 'autoload': {
      \ 'mappings' : '<Plug>(ref-keyword)',
      \ 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'Shougo/unite-help'
NeoBundleLazy 'taichouchou2/unite-reek', {
      \ 'build' : {
      \    'mac': 'gem install reek',
      \    'unix': 'gem install reek',
      \ },
      \ 'autoload': { 'filetypes': g:my.ft.ruby_files },
      \ 'depends' : 'Shougo/unite.vim' }
" NeoBundleLazy 'Shougo/neocomplcache-rsense', {
"       \ 'depends': 'Shougo/neocomplcache',
"       \ 'autoload': { 'filetypes': 'ruby' }}
NeoBundleLazy 'taichouchou2/rsense-0.3', {
      \ 'build' : {
      \    'mac': 'ruby etc/config.rb > ~/.rsense',
      \    'unix': 'ruby etc/config.rb > ~/.rsense',
      \ } }
NeoBundleLazy 'rhysd/unite-ruby-require.vim', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'rhysd/vim-textobj-ruby', { 'depends': 'kana/vim-textobj-user' }
" NeoBundleLazy 'deris/vim-textobj-enclosedsyntax', { 'autoload': {
"       \ 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'ujihisa/unite-gem', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload': { 'filetypes': g:my.ft.ruby_files }}
NeoBundleLazy 'rhysd/neco-ruby-keyword-args', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files}}

NeoBundleLazy 'tpope/vim-cucumber', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'mutewinter/nginx.vim', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files}}

" python
" ----------------------------------------
" NeoBundle 'Pydiction'
NeoBundleLazy 'yuroyoro/vim-python',
      \ Neo_al(g:my.ft.python_files)
NeoBundleLazy 'davidhalter/jedi-vim', {
      \ 'build' : {
      \     'mac' : 'git submodule update --init',
      \     'unix' : 'git submodule update --init',
      \    },
      \ 'autoload' : { 'filetypes': g:my.ft.python_files }
      \ }
" NeoBundleLazy 'kevinw/pyflakes-vim'

" scala
" ----------------------------------------
NeoBundleLazy 'taichouchou2/vim-scala', { 'autoload': {
      \ 'filetypes' : g:my.ft.scala_files }}
" NeoBundleLazy 'aemoncannon/ensime', {
"       \ "branch" : "scala-2.9",
"       \ 'autoload' : { 'filetypes' : g:my.ft.scala_files }}
" NeoBundleLazy 'taichouchou2/vimside', {
"       \ 'depends': [
"       \   'megaannum/self', 'megaannum/forms',
"       \   'Shougo/vimproc', 'Shougo/vimshell',
"       \   'aemoncannon/ensime',
"       \ ],
"       \ 'autoload' : { 'filetypes' : g:my.ft.scala_files }}
NeoBundle 'andreypopp/ensime'

" https://github.com/derekwyatt/vim-scala.git

" sh
" ----------------------------------------
NeoBundleLazy 'sh.vim', { 'autoload': {
      \ 'filetypes': g:my.ft.sh_files }}
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
NeoBundleLazy 'thinca/vim-scouter', '', 'same', { 'autoload' : {
      \ 'commands' : 'Scouter'
      \ }}
"}}}
" Installation check. "{{{
if g:my.conf.initialize && neobundle#exists_not_installed_bundles()
  echomsg 'Not installed bundles : ' .
        \ string(neobundle#get_not_installed_bundle_names())
  echomsg 'Install Plugins'
  NeoBundleInstall
endif
"}}}
filetype plugin indent on
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

" 開いているファイルのディレクトリに自動で移動
aug MyAutoCmd
  au BufEnter * execute ":silent! lcd! " . expand("%:p:h")
aug END

" 新しいバッファを開くときに、rubyか同じファイルタイプで開く {{{
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
" 対応を補完 {{{
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
aug MyAutoCmd
  au FileType scala inoremap <buffer>' '
  au FileType ruby,eruby,haml inoremap <buffer>\| \|\|<Left>
aug END
augroup MyXML
  au!
  au Filetype xml,html,eruby inoremap <buffer> </ </<C-x><C-o>
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
inoremap <C-D><C-D> <C-R>=g:my.info.date<CR>
inoremap <C-D><C-R> <C-R>=<SID>current_git()<CR>
nnoremap re :%s!
xnoremap re :s!
xnoremap rep y:%s!<C-r>=substitute(@0, '!', '\\!', 'g')<Return>!!g<Left><Left>
nnoremap <Leader>f :setl ft=
"}}}
" コメントを書くときに便利 {{{
inoremap <leader>* ****************************************
inoremap <leader>- ----------------------------------------
inoremap <leader>h <!-- / --><left><left><left><Left>
"}}}
" 変なマッピングを修正 "{{{
nnoremap ¥ \
inoremap ¥ \
cmap ¥ \
smap ¥ \

inoremap <C-R> <C-R><C-R>
inoremap <C-R><C-R> <C-R>"
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

" htmlをescape {{{
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

au Filetype php nnoremap <Leader>R :! phptohtml<CR>

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
set hlsearch
set ignorecase
set incsearch
set smartcase
set wrapscan
"grepをしたときにQuickFixで表示するようにする
set grepprg=grep\ -nH
nnoremap <silent> n nvv
nnoremap <silent> N Nvv

nnoremap <silent>mc :<C-u>call alpaca#function#macdict#close()<CR>
nnoremap <silent>mf :<C-u>call alpaca#function#macdict#focus()<CR>
nnoremap <silent>mo :<C-u>call alpaca#function#macdict#with_cursor_word()<CR>
"}}}

"----------------------------------------
"移動"{{{
set virtualedit+=block
set whichwrap=b,s,h,l,~,<,>,[,]
" set virtualedit=all " 仮想端末

" 基本的な動き {{{
inoremap <silent><C-K> <End>
inoremap <silent><C-L> <Right>
inoremap <silent><C-O> <Esc>o
inoremap jj <Esc>
nnoremap $ g_
xnoremap $ g_
nnoremap <silent><Down> gj
nnoremap <silent><Up>   gk
nnoremap <silent>j gj
nnoremap <silent>k gk

xnoremap H <Nop>
xnoremap v G
"}}}
" 画面の移動 {{{
nnoremap <C-L> <C-T>
nnoremap <silent>L            :call <SID>NextWindowOrTab()<CR>
nnoremap <silent>H            :call <SID>PreviousWindowOrTab()<CR>
nnoremap <silent><C-W>]       :call PreviewWord()<CR>
nnoremap <silent><C-W><Space> :<C-u>SmartSplit<CR>
"}}}
" tabを使い易く{{{

nmap [tag_or_tab] <Nop>
nmap t [tag_or_tab]
nnoremap <silent>[tag_or_tab]n  :tabnext<CR>
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
set ambiwidth=double
set encoding=utf-8
set fileencodings=utf-8,sjis,shift-jis,euc-jp,utf-16,ascii,ucs-bom,cp932,iso-2022-jp
set fileformats=unix,dos,mac
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set termencoding=utf8

command! -bang -bar -complete=file -nargs=? Cp932 edit<bang> ++enc=cp932 <args>
command! -bang -bar -complete=file -nargs=? Euc edit<bang> ++enc=euc-jp <args>
command! -bang -bar -complete=file -nargs=? Iso2022jp edit<bang> ++enc=iso-2022-jp <args>
command! -bang -bar -complete=file -nargs=? Jis  Iso2022jp<bang> <args>
command! -bang -bar -complete=file -nargs=? Sjis  Cp932<bang> <args>
command! -bang -bar -complete=file -nargs=? Unicode Utf16<bang> <args>
command! -bang -bar -complete=file -nargs=? Utf16 edit<bang> ++enc=ucs-2le <args>
command! -bang -bar -complete=file -nargs=? Utf16be edit<bang> ++enc=ucs-2 <args>
command! -bang -bar -complete=file -nargs=? Utf8 edit<bang> ++enc=utf-8 <args>
"}}}

"----------------------------------------
"インデント"{{{
set autoindent
set expandtab
set shiftwidth=2
set smartindent
set smarttab
set softtabstop=2
set tabstop=2
filetype indent on
"}}}

"----------------------------------------
"表示"{{{
" set noequalalways     " 画面の自動サイズ調整解除
" set relativenumber    " 相対表示
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
set showtabline=2
set ttyfast

function! MyTabLine() "{{{
  let tablines = []

  for i in range(tabpagenr('$'))
    if i + 1 == tabpagenr()
      let type = '%#TabLineSel#'
    else
      let type = '%#TabLine#'
    endif

    " let page_number = '%' . (i + 1) . 'T'

    let label = ' %{MyTabLabel(' . (i + 1) . ')} '

    let tabline = join(
          \ [type, '[', i,': ', MyTabLabel(i), ' ]', '%#TabLineFill# '],
          \ '' )
    call add( tablines, tabline )
  endfor

  " 最後のタブページの後は TabLineFill で埋め、タブページ番号をリセッ
  " トする
  call add( tablines, '%#TabLineFill#%T')

  " カレントタブページを閉じるボタンのラベルを右添えで作成
  if tabpagenr('$') > 1
    call add(tablines, '%=%#TabLine#%999Xclose')
  endif

  return join(tablines, '')
endfunction"}}}
function! MyTabLabel(n) "{{{
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  let bufname = bufname(buflist[winnr - 1])

  if empty( bufname )
    return '_無題_'
  else
    return bufname
  endif
endfunction"}}}
function! MakeTabline() "{{{
  let tabline = ''

  let tabline = MyTabLine()
  return tabline
endfunction"}}}
" set tabline=%!MakeTabline()

if v:version >= 703
  highlight ColorColumn guibg=#012345
  au FileType coffee,ruby,eruby,php,javascript,c,json,vim set colorcolumn=80
endif

"折り畳み
set foldcolumn=1
set foldenable
set foldmethod=marker
set foldnestmax=5

syntax on

" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

function! s:SID_PREFIX() "{{{
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction"}}}
function! s:my_tabline()  "{{{
  let s = ''

  for i in range(1, tabpagenr('$'))
    let bufnrs = tabpagebuflist(i)
    let bufnr = bufnrs[tabpagewinnr(i) - 1]  " first window, first appears

    let no = (i <= 10 ? i : '#')  " display 0-origin tabpagenr.
    let mod = getbufvar(bufnr, '&modified') ? '!' : ' '

    " Use gettabvar().
    let title = exists('*gettabvar') && gettabvar(i, 'title') != '' ?
          \ gettabvar(i, 'title') : fnamemodify(gettabvar(i, 'cwd'), ':t')

    let title = '[' . title . ']'

    let s .= '%'.i.'T'
    let s .= '%#' . (i == tabpagenr() ? 'TabLineSel' : 'TabLine') . '#'
    let s .= no . ':' . title
    let s .= mod
    let s .= '%#TabLineFill# '
  endfor

  let s .= '%#TabLineFill#%T%=%#TabLine#'
  return s
endfunction "}}}
" let &tabline = '%!'. s:SID_PREFIX() . 'my_tabline()'

colorscheme molokai
"}}}

"----------------------------------------
" Tags関連 cTags使う場合は有効化 "{{{
" http://vim-users.jp/2010/06/hack154/

set tags& tags-=tags tags+=./tags;

function! SetTags() "{{{
  let g:current_git_root = <SID>current_git()
  if filereadable(g:current_git_root.'/tags')
    execute 'setl tags+='.expand(g:current_git_root.'/tags')
  endif
endfunction"}}}
function! UpdateTags() "{{{
  call alpaca#let_g:('my.conf.tags.append', 0)
  call alpaca#let_g:('my.conf.tags.auto_create', 0)

  if g:my.conf.tags.auto_create != 1 |return| endif

  let append_opts = g:my.conf.tags.append ? ' --append=yes' : ''

  return alpaca#system_bg( g:my.bin.ctags, g:my.conf.tags.ctags_opts, append_opts )
endfunction"}}}
aug MyTagsCmd
  au!
  au BufEnter * call SetTags()
  " au VimEnter * call UpdateTags()
aug END

"tags_jumpを使い易くする
nnoremap [tag_or_tab]t  <C-]>
nnoremap [tag_or_tab]h  :<C-u>pop<CR>
nnoremap [tag_or_tab]l  :<C-u>tag<CR>
nnoremap [tag_or_tab]j  :<C-u>tprevious<CR>
nnoremap [tag_or_tab]k  :<C-u>tags<CR>
nnoremap [tag_or_tab]s  :<C-u>tselect<CR>
"}}}

"----------------------------------------
" 辞書:dict {{{
augroup DictSetting
  au!
  au FileType html,php,eruby                    setl dict+=~/.vim/dict/html.dict
augroup END

" カスタムファイルタイプでも、自動でdictを読み込む
" そして、編集画面までさくっと移動。
function! s:auto_dict_setting() "{{{
  let file_type_name = &filetype

  let dict_name = split( file_type_name, '\.' )

  if empty( dict_name ) || count(g:my.ft.ignore_patterns, dict_name) > 0
    return
  endif

  exe  "setl dict+=~/.vim/dict/".dict_name[0].".dict"

  let b:dict_path = expand('~/.vim/dict/'.file_type_name.'.dict')
  exe "setl dictionary+=".b:dict_path

  nnoremap <buffer><expr>[space]d ':<C-U>SmartSplit e '.b:dict_path.'<CR>'
endfunc"}}}

aug MyAutoCmd
  au FileType * call <SID>auto_dict_setting()
aug END
"}}}

"----------------------------------------
nnoremap [plug] <Nop>
nnoremap [space] <Space>
nmap <C-H> [plug]
nmap <Space> [space]
"----------------------------------------
"個別のプラグイン " {{{

"------------------------------------
" arpeggio
"------------------------------------
"{{{
" nofの表示を無くして、カーソル移動も無くしたかったので、大分ださい
call arpeggio#map('i', '', 0, 'jk', '<Esc>:nohlsearch<CR>:echo ""<CR>')
call arpeggio#map('v', '', 0, 'jk', '<Esc>:nohlsearch<CR>:echo ""<CR>')
call arpeggio#map('x', '', 0, 'jk', '<Esc>:nohlsearch<CR>:echo ""<CR>')
call arpeggio#map('c', '', 0, 'jk', '<Esc>:nohlsearch<CR>:echo ""<CR>')
"}}}

"------------------------------------
" vim-alignta
"------------------------------------
"{{{
let g:Align_xstrlen = 3
xnoremap <C-N>      :Align<Space>
xnoremap <C-N><C-N> :Align =<CR>
"}}}

"------------------------------------
" vim-surround
"------------------------------------
" {{{
nmap cs  <Plug>Csurround
nmap ds  <Plug>Dsurround
nmap yS  <Plug>YSurround
nmap ySS <Plug>YSsurround
nmap ySs <Plug>YSsurround
nmap ys  <Plug>Ysurround
nmap yss <Plug>Yssurround
xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround
xmap s   <Plug>VSurround

" append custom mappings {{{
let s:surround_mapping = []
call add( s:surround_mapping, {
      \ 'filetypes' : g:my.ft.ruby_files,
      \ 'mappings' : {
      \   '#':  "#{\r}",
      \   '%':  "<% \r %>",
      \   '-':  "<% \r -%>",
      \   'w':  "%w!\r!",
      \   'W':  "%W!\r!",
      \   'q':  "%q!\r!",
      \   'Q':  "%Q!\r!",
      \   'r':  "%r!\r!",
      \   'R':  "%R!\r!",
      \   '=':  "<%= \r %>",
      \   '{':  "{\r}",
      \ }
      \ })

call add( s:surround_mapping, {
      \ 'filetypes' : g:my.ft.php_files,
      \ 'mappings' : {
      \   '<' : "<?php \r ?>",
      \ }
      \ })

call add( s:surround_mapping, {
      \ 'filetypes' : '_',
      \ 'mappings' : {
      \   '[' : "[\r]",
      \ }
      \ })

" XXX rubyのinlucde?的な。
" vimには無いのかなー。
function! s:include(target, value) "{{{
  let target_type = type(a:target)

  if type({}) == target_type
    return has_key(a:target, a:value)

  elseif type([]) == target_type
    " return match(a:target, a:value) > -1
    echo a:target

  " elseif type('') == target_type || type(0) == target_type
  "   return match(a:target, a:value) > -1

  endif

  return 0
endfunction"}}}
function! s:let_surround_mapping(mapping_dict) "{{{
  for [ key, mapping ] in items(a:mapping_dict)
    call alpaca#let_b:('surround_'.char2nr(key), mapping )
  endfor
endfunction"}}}
" function! s:surround_mapping_filetype() "{{{
"   if !exists('s:surround_mapping_memo')
"     let s:surround_mapping_memo = {}
"   endif
"
"   if empty(&filetype) |return| endif
"   let filetype = split( &filetype, '\.' )[0]
"
"   " メモ化してある場合は設定"{{{
"   if has_key( s:surround_mapping_memo, filetype )
"   "   for mappings in s:surround_mapping_memo[filetype]
"   "     call <SID>let_surround_mapping( mappings )
"   "   endfor
"   "   return
"   endif "}}}
"   " filetypeに当てはまる設定を追加 "{{{
"   let memo = []
"   for mapping_settings in s:surround_mapping
"     if <SID>include( mapping_settings, 'filetypes' ) && <SID>include( mapping_settings, 'mappings')
"       " let filetypes = mapping_settings.filetypes
"       " let mappings  = mapping_settings.mappings
"
"       " if <SID>include( filetypes, '_' )
"       "   call <SID>let_surround_mapping( mappings )
"       "   call join(memo, mappings)
"       "   break
"       " endif
"
"       " if <SID>include( filetypes, filetype )
"       "   call <SID>let_surround_mapping( mappings )
"       "   call join(memo, mappings)
"       " endif
"     endif
"   endfor "}}}
"
"   call alpaca#let_s:('surround_mapping_memo.' . filetype, memo)
" endfunction"}}}
"
" augroup MyAutoCmd
"   autocmd FileType * call <SID>surround_mapping_filetype()
" augroup END
"}}}
" }}}

" ------------------------------------
" grep.vim
"------------------------------------
"{{{
" カーソル下の単語をgrepする
nnoremap <silent><C-G><C-g> :<C-u>Rgrep<Space><C-r><C-w> *<CR><CR>
nnoremap <silent><C-G><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><CR>

let Grep_Skip_Dirs = '.svn .git .swp .hg cache compile'
let Grep_Skip_Files = '*.bak *~ .swp .swa .swo'
let Grep_Find_Use_Xargs = 0
let Grep_Xargs_Options = '--print0'


" 検索外のディレクトリ、ファイルパターン
" qf内でファイルを開いた後画面を閉じる
function! s:open_qf() "{{{
  .cc
  ccl
endfunction"}}}

" rgrepなどで開いたqfを編修可にする
" また、Enterで飛べるようにする
function! OpenGrepQF() "{{{
  setl nowrap "折り返ししない

  nnoremap <buffer>gf <C-W>gf
  nnoremap <buffer><expr><CR> <SID>open_qf()
  nnoremap <buffer> q :q!<CR>
endfunction"}}}
aug MyAutoCmd
  autocmd Filetype qf call OpenGrepQF()
aug END
"}}}

"------------------------------------
" tagbar.vim
"------------------------------------
"{{{
nnoremap [space]t :<C-U>TagbarToggle<CR>

aug MyAutoCmd
  au FileType tagbar
        \ nnoremap <buffer><Space> [space]
        \|nnoremap <buffer><space>t :<C-U>TagbarToggle<CR>
aug END

let g:tagbar_ctags_bin  = g:my.bin.ctags
let g:tagbar_compact    = 1
let g:tagbar_autofocus  = 1
let g:tagbar_autoshowtag= 1
let g:tagbar_iconchars  =  ['▸', '▾']
let g:tagbar_width = 30
" let g:tagbar_autoclose = 1
" let g:tagbar_sort = 0

" gem ins coffeetags {{{
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
else
  let g:tagbar_type_coffee = {
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
"}}}
" js{{{
let g:tagbar_type_javascript = {
      \'ctagstype' : 'js',
      \'kinds'     : [
      \   'o:objects',
      \   'f:functions',
      \   'a:arrays',
      \   's:strings'
      \]
      \}
"}}}
" php {{{
let g:tagbar_type_php = {
      \ 'kinds' : [
      \ 'c:classes',
      \ 'f:functions',
      \ 'v:variables:1'
      \ ]
      \ }
"}}}
" markdown {{{
" let g:tagbar_type_markdown = {
"   \ 'ctagstype' : 'markdown',
"   \ 'kinds' : [
"     \ 'h:Heading_L1',
"     \ 'i:Heading_L2',
"     \ 'k:Heading_L3'
"   \ ]
" \ }
""}}}
" ruby {{{
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
" html {{{
let g:tagbar_type_html = {
      \ 'ctagstype' : 'html',
      \ 'kinds' : [
      \ 'h:Headers',
      \ 'o:Objects(ID)',
      \ 'c:Classes'
      \ ]
      \ }
"}}}
" css {{{
let g:tagbar_type_css = {
      \ 'ctagstype' : 'css',
      \ 'kinds' : [
      \   's:selectors',
      \   'i:identities',
      \   't:Tags(Elements)',
      \   'o:Objects(ID)',
      \   'c:Classes',
      \ ]
      \ }
"}}}

" scala {{{
let g:tagbar_type_scala = {
      \ "ctagstype" : 'Scala',
      \ 'sro' : '.',
      \ 'kinds' : [
      \   'p:packages:1',
      \   'V:values',
      \   'v:variables',
      \   'T:types',
      \   't:traits',
      \   'o:objects',
      \   'a:aclasses',
      \   'c:classes',
      \   'r:cclasses',
      \   'm:methods',
      \ ],
      \ 'kind2scope' : {
      \   'T' : 'type',
      \   't' : 'trait',
      \   'o' : 'object',
      \   'a' : 'abstract class',
      \   'c' : 'class',
      \   'r' : 'case class',
      \ },
      \}
"}}}
"}}}

"------------------------------------
" open-blowser.vim
"------------------------------------
"{{{
" カーソル下のURLをブラウザで開く
nmap <Leader>o <Plug>(openbrowser-open)
xmap <Leader>o <Plug>(openbrowser-open)
nnoremap <Leader>g :<C-u>OpenBrowserSearch<Space><C-r><C-w><CR>
"}}}

"------------------------------------
" qiita
"------------------------------------
"{{{
nnoremap [unite]q :unite qiita<CR>
"}}}

"------------------------------------
" quickrun.vim
"------------------------------------
"{{{
let g:quickrun_config = {}
let g:quickrun_no_default_key_mappings = 1
nnoremap <silent><Leader>r :QuickRun<CR>

let bundle = neobundle#get('vim-quickrun')
function! bundle.hooks.on_source(bundle) "{{{

  " quickrun config {{{
  let g:quickrun_config._ = {'runner' : 'vimproc'}
  let g:quickrun_config.javascript = {
        \ 'command': 'node'}

  let g:quickrun_config.lisp = {
        \ 'command': 'clisp' }

  let g:quickrun_config.coffee_compile = {
        \ 'command' : 'coffee',
        \ 'exec' : ['%c -cbp %s'] }

  let g:quickrun_config.markdown = {
        \ 'outputter': 'browser',
        \ 'cmdopt': '-s' }

  let g:quickrun_config.applescript = {
        \ 'command' : 'osascript' , 'output' : '_'}

  let g:quickrun_config['ruby.rspec'] = {
        \ 'type' : 'ruby.rspec',
        \ 'command': 'rspec',
        \ 'exec': 'bundle exec %c %o %s', }
  "}}}
  aug QuickRunAutoCmd "{{{
    au!
    au FileType quickrun
          \ au BufEnter <buffer> if (winnr('$') == 1) | q | endif
  aug END "}}}
endfunction"}}}
unlet bundle
"}}}

"------------------------------------
" toggle.vim
"------------------------------------
"{{{
"<C-T>で、true<->falseなど切り替えられる
" inoremap <C-D> <Plug>ToggleI
" nnoremap <C-D> <Plug>ToggleN
" xnoremap <C-D> <Plug>ToggleV
"
" let g:toggle_pairs = { 'and':'or', 'or':'and', 'if':'unless', 'unless':'if', 'yes':'no', 'no':'yes', 'enable':'disable', 'disable':'enable', 'pick':'reword', 'reword':'fixup', 'fixup':'squash', 'squash':'edit', 'edit':'exec', 'exec':'pick'}
"}}}

"----------------------------------------
" zencoding
"----------------------------------------
"{{{
" codaのデフォルトと一緒にする
" inoremap <C-E> <ESC>:<C-U>call zencoding#expandAbbr(0, "")<CR>
aug MyAutoCmd
  au Filetype css,scss,sass call <SID>set_zencoding_mappings()
aug END
function! s:set_zencoding_mappings()
  imap <buffer><C-E> <C-Y>,<Space>
endfunction

imap <C-E> <C-Y>,
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
let g:ref_cache_dir               = g:my.dir.vimref
let g:ref_refe_cmd                = expand('~/.vim/ref/ruby-ref1.9.2/refe-1_9_2')
let g:ref_phpmanual_path          = expand('~/.vim/ref/php-chunked-xhtml')
let g:ref_ri_cmd                  = g:my.bin.ri

nnoremap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
xnoremap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
nnoremap ra  :<C-U>Ref alc<Space>
nnoremap rp  :<C-U>Ref phpmanual<Space>
nnoremap rr  :<C-U>Unite ref/refe -default-action=split -input=
nnoremap ri  :<C-U>Unite ref/ri -default-action=split -input=
nnoremap rm  :<C-U>Unite ref/man -default-action=split -input=
nnoremap rpy :<C-U>Unite ref/pydoc -default-action=split -input=
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
nnoremap <silent>gM :<C-U>Gcommit --amend<CR>
nnoremap <silent>gb :<C-U>Gblame<CR>
nnoremap <silent>gm :<C-U>Gcommit<CR>

aug MyGitCmd
  au!
  au FileType fugitiveblame vertical res 25
  au FileType gitcommit,git-diff nnoremap <buffer>q :q<CR>
aug END
"}}}

"----------------------------------------
" vim-git
"----------------------------------------
" "{{{
" let g:git_command_edit = 'rightbelow vnew'
let g:git_command_edit = 'vnew'
let g:git_no_default_mappings = 1

nnoremap <silent>gA :<C-U>GitAdd<Space>
nnoremap <silent>ga :<C-U>GitAdd -A<CR>
nnoremap <silent>gd :<C-U>GitDiff HEAD<CR>
nnoremap <silent>gp :<C-U>Git push<Space>
nnoremap gD :<C-U>GitDiff<Space>
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
" vim-smartword
"------------------------------------
"{{{
map ,w  <Plug>(smartword-w)
map ,b  <Plug>(smartword-b)
map ,e  <Plug>(smartword-e)
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

nnoremap diw di,w
nnoremap dib di,b
nnoremap die di,e

nnoremap ciw ci,w
nnoremap cib ci,b
nnoremap cie ci,e

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
" source $VIMRUNTIME/macros/matchit.vim
" % での移動出来るタグを増やす
let b:match_ignorecase = 1
let s:match_words = {}

function! s:set_match_words() "{{{
  let ft = &ft
  if ft == '' || !has_key(s:match_words, ft)
    return
  endif

  call alpaca#let_b:('match_words', '')

  if b:match_words != '' && b:match_words !~ ':$'
    let b:match_words = b:match_words . ''
  endif

  let b:match_words = b:match_words . s:match_words[ft]
endfunction"}}}

aug MyAutoCmd
  au Filetype * call <SID>set_match_words()
aug END
"}}}

"------------------------------------
" vim-powerline / alpaca_powerline
"------------------------------------
"{{{
let g:Powerline_cache_enabled = 1
let g:Powerline_symbols='fancy'
"}}}

"------------------------------------
" vimshell
"------------------------------------
"{{{
nnoremap <silent><Leader>v  :<C-U>VimShell<CR>

let bundle = neobundle#get('vimshell')
function! bundle.hooks.on_source(bundle) "{{{
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
  endfunction "}}}

  aug MyAutoCmd
    au FileType vimshell call s:vimshell_settings()
  aug END
endfunction"}}}
unlet bundle
"}}}

"------------------------------------
" memolist.vim
"------------------------------------
""{{{
let g:memolist_path              = g:my.dir.memolist
let g:memolist_template_dir_path = g:my.dir.memolist
let g:memolist_memo_suffix       = "mkd"
let g:memolist_memo_date         = "%Y-%m-%d %H:%M"
let g:memolist_memo_date         = "epoch"
let g:memolist_memo_date         = "%D %T"
let g:memolist_vimfiler          = 1

nnoremap <silent><Space>mn  :<C-U>MemoNew<CR>
nnoremap <silent><Space>ml  :<C-U>VimFiler -buffer-name=file file:~/.memolist/<CR>
nnoremap <Space>mg  :<C-U>MemoGrep<CR>
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
" nnoremap <Leader>w :CoffeeCompile watch vert<CR>
"}}}

"------------------------------------
" t_comment
"------------------------------------
" {{{
let g:tcommentmaps=0

" TODO 特殊文字に書き換える
nmap <C-_> [tcomment]
nmap gc [tcomment]
noremap <silent>[tcomment]<c-_> :TComment<CR>
xnoremap <silent>[tcomment]<C-_> :TCommentMaybeInline<CR>

noremap <silent>[tcomment]c :TComment<CR>
xnoremap <silent>[tcomment]c :TCommentMaybeInline<CR>

let g:tcomment_types = {
      \'php_surround'            : "<?php %s ?>",
      \'eruby_surround'          : "<%% %s %%>",
      \'eruby_surround_minus'    : "<%% %s -%%>",
      \'eruby_surround_equality' : "<%%= %s %%>",
      \'eruby_block'             : "<%%=begin rdoc%s=end%%>",
      \'eruby_nodoc_block'       : "<%%=begin%s=end%%>"
      \ }
function! SetErubyMapping() "{{{
  inoremap <buffer> [tcomment]- <%  -%><ESC><Left><Left><Left>i
  inoremap <buffer> [tcomment]= <%=  %><ESC><Left><Left>i
  inoremap <buffer> [tcomment]c <%  %><ESC><Left><Left>i
  inoremap <buffer> [tcomment]d <%=begin rdoc=end%><ESC><Left><Left>i
  inoremap <buffer> [tcomment]n <%=begin=end%><ESC><Left><Left>i

  nnoremap <buffer> [tcomment]- :TCommentAs eruby_surround_minus<CR><Right><Right><Right>
  nnoremap <buffer> [tcomment]= :TCommentAs eruby_surround_equality<CR><Right><Right><Right><Right>
  nnoremap <buffer> [tcomment]c :TCommentAs eruby_surround<CR><Right><Right><Right>
  nnoremap <buffer> [tcomment]d :TCommentAs eruby_block<CR><Right><Right><Right><Right>
  nnoremap <buffer> [tcomment]n :TCommentAs eruby_nodoc_block<CR><Right><Right><Right><Right>
endfunction"}}}
function! SetRubyMapping() "{{{
  inoremap <buffer> [tcomment]b <%=begin rdoc=end%><ESC><Left><Left>i
  inoremap <buffer> [tcomment]n <%=begin=end%><ESC><Left><Left>i
  nnoremap <buffer> [tcomment]b :TCommentAs ruby_block<CR><Right><Right><Right><Right>
  nnoremap <buffer> [tcomment]n :TCommentAs ruby_nodoc_block<CR><Right><Right><Right><Right>
endfunction"}}}

aug MyAutoCmd
  au FileType eruby call SetErubyMapping()
  au FileType ruby,ruby.rspec call SetRubyMapping()
  au FileType php nnoremap <buffer><C-_>c :<C-U>TCommentAs php_surround<CR><Right><Right><Right>
  au FileType php xnoremap <buffer><C-_>c :<C-U>TCommentAs php_surround<CR><Right><Right><Right>
aug END
"}}}

"------------------------------------
" ctrlp
"------------------------------------
" {{{
nnoremap <silent>[plug]<C-B> :<C-U>CtrlPBuffer<CR>
nnoremap <silent>[plug]<C-D> :<C-U>CtrlPDir<CR>
nnoremap <silent>[plug]<C-F> :<C-U>CtrlPCurFile<CR>
let bundle = neobundle#get('ctrlp.vim')
function! bundle.hooks.on_source(bundle) "{{{
  " let g:ctrlp_mruf_case_sensitive = 0
  " let g:ctrlp_open_new_file = 't'
  let g:ctrlp_cache_dir = g:my.dir.ctrlp
  let g:ctrlp_clear_cache_on_exit = 1
  let g:ctrlp_lazy_update = 1
  let g:ctrlp_regexp = 1
  let g:ctrlp_show_hidden = 1
  let g:ctrlp_use_caching = 1
  let g:ctrlp_custom_ignore = {
        \ 'dir':  '\.\(hg\|git\|sass-cache\|svn|\~\)$',
        \ 'file': '\.\(dll\|exe\|gif\|jpg\|png\|psd\|so\|woff\)$' }
  let g:ctrlp_mruf_exclude = '\(\\\|/\)\(Temp\|Downloads\)\(\\\|/\)\|\(\\\|/\)\.\(hg\|git\|svn\|sass-cache\)'
  let g:ctrlp_prompt_mappings = {
        \ 'AcceptSelection("t")': ['<c-n>'],
        \ }

  " hi link CtrlPLinePre NonText
  " hi link CtrlPMatch IncSearch
endfunction"}}}
unlet bundle
" }}}

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
" vim-rails
"------------------------------------
""{{{
"有効化
" let g:rails_ctags_arguments = ''
" let g:rails_ctags_arguments='--languages=-javascript'
" let g:rails_some_option = 1
" let g:rails_statusline = 1
" let g:rails_subversion=0
let g:dbext_default_SQLITE_bin = 'mysql2'
let g:rails_default_file='config/database.yml'
let g:rails_gnu_screen=1
let g:rails_level = 4
let g:rails_mappings=1
let g:rails_modelines=0
let g:rails_syntax = 1
let g:rails_url='http://localhost:3000'
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
  au User Rails set dict+=~/.vim/dict/ruby.rails.dict | nnoremap <buffer><Space>dd  :<C-U>SmartSplit e ~/.vim/dict/ruby.rails.dict<CR>
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
let g:github_user = g:my.github.user
nnoremap <silent>[plug]g :<C-U>Gist<CR>
nnoremap <silent>[plug]gl :<C-U>Gist -l<CR>
"}}}

"------------------------------------
" twitvim
"------------------------------------
"{{{
let g:tweetvim_async_post = 1
let g:tweetvim_display_source = 1
let g:tweetvim_display_time = 1
let g:tweetvim_open_buffer_cmd = 'tabnew'
nnoremap <silent>[unite]T  :call BundleWithCmd('TweetVim bitly.vim twibill.vim', 'Unite tweetvim')<CR>
nnoremap <silent>tv :<C-U>TweetVimSay<CR>
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
" sass-compile.vim
"------------------------------------
""{{{
" let g:sass_compile_aftercmd = ""
" let g:sass_compile_auto = 1
" let g:sass_compile_beforecmd = ""
" let g:sass_compile_cdloop = 1
" let g:sass_compile_cssdir = ['css', 'stylesheet']
" let g:sass_compile_file = ['scss', 'sass']
" let g:sass_started_dirs = []
let g:sass_compile_cdloop = 5
let g:sass_compile_cssdir = ['css', 'stylesheet']
let g:sass_compile_file = ['scss', 'sass']
let g:sass_started_dirs = []
let g:sass_compile_beforecmd=''
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
let g:syntastic_error_symbol='>'
let g:syntastic_warning_symbol='X'
" let g:syntastic_error_symbol='✗'
" let g:syntastic_warning_symbol='⚠'

let g:syntastic_mode_map = {
      \ 'mode'              : 'active',
      \ 'active_filetypes'  : g:my.ft.program_files,
      \ 'passive_filetypes' : ["html"],
      \}
"}}}

"------------------------------------
" w3m.vim
"------------------------------------
"{{{
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
" vim-indent-guides
"------------------------------------
"{{{
let g:indent_guides_auto_colors=0
let g:indent_guides_color_change_percent = 20
let g:indent_guides_enable_on_vim_startup=1
let g:indent_guides_guide_size=1
let g:indent_guides_space_guides = 1
let g:indent_guides_start_level = 2
hi IndentGuidesOdd  ctermbg=235
hi IndentGuidesEven ctermbg=233
augroup MyAutoCmd
  au BufEnter * let g:indent_guides_guide_size=&tabstop
augroup END
" nnoremap <silent><Leader>ig <Plug>IndentGuidesToggle
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
" " xnoremap <leader>sf    <Plug>SQLU_Formatter<CR>
" " nnoremap <leader>scl   <Plug>SQLU_CreateColumnList<CR>
" " nnoremap <leader>scd   <Plug>SQLU_GetColumnDef<CR>
" " nnoremap <leader>scdt  <Plug>SQLU_GetColumnDataType<CR>
" " nnoremap <leader>scp   <Plug>SQLU_CreateProcedure<CR>
" xnoremap sf :SQLUFormatter<CR>
"}}}

"------------------------------------
" vim-endwise
"------------------------------------
"{{{
let g:endwise_no_mappings=1
"}}}

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
xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
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
nmap <silent>k <Plug>(accelerated_jk_gk)
"}}}

"------------------------------------
" eskk.vim
"------------------------------------
" "{{{
" let g:eskk#egg_like_newline = 1
" let g:eskk#revert_henkan_style = "okuri"
let g:eskk#debug = 0
let g:eskk#dictionary = { 'path': expand( "~/.eskk_jisyo" ), 'sorted': 0, 'encoding': 'utf-8', }
let g:eskk#directory = "~/.eskk"
let g:eskk#dont_map_default_if_already_mapped=1
let g:eskk#enable_completion = 1
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
" let g:textobj_enclosedsyntax_no_default_key_mappings = 1
"
" " ax、ixにマッピングしたい場合
" omap ax <Plug>(textobj-enclosedsyntax-a)
" omap ix <Plug>(textobj-enclosedsyntax-i)
" xmap ax <Plug>(textobj-enclosedsyntax-a)
" xmap ix <Plug>(textobj-enclosedsyntax-i)
"}}}

"------------------------------------
" excitetranslate
"------------------------------------
" {{{
xnoremap e :ExciteTranslate<CR>
" }}}

"------------------------------------
" qtmplsel.vim
"------------------------------------
"{{{
" let g:qts_templatedir=expand( '~/.vim/template' )
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

"------------------------------------
"  lingr
"------------------------------------
"{{{
" XXX 使えない..............・T・
let g:lingr_vim_user = g:my.lingr.user
let g:lingr_vim_command_to_open_url = 'open -g %s'
let g:lingr_vim_time_format = "%Y/%m/%d %H:%M:%S"
let g:lingr_vim_additional_rooms = [
    \   'vim',
    \   'emacs',
    \   'editor',
    \   'vim_users_en',
    \   'vimperator',
    \   'filer',
    \   'completion',
    \   'shell',
    \   'git',
    \   'termtter',
    \   'lingr',
    \   'ruby',
    \   'few',
    \   'gc',
    \   'scala',
    \   'lowlevel',
    \   'lingr_vim',
    \   'vimjolts',
    \   'gentoo',
    \   'LinuxKernel',
    \]
"}}}

"------------------------------------
"  caw.vim
"------------------------------------
"{{{
nmap gc <Plug>(caw:prefix)
xmap gc <Plug>(caw:prefix)
nmap gcc <Plug>(caw:i:toggle)
xmap gcc <Plug>(caw:i:toggle)
"}}}

"------------------------------------
"  vim-scala
"------------------------------------
"{{{
let g:scala_use_default_keymappings = 0
"}}}

"------------------------------------
"  alice.vim
"------------------------------------
"{{{
function! s:URLEncodeORDecode(encode) "{{{
  let l:line = getline('.')

  if a:encode
    let l:encoded = AL_urlencode(l:line)
  else
    let l:encoded = AL_urldecode(l:line)
  endif

  call setline('.', l:encoded)
endfunction"}}}

command! -nargs=0 -range URLEncode :call <SID>URLEncodeORDecode(1)
command! -nargs=0 -range URLDecode :call <SID>URLEncodeORDecode(0)
xnoremap ue :<C-U>URLEncode<CR>
xnoremap ud :<C-U>URLDecode<CR>
"}}}

"------------------------------------
"  fakeclip.vim
"------------------------------------
" fakeclip.vim"{{{
" let g:fakeclip_no_default_key_mappings = 1
"
" for _ in ['+', '*']
"   echo 'silent! nmap "'._.'y  <Plug>(fakeclip-y)'
"   echo 'silent! nmap "'._.'Y  <Plug>(fakeclip-Y)'
"   echo 'silent! nmap "'._.'yy  <Plug>(fakeclip-Y)'
"   echo 'silent! vmap "'._.'y  <Plug>(fakeclip-y)'
"   echo 'silent! vmap "'._.'Y  <Plug>(fakeclip-Y)'
"
"   echo 'silent! nmap "'._.'p  <Plug>(fakeclip-p)'
"   echo 'silent! nmap "'._.'P  <Plug>(fakeclip-P)'
"   echo 'silent! nmap "'._.'gp  <Plug>(fakeclip-gp)'
"   echo 'silent! nmap "'._.'gP  <Plug>(fakeclip-gP)'
"   echo 'silent! vmap "'._.'p  <Plug>(fakeclip-p)'
"   echo 'silent! vmap "'._.'P  <Plug>(fakeclip-P)'
"   echo 'silent! vmap "'._.'gp  <Plug>(fakeclip-gp)'
"   echo 'silent! vmap "'._.'gP  <Plug>(fakeclip-gP)'
"
"   echo 'silent! map! <C-r>'._.'  <Plug>(fakeclip-insert)'
"   echo 'silent! map! <C-r><C-r>'._.'  <Plug>(fakeclip-insert-r)'
"   echo 'silent! map! <C-r><C-o>'._.'  <Plug>(fakeclip-insert-o)'
"   echo 'silent! imap <C-r><C-p>'._.'  <Plug>(fakeclip-insert-p)'
" endfor
"}}}
"}}}

"----------------------------------------
" 補完・履歴 neocomplcache "{{{
set complete+=k,U,kspell,t,d " 補完を充実
set completeopt=menu,menuone,preview
set history=1000             " コマンド・検索パターンの履歴数
set infercase
set wildchar=<tab>           " コマンド補完を開始するキー
set wildmenu                 " コマンド補完を強化
set wildmode=longest:full,full

"----------------------------------------
" neocomplcache / echodoc
let g:neocomplcache_enable_at_startup = 1
let g:echodoc_enable_at_startup = 1

" default config"{{{
" let g:neocomplcache_enable_auto_select=1
let g:neocomplcache#sources#rsense#home_directory = neobundle#get_neobundle_dir() . '/rsense-0.3'
let g:neocomplcache_enable_camel_case_completion  = 1
let g:neocomplcache_enable_underbar_completion    = 1
let g:neocomplcache_force_overwrite_completefunc  = 1
let g:neocomplcache_max_list = 80
let g:neocomplcache_skip_auto_completion_time     = '0.3'

" let g:neocomplcache_auto_completion_start_length = 2
" let g:neocomplcache_caching_limit_file_size = 1000000
" let g:neocomplcache_disable_auto_select_buffer_name_pattern = '\[Command Line\]'
" let g:neocomplcache_disable_caching_buffer_name_pattern = '[\[*]\%(unite\)[\]*]'
" let g:neocomplcache_lock_buffer_name_pattern = '\.txt'
" let g:neocomplcache_manual_completion_start_length = 0
" let g:neocomplcache_min_keyword_length = 2
" let g:neocomplcache_min_syntax_length = 2
let bundle = neobundle#get('neocomplcache')
function! bundle.hooks.on_source(bundle) "{{{
  " initialize "{{{
  if $USER ==# 'root'
    let g:neocomplcache_temporary_dir = g:my.dir.bundle
  endif
  let s:neocomplcache_initialize_lists = [
        \ 'neocomplcache_include_patterns',
        \ 'neocomplcache_wildcard_characters',
        \ 'neocomplcache_omni_patterns',
        \ 'neocomplcache_force_omni_patterns',
        \ 'neocomplcache_keyword_patterns',
        \ 'neocomplcache_source_completion_length',
        \ 'neocomplcache_source_rank',
        \ 'neocomplcache_vim_completefuncs',
        \ 'neocomplcache_dictionary_filetype_lists',]
  for initialize_variable in s:neocomplcache_initialize_lists
    call alpaca#let_g:(initialize_variable, {})
  endfor
  "}}}

  " XXX どこで定義されてるか分からんので、上書きはしない。
  " Define force omni patterns"{{{
  call alpaca#let_dict( 'g:neocomplcache_source_rank', {
        \ 'c'       : '[^.[:digit:] *\t]\%(\.\|->\)',
        \ 'cpp'     : '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::',
        \ 'python'  : '[^. \t]\.\w*',
        \} )

  " Define keyword pattern.
  call alpaca#let_dict( 'g:neocomplcache_keyword_patterns', {
        \ 'filename'  : '\%(\\.\|[/\[\][:alnum:]()$+_\~.-]\|[^[:print:]]\)\+',
        \ 'c'         : '[^.[:digit:]*\t]\%(\.\|->\)',
        \ 'mail'      : '^\s*\w\+',
        \ 'php'       : '[^. *\t]\.\w*\|\h\w*::'
        \} )

  " Define include pattern.
  call alpaca#let_dict( 'g:neocomplcache_include_patterns', {
        \ 'scala' : '^import',
        \ 'scss'  : '^\s*\<\%(@import\)\>',
        \ 'php'  :  '^\s*\<\%(inlcude\|\|include_once\|require\|require_once\)\>',
        \} )

  " Define omni patterns
  call alpaca#let_dict( 'g:neocomplcache_omni_patterns', {
        \ 'php' : '[^. *\t]\.\w*\|\h\w*::'
        \} )

  " Define completefunc
  call alpaca#let_dict( 'g:neocomplcache_vim_completefuncs', {
        \ "Ref"                 : 'ref#complete',
        \ "Unite"               : 'unite#complete_source',
        \ "VimFiler"            : 'vimfiler#complete',
        \ "VimShell"            : 'vimshell#complete',
        \ "VimShellExecute"     : 'vimshell#vimshell_execute_complete',
        \ "VimShellInteractive" : 'vimshell#vimshell_execute_complete',
        \ "VimShellTerminal"    : 'vimshell#vimshell_execute_complete',
        \ "Vinarise"            : 'vinarise#complete',
        \ } )

  " Define source rank
  " 'rsense' : 2,
  call alpaca#let_dict( 'g:neocomplcache_source_rank', {
        \ 'alpaca_look' : 200,
        \ } )
  "}}}

  call alpaca#let_dict( 'g:neocomplcache_source_completion_length',  {
        \ 'alpaca_look' : 4
        \ })

  " ファイルタイプ毎の辞書ファイルの場所 {{{
  let g:neocomplcache_dictionary_filetype_lists = {
        \ 'default'             : '',
        \ 'timobile.javascript' : $HOME.'/.vim/dict/timobile.dict',
        \ 'timobile.coffee'     : $HOME.'/.vim/dict/timobile.dict',
        \ }

  for s:dict in split(glob($HOME.'/.vim/dict/*.dict'))
    let s:ft = matchstr(s:dict, '[a-zA-Z0-9.]\+\ze\.dict$')
    let g:neocomplcache_dictionary_filetype_lists[s:ft] = s:dict
  endfor
  "}}}
endfunction"}}}
unlet bundle
"}}}

" keymap {{{
imap <expr><C-G>     neocomplcache#undo_completion()
imap <expr><TAB>     neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <silent><expr><CR> neocomplcache#smart_close_popup() . "<CR>"
imap <silent><expr><CR> neocomplcache#smart_close_popup() . "<CR>" . "<Plug>DiscretionaryEnd"
" }}}
"}}}

"------------------------------------
" VimFiler {{{
nnoremap <silent>[plug]f       :call VimFilerExplorerGit()<CR>
nnoremap <silent><Leader><Leader>  :VimFilerBufferDir<CR>
" au VimEnter * call VimFilerExplorerGit()

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

  if <SID>vimfiler_is_active()
    return
  endif

  aug VimFilerExplorerKeyMapping
    au!
    au FileType vimfiler call s:vimfiler_local()
  aug END

  exe cmd
endfunction "}}}
command! VimFilerExplorerGit call VimFilerExplorerGit()

let bundle = neobundle#get('vimfiler')
function! bundle.hooks.on_source(bundle) "{{{
  let g:vimfiler_safe_mode_by_default = 0
  let g:vimfiler_as_default_explorer = 1
  let g:vimfiler_sort_type = "filename"
  let g:vimfiler_preview_action = ""
  let g:vimfiler_enable_auto_cd= 1
  let g:vimfiler_file_icon = "-"
  " XXX 思った通りに動かない...
  " let g:vimfiler_execute_file_list = { '_' : 'edit', "       \ }
  let g:vimfiler_readonly_file_icon = "x"
  let g:vimfiler_tree_closed_icon = "‣"
  let g:vimfiler_tree_leaf_icon = " "
  let g:vimfiler_tree_opened_icon = "▾"
  let g:vimfiler_marked_file_icon = "✓"

  function! s:vimfiler_is_active() "{{{
    return exists('b:vimfiler')
  endfunction"}}}
  function! s:vimfiler_local() "{{{
    if !exists('b:vimfiler') | return | endif

    let vimfiler = vimfiler#get_context()

    if vimfiler.explorer
      call <SID>vimfiler_explorer_local()
    else
      call <SID>vimfiler_not_explorer_local()
    endif

    " vimfiler common settings
    setl nonumber
    nmap <buffer><C-J> [unite]
    nmap <buffer><CR> <Plug>(vimfiler_edit_file)
    nmap <buffer>f <Plug>(vimfiler_toggle_mark_current_line)
    nnoremap <buffer>b :<C-U>UniteBookmarkAdd<CR>
    nnoremap <buffer><expr>p vimfiler#do_action('preview')
    nnoremap <buffer>v v
  endfunction"}}}
  function! s:vimfiler_explorer_local() "{{{
    au BufEnter <buffer> if (winnr('$') == 1 && &filetype ==# 'vimfiler' && <SID>vimfiler_is_active()) | q | endif
    let vimfiler = vimfiler#get_current_vimfiler()
    call UpdateTags()
    let g:my.conf.tags.auto_create = 0
  endfunction"}}}
  function! s:vimfiler_not_explorer_local() "{{{
    nnoremap <buffer><expr>u vimfiler#do_action('file')
  endfunction"}}}
  aug VimFilerKeyMapping "{{{
    au!
    au FileType vimfiler call <SID>vimfiler_local()
  aug END "}}}


  " VimFilerExplorer自動起動
endfunction"}}}
unlet bundle
"}}}

"----------------------------------------
" neosnippet"{{{
let g:neosnippet#snippets_directory = g:my.dir.bundle . '/neosnippet/autoload/neosnippet/snippets,' . g:my.dir.snippets
imap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
inoremap <silent><C-U>            <ESC>:<C-U>Unite snippet<CR>
nnoremap <silent><Space>e         :<C-U>NeoSnippetEdit -split<CR>
nnoremap <silent><expr><Space>ee  ':NeoSnippetEdit -split'.split(&ft, '.')[0].'<CR>'

smap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
" xmap <silent><C-F>                <Plug>(neosnippet_start_unite_snippet_target)
" xmap <silent>o                    <Plug>(neosnippet_register_oneshot_snippet)
"}}}

"----------------------------------------
" unite.vim"{{{
" unite prefix key.

" keymappings"{{{
nmap [unite] <Nop>
nmap <C-J> [unite]

nnoremap <silent> <Space>b       :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [unite]<C-B>   :<C-u>Unite buffer -buffer-name=buffer<CR>
nnoremap <silent> [unite]<C-J>   :<C-u>Unite file_mru -buffer-name=file_mru<CR>
nnoremap <silent> [unite]<C-U>   :<C-u>UniteWithBufferDir -buffer-name=file file<CR>
nnoremap <silent> [unite]b       :<C-u>Unite bookmark -buffer-name=bookmark<CR>
nnoremap <silent> g/             :<C-U>call Smart_unite_open('Unite -buffer-name=line_fast -hide-source-names -horizontal -no-empty -start-insert -no-quit line/fast')<CR>
nnoremap [unite]<C-F>            :<C-u>UniteFile<Space>
nnoremap <silent><expr>[unite]f ':Unite -buffer-name=file file:' . expand("%:p:h") . '<CR>'

nnoremap <silent>[unite]c        :<C-U>call BundleWithCmd('vim-unite-history', 'Unite -buffer-name=history_command -no-empty history/command')<CR>
nnoremap <silent>[unite]h        :<C-U>call BundleWithCmd('unite-help', ':Unite help -buffer-name=help')<CR>
nnoremap <silent>[unite]m        :<C-U>call BundleWithCmd('unite-mark', ':Unite mark -buffer-name=mark')<CR>
nnoremap <silent>[unite]o        :<C-U>call BundleWithCmd('unite-outline', 'Unite -auto-preview -horizontal -no-quit -buffer-name=outline -hide-source-names outline')<CR>
nnoremap <silent>[unite]s        :<C-U>call BundleWithUniteHisoryCmd('Unite -buffer-name=history_search -no-empty history/search')<CR>
nnoremap <silent>[unite]t        :<C-U>call BundleWithCmd('unite-tag unite.vim', 'Unite tag -buffer-name=tag -no-empty')<CR>
nnoremap <silent>[unite]y        :<C-U>call BundleWithUniteHisoryCmd('Unite -buffer-name=history_yank -no-empty history/yank')<CR>
nnoremap [unite]S                :<C-U>call BundleWithCmd('unite-ssh', ':Unite -buffer-name=ssh ssh://')<Left><Left>
nnoremap [unite]l                :<C-U>call BundleWithCmd('unite-locate', ':Unite locate -buffer-name=locate -input=')<Left><Left>

" UniteFile {{{
function! s:unite_file(path)
  let path=substitute(a:path, '^\s*', '', '')
  if isdirectory(path)
    execute 'Unite -buffer-name=file file:' . path
  else
    execute 'edit ' . path
  endif
endfunction
command! -nargs=? -complete=file UniteFile call <SID>unite_file(<q-args>)
"}}}
function! UniteRailsSetting() "Unite-rails.vim {{{
  nnoremap <buffer>[plug]<C-H><C-H>  :<C-U>Unite rails/view<CR>
  nnoremap <buffer>[plug]<C-H>       :<C-U>Unite rails/model<CR>
  nnoremap <buffer>[plug]            :<C-U>Unite rails/controller<CR>

  nnoremap <buffer>[plug]c           :<C-U>Unite rails/config<CR>
  nnoremap <buffer>[plug]s           :<C-U>Unite rails/spec<CR>
  nnoremap <buffer>[plug]m           :<C-U>Unite rails/db -input=migrate<CR>
  nnoremap <buffer>[plug]l           :<C-U>Unite rails/lib<CR>
  nnoremap <buffer><expr>[plug]g     ':e '.b:rails_root.'/Gemfile<CR>'
  nnoremap <buffer><expr>[plug]r     ':e '.b:rails_root.'/config/routes.rb<CR>'
  nnoremap <buffer><expr>[plug]se    ':e '.b:rails_root.'/db/seeds.rb<CR>'
  nnoremap <buffer>[plug]ra          :<C-U>Unite rails/rake<CR>
  nnoremap <buffer>[plug]h           :<C-U>Unite rails/heroku<CR>
endfunction
aug MyAutoCmd
  au User Rails call UniteRailsSetting()
aug END
"}}}
" unite_reek, unite_rails_best_practices"{{{
nnoremap <silent> [unite]r      :<C-u>Unite -no-quit reek<CR>
nnoremap <silent> [unite]rr :<C-u>Unite -no-quit rails_best_practices<CR>
"}}}
" unite-giti {{{
nnoremap <silent>gl :<C-U>call BundleWithCmd('vim-unite-giti', 'Unite -buffer-name=giti_log -no-start-insert giti/log')<CR>
nnoremap <silent>gL :<C-U>call BundleWithCmd('vim-versions', 'Unite -buffer-name=versions_log -no-start-insert versions/git/log')<CR>
nnoremap <silent>gS :<C-U>call BundleWithCmd('vim-versions', 'Unite -buffer-name=versions_status -no-start-insert versions/git/status')<CR>
nnoremap <silent>gs :<C-U>call BundleWithCmd('vim-unite-giti', 'Unite -buffer-name=giti_status -no-start-insert giti/status ')<CR>
nnoremap <silent>gh :<C-U>call BundleWithCmd('vim-unite-giti', 'Unite -buffer-name=giti_branchall -no-start-insert giti/branch_all')<CR>
"}}}
"}}}

" XXX 本体の関数をつかって実装したい
" lineなどsyntaxがあった方がいいものは、開いていたファイルのsyntaxを適応
function! Smart_unite_open(cmd) "{{{
  let file_syntax=&syntax
  let rails_root = exists('b:rails_root')? b:rails_root : ''
  let rails_buffer = rails#buffer()

  " uniteを起動
  exe a:cmd

  if rails_root != ''
    let b:rails_root = rails_root
    call rails#set_syntax(rails_buffer)
  endif
  if file_syntax != ''
    exe 'setl syntax='.file_syntax
  endif
endfunction"}}}

let bundle = neobundle#get('unite.vim')
function! bundle.hooks.on_source(bundle) "{{{
  " settings {{{
  " 入力モードで開始する
  " let g:unite_abbr_highlight = 'TabLine'
  " let g:unite_source_directory_mru_filename_format
  let g:unite_cursor_line_highlight='LineNr'
  let g:unite_enable_split_vertically=1
  let g:unite_enable_start_insert=1
  let g:unite_source_directory_mru_limit = 100
  let g:unite_source_directory_mru_time_format="(%m-%d %H:%M:%S) "
  let g:unite_source_file_mru_filename_format=":~:."
  let g:unite_source_file_mru_limit = 100
  let g:unite_source_file_mru_time_format="(%m-%d %H:%M:%S) "
  let g:unite_winheight = 20
  let g:unite_source_history_yank_enable =1
  let s:unite_kuso_hooks = {}

  call unite#set_substitute_pattern('file', '^@', '\=getcwd()."/*"', 1)
  call unite#set_substitute_pattern('file', '^@@', '\=fnamemodify(expand("#"), ":p:h")."/*"', 2)
  "}}}

  function! s:unite_my_settings() "{{{
    highlight link uniteMarkedLine Identifier
    highlight link uniteCandidateInputKeyword Statement

    inoremap <buffer><C-J> <Down>
    inoremap <buffer><C-K> <Up>
    nmap     <buffer>f <Plug>(unite_toggle_mark_current_candidate)
    xmap     <buffer>f <Plug>(unite_toggle_mark_selected_candidates)
    nmap     <buffer><C-H> <Plug>(unite_toggle_transpose_window)
    nmap     <buffer><C-J> <Plug>(unite_toggle_auto_preview)
    nnoremap <silent><buffer><expr>S unite#do_action('split')
    nnoremap <silent><buffer><expr>V unite#do_action('vsplit')
    nnoremap <silent><buffer><expr><Leader><Leader> unite#do_action('vimfiler')

    " Custom actions.
    " sample
    " {{{
    let my_tabopen = {
          \ 'description' : 'my tabopen items',
          \ 'is_selectable' : 1,
          \ }
    function! my_tabopen.func(candidates) "{{{
      call unite#take_action('tabopen', a:candidates)

      let dir = isdirectory(a:candidates[0].word) ?
            \ a:candidates[0].word : fnamemodify(a:candidates[0].word, ':p:h')
      execute g:unite_kind_openable_lcd_command '`=dir`'
    endfunction"}}}
    call unite#custom_action('file,buffer', 'tabopen', my_tabopen)
    unlet my_tabopen
    "}}}

    " hook
    let unite = unite#get_current_unite()
    let buffer_name = unite.buffer_name != '' ? unite.buffer_name : '_'

    " XXX 本体の関数をつかって実装したい
    " バッファ名に基づいたフックを実行
    call alpaca#let_s:('unite_kuso_hooks', {})
    if has_key( s:unite_kuso_hooks, buffer_name )
      call s:unite_kuso_hooks[buffer_name]()
    endif
  endfunction
  aug MyUniteCmd
    au FileType unite call <SID>unite_my_settings()
  aug END
  "}}}

  " For unite-menu.
  " Shougoさんのvimrcより拝借。sample
  " {{{
  call alpaca#let_g:('unite_source_menu_menus', {})
  let g:unite_source_menu_menus.enc = {
        \     'description' : 'Open with a specific character code again.',
        \ }
  let g:unite_source_menu_menus.enc.command_candidates = [
        \       ['utf8', 'Utf8'],
        \       ['iso2022jp', 'Iso2022jp'],
        \       ['cp932', 'Cp932'],
        \       ['euc', 'Euc'],
        \       ['utf16', 'Utf16'],
        \       ['utf16-be', 'Utf16be'],
        \       ['jis', 'Jis'],
        \       ['sjis', 'Sjis'],
        \       ['unicode', 'Unicode'],
        \     ]
  nnoremap [unite]e :<C-u>Unite menu:enc<CR>
  "}}}

  function! s:unite_kuso_hooks.file_mru() "{{{
    highlight link uniteSource__FileMru_Time Comment
    syntax region uniteSource__FileMru start=/\%3c/ end=/$/

    " syntax link uniteSource__FileMru contained
    syntax region uniteSource__FileMru start=/\%3c/ end=/$/ contained

    syntax match uniteFileDirectory '.*\/'
    syntax match uniteFileFile '[^/]*[^/]$'
    highlight link uniteFileDirectory Identifier
    highlight link uniteFileDirectory Statement
  endfunction"}}}
  function! s:unite_kuso_hooks.file() "{{{
    syntax match uniteFileDirectory '.*\/'
    highlight link uniteFileDirectory Statement
  endfunction"}}}

  "------------------------------------
  " vim-version
  "------------------------------------
  let g:versions#type#git#log#first_parent=1
  let g:versions#source#git#log#revision_length=0
  let g:versions#type#git#branch#merge#ignore_all_space=1

  "------------------------------------
  " unite-history
  "------------------------------------
  "{{{
  " TODO kusoすぎわろた。 実装方法考えないとなぁ。
  function! BundleWithUniteHisoryCmd(cmd) "{{{
    call BundleWithCmd( 'vim-unite-history unite.vim', '' )

    call Smart_unite_open(a:cmd)
  endfunction"}}}
  function s:unite_kuso_hooks.history_command() "{{{
    setl syntax=vim
  endfunction"}}}
  "}}}

  "------------------------------------
  " Unite-grep.vim
  "------------------------------------
  "{{{
  let g:unite_source_grep_command = "grep"
  let g:unite_source_grep_recursive_opt = "-R"
  " let g:unite_source_grep_ignore_pattern = ''
  "}}}

  "------------------------------------
  " Unite-outline
  "------------------------------------
  "{{{
  " let g:unite_source_outline_filetype_options
  " let g:unite_source_outline_info
  " let g:unite_source_outline_indent_width
  " let g:unite_source_outline_max_headings
  " let g:unite_source_outline_cache_limit
  " let g:unite_source_outline_highlight
  function! s:unite_kuso_hooks.outline()
    let unite = unite#get_context()
    let unite.auto_preview = 0
    nnoremap <buffer><C-J> gj
  endfunction
  "}}}

  "------------------------------------
  " Unite-reek, Unite-rails_best_practices
  "------------------------------------
  " {{{
  " }}}

  "----------------------------------------
  " unite-giti / vim-versions
  "----------------------------------------
  "{{{
  function! s:unite_kuso_hooks.giti_status()
    " nnoremap <silent><buffer><expr>gM unite#do_action('ammend')
    nnoremap <silent><buffer><expr>ga unite#do_action('stage')
    nnoremap <silent><buffer><expr>gc unite#do_action('checkout')
    nnoremap <silent><buffer><expr>gd unite#do_action('diff')
    nnoremap <silent><buffer><expr>gu unite#do_action('unstage')
  endfunction

  function! s:unite_kuso_hooks.giti_status()
    " nnoremap <silent><buffer><expr>gM unite#do_action('ammend')
    nnoremap <silent><buffer><expr>ga unite#do_action('stage')
    nnoremap <silent><buffer><expr>gc unite#do_action('checkout')
    nnoremap <silent><buffer><expr>gd unite#do_action('diff')
    nnoremap <silent><buffer><expr>gu unite#do_action('unstage')
  endfunction

  function! s:unite_kuso_hooks.giti_log()
    nnoremap <silent><buffer><expr>gd unite#do_action('diff')
    nnoremap <silent><buffer><expr>d unite#do_action('diff')
  endfunction
  "}}}
endfunction"}}}
unlet bundle
"}}}

if !has('vim_starting')
  call neobundle#call_hook('on_source')
endif

set secure
