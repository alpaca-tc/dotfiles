augroup MyAutoCmd
  autocmd!
augroup END

"----------------------------------------
" utils {{{
function! s:include(target, value) "{{{
  let target_type = type(a:target)

  if type({}) == target_type
    return has_key(a:target, a:value)

  elseif type([]) == target_type || type('') == target_type
    return match(a:target, a:value) > -1

  elseif type(0) == target_type
    return a:target == a:value

  endif

  return 0
endfunction"}}}
function! s:current_git() "{{{
  if !exists('b:git_dir')
    return ''
  endif

  return substitute(b:git_dir, '/.git$', '', 'g')
endfunction"}}}
function! s:filetype() "{{{
  if empty(&filetype) | return '' | endif

  return split( &filetype, '\.' )[0]
endfunction"}}}
function! s:smart_close() "{{{
  if winnr('$') == 1 |quit| endif
endfunction"}}}
"}}}

"----------------------------------------
" initialize"{{{
let g:my = {}
" ユーザー情報"{{{
let g:my.info = {
      \ "author": 'Ishii Hiroyuki',
      \ "email": 'alprhcp666@gmail.com',
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
      \   "ctags_opts"  : '-R --sort=yes --exclude=log --exclude=.git --exclude=.js',
      \ },
      \ }
"}}}
" path"{{{
let g:my.bin = {
      \ "ri" : expand('/Users/taichou/.rbenv/shims/ri'),
      \ "ctags" : expand('/Applications/MacVim.app/Contents/MacOS/ctags'),
      \ }

let g:my.dir = {
      \ "bundle"    : expand('~/.bundle'),
      \ "ctrlp"     : expand('~/.vim.trash/ctrlp'),
      \ "memolist"  : expand('~/.memolist'),
      \ "neocomplcache"  : expand('~/.vim.trash/neocomplcache'),
      \ "snippets"  : expand('~/.vim/snippet'),
      \ "swap_dir"  : expand('~/.vim.trash/vimswap'),
      \ "trash_dir" : expand('~/.vim.trash/'),
      \ "unite"     : expand('~/.vim.trash/unite'),
      \ "vimref"    : expand('~/.vim.trash/vim-ref'),
      \ "vimfiler"  : expand('~/.vim.trash/vimfiler'),
      \ "vimshell"  : expand('~/.vim.trash/vimshell'),
      \ }
"}}}
" その他設定"{{{
let g:my.ft = {
      \ "html_files"      : ['eruby', 'html', 'php', 'haml'],
      \ "ruby_files"      : ['ruby', 'Gemfile', 'haml', 'eruby', 'yaml'],
      \ "js_files"        : ['javascript', 'coffeescript', 'node', 'json', 'typescript'],
      \ "python_files"    : ['python'],
      \ "scala_files"     : ['scala'],
      \ "sh_files"        : ['sh'],
      \ "php_files"       : ['php', 'phtml'],
      \ "c_files"         : ["c", "cpp"],
      \ "style_files"     : ['css', 'scss', 'sass'],
      \ "markup_files"    : ['html', 'haml', 'erb', 'php'],
      \ "program_files"   : ['ruby', 'php', 'python', 'eruby', 'vim', 'javascript', 'coffee', 'scala', 'java'],
      \ "ignore_patterns" : ['vimfiler', 'unite'],
      \ }

" TODO インストールするプログラムを書く
" プログラムはまだかけていない
let g:my.install = {
      \ "gem" : ['alpaca_complete', 'CoffeeTags', 'rails', 'bundler', 'i18n', 'coffee-script',],
      \ "homebrew" : ['scala', 'sbt'],
      \ }
"}}}
if g:my.conf.initialize "{{{
  let dir_list = []
  call map(copy(g:my.dir), 'add(dir_list, v:val)')
  call alpaca#initialize#directory(dir_list)
endif"}}}
" OS"{{{
let s:is_windows = has('win32') || has('win64')
let s:is_mac     = has('mac')
let s:is_imac    = s:is_mac && match(substitute(system("echo $HOST"), "\n", "", "g"), "iMac") > -1
let s:is_unix    = has('unix')
"}}}
"}}}

"----------------------------------------
" basic settings {{{
let mapleader = ","
execute "set directory=".g:my.dir.swap_dir
set backspace=indent,eol,start
set browsedir=buffer
set clipboard+=autoselect
set clipboard+=unnamed
set formatoptions+=lcqmM
set helplang=ja,en
set modelines=1
set nomore
" set mouse=nv
" set mousefocus
" set mousehide
" set guioptions+=a
set ttymouse=xterm2
set nobackup
set norestorescreen
set showmode
set timeout timeoutlen=300 ttimeoutlen=100
set viminfo='1000,<800,s300,\"300,f1,:1000,/1000
set visualbell t_vb=

if v:version >= 703
  set undofile
  let &undodir=&directory
endif

nnoremap <Space><Space>s :<C-U>source ~/.vimrc<CR>
nnoremap <Space><Space>v :<C-U>tabnew ~/.vim/config/.vimrc<CR>
"}}}

"----------------------------------------
" neobundle initialize {{{
filetype plugin indent off     " required!
let g:neobundle#types#git#default_protocol = 'https'

" initialize"{{{
let g:neobundle#types#git#default_protocol = 'https'
let g:neobundle#install_max_processes = s:is_imac ? 50 : 10

if g:my.conf.initialize && !isdirectory(g:my.dir.bundle.'/neobundle.vim')
  call system( 'git clone https://github.com/Shougo/neobundle.vim.git '. g:my.dir.bundle . '/neobundle.vim' )
endif

execute 'set runtimepath+='.g:my.dir.bundle.'/neobundle.vim'
call neobundle#rc(g:my.dir.bundle)
"}}}
function! s:bundle_load_depends(bundle_names) "{{{
  if !exists('s:loaded_bundles')
    let s:loaded_bundles = {}
  endif

  " bundleの読み込み
  if !has_key( s:loaded_bundles, a:bundle_names )
    execute 'NeoBundleSource '.a:bundle_names
    let s:loaded_bundles[a:bundle_names] = 1
  endif
endfunction"}}}
function! s:bundle_with_cmd(bundle_names, cmd) "{{{
  call <SID>bundle_load_depends(a:bundle_names)

  " コマンドの実行
  if !empty(a:cmd)
    execute a:cmd
  endif
endfunction
"}}}

"----------------------------------------
" {{{
" 基本 / その他 {{{
NeoBundle 'Shougo/neobundle.vim'

" 非同期通信
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \   'mac' : 'make -f make_mac.mak',
      \   'unix' : 'make -f make_unix.mak',
      \ }}
" フォントとか。読み込むことは無い"{{{
let g:ricty_generate_command = join([
      \   'sh ricty_generator.sh',
      \   neobundle#get_neobundle_dir().'/alpaca/fonts/Inconsolata.otf',
      \   neobundle#get_neobundle_dir().'/alpaca/fonts/migu-1m-regular.ttf',
      \   neobundle#get_neobundle_dir().'/alpaca/fonts/migu-1m-bold.ttf',
      \ ], ' ')
"}}}
" ゴミ文字文字消す
NeoBundleLazy 'taichouchou2/alpaca_remove_dust.vim', {
      \ 'autoload': {
      \   'insert' : 1,
      \   'commands': ['RemoveDustDisable', 'RemoveDustEnable', 'RemoveDustRun']
      \ }}

" window系script
NeoBundleLazy 'taichouchou2/alpaca_window.vim', {
      \ 'autoload': {
      \   'mappings' : [
      \     '<Plug>(alpaca_window_new)', '<Plug>(alpaca_window_smart_new)',
      \     '<Plug>(alpaca_window_tabnew)', '<Plug>(alpaca_window_move_next_window_or_tab)',
      \     '<Plug>(alpaca_window_move_previous_window_or_tab)', '<Plug>(alpaca_window_move_buffer_into_last_tab)'
      \   ],
      \   'functions' : [
      \     'alpaca_window#set_smart_close', 'alpaca_window#smart_close', 'alpaca_window#open_buffer'
      \   ],
      \ }}

" Git操作
NeoBundle 'tpope/vim-fugitive', {
      \ 'autoload' : {
      \   'commands': ['Gcommit', 'Gblame', 'Ggrep', 'Gdiff'] }}
" syntaxチェック
NeoBundleLazy 'scrooloose/syntastic', { 'autoload': {
      \ 'build' : {
      \   'mac' : ['brew install tidy', 'brew install csslint', 'gem install sass', 'brew install jslint']
      \ },
      \ 'filetypes' : g:my.ft.program_files }}
NeoBundle 'Lokaltog/powerline', { 'rtp' : 'powerline/bindings/vim'}
NeoBundleLazy 'mattn/webapi-vim'
"}}}
" vim拡張"{{{
" NeoBundle 'taku-o/vim-toggle' "true<=>false など、逆の意味のキーワードを切り替えられる
" NeoBundle 'yuroyoro/vimdoc_ja'
" NeoBundle 'kana/vim-altr' " 関連するファイルを切り替えれる

" Shougo"{{{
NeoBundleLazy 'Shougo/unite.vim', {
      \ 'autoload' : {
      \   'commands' : [ {
      \     'name' : 'Unite',
      \     'complete' : 'customlist,unite#complete_source'},
      \     'UniteBookmarkAdd', 'UniteClose', 'UniteResume',
      \     'UniteWithBufferDir', 'UniteWithCurrentDir', 'UniteWithCursorWord',
      \     'UniteWithInput', 'UniteWithInputDirectory']
      \ }}
NeoBundleLazy 'ujihisa/unite-colorscheme', {
      \ 'autoload': {
      \   'unite_sources': 'colorscheme'
      \ }}
NeoBundleLazy 'Shougo/unite-build', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload': {
      \   'filetypes' : g:my.ft.scala_files,
      \   'unite_sources' : 'build'
      \ }}
NeoBundleLazy 'Shougo/unite-outline', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \   'unite_sources' : 'outline' },
      \ }
NeoBundleLazy 'Shougo/vimfiler', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \   'commands' : [
      \     { 'name' : 'VimFiler',
      \       'complete' : 'customlist,vimfiler#complete' },
      \     { 'name' : 'VimFilerBufferDir',
      \       'complete' : 'customlist,vimfiler#complete' },
      \     { 'name' : 'VimFilerExplorer',
      \       'complete' : 'customlist,vimfiler#complete' },
      \     { 'name' : 'Edit',
      \       'complete' : 'customlist,vimfiler#complete' },
      \     { 'name' : 'Write',
      \       'complete' : 'customlist,vimfiler#complete' },
      \       'Read', 'Source'],
      \   'mappings' : ['<Plug>(vimfiler_switch)'],
      \   'explorer' : 1,
      \ }}
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
endfunction"}}}

" 起動時にディレクトリを指定した場合
for arg in argv()
  if isdirectory(getcwd().'/'.arg)
    NeoBundleSource vimfiler
    autocmd! LoadVimFiler
    break
  endif
endfor
" }}}
NeoBundleLazy 'Shougo/git-vim', {
      \ 'autoload' : {
      \ 'commands': [
      \   { "name": "GitDiff",     "complete" : "customlist,git#list_commits" },
      \   { "name": "GitVimDiff",  "complete" : "customlist,git#list_commits" },
      \   { "name": "Git",         "complete" : "customlist,git#list_commits" },
      \   { "name": "GitCheckout", "complete" : "customlist,git#list_commits" },
      \   { "name": "GitAdd",      "complete" : "file" },
      \   "GitLog", "GitCommit", "GitBlame", "GitPush"] }}

NeoBundleLazy 'Shougo/neocomplcache', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}

NeoBundleLazy 'Shougo/echodoc', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}

NeoBundleLazy 'Shougo/neosnippet', {
      \ 'autoload' : {
      \   'commands' : ['NeoSnippetEdit'],
      \   'filetypes' : 'snippet',
      \   'insert' : 1,
      \   'unite_sources' : ['snippet', 'neosnippet/user', 'neosnippet/runtime'],
      \ }}

NeoBundleLazy 'Shougo/vimshell', {
      \ 'autoload' : {
      \   'commands' : [{
      \     'name' : 'VimShell',
      \     'complete' : 'customlist,vimshell#complete'},
      \     'VimShellExecute', 'VimShellInteractive', 'VimShellTerminal', 'VimShellPop'],
      \   'mappings' : ['<Plug>(vimshell_switch)']
      \ }}
NeoBundleLazy 'ujihisa/vimshell-ssh', { 'autoload' : {
      \ 'filetypes' : 'vimshell' }}
"}}}
" commands"{{{
NeoBundleLazy 'vim-scripts/sudo.vim', {
      \ 'autoload': { 'commands': ['SudoRead', 'SudoWrite'], 'insert': 1 }}
NeoBundleLazy 'glidenote/memolist.vim', { 'depends' :
      \ ['Shougo/unite.vim', 'Shougo/vimfiler'],
      \ 'autoload' : { 'commands' : ['MemoNew', 'MemoGrep'] }}
NeoBundleLazy 'h1mesuke/vim-alignta', {
      \ 'autoload' : { 'commands' : ['Align'] }}
NeoBundleLazy 'grep.vim', {
      \ 'autoload' : { 'commands': ["Grep", "Rgrep", "GrepBuffer"] }}
NeoBundleLazy 'kien/ctrlp.vim', {
      \ 'autoload' : { 'commands' : ['CtrlPBuffer', 'CtrlPDir', 'CtrlPCurFile'] }}
NeoBundleLazy 'sjl/gundo.vim', {
      \ 'autoload' : { 'commands': ["GundoToggle", 'GundoRenderGraph'] }}
NeoBundleLazy 'majutsushi/tagbar', {
      \ 'autoload' : {
      \   'commands': ["TagbarToggle", "TagbarTogglePause"],
      \   'fuctions': ['tagbar#currenttag'] }}
" NeoBundleLazy 'yuratomo/w3m.vim', {
"       \ 'build' : {
"       \   'mac' : 'brew install w3m',
"       \   'unix': 'sudo yum install w3m',
"       \ },
"       \ 'autoload' : { 'commands' : 'W3m' }}
NeoBundleLazy 'open-browser.vim', { 'autoload' : {
      \ 'mappings' : [ '<Plug>(open-browser-wwwsearch)', '<Plug>(openbrowser-open)',  ],
      \ 'commands' : ['OpenBrowserSearch'] }}
NeoBundleLazy 'thinca/vim-ref', { 'autoload' : {
      \ 'commands' : {
      \   'name' : "Ref",
      \   'complete' : 'customlist,ref#complete',
      \ },
      \ 'unite_sources' : ["ref/erlang", "ref/man", "ref/perldoc", "ref/phpmanual", "ref/pydoc", "ref/redis", "ref/refe", "ref/webdict"],
      \ 'mappings' : ['n', 'K', '<Plug>(ref-keyword)']
      \ }}
NeoBundleLazy 'tomtom/tcomment_vim', { 'autoload' : {
      \ 'commands' : ['TComment', 'TCommentAs', 'TCommentMaybeInline'] }}
NeoBundleLazy 'tyru/caw.vim', {
      \ 'autoload' : {
      \   'insert' : 1,
      \   'mappings' : [ '<Plug>(caw:prefix)', '<Plug>(caw:i:toggle)'],
      \ }}
NeoBundleLazy 'mattn/gist-vim', {
      \ 'depends': ['mattn/webapi-vim' ],
      \ 'autoload' : {
      \   'commands' : 'Gist' }}
" NeoBundleLazy 'sgur/unite-qf', { 'autoload': {
"       \ 'unite_sources' : 'qf'
"       \ }}
NeoBundleLazy  'osyo-manga/unite-quickfix', { 'autoload': {
      \ 'unite_sources' : ['quickfix', 'location_list']
      \ }}
NeoBundleLazy 'thinca/vim-quickrun', { 'autoload' : {
      \   'mappings' : [['nxo', '<Plug>(quickrun)']],
      \   'commands' : 'QuickRun' }}
"}}}
" extend mappings"{{{
NeoBundleLazy 'tyru/eskk.vim', { 'autoload' : {
      \ 'mappings' : [['i', '<Plug>(eskk:toggle)']],
      \ }}
NeoBundleLazy 'AndrewRadev/switch.vim', { 'autoload' : {
      \ 'commands' : 'Switch',
      \ }}
NeoBundleLazy 'kana/vim-arpeggio', { 'autoload': { 'functions': ['arpeggio#map'] }}
NeoBundleLazy 'camelcasemotion', { 'autoload' : {
      \ 'mappings' : ['<Plug>CamelCaseMotion_w', '<Plug>CamelCaseMotion_b', '<Plug>CamelCaseMotion_e', '<Plug>CamelCaseMotion_iw', '<Plug>CamelCaseMotion_ib', '<Plug>CamelCaseMotion_ie']
      \ }}
NeoBundleLazy 'rhysd/clever-f.vim', { 'autoload' : {
      \   'mappings' : ['f', '<Plug>(clever-f-f)'],
      \ }}
NeoBundleLazy 'mattn/zencoding-vim', {
      \ 'autoload': {
      \   'functions': ['zencoding#expandAbbr'],
      \   'filetypes': g:my.ft.html_files + g:my.ft.style_files,
      \ }}
NeoBundleLazy 'kana/vim-smartword', { 'autoload' : {
      \ 'mappings' : [
      \   '<Plug>(smartword-w)', '<Plug>(smartword-b)', '<Plug>(smartword-ge)']
      \ }}
NeoBundleLazy 't9md/vim-textmanip', { 'autoload' : {
      \ 'mappings' : [
      \   '<Plug>(textmanip-move-down)', '<Plug>(textmanip-move-up)',
      \   '<Plug>(textmanip-move-left)', '<Plug>(textmanip-move-right)'],
      \ }}
NeoBundleLazy 'edsono/vim-matchit', { 'autoload' : {
      \ 'filetypes': g:my.ft.program_files,
      \ 'mappings' : ['nx', '%'] }}
NeoBundleLazy 'rhysd/accelerated-jk', {
      \ 'autoload' : {
      \   'mappings' : [
      \     ['n', '<Plug>(accelerated_jk_gj)'], ['n', '<Plug>(accelerated_jk_gk)']
      \ ]}}
NeoBundleLazy 'tpope/vim-surround', {
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>Dsurround'], ['nx', '<Plug>Csurround' ],
      \     ['nx', '<Plug>Ysurround' ], ['nx', '<Plug>YSurround' ],
      \     ['nx', '<Plug>Yssurround'], ['nx', '<Plug>YSsurround'],
      \     ['nx', '<Plug>YSsurround'], ['nx', '<Plug>VgSurround'],
      \     ['nx', '<Plug>VSurround']
      \ ]}}
NeoBundleLazy 'tpope/vim-speeddating', {
      \ 'autoload': {
      \   'mappings': [
      \     ['nx', '<C-A>'], ['nx', '<C-X>']
      \ ] }}
" extend vim
NeoBundleLazy 'kana/vim-fakeclip', { 'autoload' : {
      \ 'mappings' : [
      \   ['nv', '<Plug>(fakeclip-y)'], ['nv', '<Plug>(fakeclip-Y)'],
      \   ['nv', '<Plug>(fakeclip-p)'], ['nv', '<Plug>(fakeclip-P)'],
      \   ['nv', '<Plug>(fakeclip-gp)']]
      \ }}
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
NeoBundleLazy 'ujihisa/neco-look', {
      \ 'depends' : 'Shougo/neocomplcache',
      \ 'autoload': {
      \   'filetypes' : g:my.ft.program_files,
      \ }}
" NeoBundleLazy 'taichouchou2/alpaca_look.git', {
"       \ 'autoload' : {
"       \   'insert' : 1,
"       \ }}
"}}}
" text-object拡張"{{{
" NeoBundle 'emonkak/vim-operator-comment'
" NeoBundle 'kana/vim-textobj-jabraces'
" NeoBundle 'kana/vim-textobj-datetime'      " d 日付
" NeoBundle 'kana/vim-textobj-fold.git'      " z 折りたたまれた{{ {をtext-objectに
" NeoBundle 'kana/vim-textobj-lastpat.git'   " /? 最後に検索されたパターンをtext-objectに
" NeoBundle 'kana/vim-textobj-syntax.git'    " y syntax hilightされたものをtext-objectに
" NeoBundle 'textobj-entire'                 " e buffer全体をtext-objectに
" NeoBundle 'thinca/vim-textobj-comment'     " c commentをtext-objectに
" f 関数をtext-objectに
NeoBundle 'kana/vim-textobj-function.git', {
      \ 'depends' : 'kana/vim-textobj-user',
      \ }
NeoBundleLazy 'kana/vim-operator-user'
NeoBundleLazy 'kana/vim-operator-replace', {
      \ 'depends' : 'vim-operator-user',
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>(operator-replace)']]
      \ }}
nmap _  <Plug>(operator-replace)

NeoBundleLazy 'kana/vim-textobj-user'
NeoBundle 'kana/vim-textobj-indent.git', {
      \ 'depends' : 'kana/vim-textobj-user',
      \ 'autoload': {
      \   'mappings' : [
      \     ['nx', '<Plug>(textobj-indent-a)' ], ['nx', '<Plug>(textobj-indent-i)'],
      \     ['nx', '<Plug>(textobj-indent-same-a)'], ['nx', '<Plug>(textobj-indent-same-i)']
      \ ]}}
NeoBundleLazy 'operator-camelize', {
      \ 'depends' : 'kana/vim-operator-user',
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>(operator-camelize)'], ['nx', '<Plug>(operator-decamelize)']
      \ ]}}
" NeoBundle 'tyru/operator-html-escape.vim'
"}}}
"}}}
" unite"{{{
" NeoBundleLazy 'thinca/vim-qfreplace', { 'autoload' : {
"       \ 'filetypes' : ['unite'],
"       \ }}
NeoBundleLazy 'tacroe/unite-mark', {
      \ 'depends' : ['Shougo/unite.vim'],
      \ 'autoload': {
      \   'unite_sources' : 'mark'
      \ }}
NeoBundleLazy 'tsukkee/unite-tag', {
      \ 'depends' : ['Shougo/unite.vim'],
      \ 'autoload' : {
      \   'unite_sources' : 'tag'
      \ }}
" NeoBundleLazy 'mattn/qiita-vim', { 'depends' :
"       \ ['Shougo/unite.vim', 'mattn/webapi-vim'],
"       \ 'autoload': {
"       \   'unite_sources' : 'qiita'
"       \ }}
" NeoBundleLazy 'Shougo/unite-ssh', {
"       \ 'depends' : ['Shougo/unite.vim', 'Shougo/vimproc', 'Shougo/vimfiler'],
"       \ 'autoload' : {
"       \   'mappings' : ['n', '[unite]s'],
"       \   'unite_sources' : 'ssh'
"       \ }}
" NeoBundleLazy 'choplin/unite-vim_hacks'
NeoBundleLazy 'kmnk/vim-unite-giti', {
      \ 'autoload': {
      \   'unite_sources': [
      \     'giti', 'giti/branch', 'giti/branch/new', 'giti/branch_all',
      \     'giti/config', 'giti/log', 'giti/remote', 'giti/status'
      \   ]
      \ }}
" NeoBundleLazy 'hrsh7th/vim-versions', {
"       \ 'autoload' : {
"       \   'functions' : 'versions#info',
"       \   'commands' : 'UniteVersions' }}
NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : {
      \ 'unite_sources' : ['history/command', 'history/search']
      \ }}
NeoBundleLazy 'ujihisa/unite-locate', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload': {
      \   'unite_sources': 'locate'
      \ }}
" NeoBundleLazy 'osyo-manga/unite-filetype', { 'autoload' : {
"       \ 'unite_sources' : 'filetype',
"       \ }}
NeoBundleLazy 'basyura/TweetVim', { 'depends' :
      \ ['basyura/twibill.vim', 'tyru/open-browser.vim', 'Shougo/unite.vim'],
      \ 'autoload' : {
      \   'commands' : [ 'TweetVimAccessToken', 'TweetVimAddAccount', 'TweetVimBitly', 'TweetVimCommandSay', 'TweetVimCurrentLineSay', 'TweetVimHomeTimeline', 'TweetVimListStatuses', 'TweetVimMentions', 'TweetVimSay', 'TweetVimSearch', 'TweetVimSwitchAccount', 'TweetVimUserTimeline', 'TweetVimVersion' ],
      \   'unite-sources' : ['tweetvim', 'tweetvim/account']
      \ }}
" NeoBundleLazy 'ujihisa/unite-font', {
"       \ 'gui' : 1,
"       \ 'autoload' : {
"       \   'unite_sources' : 'font'
"       \ }}
"}}}
" その他 / テスト {{{
NeoBundleLazy 'kana/vim-smartchr', { 'autoload' : {
      \ 'insert' : 1,
      \ 'filetypes' : g:my.ft.program_files,
      \ 'functions' : [ "smartchr#loop" ],
      \ }}
NeoBundleLazy 'itchyny/thumbnail.vim', { 'autoload' : {
      \ 'commands' : 'Thumbnail'
      \ }}
NeoBundleLazy 'tyru/restart.vim', {
      \ 'gui' : 1,
      \ 'autoload' : {
      \  'commands' : 'Restart'
      \ }}
NeoBundleLazy 'kana/vim-niceblock', { 'autoload' : {
      \ 'mappings' : ['<Plug>(niceblock-I)', '<Plug>(niceblock-A)']
      \ }}
NeoBundleLazy 'airblade/vim-gitgutter', {
      \ 'autoload': {
      \   'commands': [
      \     'GitGutterDisable', 'GitGutterEnable', 'GitGutterToggle', 'GitGutter',
      \     'GitGutterAll', 'GitGutterNextHunk', 'GitGutterPrevHunk', ''
      \ ]}}
NeoBundleLazy 'taichouchou2/yanktmp.vim', { 'autoload': {
      \ 'functions': [
      \   "yanktmp#yank", "yanktmp#paste_p", "yanktmp#paste_P"
      \ ]
      \ }}
NeoBundleLazy 'HybridText', { 'autoload' : {
      \ 'filetypes' : 'hybrid',
      \ }}
NeoBundleLazy 'DirDiff.vim', { 'autoload' : {
      \ 'commands' : 'DirDiff'
      \ }}
NeoBundleLazy 'repeat.vim', { 'autoload' : {
      \ 'mappings' : '.',
      \ }}


" NeoBundleLazy 'mattn/vdbi-vim', {
"       \ 'depends': 'mattn/webapi-vim' }
"}}}
" リポジトリをクローンするのみ"{{{
NeoBundleLazy 'github/gitignore'
NeoBundleLazy 'taichouchou2/rsense-0.3', {
      \ 'build' : {
      \    'mac': 'ruby etc/config.rb > ~/.rsense',
      \    'unix': 'ruby etc/config.rb > ~/.rsense',
      \ } }
NeoBundleFetch 'yascentur/Ricty', {
      \ 'depends' : 'taichouchou2/alpaca',
      \ 'autoload' : {
      \   'build' : {
      \     'mac'  : g:ricty_generate_command,
      \     'unix' : g:ricty_generate_command,
      \   }
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
" NeoBundleLazy 'ujihisa/neco-ghc', { 'autoload' : {
"       \ 'filetypes' : 'haskell'
"       \ }}

"  js / coffee
" ----------------------------------------
NeoBundleLazy 'kchmck/vim-coffee-script', { 'autoload' : {
      \ 'filetypes' : 'coffee' }}
NeoBundleLazy 'claco/jasmine.vim', { 'autoload' : {
      \ 'filetypes' : g:my.ft.js_files }}
NeoBundleLazy 'jiangmiao/simple-javascript-indenter', { 'autoload' : {
      \ 'filetypes' : ['javascript', 'json'],
      \ }}
" NeoBundleLazy 'taichouchou2/vim-javascript', { 'autoload' : {
"       \ 'filetypes' : ['javascript']
"       \ }}
NeoBundleLazy 'jelera/vim-javascript-syntax', { 'autoload' : {
      \ 'filetypes' : ['javascript', 'json'],
      \ }}
" NeoBundleLazy 'taichouchou2/vim-json', { 'autoload' : {
"       \ 'filetypes' : g:my.ft.js_files
"       \ }}
NeoBundleLazy 'teramako/jscomplete-vim', { 'autoload' : {
      \ 'filetypes' : g:my.ft.js_files
      \ }}
" TODO こいつはすごい。気になる。時間がある時にneocomplcacheのsource作ろう
NeoBundleLazy 'marijnh/tern', {
      \ 'build' : {
      \   'mac': 'npm install',
      \   'unix': 'npm install'
      \ },
      \ 'autoload' : {
      \   'filetypes': 'javascript'
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
NeoBundleLazy 'tpope/vim-markdown', { 'autoload' : {
      \ 'filetypes' : ['markdown'] }}

" sassのコンパイル
NeoBundleLazy 'AtsushiM/sass-compile.vim', {
      \ 'autoload': { 'filetypes': ['sass', 'scss'] }}

"  php
" ----------------------------------------
NeoBundleLazy 'taichouchou2/alpaca_wordpress.vim', { 'autoload' : {
      \ 'filetypes': 'php' }}

"  binary
" ----------------------------------------
NeoBundleLazy 'Shougo/vinarise', {
      \ 'depends': ['s-yukikaze/vinarise-plugin-peanalysis'],
      \ 'autoload': { 'commands': 'Vinarise'}}

" html
" ----------------------------------------
" なんかプラグイン間違えてる...
" NeoBundleLazy 'koron/chalice', {
"       \ 'depends': ['ynkdir/vim-funlib'],
"       \ 'autoload': { 'commands': ['AL_urlencode', 'AL_urldecode'] }}

" objective-c
" ----------------------------------------
" NeoBundle 'msanders/cocoa.vim'

" ruby
" ----------------------------------------
NeoBundleLazy 'taichouchou2/vim-rails', { 'autoload' : {
      \ 'filetypes' : g:my.ft.ruby_files }}
NeoBundleLazy 'taichouchou2/vim-endwise.git', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}

" rails
NeoBundleLazy 'basyura/unite-rails', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \   'unite_sources' : [
      \     'rails/bundle', 'rails/bundled_gem', 'rails/config',
      \     'rails/controller', 'rails/db', 'rails/destroy', 'rails/features',
      \     'rails/gem', 'rails/gemfile', 'rails/generate', 'rails/git', 'rails/helper',
      \     'rails/heroku', 'rails/initializer', 'rails/javascript', 'rails/lib', 'rails/log',
      \     'rails/mailer', 'rails/model', 'rails/rake', 'rails/route', 'rails/schema', 'rails/spec',
      \     'rails/stylesheet', 'rails/view'
      \   ]
      \ }}
NeoBundleLazy 'taichouchou2/unite-rails_best_practices', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'build' : {
      \    'mac': 'gem install rails_best_practices',
      \    'unix': 'gem install rails_best_practices',
      \ },
      \ 'autoload': {
      \   'unite_sources': 'rails_best_practices'
      \ }}
NeoBundleLazy 'taichouchou2/alpaca_complete', {
      \ 'depends' : 'taichouchou2/vim-rails',
      \ 'build' : {
      \    'mac':  'gem install alpaca_complete',
      \    'unix': 'gem install alpaca_complete',
      \   }
      \ }

let s:bundle_rails = 'unite-rails unite-rails_best_practices alpaca_complete'
if has('vim_starting')
  aug MyAutoCmd
    au User Rails call <SID>bundle_load_depends(s:bundle_rails)
  aug END
endif

" ruby全般
NeoBundleLazy 'ruby-matchit', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'skwp/vim-rspec', {
      \ 'build': {
      \   'mac': 'gem install hpricot',
      \   'unix': 'gem install hpricot'
      \ },
      \ 'autoload': { 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'taka84u9/vim-ref-ri', {
      \ 'depends': ['Shougo/unite.vim', 'thinca/vim-ref'],
      \ 'autoload': { 'filetypes': g:my.ft.ruby_files } }
" NeoBundleLazy 'vim-ruby/vim-ruby', { 'autoload': {
"       \ 'mappings' : '<Plug>(ref-keyword)',
"       \ 'filetypes': g:my.ft.ruby_files}}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : {
      \ 'unite_sources' : 'help'
      \ }}
NeoBundleLazy 'taichouchou2/unite-reek', {
      \ 'build' : {
      \   'mac': 'gem install reek',
      \   'unix': 'gem install reek',
      \ },
      \ 'autoload': {
      \   'filetypes': g:my.ft.ruby_files,
      \   'unite_sources': 'reek',
      \ },
      \ 'depends' : 'Shougo/unite.vim' }
NeoBundleLazy 'ujihisa/unite-rake', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload': {
      \   'filetypes' : g:my.ft.ruby_files,
      \   'unite_sources': 'rake'
      \ }}
" NeoBundleLazy 'Shougo/neocomplcache-rsense', {
"       \ 'depends': 'Shougo/neocomplcache',
"       \ 'autoload': { 'filetypes': 'ruby' }}
NeoBundleLazy 'rhysd/unite-ruby-require.vim', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files }}
NeoBundleLazy 'rhysd/vim-textobj-ruby', { 'depends': 'kana/vim-textobj-user' }

NeoBundleLazy 'deris/vim-textobj-enclosedsyntax', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files}}
" NeoBundleLazy 'rhysd/neco-ruby-keyword-args', { 'autoload': {
"       \ 'filetypes': g:my.ft.ruby_files }}

NeoBundleLazy 'ujihisa/unite-gem', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload': { 'filetypes': g:my.ft.ruby_files }}
NeoBundleLazy 'tpope/vim-cucumber', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files }}
NeoBundleLazy 'mutewinter/nginx.vim', { 'autoload': {
      \ 'filetypes': g:my.ft.ruby_files }}

" python
" ----------------------------------------
" NeoBundle 'Pydiction'
NeoBundleLazy 'yuroyoro/vim-python', { 'autoload' : {
      \ 'filetypes' : g:my.ft.python_files }}
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
" NeoBundleLazy 'taichouchou2/vim-scala', { 'autoload': {
"       \ 'filetypes' : g:my.ft.scala_files }}
NeoBundleLazy 'andreypopp/ensime', { 'autoload' : {
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

" cpp / c
NeoBundleLazy 'Rip-Rip/clang_complete', {
      \ 'autoload' : {
      \     'filetypes' : g:my.ft.c_files,
      \    },
      \ }
NeoBundleLazy 'osyo-manga/neocomplcache-clang_complete', {
      \ 'autoload' : {
      \     'filetypes' : g:my.ft.c_files,
      \    },
      \ }
NeoBundleLazy "vim-jp/cpp-vim", {
      \ 'autoload' : {
      \     'filetypes' : g:my.ft.c_files,
      \    },
      \ }

" sh
" ----------------------------------------
NeoBundleLazy 'sh.vim', { 'autoload': {
      \ 'filetypes': g:my.ft.sh_files }}
"}}}
" 他のアプリを呼び出すetc "{{{
" NeoBundle 'thinca/vim-openbuf'
NeoBundleLazy 'vim-scripts/dbext.vim', {
      \ 'autoload' : {
      \   'commands': [
      \     "Alter", "Call", "Create", "DBCheckModeline", "DBCommit",
      \     "DBCompleteProcedure", "DBCompleteTable", "DBCompleteView",
      \     "DBDescribeProcedure", "DBDescribeProcedureAskName",
      \     "DBDescribeTable", "DBDescribeTableAskName", "DBExecRangeSQL",
      \     "DBExecSQL", "DBExecSQLTopX", "DBExecSQLUnderCursor",
      \     "DBExecVisualSQL", "DBGetOption", "DBHistory", "DBListColumn",
      \     "DBListConnections", "DBListProcedure", "DBListTable", "DBListVar",
      \     "DBListView", "DBOrientation", "DBPromptForBufferParameters",
      \     "DBResultsClose", "DBResultsOpen", "DBResultsRefresh",
      \     "DBResultsToggleResize", "DBRollback", "DBSelectFromTable",
      \     "DBSelectFromTableAskName", "DBSelectFromTableTopX",
      \     "DBSelectFromTableWithWhere", "DBSetOption", "DBVarRangeAssign",
      \     "Delete", "Drop", "Insert", "Select", "Update"]
      \ }}
NeoBundleLazy 'tsukkee/lingr-vim', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload': {
      \ 'commands': ['LingrLaunch', 'LingrExit']}}
NeoBundleLazy 'mattn/excitetranslate-vim', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload' : { 'commands': ['ExciteTranslate']}
      \ }
NeoBundleLazy 'taichouchou2/alpaca_update_tags', {
      \ 'depends' : 'tpope/vim-fugitive',
      \ 'autoload' : {
      \   'commands': ['AlpacaUpdateTags', 'AlpacaSetTags']
      \ }}
" NeoBundleLazy 'thinca/vim-scouter', { 'autoload' : {
"       \ 'commands' : 'Scouter'
"       \ }}
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
"}}}

"----------------------------------------
"StatusLine / tabline {{{
source ~/.vim/config/.vimrc.statusline
" }}}

"----------------------------------------
"編集"{{{
" set textwidth=100
set autoread
set hidden
set nrformats-=octal
set nrformats+=alpha
set textwidth=0
" set gdefault
" set splitright
" set splitbelow
set previewheight=8
set helpheight=12

" 開いているファイルのディレクトリに自動で移動
aug MyAutoCmd
  au BufEnter * execute ":silent! lcd! " . expand("%:p:h")
aug END
" 対応を補完 {{{
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap " ""<Left>
inoremap ' ''<Left>
aug MyAutoCmd
  au FileType scala inoremap <buffer>' '
  au FileType ruby,eruby,haml,racc,racc.ruby inoremap <buffer>\| \|\|<Left>
        \| inoremap <buffer>,{ #{}<Left>
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
nnoremap <silent><Space><Space>q :qall!<CR>
nnoremap <silent><Space><Space>w :wall!<CR>
nnoremap <silent><Space>q :q!<CR>
nnoremap <silent><Space>w :wq<CR>
nnoremap <silent><Space>s :w sudo:%<CR>

" これをすると、矢印キーがバグるのはなぜ？
" inoremap <silent><ESC> <Esc>:nohlsearch<CR>
" nnoremap <silent><ESC> <Esc>:nohlsearch<CR>

inoremap <C-D><C-A> <C-R>=g:my.info.author<CR>
inoremap <C-D><C-D> <C-R>=alpaca#function#today()<CR>
inoremap <C-D><C-R> <C-R>=<SID>current_git()<CR>
nnoremap <Leader>s :call <SID>toggle_set_spell()<CR>
" inoremap <C-@> <Esc>[s1z=`]a
xnoremap <silent><C-p> "0p<CR>
nnoremap re :%s!
xnoremap re :s!
xnoremap rep y:%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!g<Left><Left>
xnoremap <Leader>c :s/./&/g
nnoremap <Leader>f :setl filetype=
xmap <silent><C-A> :ContinuousNumber <C-A><CR>
xmap <silent><C-X> :ContinuousNumber <C-X><CR>

let s:alpaca_abbr_define = {
      \ "vim" : [
      \   "sh should",
      \   "reqs require 'spec_helper'",
      \   "req require",
      \ ],
      \ "ruby,ruby.rspec" : [
      \   "sh should",
      \   "reqs require 'spec_helper'",
      \   "req require",
      \ ],
      \ "scss": [
      \   "in include",
      \   "im import",
      \   "mi mixin",
      \ ],
      \ }
for [filetype, abbr_defines] in items(s:alpaca_abbr_define)
  call alpaca#initialize#define_abbrev(abbr_defines, filetype)
endfor

function! s:toggle_set_spell() "{{{
  if &spell
    setl nospell
    echo "nospell"
  else
    setl spell
    echo "spell"
  endif
endfunction"}}}
command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor
"}}}
" コメントを書くときに便利 {{{
inoremap <leader>* ****************************************
inoremap <leader>- ----------------------------------------
inoremap <leader>h <!-- / --><left><left><left><Left>

let g:end_tag_commant_format = '<!-- /%tag_name%id%class -->'
nnoremap ,t :<C-u>call alpaca#function#endtag_comment()<CR>
"}}}
" 変なマッピングを修正 "{{{
nnoremap ¥ \
inoremap ¥ \
cmap ¥ \
smap ¥ \

" 嫌なマッピングを修正
inoremap <C-R> <C-R><C-R>
inoremap <C-R><C-R> <C-R>"

cnoremap <C-R> <C-R><C-R>
cnoremap <C-R><C-R> <C-R>"
cnoremap <C-L> <Right>
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
" Improved increment.{{{
" nmap <C-A> <SID>(increment)
" nmap <C-X> <SID>(decrement)
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
au Filetype php nnoremap <Leader>R :! phptohtml<CR>
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
inoremap <silent><C-A> <End>
inoremap <silent><C-L> <Right>
inoremap <silent><C-O> <CR><Esc>O
inoremap jj <Esc>
nnoremap $ g_
xnoremap $ g_
nnoremap <silent><Down> gj
nnoremap <silent><Up>   gk
nnoremap <silent>j gj
nnoremap <silent>k gk

xnoremap H <Nop>
inoremap <C-@> <Nop>
xnoremap v G
"}}}
" 画面の移動 {{{
" nnoremap <C-L> <C-T>
let g:alpaca_window_default_filetype='ruby'
nmap <silent>L            <Plug>(alpaca_window_move_next_window_or_tab)
nmap <silent>H            <Plug>(alpaca_window_move_previous_window_or_tab)
nmap <silent><C-W>n       <Plug>(alpaca_window_smart_new)
nmap <silent><C-W><C-N>   <Plug>(alpaca_window_smart_new)
"}}}
" tabを使い易く{{{

nmap [tag_or_tab] <Nop>
nmap t [tag_or_tab]
nnoremap <silent>[tag_or_tab]n  :tabnext<CR>
nnoremap <silent>[tag_or_tab]p  :tabprevious<CR>
nnoremap <silent>[tag_or_tab]x  :tabclose<CR>
nnoremap <silent>[tag_or_tab]o  <C-W>T
nmap <silent>[tag_or_tab]c      <Plug>(alpaca_window_tabnew)
nmap <silent>[tag_or_tab]w      <Plug>(alpaca_window_move_buffer_into_last_tab)

nnoremap <silent>[tag_or_tab]1  :<C-U>tabnext 1<CR>
nnoremap <silent>[tag_or_tab]2  :<C-U>tabnext 2<CR>
nnoremap <silent>[tag_or_tab]3  :<C-U>tabnext 3<CR>
nnoremap <silent>[tag_or_tab]4  :<C-U>tabnext 4<CR>
nnoremap <silent>[tag_or_tab]5  :<C-U>tabnext 5<CR>
nnoremap <silent>[tag_or_tab]6  :<C-U>tabnext 6<CR>

function! Move_tab(to) "{{{
  let target_tab_nr = tabpagenr() + a:to -1
  let last_tab_nr = tabpagenr("$") - 1

  if target_tab_nr > last_tab_nr
    let target_tab_nr = last_tab_nr
  elseif target_tab_nr < 1
    let target_tab_nr = 0
  endif

  execute 'tabmove ' target_tab_nr
  echo target_tab_nr
endfunction"}}}
nnoremap <silent>[tag_or_tab]<C-L> :<C-U>call Move_tab(1)<CR>
nnoremap <silent>[tag_or_tab]<C-H> :<C-U>call Move_tab(-1)<CR>
" }}}

" 前回終了したカーソル行に移動
" kaoriyaだとdefaultらしい。
" aug MyAutoCmd
"   autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g`\"" | endif
" aug END
"}}}

"----------------------------------------
"encoding"{{{
set ambiwidth=double
set encoding=utf-8
set fileencodings=utf-8,sjis,shift-jis,euc-jp,utf-16,ascii,ucs-bom,cp932,iso-2022-jp
set fileformat=unix
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
" set cmdheight=1
" set noequalalways     " 画面の自動サイズ調整解除
" set relativenumber    " 相対表示
set pumheight=20
set breakat=\\;:,!?
set cdpath+=~
set cmdheight=2
set cmdwinheight=2
set cursorline
set equalalways       " 画面の自動サイズ調整
set laststatus=2
set lazyredraw
set linebreak
" set balloondelay=300
set browsedir=buffer
" http://www15.ocn.ne.jp/~tusr/vim/options_help.html#highlight
" set highlight=8:SpecialKey,@:NonText,d:Directory,e:ErrorMsg,i:IncSearch,l:Search, m:MoreMsg,M:ModeMsg,n:LineNr,r:Question,s:StatusLine,S:StatusLineNC,c:VertSplit,t:Title,v:Visual,w:WarningMsg,W:WildMenu,f:Folded,F:FoldColumn
" set browsedir=current
set list
set listchars=tab:␣.,trail:›,extends:>,precedes:<
set fillchars=stl:\ ,stlnc:\ ,vert:░,fold:-,diff:-
" set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%
" set listchars=tab:>-,trail:-,extends:>,precedes:<
set matchpairs+=<:>
set number
set scrolloff=5
set showcmd
set showfulltag
set showmatch
set showtabline=2
set spelllang=en
set nospell
set t_Co=256
set title
set titlelen=95
set ttyfast

"折り畳み
" set foldcolumn=1
set foldenable
set foldmethod=marker
set foldnestmax=5

if v:version >= 703
  highlight ColorColumn guibg=#012345
  set conceallevel=2 concealcursor=iv
  set colorcolumn=80
endif

syntax on

" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

let g:molokai_original=1
colorscheme  desertEx
" colorscheme orig_molokai
"}}}

"----------------------------------------
" Tags関連 cTags使う場合は有効化 "{{{
" http://vim-users.jp/2010/06/hack154/

set tags-=tags

aug MyUpdateTags
  au!
  au FileWritePost,BufWritePost * AlpacaUpdateTags
  " au FileReadPost,BufEnter * AlpacaSetTags
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
  au FileType html,php,eruby setl dict+=~/.vim/dict/html.dict
augroup END

" カスタムファイルタイプでも、自動でdictを読み込む
" そして、編集画面までさくっと移動。
function! s:auto_dict_setting() "{{{
  let file_type_name = &filetype

  let dict_name = split( file_type_name, '\.' )

  if empty( dict_name ) || count(g:my.ft.ignore_patterns, dict_name) > 0
    return
  endif

  execute "setl dict+=~/.vim/dict/".dict_name[0].".dict"

  let b:dict_path = expand('~/.vim/dict/'.file_type_name.'.dict')
  execute "setl dictionary+=".b:dict_path

  nnoremap <buffer><expr>[space]d ':<C-U>SmartEdit '.b:dict_path.'<CR>'
endfunc"}}}

aug MyAutoCmd
  au FileType * call <SID>auto_dict_setting()
aug END
"}}}

"----------------------------------------
nnoremap [plug] <Nop>
nnoremap [space] <Nop>
nnoremap [minor] <Nop>
nmap <C-H> [plug]
nmap <Space> [space]
nmap ; [minor]

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
let g:surround_no_mappings = 1
nmap cs  <Plug>Csurround
nmap ds  <Plug>Dsurround
nmap ySS <Plug>YSsurround
nmap ySs <Plug>YSsurround
nmap ys  <Plug>Ysurround
nmap yss <Plug>Yssurround

xmap S   <Plug>VSurround
xmap gS  <Plug>VgSurround
xmap s   <Plug>VSurround

" append custom mappings {{{
let s:surround_mapping = []

if empty( s:surround_mapping )
  call add( s:surround_mapping, {
        \ 'filetypes' : g:my.ft.ruby_files,
        \ 'mappings' : {
        \   '#':  "#{\r}",
        \   '%':  "<% \r %>",
        \   '-':  "<% \r -%>",
        \   '=':  "<%= \r %>",
        \   'w':  "%w!\r!",
        \   'W':  "%W!\r!",
        \   'q':  "%q!\r!",
        \   'Q':  "%Q!\r!",
        \   'r':  "%r!\r!",
        \   'R':  "%R!\r!",
        \   '{':  "{ \r }",
        \ }
        \ })

  call add( s:surround_mapping, {
        \ 'filetypes' : g:my.ft.php_files,
        \ 'mappings' : {
        \   '<' : "<?php \r ?>",
        \ }
        \ })

  call add( s:surround_mapping, {
        \ 'filetypes' : ['_'],
        \ 'mappings' : {
        \   '(' : "(\r)",
        \   '[' : "[\r]",
        \   '{' : "{ \r }",
        \ }
        \ })
endif

function! s:let_surround_mapping(mapping_dict) "{{{
  for [ key, mapping ] in items(a:mapping_dict)
    " XXX filetype変わったときに、unletできない
    call alpaca#let_b:('surround_'.char2nr(key), mapping )
  endfor
endfunction"}}}
function! s:surround_mapping_filetype() "{{{
  if !exists('s:surround_mapping_memo')
    let s:surround_mapping_memo = {}
  endif

  if empty(&filetype) |return| endif
  let filetype = <SID>filetype()

  " メモ化してある場合は設定"{{{
  if has_key( s:surround_mapping_memo, filetype )
    for mappings in s:surround_mapping_memo[filetype]
      call <SID>let_surround_mapping( mappings )
    endfor
    return
  endif "}}}
  " filetypeに当てはまる設定を追加 "{{{
  let memo = []
  for mapping_settings in s:surround_mapping
    if <SID>include( mapping_settings, 'filetypes' ) && <SID>include( mapping_settings, 'mappings')
      let filetypes = mapping_settings.filetypes
      let mappings  = mapping_settings.mappings

      if <SID>include( filetypes, filetype ) || <SID>include( filetypes, '_' )
        call <SID>let_surround_mapping( mappings )
        call add(memo, mappings)
      endif
    endif
  endfor "}}}

  let s:surround_mapping_memo[filetype] = memo
endfunction"}}}

augroup MyAutoCmd
  autocmd FileType * call <SID>surround_mapping_filetype()
augroup END
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
" quickrun.vim
"------------------------------------
"{{{
let g:quickrun_config = {}
let g:quickrun_no_default_key_mappings = 1
nnoremap <silent><Leader>r :QuickRun<CR>

let bundle = neobundle#get('vim-quickrun')
function! bundle.hooks.on_source(bundle) "{{{
  " quickrun config {{{
  let g:quickrun_config._ = {
        \ 'runner' : 'vimproc',
        \ }
  let g:quickrun_config.javascript = {
        \ 'command': 'node'}

  let g:quickrun_config.lisp = {
        \ 'command': 'clisp' }

  let g:quickrun_config["coffee.compile"] = {
        \ 'command' : 'coffee',
        \ 'exec' : ['%c -cbp %s'] }

  let g:quickrun_config["coffee"] = {
        \ 'command' : 'coffee'
        \ }
  let g:quickrun_config["coffee.javascript"] = g:quickrun_config["coffee"]

  let g:quickrun_config.markdown = {
        \ 'outputter': 'browser',
        \ 'cmdopt': '-s' }

  let g:quickrun_config.applescript = {
        \ 'command' : 'osascript' , 'output' : '_'}

  let g:quickrun_config["racc.ruby"] = {
        \ 'command': 'racc',
        \ 'cmdopt' : '-o',
        \ 'args'   : 'main.rb',
        \ 'outputter': 'message',
        \ 'exec'   : '%c %o %a %s', }

  let g:quickrun_config['racc.run'] = {
        \ 'command': 'ruby',
        \ 'args'   : 'main.rb',
        \ 'exec'   : '%c %a src/', }

  let g:quickrun_config['ruby.rspec'] = {
        \ 'type' : 'ruby.rspec',
        \ 'command': 'rspec',
        \ 'exec': 'bundle exec %c %o %s', }

  "}}}
endfunction"}}}
unlet bundle

aug QuickRunAutoCmd "{{{
  au!

  " au FileType quickrun au BufEnter <buffer> if winnr('$') == 1 |quit| endif
  au FileType quickrun au BufEnter <buffer> call s:smart_close()
  au FileType racc.ruby,racc nnoremap <buffer><Leader>R :<C-U>QuickRun racc.run<CR>
aug END "}}}
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
let g:ref_no_default_key_mappings = 1

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
  au FileType vim if empty(&buftype) && &filetype != 'vim' |nnoremap <buffer>K <Plug>(ref-keyword)| endif
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

nnoremap gA :<C-U>GitAdd<Space>
nnoremap <silent>ga :<C-U>GitAdd -A<CR>
nnoremap <silent>gd :<C-U>GitDiff HEAD<CR>
nnoremap gp :<C-U>Git push<Space>
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

  if !exists('b:match_words')
    let b:match_words = ''
  endif

  if b:match_words != '' && b:match_words !~ ':$'
    let b:match_words = b:match_words . ''
  endif

  let b:match_words = b:match_words . s:match_words[ft]
endfunction"}}}

" aug MyAutoCmd
"   au Filetype * call <SID>set_match_words()
" aug END
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
let g:vimshell_user_prompt  = '"(" . getcwd() . ")" '
let g:vimshell_prompt       = '$ '
let g:vimshell_ignore_case  = 1
let g:vimshell_smart_case   = 1
let g:vimshell_temporary_directory = g:my.dir.vimshell


let bundle = neobundle#get('vimshell')
function! bundle.hooks.on_source(bundle) "{{{
  let s:vimshell_altercmd = [
        \ 'vi vim',
        \ 'g git',
        \ 'r rails',
        \ 'diff diff --unified',
        \ 'du du -h',
        \ 'free free -m -l -t',
        \ 'll ls -lh',
        \ 'la ls -a'
        \ ]
  call map(map(s:vimshell_altercmd, "split(v:val, ' ')"), '[v:val[0], join(v:val[1:], " ")]')
  " => [['vi', 'vim'], ['la', 'ls -a']]

  function! s:vimshell_settings() "{{{
    for altercmd in s:vimshell_altercmd
      call vimshell#altercmd#define(altercmd[0], altercmd[1])
    endfor
    imap <buffer>! <Plug>(vimshell_zsh_complete)
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
" let g:memolist_memo_date         = "%Y-%m-%d %H:%M"
let g:memolist_memo_date         = "%D %T"
let g:memolist_memo_date         = "%D %T"
let g:memolist_memo_date         = ""
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
noremap <silent><C-_><c-_> :TComment<CR>
noremap <silent><C-_>c :TComment<CR>
"}}}

"------------------------------------
" ctrlp
"------------------------------------
" {{{
nnoremap <silent>[plug]<C-B> :<C-U>CtrlPBuffer<CR>
nnoremap <silent>[plug]<C-D> :<C-U>CtrlPDir<CR>
nnoremap <silent>[plug]<C-F> :<C-U>CtrlPCurFile<CR>
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
" }}}

"------------------------------------
" vim-ruby
"------------------------------------
"{{{
" function! s:vimRuby()
let g:rubycomplete_buffer_loading = 1
let g:rubycomplete_classes_in_global = 0
let g:rubycomplete_rails = 0
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
function! s:set_up_rails_setting() "{{{
  nnoremap <buffer><Space>r :R<CR>
  nnoremap <buffer><Space>a :A<CR>
  nnoremap <buffer><Space>m :Rmodel<Space>
  nnoremap <buffer><Space>c :Rcontroller<Space>
  nnoremap <buffer><Space>v :Rview<Space>
  nnoremap <buffer><Space>p :Rpreview<CR>

  setl dict+=~/.vim/dict/ruby.rails.dict
  for s:syntax in split(glob($HOME.'/.vim/syntax/ruby.rails.*.vim'))
    execute 'source ' . s:syntax
  endfor

  if !exists('b:file_type_name') | return | endif

  execute 'nnoremap <buffer><Space><Space>d  :<C-U>SmartEdit ~/.vim/dict/'. b:file_type_name .'.dict<CR>'
  execute 'setl dict+=~/.vim/dict/' . b:file_type_name . '.dict'
endfunction"}}}
function! s:set_up_rails_setting() "{{{
  nnoremap <Space>r :R<CR>
  nnoremap <Space>a :A<CR>
  nnoremap <Space>m :Rmodel<Space>
  nnoremap <Space>c :Rcontroller<Space>
  nnoremap <Space>v :Rview<Space>
  nnoremap <Space>p :Rpreview<CR>

  set dict+=~/.vim/dict/ruby.rails.dict
  for s:syntax in split(glob($HOME.'/.vim/syntax/ruby.rails.*.vim'))
    execute 'source ' . s:syntax
  endfor

  if !exists('b:file_type_name') | return | endif

  execute 'nnoremap <buffer><Space><Space>d  :<C-U>SmartEdit ~/.vim/dict/'. b:file_type_name .'.dict<CR>'
  execute 'set dict+=~/.vim/dict/' . b:file_type_name . '.dict'
endfunction"}}}

function! s:do_rails()
  let git_dir = <SID>current_git()

  if isdirectory(git_dir) && filereadable(git_dir . '/config/environment.rb')
    if <SID>include(g:my.ft.program_files, &filetype)
      silent doau User Rails
    endif
  endif
endfunction

aug MyAutoCmd
  au User Rails call <SID>set_up_rails_setting()
  au BufEnter * call <SID>do_rails()
aug END

aug RailsDictSetting "{{{
  au!
  " 別の関数に移そうか..
  au User Rails.controller*           let b:file_type_name="ruby.controller"
  au User Rails.view*erb              let b:file_type_name="ruby.view"
  au User Rails.view*haml             let b:file_type_name="haml.view"
  au User Rails.model*                let b:file_type_name="ruby.model"
  au User Rails/db/migrate/*          let b:file_type_name="ruby.migrate"
  au User Rails/config/environment.rb let b:file_type_name="ruby.environment"
  au User Rails/config/routes.rb      let b:file_type_name="ruby.routes"
  au User Rails/config/database.rb    let b:file_type_name="ruby.database"
  au User Rails/config/boot.rb        let b:file_type_name="ruby.boot"
  au User Rails/config/locales/*      let b:file_type_name="ruby.locales"
  au User Rails/config/initializes    let b:file_type_name="ruby.initializes"
  au User Rails/config/environments/* let b:file_type_name="ruby.environments"
aug END"}}}
"}}}

"------------------------------------
" vim-rspec
"------------------------------------
let g:RspecKeymap=0
function! s:rspec_settings()
  nnoremap <buffer><Leader>r :RunSpec<CR>
  nnoremap <buffer><Leader>lr :RunSpecLine<CR>
  au FileType RSpecOutput setl nofoldenable
endfunction
au bufNewFile,bufRead *_spec.rb call s:rspec_settings()

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
nnoremap <silent>[unite]T  :call <SID>bundle_with_cmd('TweetVim bitly.vim twibill.vim', 'Unite tweetvim -buffer-name=tweetvim -no-start-insert')<CR>
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
"{{{
" let bundle = neobundle#get('vim-smartchr')
" function! bundle.hooks.on_source(bundle)
  augroup MyAutoCmd
    " Substitute .. into -> .
    au FileType c,cpp    inoremap <buffer><expr> . smartchr#loop('.', '->', '...')
    au FileType perl,php inoremap <buffer><expr> - smartchr#loop('-', '->')
    au FileType vim      inoremap <buffer><expr> . smartchr#loop('.', ' . ', '..', '...')
    au FileType coffee   inoremap <buffer><expr> - smartchr#loop('-', '->', '=>')
    au FileType php      inoremap <buffer><expr> . smartchr#loop('.', '->', '..')
          \| inoremap <buffer><expr>> smartchr#loop('>', '=>')
    au FileType scala    inoremap <buffer><expr> - smartchr#loop('-', '->', '=>')
          \| inoremap <buffer><expr> < smartchr#loop('<', '<-')
    au FileType yaml,eruby inoremap <buffer><expr> < smartchr#loop('<', '<%', '<%=')
          \| inoremap <buffer><expr> > smartchr#loop('>', '%>', '-%>')

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
  augroup END
" endfunction
"}}}

"------------------------------------
" Syntastic
"------------------------------------
"{{{
"loadのときに、syntaxCheckをする
let g:syntastic_auto_jump=1
let g:syntastic_auto_loc_list=1
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

" neosnippetsといい、syntasticといい、custom filetypeで判定されるとつらい。。
" racc.rubyのftで編集すると、保存時に怒られるので除外する。元はといえば、
" neosnippetsがfiletypeしか見ないでsnipを読み込むからいけないのか。。
au FileType ruby let g:syntastic_mode_map.passive_filetypes = copy( s:passive_filetypes )
au BufEnter *.y call <SID>remove_ruby_syntastic()
function! s:remove_ruby_syntastic() "{{{
  call add( g:syntastic_mode_map.passive_filetypes, "ruby" )
endfunction"}}}

let s:passive_filetypes = ["html", "yaml", "racc.ruby"]
let g:syntastic_mode_map = {
      \ 'mode'              : 'active',
      \ 'active_filetypes'  : g:my.ft.program_files,
      \ 'passive_filetypes' : copy(s:passive_filetypes),
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
  " au BufEnter * let g:indent_guides_guide_size=&tabstop
augroup END
nnoremap <silent><Leader>i :<C-U>IndentGuidesToggle<CR>
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
let g:eskk#debug = 0
let g:eskk#dictionary = { 'path': expand( "~/.eskk_jisyo" ), 'sorted': 0, 'encoding': 'utf-8', }
let g:eskk#directory = "~/.eskk"
let g:eskk#dont_map_default_if_already_mapped=1
let g:eskk#enable_completion = 1
let g:eskk#large_dictionary = { 'path':  expand("~/.eskk_dict/SKK-JISYO.L"), 'sorted': 1, 'encoding': 'euc-jp', }
let g:eskk#max_candidates= 40
let g:eskk#start_completion_length=3
let g:eskk#no_default_mappings=1
let g:eskk#revert_henkan_style = "okuri"
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
let g:eskk#marker_jisyo_touroku=""
let g:eskk#marker_okuri=''
imap <C-J> <Plug>(eskk:toggle)
lmap <C-J> <Plug>(eskk:toggle)
" }}}

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
let g:jscomplete_use = ['dom', 'moz', 'ex6th']
" xpcom.vim
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
    \   'vim_users_en',
    \   'vimperator',
    \   'completion',
    \   'git',
    \   'ruby',
    \   'scala',
    \   'lingr_vim',
    \   'gentoo',
    \   'LinuxKernel',
    \]
function! LingrLaunchNewTab() "{{{
  tabnew
  LingrLaunch
endfunction"}}}
nnoremap [space]l :<C-U>call LingrLaunchNewTab()<CR>

function! s:lingr_settings()
  nnoremap <buffer><Space>q :<C-U>LingrExit<CR>
endfunction
autocmd MyAutoCmd FileType lingr-* call s:lingr_settings()
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

" ------------------------------------
" alpaca_remove_dust
"------------------------------------
"{{{
let g:remove_dust_enable=1
"}}}

" ------------------------------------
" vim-niceblock
" ------------------------------------
"{{{
xmap I  <Plug>(niceblock-I)
xmap A  <Plug>(niceblock-A)
"}}}

" ------------------------------------
" switch.vim
" ------------------------------------
"{{{
nnoremap ! :Switch<CR>
let s:switch_define = {}

function! s:define_switch_mappings()
  call alpaca#let_b:('switch_definitions', [])

  let filetype = <SID>filetype()
  if has_key(s:switch_define, filetype)
    call add(b:switch_definitions, s:switch_define[filetype])
  endif
endfunction

aug MyAutoCmd
  au Filetype * if !empty( <SID>filetype() ) | call <SID>define_switch_mappings() | endif
aug END
"}}}

" ------------------------------------
" clever-f
" ------------------------------------
"{{{
let g:clever_f_not_overwrites_standard_mappings=1
map f <Plug>(clever-f-f)
map F <Plug>(clever-f-F)
"}}}

" ------------------------------------
" evervim
" ------------------------------------
"{{{
let g:evervim_devtoken='S=s36:U=3d4ae2:E=144cb576ba9:C=13d73a63fad:P=1cd:A=en-devtoken:V=2:H=ff00fa0e63346327d6d1a479ab1f1556'
"}}}

" ------------------------------------
" alpaca_update_tags
" ------------------------------------
"{{{
      " \ '_' : '-R --sort=yes --languages=-css --languages=-scss --languages=-js',
let g:alpaca_update_tags_config = {
      \ '_' : '-R --sort=yes --languages-=js',
      \ 'javascript' : '--languages+=js',
      \ 'scss' : '--languages+=scss',
      \ 'sass' : '--languages+=sass',
      \ 'css' : '--languages+=css',
      \ 'java' : '--languages+=java $JAVA_HOME/src',
      \ }
"}}}

" ------------------------------------
" vim-gitgutter
" ------------------------------------
" let g:gitgutter_sign_added = 'xx'
" let g:gitgutter_sign_modified = 'yy'
" let g:gitgutter_sign_removed = 'zz'
" let g:gitgutter_sign_modified_removed = 'ww'
" let g:gitgutter_all_on_focusgained = 0
" let g:gitgutter_on_bufenter = 0
" let g:gitgutter_highlight_lines = 1
" let g:gitgutter_on_bufenter = 0
" let g:gitgutter_all_on_focusgained = 0
" augroup MyAutoCmd
"   autocmd BufReadPost,BufWritePost * GitGutterEnable
" augroup END

function! GitGutterToggleForNeoBundlelazy() "{{{
  let is_active = exists('g:gitgutter_enabled') && g:gitgutter_enabled
  if is_active
    echo "gitgutter disabled"
    GitGutterDisable
  else
    echo "gitgutter enabled"
    GitGutterEnable
  endif
endfunction"}}}
nnoremap <silent>[space]g :<C-U>call GitGutterToggleForNeoBundlelazy()<CR>


" ------------------------------------
" yanktmp.vim
" ------------------------------------
"{{{
xnoremap <silent>[minor]y :<C-U>call yanktmp#yank()<CR>
nnoremap <silent>[minor]p :<C-U>call yanktmp#paste_p()<CR>
nnoremap <silent>[minor]P :<C-U>call yanktmp#paste_P()<CR>
"}}}

" ------------------------------------
" tern
" ------------------------------------
let bundle = neobundle#get('tern')
function! bundle.hooks.on_source(bundle) "{{{
  " source `neobundle#get_neobundle_dir() . '/tern/vim/tern.vim'`
  execute 'source ' . neobundle#get_neobundle_dir() . '/tern/vim/tern.vim'
  call tern#Enable()
endfunction"}}}
unlet bundle
"}}}

"----------------------------------------
" 補完・履歴 neocomplcache "{{{
set complete=.,w,b,u,U,s,i,d,t
set completeopt=menu,menuone,longest,preview
set history=1000             " コマンド・検索パターンの履歴数
set infercase
set wildchar=<tab>           " コマンド補完を開始するキー
set wildmenu                 " コマンド補完を強化
set wildoptions=tagfile
set wildmode=longest:full,full
set thesaurus+=~/.vim/thesaurus/mthes10/mthesaur.txt

" tmuxに<C-T>が取られているため
inoremap <C-X><C-F> <C-X><C-T>

" command-lineはzsh風補完で使う
cnoremap <C-P> <UP>
cnoremap <C-N> <Down>

" シンタックスハイライトの予約語を補完へ流用
autocmd FileType *
\   if &l:omnifunc == ''
\ |     setlocal omnifunc=syntaxcomplete#Complete
\ | endif

" set pumheight=10

"----------------------------------------
" neocomplcache / echodoc
" default config"{{{
let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_enable_auto_select=0
let g:neocomplcache#sources#rsense#home_directory = neobundle#get_neobundle_dir() . '/rsense-0.3'
let g:neocomplcache_enable_camel_case_completion  = 1
let g:neocomplcache_enable_underbar_completion    = 1
let g:neocomplcache_force_overwrite_completefunc  = 1
let g:neocomplcache_max_list                      = 80
let g:neocomplcache_skip_auto_completion_time     = '0.3'
let g:neocomplcache_caching_limit_file_size       = 0
let g:neocomplcache_temporary_dir                 = g:my.dir.neocomplcache
" let g:neocomplcache_enable_auto_close_preview = 1

" for clang
" libclang を使用して高速に補完を行う
let g:neocomplcache_clang_use_library=1
" clang.dll へのディレクトリパス
" let g:neocomplcache_clang_library_path='C:/llvm/bin'
" clang のコマンドオプション
" MinGW や Boost のパス周りの設定は手元の環境に合わせて下さい
" let g:neocomplcache_clang_user_options =
"     \ '-I C:/MinGW/lib/gcc/mingw32/4.5.3/include '.
"     \ '-I C:/lib/boost_1_47_0 '.
"     \ '-fms-extensions -fgnu-runtime '.
"     \ '-include malloc.h '

" neocomplcache で表示される補完の数を増やす
" これが少ないと候補が表示されない場合があります
let g:neocomplcache_max_list=1000
let g:neocomplcache_auto_completion_start_length = 2
" let g:neocomplcache_min_keyword_length = 2
" let g:neocomplcache_min_syntax_length = 2

" alpaca_complete.vim
" let g:alpaca_complete_assets_dir = {
"       \ 'img'   : 'app/assets/images',
"       \ 'js'    : 'app/assets/javascripts',
"       \ 'style' : 'app/assets/stylesheets',
"       \ 'ctrl'  : 'app/controllers',
"       \ 'mig'   : 'db/migrate',
"       \ 'seed'  : 'db/seeds',
"       \ 'lib'   : 'lib',
"       \ 'spec'  : 'spec',
"       \ 'model' : 'app/models',
"       \ 'view'  : 'app/views',
"       \ 'helper': 'app/helpers',
"       \ 'admin' : 'app/admin',
"       \ 'conf'  : 'config',
"       \}

let bundle = neobundle#get('neocomplcache')
function! bundle.hooks.on_source(bundle) "{{{
  " initialize "{{{
  if $USER == 'root'
    let g:neocomplcache_temporary_dir = '/tmp'
  endif

  aug MyAutoCmd
    " rubycomplete#Completeを消す
    au FileType ruby,haml,eruby,ruby.rspec set omnifunc=
  aug END
  let s:neocomplcache_initialize_lists = [
        \ 'neocomplcache_include_patterns',
        \ 'neocomplcache_wildcard_characters',
        \ 'neocomplcache_omni_patterns',
        \ 'neocomplcache_force_omni_patterns',
        \ 'neocomplcache_keyword_patterns',
        \ 'neocomplcache_source_completion_length',
        \ 'neocomplcache_source_rank',
        \ 'neocomplcache_vim_completefuncs',
        \ 'neocomplcache_same_filetype_lists',
        \ 'neocomplcache_delimiter_patterns',
        \ 'neocomplcache_dictionary_filetype_lists',
        \ 'neocomplcache_disabled_sources_list']

  for initialize_variable in s:neocomplcache_initialize_lists
    call alpaca#let_g:(initialize_variable, {})
  endfor
  "}}}

  " Define force omni patterns"{{{
  let g:neocomplcache_source_rank = {
        \ 'c'       : '[^.[:digit:] *\t]\%(\.\|->\)',
        \ 'cpp'     : '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::',
        \ 'python'  : '[^. \t]\.\w*',
        \ }

  " Define keyword pattern.
  let g:neocomplcache_keyword_patterns = {
        \ 'c'         : '[^.[:digit:]*\t]\%(\.\|->\)',
        \ 'mail'      : '^\s*\w\+',
        \ }

  " Define include pattern.
  let g:neocomplcache_include_patterns = {
        \ 'scala' : '^import',
        \ 'scss'  : '^\s*\<\%(@import\)\>',
        \ 'php'   : '^\s*\<\%(inlcude\|\|include_once\|require\|require_once\)\>',
        \ }

  " もはやデフォルトでOFFでいい。。
  " let g:neocomplcache_disabled_sources_list._ = ['tags_complete']
  let g:neocomplcache_disabled_sources_list._ = ['tags_complete', 'omni_complete']

  " Define omni patterns
  let g:neocomplcache_omni_patterns = {
        \ 'php' : '[^. *\t]\.\w*\|\h\w*::'
        \ }

  " let g:neocomplcache_delimiter_patterns = {
  "       \ 'ruby' : []
  "       \ }

  " Define completefunc
  let g:neocomplcache_vim_completefuncs = {
        \ "Ref"                 : 'ref#complete',
        \ "Unite"               : 'unite#complete_source',
        \ "VimFiler"            : 'vimfiler#complete',
        \ "VimShell"            : 'vimshell#complete',
        \ "VimShellExecute"     : 'vimshell#vimshell_execute_complete',
        \ "VimShellInteractive" : 'vimshell#vimshell_execute_complete',
        \ "VimShellTerminal"    : 'vimshell#vimshell_execute_complete',
        \ "Vinarise"            : 'vinarise#complete',
        \ }

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

  aug MyAutoCmd
    " previewwindowを自動で閉じる
    au BufReadPre *
          \  if &previewwindow
          \| au BufEnter <buffer>
          \|   if &previewwindow
            \| call <SID>smart_close()
            \| endif
          \| endif
  aug END
endfunction"}}}
unlet bundle
"}}}

" keymap {{{
imap <expr><C-G>          neocomplcache#undo_completion()
imap <expr><TAB>          neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? "\<C-n>" : "\<TAB>"
" imap <silent><expr><CR>   neocomplcache#smart_close_popup() . "<CR>" . "<Plug>DiscretionaryEnd"
function! s:my_crinsert()
    return pumvisible() ? neocomplcache#close_popup() : "\<CR>"
endfunction
inoremap <silent> <CR> <C-R>=<SID>my_crinsert()<CR>

inoremap <expr><C-n>      pumvisible() ? "\<C-n>" : "\<Down>"
inoremap <expr><C-p>      pumvisible() ? "\<C-p>" : "\<Up>"
inoremap <expr><C-x><C-f> neocomplcache#manual_filename_complete()
" }}}
"}}}
" }}}

"----------------------------------------
" echodoc"{{{
let g:echodoc_enable_at_startup = 1
"}}}

"------------------------------------
" VimFiler {{{
nnoremap <silent>[plug]f          :<C-U>call VimFilerExplorerGit()<CR>
nnoremap <silent><Leader><Leader> :<C-U>VimFilerBufferDir<CR>
nnoremap <silent><Leader>n        :<C-U>VimFilerCreate<CR>

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

let g:vimfiler_data_directory = g:my.dir.vimfiler
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


let bundle = neobundle#get('vimfiler')
function! bundle.hooks.on_source(bundle) "{{{
  function! s:vimfiler_is_active() "{{{
    return exists('b:vimfiler')
  endfunction"}}}
  function! s:vimfiler_local() "{{{
    if !exists('b:vimfiler') | return | endif

    let vimfiler = vimfiler#get_context()

    if vimfiler.explorer
      call <SID>vimfiler_explorer_local()
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
  endfunction"}}}
  aug VimFilerKeyMapping "{{{
    au!
    au FileType vimfiler call <SID>vimfiler_local()
  aug END "}}}
endfunction"}}}
unlet bundle
"}}}

"----------------------------------------
" neosnippet"{{{
let g:neosnippet#snippets_directory = g:my.dir.snippets
" let g:neosnippet#disable_runtime_snippets = {
"       \ '_' : 1
"       \ }

imap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
inoremap <silent><C-U>            <ESC>:<C-U>Unite snippet<CR>
nnoremap <silent><Space>e         :<C-U>NeoSnippetEdit -split<CR>
nnoremap <silent><expr><Space>ee  ':NeoSnippetEdit -split'.split(&ft, '.')[0].'<CR>'
smap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
"}}}

"----------------------------------------
" unite.vim"{{{
" unite prefix key.

" keymappings"{{{
nmap [unite] <Nop>
nmap <C-J> [unite]

nnoremap <silent> <Space>b       :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent> [unite]b       :<C-u>Unite buffer -buffer-name=buffer<CR>
nnoremap <silent> [unite]j       :<C-u>Unite file_mru -buffer-name=file_mru<CR>
nnoremap <silent> [unite]u       :<C-u>UniteWithBufferDir -buffer-name=file file<CR>
nnoremap <silent> [unite]B       :<C-u>Unite bookmark -buffer-name=bookmark<CR>
nnoremap <silent> g/             :<C-U>call <SID>smart_unite_open('Unite -buffer-name=line_fast -hide-source-names -horizontal -no-empty -start-insert -no-quit line/fast')<CR>
nnoremap <silent> g#             :<C-U>call <SID>smart_unite_open('Unite -buffer-name=line_fast -hide-source-names -horizontal -no-empty -start-insert -no-quit line/fast -input=<C-R><C-W>')<CR>

cnoremap <expr><silent><C-g>     (getcmdtype() == '/') ?  "\<ESC>:Unite -buffer-name=search line -input=".getcmdline()."\<CR>" : "\<C-g>"
" nnoremap <silent><expr>[unite]f ':Unite -buffer-name=file file:' . expand("%:p:h") . '<CR>'
nnoremap [unite]f                :<C-U>Unite -buffer-name=file file:
nnoremap [unite]<C-F>            :<C-u>UniteFile<Space><C-R>=$PWD<CR>

nnoremap <silent>[unite]:        :<C-U>Unite -buffer-name=history_command -no-empty history/command<CR>
nnoremap <silent>[unite]h        :<C-U>Unite help -buffer-name=help<CR>
nnoremap <silent>[unite]m        :<C-U>Unite mark -no-start-insert -buffer-name=mark<CR>
nnoremap <silent>[unite]o        :<C-U>Unite -no-start-insert -horizontal -no-quit -buffer-name=outline -hide-source-names outline<CR>
nnoremap <silent>[unite]q        :<C-U>Unite qiita -buffer-name=qiita<CR>
nnoremap <silent>[unite]ra       :<C-U>Unite -buffer-name=rake rake<CR>
nnoremap <silent>[unite]/        :<C-U>Unite -buffer-name=history_search -no-empty history/search<CR>
nnoremap <silent>[unite]t        :<C-U>Unite tag -buffer-name=tag -no-empty<CR>
nnoremap <silent>[unite]y        :<C-U>Unite -buffer-name=history_yank -no-empty history/yank<CR>
nnoremap [unite]S                :<C-U>Unite -no-start-insert -buffer-name=ssh ssh://
nnoremap [unite]l                :<C-U>Unite locate -buffer-name=locate -input=

" UniteFile {{{
function! s:unite_file(path)
  let path=substitute(a:path, '^\s*', '', '')
  if isdirectory(path)
    execute 'Unite -buffer-name=file file:' . path
  else
    execute 'edit ' . path
  endif
endfunction
" デフォルトのunite file:は補完がないので。
command! -nargs=? -complete=file UniteFile call <SID>unite_file(<q-args>)
"}}}
function! UniteRailsSetting() "Unite-rails.vim {{{
  nnoremap <buffer>[plug]<C-H><C-H>  :<C-U>Unite rails/view<CR>
  nnoremap <buffer>[plug]<C-H>       :<C-U>Unite rails/model<CR>
  nnoremap <buffer>[plug]            :<C-U>Unite rails/controller<CR>

  nnoremap <buffer>[plug]c           :<C-U>Unite rails/config<CR>
  nnoremap <buffer>[plug]j           :<C-U>Unite rails/javascript<CR>
  nnoremap <buffer>[plug]a           :<C-U>Unite rails/stylesheet<CR>
  nnoremap <buffer>[plug]s           :<C-U>Unite rails/spec<CR>
  nnoremap <buffer>[plug]m           :<C-U>Unite rails/db -input=migrate<CR>
  nnoremap <buffer>[plug]l           :<C-U>Unite rails/lib<CR>
  nnoremap <buffer><expr>[plug]g     ':e '.b:rails_root.'/Gemfile<CR>'
  nnoremap <buffer><expr>[plug]r     ':e '.b:rails_root.'/config/routes.rb<CR>'
  nnoremap <buffer><expr>[plug]se    ':e '.b:rails_root.'/db/seeds.rb<CR>'
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
nnoremap <silent>gl :<C-U>Unite -buffer-name=giti_log -no-start-insert giti/log<CR>
nnoremap <silent>gL :<C-U>Unite -buffer-name=versions_log -no-start-insert versions/git/log<CR>
nnoremap <silent>gS :<C-U>Unite -buffer-name=versions_status -no-start-insert versions/git/status')<CR>
nnoremap <silent>gs :<C-U>Unite -buffer-name=giti_status -no-start-insert giti/status<CR>
nnoremap <silent>gh :<C-U>Unite -buffer-name=giti_branchall -no-start-insert giti/branch_all<CR>
"}}}
"}}}
function! s:smart_unite_open(cmd) "{{{
  let file_syntax=&syntax
  " let rails_root = exists('b:rails_root')? b:rails_root : ''
  " let rails_buffer = rails#buffer()

  " uniteを起動
  exe a:cmd

  if file_syntax != ''
    exe 'setl syntax='.file_syntax
  endif
  " if rails_root != ''
  "   let b:rails_root = rails_root
  "   call rails#set_syntax(rails_buffer)
  " endif
endfunction"}}}

" settings {{{
" 入力モードで開始する
hi UniteCursorLine ctermbg=236   cterm=none
let g:unite_cursor_line_highlight='UniteCursorLine'
let g:unite_data_directory=g:my.dir.unite
let g:unite_enable_split_vertically=1
let g:unite_enable_start_insert=1
let g:unite_source_directory_mru_limit = 200
let g:unite_source_directory_mru_time_format="(%m-%d %H:%M) "
let g:unite_source_file_mru_time_format="(%m-%d %H:%M) "
let g:unite_source_file_mru_filename_format=":~:."
let g:unite_source_file_mru_limit = 300
let g:unite_winheight = 20
let g:unite_source_history_yank_enable =1
let s:unite_kuso_hooks = {}
"}}}

let bundle = neobundle#get('unite.vim')
function! bundle.hooks.on_source(bundle) "{{{
  function! s:unite_my_settings() "{{{
    aug MyAutoCmd
      autocmd BufEnter <buffer> call s:smart_close()
    aug END

    setl nolist

    highlight link uniteMarkedLine Identifier
    highlight link uniteCandidateInputKeyword Statement

    inoremap <silent><buffer><C-J> <Down>
    inoremap <silent><buffer><C-K> <Up>
    nmap     <silent><buffer>f <Plug>(unite_toggle_mark_current_candidate)
    xmap     <silent><buffer>f <Plug>(unite_toggle_mark_selected_candidates)
    nmap     <silent><buffer><C-H> <Plug>(unite_toggle_transpose_window)
    nmap     <silent><buffer><C-J> <Plug>(unite_toggle_auto_preview)
    nnoremap <silent><buffer><expr>S unite#do_action('split')
    nnoremap <silent><buffer><expr>V unite#do_action('vsplit')
    nnoremap <silent><buffer><expr><Leader><Leader> unite#do_action('vimfiler')

    " hook
    let unite = unite#get_current_unite()
    let buffer_name = unite.buffer_name != '' ? unite.buffer_name : '_'

    " バッファ名に基づいたフックを実行
    if has_key( s:unite_kuso_hooks, buffer_name )
      call s:unite_kuso_hooks[buffer_name]()
    endif
  endfunction
  aug MyUniteCmd
    au FileType unite call <SID>unite_my_settings()
  aug END
  "}}}
  function! s:unite_kuso_hooks.file_mru() "{{{
    syntax match uniteSource__FileMru_Dir  /.*\// containedin=uniteSource__FileMru contains=uniteSource__FileMru_Time,uniteCandidateInputKeyword nextgroup=uniteSource__FileMru_Dir

    highlight link uniteSource__FileMru_Dir Directory
    highlight link uniteSource__FileMru_Time Comment
  endfunction"}}}
  function! s:unite_kuso_hooks.file() "{{{
    inoremap <buffer><Tab> <CR>
    syntax match uniteFileDirectory '.*\/'
    highlight link uniteFileDirectory Directory
  endfunction"}}}

  " command menu"{{{
  let g:unite_source_menu_menus = {}
  let g:unite_source_menu_menus.command = {
        \     'description' : 'command alias',
        \ }
  let g:unite_source_menu_menus.command.command_candidates = {
        \       'gitignore'  : 'Unite file_rec:' . neobundle#get_neobundle_dir() . "/gitignore",
        \     }
  "}}}

  "------------------------------------
  " vim-version
  "------------------------------------
  "{{{
  let g:versions#type#git#log#first_parent=1
  let g:versions#source#git#log#revision_length=0
  let g:versions#type#git#branch#merge#ignore_all_space=1
  "}}}

  "------------------------------------
  " unite-history
  "------------------------------------
  "{{{
  function! s:unite_kuso_hooks.history_command() "{{{
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
  function! s:unite_kuso_hooks.grep()
    nnoremap <expr><buffer>re unite#do_action('replace')
  endfunction
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

  function! s:unite_kuso_hooks.giti_log()
    nnoremap <silent><buffer><expr>gd unite#do_action('diff')
    nnoremap <silent><buffer><expr>d unite#do_action('diff')
  endfunction
  "}}}
endfunction"}}}
unlet bundle
"}}}

" Dash"{{{
function! s:dash(...) "{{{
  let ft = <SID>filetype()
  if &filetype == 'python' |let ft = ft.'2'| endif

  let ft = ft.':'

  let word = len(a:000) == 0 ? ft.join('<cword>') : join(a:000, ' ')
  call system(printf("open dash://'%s'", word))
endfunction"}}}
command! -nargs=* Dash call <SID>dash(<f-args>)

nnoremap <C-K><C-K> :Dash <C-R><C-W><CR>
au User Rails nnoremap <buffer><C-K><C-K><C-K> :Dash rails:<C-R><C-W><CR>
nnoremap <Leader>d :Dash<Space>
"}}}

function! s:get_ruby_root() "{{{
  if !exists('s:ruby_root')
    let s:ruby_root = substitute(system('echo `rbenv root`/versions/`rbenv version-name`/lib/ruby'), '\n', '', 'g')
  endif

  return s:ruby_root
endfunction"}}}

function! s:set_ruby_tags() "{{{
  if !executable('rbenv')|return -1 |endif

  if !exists('s:ruby_tags')
    " let ruby_root = s:get_ruby_root()
    let ruby_root = <SID>get_ruby_root()
    let number    = isdirectory(ruby_root . "/1.9.1") ? "/1.9.1" : "/2.0.0"
    let tags      = "/tags"
    let s:ruby_tags = join([
          \ ruby_root . number . tags,
          \ ruby_root . '/gems' . number . '/gems/**2' . tags,
          \ ruby_root . '/site_ruby' . number . tags,
          \ ruby_root . '/vendor_ruby' . number . tags,
          \ ], ',')
  endif

  execute 'setl tags+='.s:ruby_tags
endfunction"}}}

" あとでautoloaderへ移す
function! s:update_ruby_ctags() "{{{
  call vimproc#system("rbenv ctags")
  call vimproc#system("gem ctags")
endfunction"}}}
command! UpdateRubyTags call <SID>update_ruby_ctags()

aug MyAutoCmd
  " au FileType haml,ruby,eruby,yaml xnoremap <silent><buffer>H :s!:\(\w\+\)\s*=>!\1:!g
  au FileType haml,ruby,eruby call <SID>set_ruby_tags()
aug END

if has('vim_starting')
  call neobundle#call_hook('on_source')
endif

" 人のvimrc
" @see http://vim-users.jp/2011/02/hack202/
" 保存時に対象ディレクトリが存在しなければ作成する(作成有無は確認できる)
augroup AutoMkdir
  autocmd!
  autocmd BufWritePre * call s:auto_mkdir(expand('<afile>:p:h'), v:cmdbang)
  function! s:auto_mkdir(dir, force)
    if !isdirectory(a:dir) && (a:force ||
          \    input(printf('"%s" does not exist. Create? [y/n]', a:dir)) =~? '^y\%[es]$')
      call mkdir(a:dir, 'p')
    endif
  endfunction
augroup END

set secure
