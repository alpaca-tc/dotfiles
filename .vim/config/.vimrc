"              ,dPYb,
"              IP'`Yb
"              I8  8I
"              I8  8'
"    ,gggg,gg  I8 dP  gg,gggg,      ,gggg,gg    ,gggg,    ,gggg,gg
"   dP"  "Y8I  I8dP   I8P"  "Yb    dP"  "Y8I   dP"  "Yb  dP"  "Y8I
"  i8'    ,8I  I8P    I8'    ,8i  i8'    ,8I  i8'       i8'    ,8I
" ,d8,   ,d8b,,d8b,_ ,I8 _  ,d8' ,d8,   ,d8b,,d8,_    _,d8,   ,d8b,
" P"Y8888P"`Y88P'"Y88PI8 YY88888PP"Y8888P"`Y8P""Y8888PPP"Y8888P"`Y8
"                     I8
"                 I8                              ,dPYb,
"                 I8                              IP'`Yb
"              88888888             gg             I8  8I
"                 I8                ""             I8  8'
"                 I8     ,gggg,gg   gg     ,gggg,  I8 dPgg,     ,ggggg,   gg      gg
"                 I8    dP"  "Y8I   88    dP"  "Yb I8dP" "8I   dP"  "Y8gggI8      8I
"    Δ~~~~Δ    ,I8,  i8'    ,8I   88   i8'       I8P    I8  i8'    ,8I  I8,    ,8I
"    ξ・ェ・ξ ,d88b,,d8,   ,d8b,_,88,_,d8,_    _,d8     I8,,d8,   ,d8' ,d8b,  ,d8b,
"    ξ     ξ  8P""Y8P"Y8888P"`Y88P""Y8P""Y8888PP88P     `Y8P"Y8888P"   8P'"Y88P"`Y8
"    ξ     ξ
"    ξ     “~～~～~〜〇
"    ξ                ξ
"    ξ ξξ~～~~〜~ξ ξ
"    ξ_ξξ_ξξ_ξξ_ξ  =з =з =з

augroup MyAutoCmd
  autocmd!
augroup END

" http://rubyforge.org/pipermail/vim-ruby-devel/2007q1/000698.html
" Fix up ruby interface
" For vim > v932
if has('ruby')
  silent! ruby nil
endif

"----------------------------------------
" Utils "{{{
function! s:include(target, value) 
  let target_type = type(a:target)

  if type({}) == target_type
    return has_key(a:target, a:value)

  elseif type([]) == target_type || type('') == target_type
    return match(a:target, a:value) > -1

  elseif type(0) == target_type
    return a:target == a:value

  endif

  return 0
endfunction
function! s:current_git() 
  let current_dir = getcwd()
  if !exists("s:git_root_cache") | let s:git_root_cache = {} | endif
  if has_key(s:git_root_cache, current_dir)
    return s:git_root_cache[current_dir]
  endif

  let git_root = system("git rev-parse --show-toplevel")
  if git_root =~ "fatal: Not a git repository"
    " throw "No a git repository."
    return ""
  endif

  let s:git_root_cache[current_dir] = substitute(git_root, '\n', '', 'g')

  return s:git_root_cache[current_dir]
endfunction
function! s:convert_bufname(name)
  let bufname = a:name
  if bufname =~# '^[[:alnum:].+-]\+:\\\\'
    let bufname = substitute(bufname, '\\', '/', 'g')
  endif
  
  return bufname
endfunction
function! s:filetype() 
  if empty(&filetype) | return '' | endif

  return split( &filetype, '\.' )[0]
endfunction
function! s:smart_close() 
  if winnr('$') == 1 |quit| endif
endfunction
function! s:get_cursor_word() 
  return expand("<cword>")

  " let [line, start] = [getline('.'), col('.') - 1]
  " while start > 0 && line[start - 1] =~ '\a'
  "   let start -= 1
  " endwhile
  " return getline(".")[start : col(".") - 1]
endfunction
function! s:buffer_auto_fold(to_close) 
  if !exists("b:__buffer_winheight")
    let b:__buffer_winheight = winheight("1")
    let b:__buffer_winwidth = winwidth("1")
  endif

  if a:to_close
    1 wincmd _
  else
    execute get(b:, '__buffer_winheight', 15) 'wincmd _'
  endif

  if !a:to_close && exists("b:__buffer_winheight")
    unlet b:__buffer_winheight
    unlet b:__buffer_winwidth
  endif
endfunction
function! s:gsub(str,pat,rep) 
  return substitute(a:str,'\v\C'.a:pat,a:rep,'g')
endfunction
function! s:set_default(var, val) 
  if !exists(a:var) || type({a:var}) != type(a:val)
    silent! unlet {a:var}
    let {a:var} = a:val
  endif
endfunction
function! s:SID_PREFIX() 
  return matchstr(expand('<sfile>'), '<SNR>\d\+_\zeSID_PREFIX$')
endfunction
function! s:directory_delimiter_complete(path)
  return isdirectory(a:path) ? a:path . '/' : a:path
endfunction
function! s:directory(path)
  return strpart(a:path, 0, strridx(a:path, '/'))
endfunction
function! s:strwidthpart(str, width) 
  if a:width <= 0
    return ''
  endif
  let ret = a:str
  let width = strwidth(a:str)
  while width > a:width
    let char = matchstr(ret, '.$')
    let ret = ret[: -1 - len(char)]
    let width -= strwidth(char)
  endwhile

  return ret
endfunction
function! NeoBundleGet(name) 
  if !exists('s:dummy')
    let s:dummy = { "hooks" : {} }
    function! s:dummy.hooks.on_source(_)
    endfunction
  endif

  let bundle = neobundle#get(a:name)
  return empty(bundle) ? s:dummy : bundle
endfunction 


function! s:compare_asc(me, target) "{{{
  if a:me > a:target
    1
  else
    0
  endif
endfunction "}}}
function! s:buffer_nr_list() "{{{
  redir => output
  silent! ls
  redir END

  let buffer_nr_list = []
  for line in map(split(output, '\n'), 'split(v:val)')
    call add(buffer_nr_list, line[0])
  endfor

  return sort(buffer_nr_list, 's:compare_asc')
endfunction "}}}
"}}}

"----------------------------------------
" initialize "{{{
let g:my = {}
" OS 
let s:is_windows = has('win32') || has('win64')
let s:is_mac     = has('mac')
let s:is_unix    = has('unix')

" user information 
let g:my.info = {
      \ "author": 'Ishii Hiroyuki',
      \ "email": 'alprhcp666@gmail.com',
      \ "github" : "taichouchou2",
      \ "lingr" : 'alpaca_taichou'
      \ }

" config 
let g:my.conf = {
      \ "initialize" : 1,
      \ }

" path 
      " \ "ctags" : expand('/Applications'),
let g:my.bin = {
      \ "ri" : expand('/Users/taichou/.rbenv/shims/ri'),
      \ }

let g:my.dir = {
      \ "neobundle"    : expand('~/.bundle'),
      \ "ctrlp"     : expand('~/.vim.trash/ctrlp'),
      \ "memolist"  : expand('~/.memolist'),
      \ "snippets"  : expand('~/.vim/snippet'),
      \ "swap_dir"  : expand('~/.vim.trash/vimswap'),
      \ "trash_dir" : expand('~/.vim.trash/'),
      \ "unite"     : expand('~/.vim.trash/unite'),
      \ "vimref"    : expand('~/.vim.trash/vim-ref'),
      \ "vimfiler"  : expand('~/.vim.trash/vimfiler'),
      \ "vimshell"  : expand('~/.vim.trash/vimshell'),
      \ "neocomplete"  : expand('~/.vim.trash/neocomplete'),
      \ }

" other settings 
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
      \ "markup_files"    : ['html', 'haml', 'erb', 'php', 'xhtml'],
      \ "english_files"   : ['markdown', 'help', 'text'],
      \ "program_files"   : ['ruby', 'php', 'python', 'eruby', 'vim', 'javascript', 'coffee', 'scala', 'java', 'go', 'cpp', 'haml'],
      \ "ignore_patterns" : ['vimfiler', 'unite'],
      \ }

" TODO インストールするプログラムを書く
" プログラムはまだかけていない
let g:my.install = {
      \ "gem" : [
      \   'alpaca_complete', 'CoffeeTags', 'rails', 'bundler', 'i18n', 'coffee-script',
      \   'git-issue'
      \ ],
      \ "homebrew" : ['scala', 'sbt'],
      \ }

if g:my.conf.initialize 
  let dir_list = []
  call map(copy(g:my.dir), 'add(dir_list, v:val)')
  call alpaca#initialize#directory(dir_list)
endif
"}}}

"----------------------------------------
" basic settings "{{{
execute "set directory=".g:my.dir.swap_dir
set nocompatible
set backspace=indent,eol,start
set clipboard+=autoselect,unnamed
set formatoptions+=lcqmM
set helplang=ja,en

set langmenu=en_us.UTF-8
language en_US.UTF-8
set modelines=1
set nomore
set ttymouse=xterm2
set nobackup
set nowritebackup
set norestorescreen
set noshowmode
set timeout timeoutlen=300 ttimeoutlen=90
set updatetime=500
set viminfo='1000,<800,s300,\"1000,f1,:1000,/1000
set visualbell t_vb=

if v:version >= 703
  set undofile
  let &undodir=&directory
endif

nnoremap <Space><Space>s :<C-U>source ~/.vimrc<CR>
nnoremap <Space><Space>v :<C-U>tabnew ~/.vim/config/.vimrc<CR>
"}}}

"----------------------------------------
" Neobundle Initialize "{{{
filetype plugin indent off     " required!
let g:neobundle#types#git#default_protocol = 'https'
let g:neobundle#install_max_processes = s:is_mac ? 50 : 10

if g:my.conf.initialize && !isdirectory(g:my.dir.neobundle.'/neobundle.vim')
  call system( 'git clone https://github.com/Shougo/neobundle.vim.git '. g:my.dir.neobundle . '/neobundle.vim' )
endif

execute 'set runtimepath+='.g:my.dir.neobundle.'/neobundle.vim'
call neobundle#rc(g:my.dir.neobundle)
"}}}

"----------------------------------------
" NeoBundle  "{{{
NeoBundleFetch 'Shougo/neobundle.vim'
" For asynchronous communication
NeoBundle 'Shougo/vimproc', {
      \ 'build' : {
      \   'mac' : 'make -f make_mac.mak',
      \   'unix' : 'make -f make_unix.mak',
      \ }}
" An awesome improvement to the Vim status bar.
if has('python') 
  " NeoBundle 'Lokaltog/powerline'
  NeoBundle 'taichouchou2/powerline', {
        \ 'name': 'powerline',
        \ 'branch': 'develop',
        \ 'directory': 'powerline',
        \ 'rtp' : 'powerline/bindings/vim',
        \ }
  " NeoBundle 'zhaocai/linepower.vim'
endif

" An awesome improvement to the Vim tabline.
" NeoBundle 'taichouchou2/alpaca_powertabline'

" WebAPI utils
NeoBundleLazy 'mattn/webapi-vim', {
      \ "autoload" : {
      \   "function_prefix": "webapi"
      \ }}

" Basic
NeoBundle 'rhysd/accelerated-jk', {
      \ 'autoload' : {
      \   'mappings' : [
      \     ['n', '<Plug>(accelerated_jk_gj)'], ['n', '<Plug>(accelerated_jk_gk)']
      \ ] }}
NeoBundleLazy 'edsono/vim-matchit', { 'autoload' : {
      \ 'filetypes': g:my.ft.program_files,
      \ 'mappings' : ['nx', '%'] }}
NeoBundleLazy 'tpope/vim-surround', {
      \ 'autoload' : {
      \   'mappings' : [
      \     ['nx', '<Plug>Dsurround'], ['nx', '<Plug>Csurround' ],
      \     ['nx', '<Plug>Ysurround' ], ['nx', '<Plug>YSurround' ],
      \     ['nx', '<Plug>Yssurround'], ['nx', '<Plug>YSsurround'],
      \     ['nx', '<Plug>YSsurround'], ['nx', '<Plug>VgSurround'],
      \     ['nx', '<Plug>VSurround']
      \ ] }}
NeoBundle 'camelcasemotion', { 'autoload' : {
      \ 'mappings' : ['<Plug>CamelCaseMotion_w', '<Plug>CamelCaseMotion_b', '<Plug>CamelCaseMotion_e', '<Plug>CamelCaseMotion_iw', '<Plug>CamelCaseMotion_ib', '<Plug>CamelCaseMotion_ie']
      \ }}
NeoBundleLazy 'kana/vim-arpeggio', { 'autoload': { 
      \ 'functions': ['arpeggio#map'],
      \ 'insert' : 1,
      \ }}
NeoBundleLazy 'rhysd/clever-f.vim', { 'autoload' : {
      \   'mappings' : ['f', '<Plug>(clever-f-f)'],
      \ }}
NeoBundle 'kana/vim-smartword', { 'autoload' : {
      \ 'mappings' : [
      \   '<Plug>(smartword-w)', '<Plug>(smartword-b)', '<Plug>(smartword-ge)']
      \ }}

" vim必須 
NeoBundleLazy 'thinca/vim-quickrun', { 'autoload' : {
      \   'mappings' : [['nxo', '<Plug>(quickrun)']],
      \   'commands' : 'QuickRun' }}
NeoBundleLazy 'scrooloose/syntastic', { 'autoload': {
      \ 'build' : {
      \   'mac' : join(['brew install tidy', 'brew install csslint', 'gem install sass', 'npm install -g jslint', 'gem install rubocop'], ' && ')
      \ },
      \ 'filetypes' : g:my.ft.program_files }}
NeoBundleLazy 'vim-scripts/sudo.vim', {
      \ 'autoload': { 'commands': ['SudoRead', 'SudoWrite'] }}
" NeoBundleLazy 'tyru/eskk.vim', { 'autoload' : {
"       \ 'mappings' : [['i', '<Plug>(eskk:toggle)']],
"       \ 'insert' : 1,
"       \ }}
NeoBundleLazy 'thinca/vim-ref', { 'autoload' : {
      \ 'commands' : {
      \   'name' : "Ref",
      \   'complete' : 'customlist,ref#complete',
      \ },
      \ 'unite_sources' : ["ref/erlang", "ref/man", "ref/perldoc", "ref/phpmanual", "ref/pydoc", "ref/redis", "ref/refe", "ref/webdict"],
      \ 'mappings' : ['n', 'K', '<Plug>(ref-keyword)']
      \ }}
" 暗黒美夢王 
NeoBundleLazy 'Shougo/unite.vim', {
      \ 'autoload' : {
      \   'commands' : [ {
      \     'name' : 'Unite',
      \     'complete' : 'customlist,unite#complete_source'},
      \     'UniteBookmarkAdd', 'UniteClose', 'UniteResume',
      \     'UniteWithBufferDir', 'UniteWithCurrentDir', 'UniteWithCursorWord',
      \     'UniteWithInput', 'UniteWithInputDirectory']
      \ }}
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
if has("lua")
  NeoBundleLazy 'Shougo/neocomplete', { 'autoload' : {
        \   'insert' : 1,
        \ }}
else
  NeoBundleLazy 'Shougo/neocomplcache', {
        \ 'autoload' : {
        \   'insert' : 1,
        \ },
        \ }
endif
NeoBundleLazy 'Shougo/neosnippet', {
      \ 'autoload' : {
      \   'commands' : ['NeoSnippetEdit', 'NeoSnippetSource'],
      \   'filetypes' : 'snippet',
      \   'insert' : 1,
      \   'unite_sources' : ['snippet', 'neosnippet/user', 'neosnippet/runtime'],
      \ }}
NeoBundleLazy 'Shougo/vimshell', {
      \ 'autoload' : {
      \   'commands' : [{
      \     'name' : 'VimShell',
      \     'complete' : 'customlist,vimshell#complete'},
      \     'VimShellExecute', 'VimShellInteractive', 'VimShellTerminal', 'VimShellPop', 'VimShellBufferDir'],
      \   'mappings' : ['<Plug>(vimshell_switch)']
      \ }}
" NeoBundleLazy 'Shougo/echodoc', {
"       \ 'autoload' : {
"       \   'insert' : 1,
"       \ }}

" commands 
" Removing dust.
NeoBundleLazy 'taichouchou2/alpaca_remove_dust.vim', {
      \ 'autoload': {
      \   'commands': ['RemoveDustDisable', 'RemoveDustEnable', 'RemoveDust']
      \ }}
" Asynchronous updating tags
NeoBundleLazy 'taichouchou2/alpaca_tags', {
      \ 'depends': 'Shougo/vimproc',
      \ 'autoload' : {
      \   'commands': ['AlpacaTagsUpdate', 'AlpacaTagsSet', 'AlpacaTagsBundle']
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
NeoBundle 'tpope/vim-fugitive', { 'autoload': {
      \ 'commands': ['Gcommit', 'Gblame', 'Ggrep', 'Gdiff']}}
NeoBundleLazy 'Shougo/git-vim', {
      \ 'autoload' : {
      \ 'commands': [
      \   { "name": "GitDiff",     "complete" : "customlist,git#list_commits" },
      \   { "name": "GitVimDiff",  "complete" : "customlist,git#list_commits" },
      \   { "name": "Git",         "complete" : "customlist,git#list_commits" },
      \   { "name": "GitCheckout", "complete" : "customlist,git#list_commits" },
      \   { "name": "GitAdd",      "complete" : "file" },
      \   "GitLog", "GitCommit", "GitBlame", "GitPush"] }}
NeoBundleLazy 'mattn/gist-vim', {
      \ 'depends': ['mattn/webapi-vim' ],
      \ 'autoload' : {
      \   'commands' : 'Gist' }}
" NeoBundleLazy 'ujihisa/vimshell-ssh', { 'autoload' : {
"       \ 'filetypes' : 'vimshell' }}
NeoBundleLazy 'glidenote/memolist.vim', { 'autoload' :
      \ { 'commands' : ['MemoNew', 'MemoGrep'] }}
NeoBundleLazy 'h1mesuke/vim-alignta', {
      \ 'autoload' : { 'commands' : ['Align'] }}
NeoBundleLazy 'grep.vim', {
      \ 'autoload' : { 'commands': ["Grep", "Rgrep", "GrepBuffer"] }}
NeoBundleLazy 'sjl/gundo.vim', {
      \ 'autoload' : { 'commands': ["GundoToggle", 'GundoRenderGraph'] }}
NeoBundleLazy 'majutsushi/tagbar', {
      \ 'build' : {
      \   'mac' : 'npm install jsctags && gem ins CoffeeTags',
      \   'unix' : 'npm install -g jsctags',
      \ },
      \ 'autoload' : {
      \   'commands': ["TagbarToggle", "TagbarTogglePause", "TagbarOpen"],
      \   'fuctions': ['tagbar#currenttag'] }}
NeoBundleLazy 'open-browser.vim', { 'autoload' : {
      \ 'mappings' : [ '<Plug>(open-browser-wwwsearch)', '<Plug>(openbrowser-open)',  ],
      \ 'commands' : ['OpenBrowserSearch'] }}

" Commenting out code
NeoBundleLazy 'tomtom/tcomment_vim', { 'autoload' : {
      \ 'commands' : ['TComment', 'TCommentAs', 'TCommentMaybeInline'] }}
NeoBundleLazy 'tyru/caw.vim', {
      \ 'autoload' : {
      \   'insert' : 1,
      \   'mappings' : [ '<Plug>(caw:prefix)', '<Plug>(caw:i:toggle)'],
      \ }}

" extend mappings
NeoBundleLazy 'AndrewRadev/switch.vim', { 'autoload' : {
      \ 'commands' : 'Switch',
      \ }}
NeoBundle 'mattn/zencoding-vim', {
      \ 'autoload': {
      \   'function_prefix': 'zencoding',
      \   'filetypes': g:my.ft.html_files + g:my.ft.style_files,
      \ }}
NeoBundleLazy 't9md/vim-textmanip', { 'autoload' : {
      \ 'mappings' : [
      \   '<Plug>(textmanip-move-down)', '<Plug>(textmanip-move-up)',
      \   '<Plug>(textmanip-move-left)', '<Plug>(textmanip-move-right)'],
      \ }}
" NeoBundleLazy 'tpope/vim-speeddating', {
"       \ 'autoload': {
"       \   'mappings': [
"       \     ['nx', '<C-A>'], ['nx', '<C-X>']
"       \ ] }}
if has("conceal")
  NeoBundleLazy 'Yggdroot/indentLine', { 'autoload' : {
        \   'commands' : ["IndentLinesReset", "IndentLinesToggle"],
        \   'filetypes': g:my.ft.program_files,
        \ }}
else
  NeoBundleLazy 'nathanaelkane/vim-indent-guides', {
        \ 'autoload': {
        \   'commands': ['IndentGuidesEnable', 'IndentGuidesToggle'],
        \   'filetypes': g:my.ft.program_files,
        \ }}
endif

" 補完
" text-object拡張
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


" unite
NeoBundleLazy 'thinca/vim-qfreplace', { 'autoload' : {
      \ 'filetypes' : ['unite', 'quickfix'],
      \ 'commands' : ["Qfreplace"],
      \ }}
NeoBundleLazy 'Shougo/unite-build', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload': {
      \   'unite_sources' : 'build'
      \ }}
NeoBundleLazy 'Shougo/unite-outline', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload' : {
      \   'unite_sources' : 'outline' },
      \ }
NeoBundleLazy 'osyo-manga/unite-quickfix', { 'autoload': {
      \ 'unite_sources' : ['quickfix', 'location_list']
      \ }}
NeoBundleLazy 'tacroe/unite-mark', {
      \ 'depends' : ['Shougo/unite.vim'],
      \ 'autoload': {
      \   'unite_sources' : 'mark'
      \ }}
NeoBundle 'taichouchou2/unite-converter'
NeoBundleLazy 'ujihisa/unite-colorscheme', {
      \ 'autoload': {
      \   'unite_sources': 'colorscheme'
      \ }}
" NeoBundleLazy 'tsukkee/unite-tag', {
NeoBundleLazy 'zhaocai/unite-tag', {
      \ 'depends' : ['Shougo/unite.vim'],
      \ 'autoload' : {
      \   'unite_sources' : 'tag'
      \ }}
NeoBundleLazy 'mattn/qiita-vim', { 'depends' :
      \ ['Shougo/unite.vim', 'mattn/webapi-vim'],
      \ 'autoload': {
      \   'unite_sources' : 'qiita'
      \ }}
NeoBundleLazy 'kmnk/vim-unite-giti', {
      \ 'autoload': {
      \   'unite_sources': [
      \     'giti', 'giti/branch', 'giti/branch/new', 'giti/branch_all',
      \     'giti/config', 'giti/log', 'giti/remote', 'giti/status'
      \   ]
      \ }}
NeoBundleLazy 'hrsh7th/vim-versions', {
      \ 'autoload' : {
      \   'functions' : 'versions#info',
      \   'commands' : 'UniteVersions',
      \   'unite_sources' : ['versions/git/branch', 'versions/git/log',
      \     'versions/git/status', 'versions/svn/log', 'versions/svn/status'],
      \ }}
NeoBundleLazy 'thinca/vim-unite-history', { 'autoload' : {
      \ 'unite_sources' : ['history/command', 'history/search']
      \ }}
NeoBundleLazy 'ujihisa/unite-locate', {
      \ 'depends' : 'Shougo/unite.vim',
      \ 'autoload': {
      \   'unite_sources': 'locate'
      \ }}
NeoBundleLazy 'Shougo/unite-help', { 'autoload' : {
      \ 'unite_sources' : 'help'
      \ }}
NeoBundleLazy 'basyura/TweetVim', { 'depends' :
      \ ['basyura/twibill.vim', 'tyru/open-browser.vim', 'Shougo/unite.vim'],
      \ 'autoload' : {
      \   'commands' : [ 'TweetVimAccessToken', 'TweetVimAddAccount', 'TweetVimBitly', 'TweetVimCommandSay', 'TweetVimCurrentLineSay', 'TweetVimHomeTimeline', 'TweetVimListStatuses', 'TweetVimMentions', 'TweetVimSay', 'TweetVimSearch', 'TweetVimSwitchAccount', 'TweetVimUserTimeline', 'TweetVimVersion' ],
      \   'unite_sources' : ['tweetvim', 'tweetvim/account']
      \ }}

" その他 / テスト 
" C# そのうち試す http://d.hatena.ne.jp/thinca/20130522/1369234427
" NeoBundleLazy 'https://bitbucket.org/abudden/taghighlight', { 'autoload' : {
"       \   'filetypes' : g:my.ft.program_files
"       \ }}
NeoBundleLazy 'kana/vim-smartchr', { 'autoload' : {
      \ 'insert' : 1,
      \ 'filetypes' : g:my.ft.program_files,
      \ 'autoload': {
      \   'function_prefix' : "smartchr",
      \ }
      \ }}
if has("ruby")
  NeoBundleLazy 'taichouchou2/alpaca_english', {
        \ 'build' : {
        \   "mac" : "bundle",
        \   "unix" : "bundle",
        \   "other" : "bundle",
        \ },
        \ 'autoload' : {
        \   'commands' : ["AlpacaEnglishDisable", "AlpacaEnglishEnable", "AlpacaEnglishSay"],
        \   'unite_sources': ['english_dictionary', 'english_example', 'english_thesaurus'],
        \ }
        \ }
  " l8のバイトの金額求める
  NeoBundle 'taichouchou2/snail_csv2google_sheet', { 'autoload': {
        \ 'commands' : [],
        \ }}
endif

if has("clientserver")
  NeoBundleLazy 'thinca/vim-singleton', { 'autoload' : {
        \ 'functions' : 'singleton#enable'
        \ }}
end
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
      \ 'function_prefix': "yanktmp",
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
NeoBundle 'jiangmiao/auto-pairs' 

" NeoBundleLazy 'vim-scripts/LanguageTool', {
"       \ 'depends': 'taichouchou2/language-tool-mirror',
"       \ 'build' : {
"       \   'mac' : 'brew install languagetool'
"       \ },
"       \ 'autoload': {
"       \   'commands' : ['LanguageToolCheck', 'LnaguageToolClear']
"       \ }}
NeoBundle 'terryma/vim-multiple-cursors'

" NeoBundleLazy 'mattn/vdbi-vim', {
"       \ 'depends': 'mattn/webapi-vim' }

" リポジトリをクローンするのみ
NeoBundleFetch 'github/gitignore'
NeoBundleFetch 'taichouchou2/rsense-0.3', {
      \ 'build' : {
      \    'mac': 'ruby etc/config.rb > ~/.rsense',
      \    'unix': 'ruby etc/config.rb > ~/.rsense',
      \ } }
" Generating Ricty Font. 
let g:ricty_generate_command = join([
      \   'sh ricty_generator.sh',
      \   neobundle#get_neobundle_dir().'/alpaca/fonts/Inconsolata.otf',
      \   neobundle#get_neobundle_dir().'/alpaca/fonts/migu-1m-regular.ttf',
      \   neobundle#get_neobundle_dir().'/alpaca/fonts/migu-1m-bold.ttf',
      \ ], ' ')

NeoBundleFetch 'yascentur/Ricty', {
      \ 'depends' : 'taichouchou2/alpaca',
      \ 'autoload' : {
      \   'build' : {
      \     'mac'  : g:ricty_generate_command,
      \     'unix' : g:ricty_generate_command,
      \   }
      \ }}

" bundle.lang

" css
" ----------------------------------------
NeoBundleLazy 'hail2u/vim-css3-syntax', { 'autoload' : {
      \   'filetypes' : g:my.ft.style_files,
      \ }}
" sassのコンパイル
NeoBundleLazy 'AtsushiM/sass-compile.vim', {
      \ 'autoload': { 'filetypes': ['sass', 'scss'] }}
NeoBundleLazy 'vim-less', {
      \ 'autoload': { 'filetypes': ['less'] }
      \ }

" html
" ----------------------------------------
NeoBundleLazy 'taichouchou2/html5.vim', { 'autoload' : {
      \   'filetypes' : g:my.ft.markup_files,
      \   'functions' : ['HtmlIndentGet']
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
      \ 'filetypes' : ['javascript', 'json', 'nginx'],
      \ }}
NeoBundleLazy 'jelera/vim-javascript-syntax', { 'autoload' : {
      \ 'filetypes' : ['javascript', 'json'],
      \ }}
NeoBundleLazy 'teramako/jscomplete-vim', { 'autoload' : {
      \ 'filetypes' : g:my.ft.js_files
      \ }}
NeoBundleLazy 'mklabs/vim-backbone', { 'autoload' : {
      \ 'filetypes' : ['javascript']
      \ }}
if has("python")
  " NeoBundleLazy 'marijnh/tern_for_vim', {
  "       \ 'autoload' : {
  "       \   'filetypes' : 'javascript'
  "       \ }}
  " NeoBundleLazy 'marijnh/tern'
endif

NeoBundleLazy 'leafgarland/typescript-vim', { 'autoload' : {
      \ 'filetypes' : ['typescript']
      \ }}

"  go
" ----------------------------------------
NeoBundleLazy 'fsouza/go.vim', { 'autoload' : {
      \ 'filetypes' : ['go'] }}

"  markdown
" ----------------------------------------
NeoBundleLazy 'tpope/vim-markdown', { 'autoload' : {
      \ 'filetypes' : ['markdown'] }}

"  php
" ----------------------------------------
NeoBundleLazy 'taichouchou2/alpaca_wordpress.vim', { 'autoload' : {
      \ 'filetypes': 'php' }}

"  binary
" ----------------------------------------
NeoBundleLazy 'Shougo/vinarise', {
      \ 'depends': ['s-yukikaze/vinarise-plugin-peanalysis'],
      \ 'autoload': { 'commands': 'Vinarise'}}

" objective-c
" ----------------------------------------
" NeoBundle 'msanders/cocoa.vim'

" eclim
" ----------------------------------------
NeoBundleLazy 'taichouchou2/eclim', { 'autoload' : {
      \ 'commands' : ['ProjectCreate', 'PingEclim'],
      \ 'function_prefix': 'eclim'
      \ }}

" ruby
" ----------------------------------------
NeoBundle 'taichouchou2/vim-rails', { 'autoload' : {
      \ 'filetypes' : g:my.ft.ruby_files }}
NeoBundleLazy 'taichouchou2/vim-endwise.git', {
      \ 'autoload' : {
      \   'insert' : 1,
      \ }}
NeoBundleLazy 'vim-ruby/vim-ruby', { 'autoload' : {
      \ 'filetypes': ['ruby'] } }

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

" ruby全般
NeoBundleLazy 'skwp/vim-rspec', {
      \ 'build': {
      \   'mac': 'gem install hpricot',
      \   'unix': 'gem install hpricot'
      \ },
      \ 'autoload': { 
      \   'filetypes': ['ruby.rspec', 'ruby'],
      \   'commands' : ['RunSpec'],
      \ }}
NeoBundleLazy 'taichouchou2/neorspec.vim', {
      \ 'depends' : 'taichouchou2/vim-rails',
      \ 'autoload' : {
      \   'commands' : ['RSpec', 'RSpecAll', 'RSpecCurrent', 'RSpecNearest', 'RSpecRetry']
      \ }}
NeoBundleLazy 'tpope/vim-dispatch', { 'autoload' : {
      \ 'commands' : ['Dispatch', 'FocusDispatch', 'Start']
      \ }}
NeoBundleLazy 'taka84u9/vim-ref-ri', {
      \ 'depends': ['Shougo/unite.vim', 'thinca/vim-ref'],
      \ 'autoload': { 'filetypes': g:my.ft.ruby_files } }
NeoBundleLazy 'taichouchou2/unite-reek', {
      \ 'build' : {
      \   'mac': 'gem install reek',
      \   'unix': 'gem install reek',
      \ },
      \ 'autoload': {
      \   'unite_sources': 'reek',
      \ },
      \ 'depends' : 'Shougo/unite.vim' }
" NeoBundleLazy 'taichouchou2/vim-rsense', {
"       \ 'depends': 'Shougo/neocomplete',
"       \ 'autoload' : {
"       \   'filetypes' : 'ruby'
"       \ }
"       \ }
" NeoBundle 'Shougo/neocomplcache-rsense.vim', {
"       \ 'autoload' : {
"       \   'filetype' : ['ruby']
"       \ }}
" NeoBundleLazy 'rhysd/unite-ruby-require.vim', { 'autoload': {
"       \ 'filetypes': g:my.ft.ruby_files }}
" NeoBundleLazy 'rhysd/vim-textobj-ruby', { 'depends': 'kana/vim-textobj-user' }

" NeoBundleLazy 'deris/vim-textobj-enclosedsyntax', { 'autoload': {
"       \ 'filetypes': g:my.ft.ruby_files}}
" NeoBundleLazy 'rhysd/neco-ruby-keyword-args', { 'autoload': {
"       \ 'filetypes': g:my.ft.ruby_files }}
" NeoBundleLazy 'tpope/vim-cucumber', { 'autoload': {
"       \ 'filetypes': g:my.ft.ruby_files }}

NeoBundleLazy "depuracao/vim-rdoc", { "autoload" : {
      \   "filetypes" : "rdoc"
      \ }}

" nginx
" ----------------------------------------
NeoBundleLazy 'mutewinter/nginx.vim', {
      \ 'autoload' : { 'filetypes': "nginx" }}

" python
" ----------------------------------------
" NeoBundle 'Pydiction'
NeoBundleLazy 'yuroyoro/vim-python', { 'autoload' : {
      \ 'filetypes' : g:my.ft.python_files }}
NeoBundleLazy 'hynek/vim-python-pep8-indent', { 'autoload' : {
      \ 'filetypes' : g:my.ft.python_files }}
if has("python")
  NeoBundleLazy 'davidhalter/jedi-vim', {
        \ 'build' : {
        \     'mac' : 'git submodule update --init',
        \     'unix' : 'git submodule update --init',
        \    },
        \ 'autoload' : { 'filetypes': g:my.ft.python_files }
        \ }
endif
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
" ----------------------------------------
"NeoBundleLazy 'Rip-Rip/clang_complete', {
"      \ 'autoload' : {
"      \     'filetypes' : g:my.ft.c_files,
"      \    },
"      \ }
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

" 他のアプリを呼び出すetc 
" NeoBundle 'yuroyoro/vimdoc_ja'
" NeoBundle 'kana/vim-altr' " 関連するファイルを切り替えれる
NeoBundleLazy 'tsukkee/lingr-vim', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload': {
      \   'commands': ['LingrLaunch', 'LingrExit']}}
NeoBundleLazy 'mattn/excitetranslate-vim', {
      \ 'depends': 'mattn/webapi-vim',
      \ 'autoload' : { 'commands': ['ExciteTranslate']}
      \ }
NeoBundleLazy 'thinca/vim-scouter', { 'autoload' : {
      \ 'commands' : 'Scouter'
      \ }}

" Installation check. 
" if g:my.conf.initialize && neobundle#exists_not_installed_bundles()
"   echomsg 'Not installed bundles : ' .
"         \ string(neobundle#get_not_installed_bundle_names())
"   echomsg 'Install Plugins'
"   NeoBundleInstall
" endif

filetype plugin indent on
"}}}

"----------------------------------------
" StatusLine / tabline "{{{
" source ~/.vim/config/.vimrc.statusline
"}}}

"----------------------------------------
" Editing"{{{
" set textwidth=100
set autoread
set nostartofline
set hidden
set nrformats-=octal
set nrformats+=alpha
set textwidth=0
" set gdefault
" set splitright
set splitbelow
set previewheight=5
set helpheight=12
set matchtime=1

if has('multi_byte_ime')
  set iminsert=0 imsearch=0
endif
" 開いているファイルのディレクトリに自動で移動
aug MyAutoCmd
  au BufEnter * execute ":silent! lcd! " . expand("%:p:h")
aug END
" 対応を補完 
inoremap { {}<Left>
inoremap [ []<Left>
inoremap ( ()<Left>
inoremap " ""<Left>
" inoremap ' ''<Left>
aug MyAutoCmd
  " au FileType scala inoremap <buffer>' '
  au FileType ruby,eruby,haml,racc,racc.ruby inoremap <buffer>\| \|\|<Left>
        \| inoremap <buffer>,{ #{}<Left>
aug END
augroup MyXML
  au!
  au Filetype xml,html,eruby inoremap <buffer> </ </<C-x><C-o>
augroup END

" 整列系 
" xnoremap <S-TAB>  <
" xnoremap <TAB>  >
xnoremap < <gv
xnoremap <C-M> :sort<CR>
xnoremap > >gv

" 便利系 
nnoremap <silent><Space><Space>q :qall!<CR>
nnoremap <silent><Space><Space>w :wall!<CR>
nnoremap <silent><Space>q :q!<CR>
nnoremap <silent><Space>w :wq<CR>
nnoremap <silent><Space>s :SudoWrite %<CR>
" For quickrun and as so on.
nnoremap <silent><C-L> :call <SID>redraw_with_doautocmd()<CR>
function! s:redraw_with_doautocmd()
  doautocmd CursorHoldI <buffer>
  redraw!
endfunction

" これをすると、矢印キーがバグるのはなぜ？
" inoremap <silent><ESC> <Esc>:nohlsearch<CR>
" nnoremap <silent><ESC> <Esc>:nohlsearch<CR>

inoremap <C-D><C-A> <C-R>=g:my.info.author<CR>
inoremap <C-D><C-D> <C-R>=alpaca#function#today()<CR>
inoremap <C-D><C-R> <C-R>=<SID>current_git()<CR>
nnoremap <silent>,s :call <SID>toggle_set_spell()<CR>
" inoremap <C-@> <Esc>[s1z=`]a
xnoremap <silent><C-p> "0p<CR>
nnoremap re :%s!
xnoremap re :s!
xnoremap rep y:%s!<C-r>=substitute(@0, '!', '\\!', 'g')<CR>!!g<Left><Left>
xnoremap ,c :s/./&/g
nnoremap ,f :setl filetype=
xmap <silent><C-A> :ContinuousNumber <C-A><CR>
xmap <silent><C-X> :ContinuousNumber <C-X><CR>

let s:alpaca_abbr_define = {
      \ "vim" : [
      \   "sh should",
      \   "reqs require 'spec_helper'",
      \   "req require",
      \ ],
      \ "yaml": [
      \   "< << : *"
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
      \ "python" : [
      \   "im import"
      \ ],
      \ "gitcommit" : [
      \   "wip [WIP]"
      \ ]
      \ }
for [filetype, abbr_defines] in items(s:alpaca_abbr_define)
  call alpaca#initialize#define_abbrev(abbr_defines, filetype)
endfor

" for leaning english.
function! s:toggle_set_spell() 
  if &spell
    setl nospell
    echo "nospell"
    AlpacaEnglishDisable
  else
    setl spell
    echo "spell"
    AlpacaEnglishEnable
  endif
endfunction
nnoremap ;; :<C-U>AlpacaEnglishSay<CR>
xnoremap ;; :AlpacaEnglishSay<CR>

command! -count -nargs=1 ContinuousNumber let c = col('.')|for n in range(1, <count>?<count>-line('.'):1)|exec 'normal! j' . n . <q-args>|call cursor('.', c)|endfor

" コメントを書くときに便利 
inoremap ,* ****************************************
inoremap ,- ----------------------------------------
inoremap ,h <!-- / --><left><left><left><Left>

let g:end_tag_commant_format = '<!-- /%tag_name%id%class -->'
" Generating comment tag
nnoremap ,t :<C-u>call alpaca#function#endtag_comment()<CR>

" 変なマッピングを修正 
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

" Improved increment.
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

au Filetype php nnoremap ,R :! phptohtml<CR>
"}}}

"----------------------------------------
" Searching"{{{
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
" Moving"{{{
set virtualedit+=block
set whichwrap=b,s,h,l,~,<,>,[,]
" set virtualedit=all " 仮想端末

" 基本的な動き 
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
nnoremap <silent>gj j
nnoremap <silent>gk k

xnoremap H <Nop>
inoremap <C-@> <Nop>
" xnoremap v G

" 画面の移動 
" nnoremap <C-L> <C-T>
let g:alpaca_window_default_filetype='ruby'
nmap <silent>L            <Plug>(alpaca_window_move_next_window_or_tab)
nmap <silent>H            <Plug>(alpaca_window_move_previous_window_or_tab)
nmap <silent><C-W>n       <Plug>(alpaca_window_smart_new)
nmap <silent><C-W><C-N>   <Plug>(alpaca_window_smart_new)

" tabを使い易く

nmap [tag_or_tab] <Nop>
nmap t [tag_or_tab]
nmap <silent>[tag_or_tab]c      <Plug>(alpaca_window_tabnew)
nmap <silent>[tag_or_tab]w      <Plug>(alpaca_window_move_buffer_into_last_tab)
nnoremap <silent>[tag_or_tab]n  :tabnext<CR>
nnoremap <silent>[tag_or_tab]p  :tabprevious<CR>
nnoremap <silent>[tag_or_tab]x  :tabclose<CR>
nnoremap <silent>[tag_or_tab]o  <C-W>T

for num in range(0, 9)
  execute 'nnoremap <silent>[tag_or_tab]'.num.'  :<C-U>tabnext '.num'<CR>'
  execute 'nnoremap <silent>[tag_or_tab]m'.num.'  :<C-U>tabmove '.num'<CR>'
endfor

function! s:move_tab_to(to) 
  let target_tab_nr = tabpagenr() + a:to -1
  let last_tab_nr = tabpagenr("$") - 1

  if target_tab_nr > last_tab_nr
    let target_tab_nr = last_tab_nr
  elseif target_tab_nr < 1
    let target_tab_nr = 0
  endif

  execute 'tabmove ' target_tab_nr
endfunction
nnoremap <silent>[tag_or_tab]<C-L> :<C-U>call <SID>move_tab_to(1)<CR>
nnoremap <silent>[tag_or_tab]<C-H> :<C-U>call <SID>move_tab_to(-1)<CR>
" 

" 前回終了したカーソル行に移動
" kaoriyaだとdefaultらしい。
aug MyAutoCmd
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal g`\"" | endif
aug END
"}}}

"----------------------------------------
" Encoding"{{{
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
" Indent"{{{
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
" Display"{{{
" set cmdheight=1
" set noequalalways     " 画面の自動サイズ調整解除
" set relativenumber    " 相対表示
set pumheight=20
set breakat=\\;:,!?
" set breakat=\ \  ;:,!?
set cdpath+=~
set cmdheight=2
" set cursorline
set equalalways       " 画面の自動サイズ調整

" ここら辺を設定すると、描写が遅くなる
" set laststatus=2
set laststatus=0
set lazyredraw
" set linebreak
" set balloondelay=300

set browsedir=buffer
" http://www15.ocn.ne.jp/~tusr/vim/options_help.html#highlight
" set highlight=8:SpecialKey,@:NonText,d:Directory,e:ErrorMsg,i:IncSearch,l:Search, m:MoreMsg,M:ModeMsg,n:LineNr,r:Question,s:StatusLine,S:StatusLineNC,c:VertSplit,t:Title,v:Visual,w:WarningMsg,W:WildMenu,f:Folded,F:FoldColumn
" set browsedir=current
set list
set listchars=tab:␣.,trail:›,extends:>,precedes:<
set fillchars=stl:\ ,stlnc:\ ,fold:\ ,diff:-
" set listchars=tab:▸\ ,trail:-,extends:»,precedes:«,nbsp:%
" set listchars=tab:>-,trail:-,extends:>,precedes:<
set matchpairs+=<:>
set number
set scrolloff=8
set noshowcmd
set showfulltag
set showmatch
set showtabline=2
set spelllang=en
set nospell
set t_Co=256
set title
" set titlelen=95
set ttyfast
set shortmess=aTI

"折り畳み
set foldenable
set foldmethod=marker
set foldlevel=0
set foldlevelstart=0
set foldminlines=2
set foldnestmax=2

if v:version >= 703
  highlight ColorColumn guibg=#012345
  set conceallevel=2 concealcursor=iv
  set colorcolumn=80
endif

syntax on

" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd!
  " autocmd WinLeave * set nocursorline
  " autocmd WinEnter,BufRead * set cursorline
augroup END

if exists('+fuoptions')
  set fuoptions=maxhorz,maxvert
endif

let g:molokai_original=1
colorscheme  desertEx
" colorscheme morning
" colorscheme  pyte
"}}}

"----------------------------------------
" Tags"{{{
" http://vim-users.jp/2010/06/hack154/

set tags-=tags
set tags+=tags;
if v:version < 703 || (v:version == 7.3 && !has('patch336'))
  " Vim's bug.
  set notagbsearch
endif

" 超絶便利
aug AlpacaUpdateTags
  au!
  " au FileWritePost,BufWritePost * AlpacaTagsUpdate -style
  au FileWritePost,BufWritePost Gemfile AlpacaTagsBundle -style
  au FileReadPost,BufEnter * AlpacaTagsSet
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
" 辞書:dict "{{{
" カスタムファイルタイプでも、自動でdictを読み込む
" そして、編集画面までさくっと移動。
function! s:auto_dict_setting() 
  let file_type_name = &filetype

  let dict_name = split( file_type_name, '\.' )

  if empty( dict_name ) || count(g:my.ft.ignore_patterns, dict_name) > 0
    return
  endif

  execute "setl dict+=~/.vim/dict/".dict_name[0].".dict"

  let b:dict_path = expand('~/.vim/dict/'.file_type_name.'.dict')
  execute "setl dictionary+=".b:dict_path

  nnoremap <buffer><Space>d :execute join([alpaca_window#util#get_smart_split_command("split"), b:dict_path], " ")<CR>
endfunc
aug MyAutoCmd
  au FileType * call <SID>auto_dict_setting()
aug END


nnoremap [plug] <Nop>
nnoremap [minor] <Nop>
nmap <C-H> [plug]
nmap ; [minor]
"}}}

"----------------------------------------
" 補完・履歴 "{{{
set complete=.,w,b,u,U,s,i,d,t
" set completeopt=menu,menuone,preview
set completeopt=menu,menuone
set history=1000             " コマンド・検索パターンの履歴数
set infercase
set wildchar=<tab>           " コマンド補完を開始するキー
set wildmenu                 " コマンド補完を強化
set showfulltag
set wildoptions=tagfile
set wildmode=longest:full,full
" set thesaurus+=~/.vim/thesaurus/mthes10/mthesaur.txt

" command-lineはzsh風補完で使う
cnoremap <C-P> <UP>
cnoremap <C-N> <Down>
"}}}

"----------------------------------------
" Setting of each plugin"{{{

"------------------------------------
let bundle = NeoBundleGet('vim-arpeggio')
function bundle.hooks.on_source(bundle) "{{{
  call arpeggio#map('i', 's', 0, 'jk', '<Esc>:nohlsearch<CR>')
  call arpeggio#map('v', 's', 0, 'jk', '<Esc>:nohlsearch<CR>')
  call arpeggio#map('x', 's', 0, 'jk', '<Esc>:nohlsearch<CR>')
  call arpeggio#map('c', 's', 0, 'jk', '<Esc>:nohlsearch<CR>')
endfunction "}}}
unlet bundle

"------------------------------------
xnoremap m      :Align<Space>
xnoremap mm :Align =<CR>
let bundle = NeoBundleGet('vim-alignta')
function bundle.hooks.on_source(bundle) "{{{
  let g:Align_xstrlen = 3
endfunction "}}}
unlet bundle

"------------------------------------
" surround.vim"{{{
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

" append custom mappings 
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
        \   '\"':  '\"\r\"',
        \   "'":  "'\r'",
        \   '{':  "{ \r }",
        \   'd':  "do\n \r end",
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

function! s:let_surround_mapping(mapping_dict) 
  for [ key, mapping ] in items(a:mapping_dict)
    " XXX filetype変わったときに、unletできない
    call alpaca#let_b:('surround_'.char2nr(key), mapping )
  endfor
endfunction
function! s:surround_mapping_filetype() 
  if !exists('s:surround_mapping_memo')
    let s:surround_mapping_memo = {}
  endif

  if empty(&filetype) |return| endif
  let filetype = <SID>filetype()

  " メモ化してある場合は設定
  if has_key( s:surround_mapping_memo, filetype )
    for mappings in s:surround_mapping_memo[filetype]
      call <SID>let_surround_mapping( mappings )
    endfor
    return
  endif 

  " filetypeに当てはまる設定を追加 
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
  endfor 

  let s:surround_mapping_memo[filetype] = memo
endfunction

augroup MySurroundMapping
  autocmd FileType * call <SID>surround_mapping_filetype()
augroup END
"}}}

" ------------------------------------
nnoremap <silent><C-G><C-g> :<C-u>Rgrep<Space><C-r><C-w> *<CR><CR>
nnoremap <silent><C-G><C-b> :<C-u>GrepBuffer<Space><C-r><C-w><CR>
let bundle = NeoBundleGet('grep.vim')
function bundle.hooks.on_source(bundle) "{{{
  let Grep_Skip_Dirs = '.svn .git .swp .hg cache compile'
  let Grep_Skip_Files = '*.bak *~ .swp .swa .swo'
  let Grep_Find_Use_Xargs = 0
  let Grep_Xargs_Options = '--print0'
endfunction "}}}
unlet bundle

"------------------------------------
nnoremap <Space>t :<C-U>TagbarToggle<CR>
let bundle = NeoBundleGet('tagbar')
function bundle.hooks.on_source(bundle) "{{{
  aug MyTagbarCmd
    autocmd!
    autocmd FileType tagbar
          \ nnoremap <buffer><Space> <Space>
          \|nnoremap <buffer><space>t :<C-U>TagbarToggle<CR>
  aug END

  if exists('g:my.bin.ctags')
    let g:tagbar_ctags_bin  = g:my.bin.ctags
  endif
  " let g:tagbar_autoclose = 1
  " let g:tagbar_sort = 0
  let g:tagbar_compact    = 1
  let g:tagbar_autofocus  = 1
  let g:tagbar_autoshowtag= 1
  let g:tagbar_iconchars  =  ['▸', '▾']
  let g:tagbar_width = 30
endfunction "}}}
unlet bundle

"------------------------------------
" let bundle = NeoBundleGet('open-browser.vim')
nmap ,o <Plug>(openbrowser-open)
xmap ,o <Plug>(openbrowser-open)
nnoremap ,g :<C-u>OpenBrowserSearch<Space><C-r><C-w><CR>

"------------------------------------
nnoremap <silent>,r :QuickRun<CR>
let bundle = NeoBundleGet('vim-quickrun')
function! bundle.hooks.on_source(bundle) "{{{
  let g:quickrun_config = {}
  let g:quickrun_no_default_key_mappings = 1

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

  aug QuickRunAutoCmd 
    autocmd!
    " au FileType quickrun au BufEnter <buffer> if winnr('$') == 1 |quit| endif
    autocmd FileType quickrun au BufEnter <buffer> call <SID>smart_close()
    autocmd FileType racc.ruby,racc nnoremap <buffer>,R :<C-U>QuickRun racc.run<CR>
  aug END 
endfunction"}}}
unlet bundle

"----------------------------------------
let bundle = NeoBundleGet("zencoding-vim")
imap <C-E> <C-Y>,<Space>
function bundle.hooks.on_source(bundle) "{{{
  let g:user_zen_complete_tag = 1
  let g:user_zen_expandabbr_key = '<C-E>'
  let g:user_zen_leader_key = '<c-y>'
  " let g:user_zen_leader_key = '<C-Y>'

  let g:user_zen_settings = {
        \ 'lang' : 'ja',
        \ 'html' : {
        \ 'filters' : 'html',
        \   'indentation' : ''
        \ },
        \ 'css' : {
        \   'filters' : 'fc',
        \ },
        \ 'scss' : {
        \   'snippets': {
        \     'fs' : "font-size: ${cursor};",
        \   },
        \ },
        \ 'php' : {
        \   'extends' : 'html',
        \   'filters' : 'html,c',
        \ },
        \}
endfunction "}}}
unlet bundle

"----------------------------------------
let bundle = NeoBundleGet('vim-ref')
nnoremap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
xnoremap <C-K> :<C-U>Ref alc <Space><C-R><C-W><CR>
nnoremap ra  :<C-U>Ref alc<Space>
nnoremap rp  :<C-U>Ref phpmanual<Space>
nnoremap rr  :<C-U>Unite ref/refe -default-action=split -input=
nnoremap ri  :<C-U>Unite ref/ri -default-action=split -input=
nnoremap rm  :<C-U>Unite ref/man -default-action=split -input=
nnoremap rpy :<C-U>Unite ref/pydoc -default-action=split -input=
nnoremap rpe :<C-U>Unite ref/perldoc -default-action=split -input=

function bundle.hooks.on_source(bundle) "{{{
  let g:ref_open                    = 'tabnew'
  let g:ref_cache_dir               = g:my.dir.vimref
  let g:ref_phpmanual_path          = expand('~/.vim/ref/php-chunked-xhtml')
  let g:ref_no_default_key_mappings = 1

  "webdictサイトの設定
  let g:ref_source_webdict_sites = {
        \   'wikipedia': {
        \     'key': 'rew',
        \     'url': 'http://ja.wikipedia.org/wiki/%s',
        \     'cache': 1,
        \   },
        \   "en_example" : {
        \     'key': 'ree',
        \     'url': 'http://ejje.weblio.jp/sentence/content/%s',
        \     'cache': 1,
        \     'line': 67,
        \   },
        \   "en_thesaurus" : {
        \     'key': 'ret',
        \     'url': 'http://ejje.weblio.jp/english-thesaurus/content/%s',
        \     'cache': 1,
        \     'line': 53,
        \   },
        \   "en_word" : {
        \     'key': 'rer',
        \     'url': 'http://ejje.weblio.jp/content/%s',
        \     'cache': 1,
        \     'line': 79,
        \   },
        \   "alc" : {
        \     'key': 'rea',
        \     'url': 'http://eow.alc.co.jp/%s/UTF-8/',
        \     'cache': 1,
        \     'line': 51,
        \   },
        \ }

  function! s:search_text_or_input_text(dict_name) 
    let cursor_word = s:get_cursor_word()
    if empty(cursor_word)
      let cursor_word = input("search by ". a:dict_name .": ")
    endif
    execute join([':Ref webdict', a:dict_name, cursor_word], " ")
  endfunction
  for [name, dict] in items(g:ref_source_webdict_sites) 
    if has_key(dict, 'key')
      let command = join(['nnoremap', dict["key"], ':call <SID>search_text_or_input_text("' .name. '")', '<CR>'], " ")
      execute command
    endif
  endfor
  unlet command

  aug VimRef
    autocmd!
    " autocmd FileType ruby,eruby,ruby.rspec nnoremap <silent><buffer>K :<C-U>Unite -no-start-insert ref/ri -default-action=split -input=<C-R><C-W><CR>
    " au FileType ruby,eruby,ruby.rspec nnoremap <silent><buffer>K  :<C-U>Unite -no-start-insert ref/refe -input=<C-R><C-W><CR>
  aug END
endfunction "}}}
unlet bundle

"----------------------------------------
nnoremap <silent>gM :<C-U>Gcommit --amend<CR>
nnoremap <silent>gb :<C-U>Gblame<CR>
nnoremap <silent>gm :<C-U>Gcommit<CR>
let bundle = NeoBundleGet('vim-fugitive')
function bundle.hooks.on_source(bundle) "{{{
  aug MyGitCmd
    autocmd!
    autocmd FileType fugitiveblame vertical res 25
    autocmd FileType gitcommit,git-diff nnoremap <buffer>q :q<CR>
  aug END
  let g:fugitive_git_executable = executable('hub') ? 'hub' : 'git'
endfunction "}}}
unlet bundle

"----------------------------------------
nnoremap gA :<C-U>GitAdd<Space>
nnoremap <silent>ga :<C-U>GitAdd<CR>
nnoremap <silent>gd :<C-U>GitDiff HEAD<CR>
nnoremap gp :<C-U>Git push<Space>
nnoremap gD :<C-U>GitDiff<Space>

let bundle = NeoBundleGet('git-vim')
function bundle.hooks.on_source(bundle) "{{{
  let g:git_command_edit = 'vnew'
  let g:git_bin = executable('hub') ? 'hub' : 'git'
  let g:git_no_default_mappings = 1
endfunction "}}}
unlet bundle

"----------------------------------------
" html5.vim
"----------------------------------------
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

"------------------------------------
let bundle = NeoBundleGet('vim-smartword')
function bundle.hooks.on_source(bundle) "{{{
  map ,w  <Plug>(smartword-w)
  map ,b  <Plug>(smartword-b)
  map ,e  <Plug>(smartword-e)
endfunction "}}}
unlet bundle

"------------------------------------
let bundle = NeoBundleGet('camelcasemotion')
function bundle.hooks.on_source(bundle) "{{{
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
endfunction "}}}
unlet bundle

"------------------------------------
nnoremap <silent>,v  :<C-U>VimShell<CR>
nnoremap <silent>,V  :<C-U>VimShellBufferDir<CR>
let bundle = NeoBundleGet('vimshell')
function! bundle.hooks.on_source(bundle) "{{{
  let g:vimshell_user_prompt  = '"(" . getcwd() . ")" '
  let g:vimshell_prompt       = '$ '
  let g:vimshell_ignore_case  = 1
  let g:vimshell_smart_case   = 1
  let g:vimshell_temporary_directory = g:my.dir.vimshell

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

  function! s:vimshell_settings() 
    for altercmd in s:vimshell_altercmd
      call vimshell#altercmd#define(altercmd[0], altercmd[1])
    endfor
    imap <buffer>! <Plug>(vimshell_zsh_complete)
  endfunction 

  aug MyAutoCmd
    au FileType vimshell call <SID>vimshell_settings()
  aug END
endfunction "}}}
unlet bundle

"------------------------------------
" memolist.vim
"------------------------------------
"
let g:memolist_path              = g:my.dir.memolist
let g:memolist_template_dir_path = g:my.dir.memolist
let g:memolist_memo_suffix       = "mkd"
" let g:memolist_memo_date         = "%Y-%m-%d %H:%M"
let g:memolist_memo_date         = "%D %T"
let g:memolist_memo_date         = "%D %T"
let g:memolist_memo_date         = ""
let g:memolist_vimfiler          = 1

nnoremap <silent><Space>mn  :<C-U>MemoNew<CR>
function! s:edit_memolist()
  lcd ~/.memolist
  Unite file
endfunction
nnoremap <silent><Space>ml :call <SID>edit_memolist()<CR>
nnoremap <Space>mg  :<C-U>MemoGrep<CR>


"------------------------------------
" coffee script
"------------------------------------

" 保存するたびに、コンパイル
function! AutoCoffeeCompile()
  aug MyCofeeSetting
    autocmd BufWritePost *.coffee silent CoffeeMake! -cb | cwindow | redraw!
  aug END
endfunction


"------------------------------------
" t_comment
"------------------------------------
" 
let g:tcommentmaps=0
noremap <silent><C-_><c-_> :TComment<CR>
noremap <silent><C-_>c :TComment<CR>


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
function! s:set_up_rails_setting() 
  nnoremap <Space>r :R<CR>
  nnoremap <Space>a :A<CR>
  nnoremap <Space>p :Rpreview<CR>

  let buf = rails#buffer()
  let type_name = buf.calculate_file_type()
  let dict_name = "rails." . type_name

  set dict+=~/.vim/dict/ruby.rails.dict
  for s:syntax in split(glob($HOME.'/.vim/syntax/ruby.rails.*.vim'))
    execute 'source ' . s:syntax
  endfor

  execute 'nnoremap <buffer><Space><Space>d  :<C-U>Edit ~/.vim/dict/' . dict_name .'.dict<CR>'
  execute 'set dict+=~/.vim/dict/' . dict_name . '.dict'
endfunction

function! s:unite_rails_setting()
  call s:do_rails_autocmd()
  nnoremap <buffer>[plug]            :<C-U>UniteGit app/models<CR>
  nnoremap <buffer>[plug]<C-H>       :<C-U>UniteGit app/controllers<CR>
  nnoremap <buffer>[plug]<C-H><C-H>  :<C-U>UniteGit app/views<CR>

  nnoremap <buffer>[plug]c           :<C-U>UniteGit config<CR>
  nnoremap <buffer>[plug]j           :<C-U>UniteGit app/assets/javascripts<CR>
  nnoremap <buffer>[plug]a           :<C-U>UniteGit app/assets/stylesheets<CR>
  nnoremap <buffer>[plug]s           :<C-U>UniteGit spec<CR>
  nnoremap <buffer>[plug]d           :<C-U>UniteGit db<CR>
  nnoremap <buffer>[plug]i           :<C-U>UniteGit db/migrate<CR>
  nnoremap <buffer>[plug]f           :<C-U>UniteGit db/fixtures<CR>
  nnoremap <buffer>[plug]m           :<C-U>UniteGit app/mailers<CR>
  nnoremap <buffer>[plug]l           :<C-U>UniteGit lib<CR>
  nnoremap <buffer>[plug]p           :<C-U>UniteGit public<CR>
  nnoremap <buffer>[plug]g           :<C-U>UniteGit Gemfile<CR>
  nnoremap <buffer>[plug]r           :<C-U>UniteGit config/routes.rb<CR>
  nnoremap <buffer>[plug]h           :<C-U>UniteGit rails/heroku<CR>

  nnoremap <buffer><silent>,cr  :<C-U>RSpecCurrent<CR>
  nnoremap <buffer><silent>,nr :<C-U>RSpecNearest<CR>
  nnoremap <buffer><silent>,lr :<C-U>RSpecRetry<CR>
  nnoremap <buffer><silent>,ar :<C-U>RSpecAll<CR>
endfunction

function! s:do_rails_autocmd() 
  if !exists("b:rails_root")
    return
  endif

  let buf = rails#buffer()
  let type = "-" . buf.type_name()
  let path = '/' . buf.name()
  if path =~ '[ !#$%\,]'
    let path = ''
  endif

  if type != '-'
    execute "silent doautocmd User Rails" . s:gsub(type, '-', '.')
  endif

  if path != ''
    execute "silent doautocmd User Rails" . path
  endif
endfunction
aug RailsDictSetting 
  autocmd!
  " 別の関数に移そうか..
  autocmd User Rails call <SID>unite_rails_setting()
  autocmd User Rails.controller*           NeoSnippetSource ~/.vim/snippet/ruby.rails.controller.snip
  autocmd User Rails.view*                 NeoSnippetSource ~/.vim/snippet/ruby.rails.view.snip
  autocmd User Rails.model*                NeoSnippetSource ~/.vim/snippet/ruby.rails.model.snip
  autocmd User Rails/db/migrate/*          NeoSnippetSource ~/.vim/snippet/ruby.rails.migrate.snip
  autocmd User Rails/config/environment.rb NeoSnippetSource ~/.vim/snippet/ruby.rails.environment.snip
  autocmd User Rails/config/routes.rb      NeoSnippetSource ~/.vim/snippet/ruby.rails.routes.snip
  autocmd User Rails/spec/controllers/*    NeoSnippetSource ~/.vim/snippet/ruby.rspec.controller.snip
  autocmd User Rails/spec/models/*    NeoSnippetSource ~/.vim/snippet/ruby.rspec.controller.snip
  " autocmd User Rails/spec/views/*    NeoSnippetSource ~/.vim/snippet/ruby.rspec.controller.snip
  " autocmd User Rails/spec/features/*    NeoSnippetSource ~/.vim/snippet/ruby.rspec.controller.snip
  " autocmd User Rails/spec/routes/*    NeoSnippetSource ~/.vim/snippet/ruby.rspec.controller.snip

  autocmd User Rails autocmd BufWrite <buffer> AlpacaTagsUpdate
  " autocmd User Rails/config/database.rb    let b:file_type_name="ruby.database"
  " autocmd User Rails/config/boot.rb        let b:file_type_name="ruby.boot"
  " autocmd User Rails/config/locales/*      let b:file_type_name="ruby.locales"
  " autocmd User Rails/config/initializes    let b:file_type_name="ruby.initializes"
  " autocmd User Rails/config/environments/* let b:file_type_name="ruby.environments"
aug END
"}}}

"------------------------------------
" vim-rspec
"------------------------------------
let g:RspecKeymap=0
function! s:rspec_settings() "{{{
  setl foldmethod=syntax
  setl foldlevel=2
  setl foldlevelstart=1
  setl foldminlines=10
  setl foldnestmax=10

  augroup RspecSetting
    autocmd!
    autocmd FileType RSpecOutput setl nofoldenable
  augroup END
endfunction "}}}

augroup MyAutoCmd
  autocmd FileType ruby.rspec call <SID>rspec_settings()
augroup END

"------------------------------------
" gist.vim
"------------------------------------

let g:gist_browser_command = 'w3m %URL%'
let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1
let g:github_user = g:my.info.github
nnoremap <silent>[plug]g :<C-U>Gist<CR>
nnoremap <silent>[plug]gl :<C-U>Gist -l<CR>


"------------------------------------
" twitvim
"------------------------------------

let g:tweetvim_async_post = 1
let g:tweetvim_display_source = 1
let g:tweetvim_display_time = 1
let g:tweetvim_open_buffer_cmd = 'tabnew'
nnoremap <silent>[unite]w  :<C-U>Unite tweetvim -buffer-name=tweetvim -no-start-insert<CR>
nnoremap <silent>tv :<C-U>TweetVimSay<CR>


"------------------------------------
" alter
"------------------------------------

"specの設定
" au User Rails nnoremap <buffer><Space>s <Plug>(altr-forward)
" au User Rails nnoremap <buffer><Space>s <Plug>(altr-back)

" call altr#define('%.rb', 'spec/%_spec.rb')
" " For rails tdd
" call altr#define('app/models/%.rb', 'spec/models/%_spec.rb', 'spec/factories/%s.rb')
" call altr#define('app/controllers/%.rb', 'spec/controllers/%_spec.rb')
" call altr#define('app/helpers/%.rb', 'spec/helpers/%_spec.rb')


"------------------------------------
" sass-compile.vim
"------------------------------------
"
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
  aug AutoSassCompile
    au!
    au BufWritePost <buffer> SassCompile
  aug END
endfunction


"------------------------------------
" jasmine.vim
"------------------------------------

aug MyAutoCmd
  au BufRead,BufNewFile,BufReadPre *Helper.coffee,*Spec.coffee let b:quickrun_config = {'type' : 'coffee'}
aug END


"------------------------------------
" operator-camelize.vim
"------------------------------------
" camel-caseへの変換
xmap ,u <Plug>(operator-camelize)
xmap ,U <Plug>(operator-decamelize)


"------------------------------------
" smartchr.vim
"------------------------------------

let bundle = NeoBundleGet('vim-smartchr')
function! bundle.hooks.on_source(bundle)
  augroup MySmarChr
    au!
    " Substitute .. into -> .
    au FileType c,cpp    inoremap <buffer><expr> . smartchr#loop('.', '->', '..', '...')
    au FileType perl,php inoremap <buffer><expr> - smartchr#loop('-', '->')
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
endfunction


"------------------------------------
let bundle = NeoBundleGet('syntastic')
function bundle.hooks.on_source(bundle) "{{{
  "loadのときに、syntaxCheckをする
  let g:syntastic_auto_jump=1
  let g:syntastic_auto_loc_list=1
  let g:syntastic_check_on_open=0
  let g:syntastic_echo_current_error=1
  let g:syntastic_enable_balloons = has("balloon_eval")
  let g:syntastic_enable_highlighting = 1
  let g:syntastic_enable_signs = 1
  let g:syntastic_loc_list_height=3
  let g:syntastic_quiet_warnings=0
  let g:syntastic_error_symbol='>'
  let g:syntastic_warning_symbol='X'
  " let g:syntastic_error_symbol='✗'
  " let g:syntastic_warning_symbol='⚠'

  " racc.rubyのftで編集すると、保存時に怒られるので除外する。
  " au FileType ruby let g:syntastic_mode_map.passive_filetypes = copy( s:passive_filetypes )
  " au BufEnter *.y call <SID>remove_ruby_syntastic()
  " function! s:remove_ruby_syntastic() 
  "   call add( g:syntastic_mode_map.passive_filetypes, "ruby" )
  " endfunction

  let s:passive_filetypes = ["html", "yaml", "racc.ruby"]
  let g:syntastic_mode_map = {
        \ 'mode'              : 'active',
        \ 'active_filetypes'  : g:my.ft.program_files,
        \ 'passive_filetypes' : copy(s:passive_filetypes),
        \}
endfunction "}}}
unlet bundle

"------------------------------------
" w3m.vim
"------------------------------------

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


"------------------------------------
" vim-indent-guides
"------------------------------------
let bundle = NeoBundleGet("vim-indent-guides")
function! bundle.hooks.on_source(bundle) 
  let g:indent_guides_auto_colors=0
  let g:indent_guides_color_change_percent = 20
  let g:indent_guides_enable_on_vim_startup=1
  let g:indent_guides_guide_size=1
  let g:indent_guides_space_guides = 1
  let g:indent_guides_start_level = 2
  hi IndentGuidesOdd  ctermbg=235
  hi IndentGuidesEven ctermbg=233
  nnoremap <Space>i :<C-U>IndentGuidesToggle<CR>

  augroup MyAutoCmd
    au BufEnter * let g:indent_guides_guide_size=&tabstop
  augroup END
endfunction
unlet bundle


"------------------------------------
" SQLUtils
"------------------------------------

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


"------------------------------------
" vim-endwise
"------------------------------------

let g:endwise_no_mappings=1


"------------------------------------
" jedi-vim
"------------------------------------

let g:jedi#auto_initialization = 1
let g:jedi#get_definition_command = ",d"
let g:jedi#goto_command = ",g"
let g:jedi#popup_on_dot = 0
let g:jedi#pydoc = "K"
let g:jedi#related_names_command = ",n"
let g:jedi#rename_command = ",R"
let g:jedi#use_tabs_not_buffers = 0
let g:vinarise_objdump_command='gobjdump' " homebrew
aug MyAutoCmd
  au FileType python let b:did_ftplugin = 1
  au MyAutoCmd FileType python*
        \ NeoBundleSource jedi-vim | let b:did_ftplugin = 1
aug END


"------------------------------------
" text-manipvim
"------------------------------------

xmap <C-h> <Plug>(textmanip-move-left)
xmap <C-j> <Plug>(textmanip-move-down)
xmap <C-k> <Plug>(textmanip-move-up)
xmap <C-l> <Plug>(textmanip-move-right)


"------------------------------------
" Gundo.vim
"------------------------------------

nnoremap U      :<C-u>GundoToggle<CR>


"------------------------------------
" accelerated-jk
"------------------------------------

let bundle = NeoBundleGet("accelerated-jk")
function! bundle.hooks.on_source(bundle) 
  nmap <silent>j <Plug>(accelerated_jk_gj)
  nmap <silent>k <Plug>(accelerated_jk_gk)
endfunction


"------------------------------------
" eskk.vim
"------------------------------------
" 
let bundle = NeoBundleGet("eskk.vim")
function! bundle.hooks.on_source(bundle) 
  let g:eskk#debug = 0
  let g:eskk#dictionary = { 'path': expand( "~/.eskk_jisyo" ), 'sorted': 0, 'encoding': 'utf-8', }
  let g:eskk#directory = "~/.eskk"
  " let g:eskk#dont_map_default_if_already_mapped=1
  " let g:eskk#enable_completion = 1
  let g:eskk#large_dictionary = { 'path':  expand("~/.eskk_dict/SKK-JISYO.L"), 'sorted': 1, 'encoding': 'euc-jp', }
  " let g:eskk#max_candidates= 40
  let g:eskk#start_completion_length=3
  " let g:eskk#no_default_mappings=1
  " let g:eskk#revert_henkan_style = "okuri"
  let g:eskk#show_annotation=1
  let g:eskk#kakutei_when_unique_candidate=1
  let g:eskk#register_completed_word=0
  let g:eskk#keep_state = 1
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
endfunction
unlet bundle
" 

"------------------------------------
" alpaca_wordpress.vim
"------------------------------------

let g:alpaca_wordpress_syntax = 1
let g:alpaca_wordpress_use_default_setting = 1


"------------------------------------
" vim-textobj-enclosedsyntax
"------------------------------------

" let g:textobj_enclosedsyntax_no_default_key_mappings = 1
"
" " ax、ixにマッピングしたい場合
" omap ax <Plug>(textobj-enclosedsyntax-a)
" omap ix <Plug>(textobj-enclosedsyntax-i)
" xmap ax <Plug>(textobj-enclosedsyntax-a)
" xmap ix <Plug>(textobj-enclosedsyntax-i)


"------------------------------------
" excitetranslate
"------------------------------------
xnoremap E :ExciteTranslate<CR>

"------------------------------------
" qtmplsel.vim
"------------------------------------

" let g:qts_templatedir=expand( '~/.vim/template' )


"------------------------------------
"  jscomplete-vim
"------------------------------------
" 
let g:jscomplete_use = ['dom', 'moz', 'ex6th']
" xpcom.vim
" 

"------------------------------------
"  typescript
"------------------------------------
" 
" let s:system = neobundle#is_installed('vimproc') ? 'vimproc#system_bg' : 'system'
"
" augroup vim-auto-typescript
"   autocmd!
"   autocmd CursorHold,CursorMoved *.ts :checktime
"   autocmd BufWritePost *.ts :call {s:system}('tsc ' . expand('%'))
" augroup END
" autocmd QuickFixCmdPost [^l]* nested cwindow
" autocmd QuickFixCmdPost    l* nested lwindow
" 

"------------------------------------
"  lingr
"------------------------------------

" XXX 使えない..............・T・
let g:lingr_vim_user = g:my.info.lingr
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
function! LingrLaunchNewTab() 
  tabnew
  LingrLaunch
endfunction
nnoremap <Space>l :<C-U>call LingrLaunchNewTab()<CR>

function! s:lingr_settings()
  nnoremap <buffer><Space>q :<C-U>call lingr#exit()<CR>
endfunction
autocmd MyAutoCmd FileType lingr-* call s:lingr_settings()


"------------------------------------
"  caw.vim
"------------------------------------

let bundle = NeoBundleGet("caw.vim")
function! bundle.hooks.on_source(bundle)
  nmap gc <Plug>(caw:prefix)
  xmap gc <Plug>(caw:prefix)
  nmap gcc <Plug>(caw:i:toggle)
  xmap gcc <Plug>(caw:i:toggle)
endfunction


"------------------------------------
"  vim-scala
"------------------------------------

let g:scala_use_default_keymappings = 0


" ------------------------------------
" alpaca_remove_dust
"------------------------------------

let bundle = NeoBundleGet("alpaca_remove_dust.vim")
function bundle.hooks.on_source(bundle) 
  let g:remove_dust_enable=1
  augroup RemoveDust
    au!
    au BufWritePre * RemoveDust
  augroup END
endfunction

" ------------------------------------
" vim-niceblock
" ------------------------------------
xmap I  <Plug>(niceblock-I)
xmap A  <Plug>(niceblock-A)

" ------------------------------------
" switch.vim
" ------------------------------------
nnoremap ! :Switch<CR>
let s:switch_define = {
      \ "ruby" : [
      \   ["if", "unless"],
      \   ["while", "until"],
      \   [".blank?", ".present?"],
      \   ["include", "extend"],
      \   ["class", "module"],
      \ ],
      \ 'rails' : [
      \   [100, ':continue', ':information'],
      \   [101, ':switching_protocols'],
      \   [102, ':processing'],
      \   [200, ':ok', ':success'],
      \   [201, ':created'],
      \   [202, ':accepted'],
      \   [203, ':non_authoritative_information'],
      \   [204, ':no_content'],
      \   [205, ':reset_content'],
      \   [206, ':partial_content'],
      \   [207, ':multi_status'],
      \   [208, ':already_reported'],
      \   [226, ':im_used'],
      \   [300, ':multiple_choices'],
      \   [301, ':moved_permanently'],
      \   [302, ':found'],
      \   [303, ':see_other'],
      \   [304, ':not_modified'],
      \   [305, ':use_proxy'],
      \   [306, ':reserved'],
      \   [307, ':temporary_redirect'], 
      \   [308, ':permanent_redirect'], 
      \   [400, ':bad_request'], 
      \   [401, ':unauthorized'], 
      \   [402, ':payment_required'], 
      \   [403, ':forbidden'], 
      \   [404, ':not_found'], 
      \   [405, ':method_not_allowed'], 
      \   [406, ':not_acceptable'], 
      \   [407, ':proxy_authentication_required'], 
      \   [408, ':request_timeout'], 
      \   [409, ':conflict'], 
      \   [410, ':gone'], 
      \   [411, ':length_required'], 
      \   [412, ':precondition_failed'], 
      \   [413, ':request_entity_too_large'], 
      \   [414, ':request_uri_too_long'], 
      \   [415, ':unsupported_media_type'], 
      \   [416, ':requested_range_not_satisfiable'], 
      \   [417, ':expectation_failed'], 
      \   [422, ':unprocessable_entity'], 
      \   [423, ':precondition_required'], 
      \   [424, ':too_many_requests'], 
      \   [426, ':request_header_fields_too_large'], 
      \   [500, ':internal_server_error'],
      \   [501, ':not_implemented'], 
      \   [502, ':bad_gateway'], 
      \   [503, ':service_unavailable'], 
      \   [504, ':gateway_timeout'], 
      \   [505, ':http_version_not_supported'], 
      \   [506, ':variant_also_negotiates'], 
      \   [507, ':insufficient_storage'], 
      \   [508, ':loop_detected'], 
      \   [510, ':not_extended'], 
      \   [511, ':network_authentication_required'], 
      \ ],
      \ "haml" : [
      \   ["if", "unless"],
      \   ["while", "until"],
      \   [".blank?", ".present?"],
      \ ],
      \ "css,scss,sass": [
      \   ["collapse", "separate"],
      \   ["margin", "padding"],
      \ ],
      \ "rspec": [
      \   ["describe", "context", "specific", "example"],
      \   ['before', 'after'],
      \   { '\.should_not': '\.should' },
      \   ['\.to_not', '\.to'],
      \   { '\([^. ]\+\)\.should\(_not\|\)': 'expect(\1)\.to\2' },
      \   { 'expect(\([^. ]\+\))\.to\(_not\|\)': '\1.should\2' },
      \ ]
      \ }

let s:switch_define = alpaca#initialize#redefine_with_each_filetypes(s:switch_define)
function! s:define_switch_mappings() "{{{
  if exists('b:switch_custom_definitions')
    unlet b:switch_custom_definitions
  endif

  for filetype in split(&ft, '\.')
    if has_key(s:switch_define, filetype)
      let ft_define = s:switch_define[filetype]
      let defines = !exists("defines") ? ft_define : extend(defines, ft_define)
    endif
  endfor

  if exists('b:rails_root')
    let ft_define = s:switch_define['rails']
    let defines = !exists("defines") ? ft_define : extend(defines, ft_define)
  endif

  if exists('defines')
    call alpaca#let_b:('switch_custom_definitions', defines)
  endif
endfunction"}}}

aug MyAutoCmd
  au Filetype * if !empty(<SID>filetype()) | call <SID>define_switch_mappings() | endif
aug END

" ------------------------------------
map f <Plug>(clever-f-f)
map F <Plug>(clever-f-F)
let bundle = NeoBundleGet("clever-f.vim")
function! bundle.hooks.on_source(bundle) "{{{
  let g:clever_f_not_overwrites_standard_mappings=1
endfunction"}}}
unlet bundle

" ------------------------------------
" alpaca_tags
" ------------------------------------
      " \ '_' : '-R --sort=yes --languages=-css --languages=-scss --languages=-js',
let g:alpaca_update_tags_config = {
      \ '_' : '-R --sort=yes --languages=-js,JavaScript',
      \ 'js' : '--languages=+js',
      \ '-js' : '--languages=-js,JavaScript',
      \ 'vim' : '--languages=+Vim,vim',
      \ '-vim' : '--languages=-Vim,vim',
      \ '-style': '--languages=-css,sass,scss,js,JavaScript,html',
      \ 'scss' : '--languages=+scss --languages=-css,sass',
      \ 'sass' : '--languages=+sass --languages=-css,scss',
      \ 'css' : '--languages=+css',
      \ 'java' : '--languages=+java $JAVA_HOME/src',
      \ 'ruby': '--languages=+Ruby',
      \ 'coffee': '--languages=+coffee',
      \ '-coffee': '--languages=-coffee',
      \ 'bundle': '--languages=+Ruby --languages=-css,sass,scss,js,JavaScript,coffee',
      \ }

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
nnoremap <silent><Space>g :<C-U>call GitGutterToggleForNeoBundlelazy()<CR>

" ------------------------------------
" yanktmp.vim
" ------------------------------------
nnoremap YY :<C-U>call yanktmp#yank()<CR>
xnoremap Y :<C-U>call yanktmp#yank()<CR>
nnoremap [minor]p :<C-U>call yanktmp#paste_p()<CR>
nnoremap [minor]P :<C-U>call yanktmp#paste_P()<CR>

" ------------------------------------
" LanguageTool
" ------------------------------------
let g:languagetool_jar=neobundle#get_neobundle_dir() . "/language-tool-mirror/languagetool-commandline.jar"
" let g:languagetool_win_height
" LanguageToolGrammarError
" LanguageToolSpellingError
" LanguageToolCmd
" LanguageToolLabel
" LanguageToolErrorCount
xnoremap ,l :<C-U>LanguageToolCheck<CR>

" ------------------------------------
" tern
" ------------------------------------
let bundle = NeoBundleGet('tern')
function! bundle.hooks.on_source(bundle) "{{{
  " source `neobundle#get_neobundle_dir() . '/tern/vim/tern.vim'`
  execute 'source ' . neobundle#get_neobundle_dir() . '/tern/vim/tern.vim'
  autocmd FileType javascript call tern#Enable()
endfunction"}}}
unlet bundle

" ------------------------------------
" alpaca_english enable
" ------------------------------------
let g:alpaca_english_enable=1
let g:alpaca_english_max_candidates=100
let g:alpaca_english_enable_duplicate_candidates=1

" DEVELOPMENT VERSION
let g:alpaca_english_web_search_url = 'http://eow.alc.co.jp/%s/UTF-8/'
let g:alpaca_english_web_search_xpath = "div[@id='resultsList']/ul/li"

" ------------------------------------
" linepower
" ------------------------------------
let g:vimshell_force_overwrite_statusline = 1
let g:vimfiler_force_overwrite_statusline = 1
let g:vimfiler_force_overwrite_statusline = 1
let g:unite_force_overwrite_statusline = 0

" ----------------------------------------
" vim-singleton.vim
" ----------------------------------------
let bundle = NeoBundleGet('vim-singleton')
function! bundle.hooks.on_source(bundle) "{{{
  call singleton#enable()
endfunction"}}}
unlet bundle

" ----------------------------------------
" indentLine
" ----------------------------------------
nnoremap <Space>i :<C-U>IndentLinesToggle<CR>
let bundle = NeoBundleGet("indentLine")
function! bundle.hooks.on_source(bundle) "{{{
  let g:indentLine_color_term = 239
  " let g:indentLine_color_gui = '#A4E57E'
  " let g:indentLine_char = 'c'
  let g:indentLine_fileType=g:my.ft.program_files
  " let g:indentLine_noConcealCursor=
  " hi Conceal ctermfg=239 ctermbg=NONE
  " ¦┆│
endfunction"}}}
unlet bundle

"----------------------------------------
let bundle = NeoBundleGet('alpaca_complete')
function! bundle.hooks.on_source(bundle) "{{{
  let g:alpaca_complete_assets_dir = {
        \ 'img'   : 'app/assets/images',
        \ 'js'    : 'app/assets/javascripts',
        \ 'style' : 'app/assets/stylesheets',
        \}
  " \ 'ctrl'  : 'app/controllers',
  " \ 'mig'   : 'db/migrate',
  " \ 'seed'  : 'db/seeds',
  " \ 'lib'   : 'lib',
  " \ 'spec'  : 'spec',
  " \ 'model' : 'app/models',
  " \ 'view'  : 'app/views',
  " \ 'helper': 'app/helpers',
  " \ 'admin' : 'app/admin',
  " \ 'conf'  : 'config',
endfunction"}}}
unlet bundle

let bundle = NeoBundleGet('neocomplcache-rsense')
function! bundle.hooks.on_source(bundle)"{{{
  let g:neocomplete#sources#rsense#home_directory = neobundle#get_neobundle_dir() . '/rsense-0.3'
  " let g:neocomplete#sources#rsense#home_directory = "/usr/local/Cellar/rsense/0.3"
endfunction"}}}
unlet bundle

"----------------------------------------
let g:neocomplete#enable_at_startup = 1
let bundle = NeoBundleGet(has("lua") ? 'neocomplete' : 'nothing!!')
function! bundle.hooks.on_source(bundle) "{{{
  " " let g:neocomplete_enable_cursor_hold_i=0
  " let g:neocomplete#enable_smart_case = 1
  let g:neocomplete#sources#syntax#min_keyword_length = 3
  let g:neocomplete#lock_buffer_name_pattern = '\*ku\*'

  let g:neocomplete#auto_completion_start_length=2
  " let g:neocomplete_caching_limit_file_size=500000
  " let g:neocomplete_max_keyword_width=120
  let g:neocomplete#auto_completion_start_length=g:neocomplete#sources#syntax#min_keyword_length
  let g:neocomplete#ctags_arguments=g:alpaca_update_tags_config
  let g:neocomplete#data_directory=g:my.dir.neocomplete
  let g:neocomplete#enable_auto_close_preview=0
  let g:neocomplete#enable_auto_select=0

  " let g:neocomplete#enable_refresh_always = 0
  " For auto select.
  let g:neocomplete#enable_complete_select = 0
  let g:neocomplete#enable_fuzzy_completion=0
  let g:neocomplete#force_overwrite_completefunc = 1
  let g:neocomplete#manual_completion_start_length=0

  let g:neocomplete#sources#buffer#cache_limit_size=700000
  let g:neocomplete#sources#tags#cache_limit_size=1000000
  let g:neocomplete#sources#include#max_proceslses = 30
  let g:neocomplete#max_list=100
  " let g:neocomplete#skip_auto_completion_time='0.1'

  " if g:neocomplete#enable_complete_select
  "   set completeopt-=noselect
  "   set completeopt+=noinsert
  " endif

  let g:neocomplete#disable_auto_select_buffer_name_pattern =
        \ '\[Command Line\]'

  call neocomplete#custom#source('tag', 'disabled', 1)
  call neocomplete#custom#source('vim', 'filetypes', { 'vim' : 1, 'vimconsole': 1})
  " file         
  " file/include 
  " dictionary   
  " member       
  " buffer       
  " syntax       
  " include      
  " neosnippet   
  " vim          
  " omni         
  " tag

  " for rsense
  let g:rsenseHome = expand("~/.bundle/rsense-0.3")
  let g:rsenseUseOmniFunc = 1
  " omnifuncいらねー。
  " autocmd MyAutoCmd FileType ruby set omnifunc=

  " for clang
  " libclang を使用して高速に補完を行う
  " let g:neocomplete_clang_use_library=1
  " clang.dll へのディレクトリパス
  " let g:neocomplete_clang_library_path='C:/llvm/bin'
  " clang のコマンドオプション
  " let g:neocomplete_clang_user_options =
  "     \ '-I C:/MinGW/lib/gcc/mingw32/4.5.3/include '.
  "     \ '-I C:/lib/boost_1_47_0 '.
  "     \ '-fms-extensions -fgnu-runtime '.
  "     \ '-include malloc.h '

  " initialize 
  if $USER == 'root'
    let g:neocomplete#data_directory = '/tmp'
  endif

  let s:neocomplete_initialize_lists = [
        \ 'neocomplete#sources#include#patterns',
        \ 'neocomplete#sources#omni#functions',
        \ 'neocomplete#sources#omni#input_patterns',
        \ 'neocomplete#force_omni_input_patterns',
        \ 'neocomplete#keyword_patterns',
        \ 'neocomplete#sources#vim#complete_functions',
        \ 'neocomplete#delimiter_patterns',
        \ 'neocomplete#sources#dictionary#dictionaries',
        \ 'neocomplete#sources',
        \ 'neocomplete#text_mode_filetypes',
        \ ]

  for initialize_variable in s:neocomplete_initialize_lists
    call alpaca#let_g:(initialize_variable, {})
  endfor
  
  let g:neocomplete#text_mode_filetypes = {
        \ 'markdown' : 1,
        \ 'gitcommit' : 1,
        \ 'text' : 1,
        \ }

  let g:neocomplete#sources#omni#functions.java = 'eclim#java#complete#CodeComplete'

  " Define keyword pattern.
  let g:neocomplete#keyword_patterns = {
        \ '_' : '[0-9a-zA-Z:#_]\+',
        \ 'c' : '[^.[:digit:]*\t]\%(\.\|->\)',
        \ 'mail' : '^\s*\w\+',
        \ 'perl' : '\h\w*->\h\w*\|\h\w*::',
        \ }

  " Define include pattern.
  let g:neocomplete#sources#include#patterns = {
        \ 'scala' : '^import',
        \ 'scss'  : '^\s*\<\%(@import\)\>',
        \ 'php'   : '^\s*\<\%(inlcude\|\|include_once\|require\|require_once\)\>',
        \ }

  " Define omni input patterns
  " let g:neocomplete#sources#omni#input_patterns.ruby =
  "       \ '[^. *\t]\.\w*\|\h\w*::'
  let g:neocomplete#sources#omni#input_patterns.php =
        \ '[^. \t]->\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'
  let g:neocomplete#sources#omni#input_patterns.c =
    \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?'
  let g:neocomplete#sources#omni#input_patterns.cpp =
    \ '[^.[:digit:] *\t]\%(\.\|->\)\%(\h\w*\)\?\|\h\w*::\%(\h\w*\)\?'

  " Define force omni patterns
  let g:neocomplete#force_omni_input_patterns.c      =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#force_omni_input_patterns.cpp    =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'
  let g:neocomplete#force_omni_input_patterns.objc   =
        \ '[^.[:digit:] *\t]\%(\.\|->\)'
  let g:neocomplete#force_omni_input_patterns.objcpp =
        \ '[^.[:digit:] *\t]\%(\.\|->\)\|\h\w*::'

  " tags_completeはデフォルトでOFFでいい。。
  " keys(neocomplete#variables#get_sources())
  " let g:neocomplete#sources._ = ['file', 'tag', 'neosnippet', 'vim', 'dictionary', 'omni', 'member', 'syntax', 'include', 'buffer', 'file/include']
  " let g:neocomplete_disabled_sources_list._ = ['tags_complete']
  " let g:neocomplete_disabled_sources_list.vim = ['vimshell']
  " let g:neocomplete_disabled_sources_list.ruby = ['syntax', 'include', 'omni', 'file/include', 'member']
  " let g:neocomplete_disabled_sources_list.haml = g:neocomplete_disabled_sources_list.ruby
  " let g:neocomplete_sources_list = {
  "       \ 'unite': [],
  "       \ }
  " let g:neocomplete_disabled_sources_list._ = ['tags_complete', 'omni_complete']

  " neocomplete#custom#source(

  " let g:neocomplete_delimiter_patterns = {
  "       \ 'ruby' : []
  "       \ }

  " Define completefunc
  let g:neocomplete#sources#vim#complete_functions = {
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

  " ファイルタイプ毎の辞書ファイルの場所 
  let neocomplete#sources#dictionary#dictionaries = {
        \ 'default'             : '',
        \ 'javascript.timobile' : $HOME.'/.vim/dict/timobile.dict',
        \ 'coffee.timobile'     : $HOME.'/.vim/dict/timobile.dict',
        \ 'vimshell' : g:my.dir.vimshell . '/command-history',
        \ }

  for s:dict in split(glob($HOME.'/.vim/dict/*.dict'))
    let s:ft = matchstr(s:dict, '[a-zA-Z0-9.]\+\ze\.dict$')
    let neocomplete#sources#dictionary#dictionaries[s:ft] = s:dict
  endfor

  aug MyAutoCmd
    " previewwindowを自動で閉じる
    au BufReadPre *
          \ if &previewwindow
          \|  au BufEnter <buffer>
          \|  if &previewwindow
          \|    call <SID>smart_close()
          \|  endif
          \|endif
  aug END

  " keymap 
  imap <expr><C-G>          neocomplete#undo_completion()
  imap <C-K>  <Plug>(neocomplete_start_unite_complete)
  imap <expr><TAB>          neosnippet#expandable() ? "\<Plug>(neosnippet_expand_or_jump)" : pumvisible() ? neocomplete#complete_common_string() : "\<TAB>"
  " imap <silent><expr><CR>   neocomplete#smart_close_popup() . "<CR>" . "<Plug>DiscretionaryEnd"
  function! s:my_crinsert()
    return neocomplete#close_popup() . "\<CR>"
    " return pumvisible() ? neocomplete#close_popup() . "\<CR>" : "\<CR>"
  endfunction
  inoremap <silent> <CR> <C-R>=<SID>my_crinsert()<CR>
  inoremap <expr><C-h> neocomplete#smart_close_popup()."\<C-h>"
  " inoremap <expr><C-n>      pumvisible() ? "\<C-n>" : "\<Down>"
  " inoremap <expr><C-p>      pumvisible() ? "\<C-p>" : "\<Up>"
  inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>\<Down>"
  inoremap <expr><C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
  inoremap <expr>'  pumvisible() ? neocomplete#close_popup() . "'" : "'"
  inoremap <expr><C-x><C-f>  neocomplete#start_manual_complete('file')
  inoremap <expr><C-g>     neocomplete#undo_completion()

  inoremap <expr><Left>  neocomplete#close_popup() . "\<Left>"
  inoremap <expr><Right> neocomplete#close_popup() . "\<Right>"
  inoremap <expr><Up>    neocomplete#close_popup() . "\<Up>"
  inoremap <expr><Down>  neocomplete#close_popup() . "\<Down>"

  " test
  inoremap <expr><TAB>  pumvisible() ? "\<C-n>" :
        \ <SID>check_back_space() ? "\<TAB>" :
        \ neocomplete#start_manual_complete()
  function! s:check_back_space() 
    let col = col('.') - 1
    return !col || getline('.')[col - 1]  =~ '\s'
  endfunction
  " 
endfunction"}}}
unlet bundle

"----------------------------------------
" echodoc
let g:echodoc_enable_at_startup = 1

"------------------------------------
" VimFiler "{{{
nnoremap <silent>[plug]f   :<C-U>call <SID>vim_filer_explorer_git()<CR>
nnoremap <silent>,,        :<C-U>VimFilerBufferDir<CR>
nnoremap <silent>,n        :<C-U>VimFilerCreate<CR>

function! s:vim_filer_explorer_git() 
  let path = (system('git rev-parse --is-inside-work-tree') == "true\n") ?
        \ substitute(system('git rev-parse --show-cdup'), '\n', "", "g" ) : '.'
  execute 'VimFiler -explorer' path
endfunction 
command! VimFilerExplorerGit call <SID>vim_filer_explorer_git()

let bundle = NeoBundleGet('vimfiler')
function! bundle.hooks.on_source(bundle) "{{{
  " Settings
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
  let g:vimfiler_ignore_pattern = '\.git'

  function! s:vimfiler_is_active() 
    return exists('b:vimfiler')
  endfunction
  function! s:vimfiler_local() 
    if !s:vimfiler_is_active() | return | endif

    " vimfiler common settings
    setl nonumber
    nmap <buffer><C-J> [unite]
    nmap <buffer><CR>  <Plug>(vimfiler_edit_file)
    nmap <buffer>f     <Plug>(vimfiler_toggle_mark_current_line)
    nnoremap <buffer>b :<C-U>UniteBookmarkAdd<CR>
    nnoremap <buffer><expr>p vimfiler#do_action('preview')
    nnoremap <buffer>v v
  endfunction
  augroup VimFilerKeyMapping 
    autocmd!
    autocmd FileType vimfiler call <SID>vimfiler_local()
  augroup END 
endfunction"}}}
unlet bundle
"}}}

"----------------------------------------
" neosnippet
nnoremap <silent><Space>e         :<C-U>NeoSnippetEdit -split<CR>
nnoremap <silent><Space><Space>e  :<C-U>Unite neosnippet/user neosnippet/runtime<CR>

let bundle = NeoBundleGet('neosnippet')
function! bundle.hooks.on_source(bundle) "{{{
  let g:neosnippet#snippets_directory = g:my.dir.snippets
  let g:neosnippet#enable_preview = 1
  " let g:neosnippet#disable_runtime_snippets = {
  "       \ '_' : 1
  "       \ }

  imap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
  smap <silent><C-F>                <Plug>(neosnippet_expand_or_jump)
  inoremap <silent><C-U>            <ESC>:<C-U>Unite snippet<CR>
endfunction "}}}
unlet bundle

"----------------------------------------
" unite.vim"{{{
" keymappings
nmap [unite] <Nop>
nmap <C-J> [unite]

nnoremap <silent><Space>b       :<C-u>UniteBookmarkAdd<CR>
nnoremap <silent>[unite]b       :<C-u>Unite buffer -buffer-name=buffer<CR>
nnoremap <silent>[unite]j       :<C-u>Unite file_mru -buffer-name=file_mru<CR>
nnoremap <silent>[unite]u       :<C-u>UniteWithBufferDir -buffer-name=file file<CR>
nnoremap <silent>[unite]e       :<C-u>Unite english_dictionary -buffer-name=english_dictionary<CR>
nnoremap <silent>[unite]x       :<C-u>Unite english_example -horizontal -buffer-name=example<CR>
nnoremap <silent>[unite]a       :<C-u>Unite web_search -horizontal -buffer-name=web_search<CR>
nnoremap <silent>[unite]t       :<C-u>Unite english_thesaurus -horizontal -buffer-name=thesaurus<CR>
nnoremap <silent>[unite]B       :<C-u>Unite bookmark -buffer-name=bookmark<CR>
nnoremap <silent>g/             :<C-U>call <SID>unite_with_same_syntax('Unite -buffer-name=line_fast -hide-source-names -horizontal -no-empty -start-insert -no-quit line/fast')<CR>
nnoremap <silent>g#             :<C-U>call <SID>unite_with_same_syntax('Unite -buffer-name=line_fast -hide-source-names -horizontal -no-empty -start-insert -no-quit line/fast -input=<C-R><C-W>')<CR>

cnoremap <expr><silent><C-g>     (getcmdtype() == '/') ?  "\<ESC>:Unite -buffer-name=search line -input=".getcmdline()."\<CR>" : "\<C-g>"
nnoremap [unite]f                :<C-U>Unite -buffer-name=file file_rec:
nnoremap <silent>[unite]<C-F>    :<C-U>call <SID>unite_git_root()<CR>
function! s:unite_git_root(...) "{{{
  let git_root = s:current_git()
  let path = empty(a:000) ? '' : a:1
  let absolute_path = s:directory_delimiter_complete(git_root) . path

  if isdirectory(absolute_path)
    execute "Unite -buffer-name=file file_rec/async:".absolute_path
    lcd `=absolute_path`
    file `='*unite* - ' . path`
  elseif filereadable(absolute_path)
    edit `=absolute_path`
  else
    echomsg path . ' is not exists!'
  endif
endfunction"}}}
function! s:unite_git_complete(arg_lead, cmd_line, cursor_pos) "{{{
  let git_root = s:directory_delimiter_complete(s:current_git())
  let files = globpath(git_root, a:arg_lead . '*')
  let file_list = split(files, '\n')
  let file_list = map(file_list, 's:directory_delimiter_complete(v:val)')
  let file_list = map(file_list, "substitute(v:val, git_root, '', 'g')")

  return file_list
endfunction "}}}
command! -nargs=? -complete=customlist,s:unite_git_complete UniteGit call <SID>unite_git_root(<f-args>)

nnoremap <silent>[unite]:        :<C-U>Unite -buffer-name=history_command -no-empty history/command<CR>
nnoremap <silent>[unite]h        :<C-U>Unite help -no-quit -buffer-name=help<CR>
nnoremap <silent>[unite]m        :<C-U>Unite mark -no-start-insert -buffer-name=mark<CR>
nnoremap <silent>[unite]o        :<C-U>Unite -no-start-insert -horizontal -no-quit -buffer-name=outline -hide-source-names outline<CR>
nnoremap <silent>[unite]q        :<C-U>Unite qiita -buffer-name=qiita<CR>
nnoremap <silent>[unite]ra       :<C-U>Unite -buffer-name=rake rake<CR>
nnoremap <silent>[unite]/        :<C-U>Unite -buffer-name=history_search -no-empty history/search<CR>
nnoremap <silent>[unite]T        :<C-U>Unite tag -buffer-name=tag -no-empty -split<CR>
autocmd BufEnter *
      \   if empty(&buftype)
      \|      nnoremap <buffer>[unite]T :<C-u>UniteWithCursorWord -horizontal -immediately tag<CR>
      \|  endif
nnoremap <silent>[unite]y        :<C-U>Unite -buffer-name=history_yank -no-empty history/yank<CR>
nnoremap [unite]S                :<C-U>Unite -no-start-insert -buffer-name=ssh ssh://
nnoremap [unite]l                :<C-U>Unite locate -buffer-name=locate -input=

" unite_reek, unite_rails_best_practices
nnoremap <silent> [unite]r      :<C-u>Unite -no-quit reek<CR>
nnoremap <silent> [unite]rr :<C-u>Unite -no-quit rails_best_practices<CR>

" unite-giti 
nnoremap <silent>gl :<C-U>Unite -buffer-name=giti_log -no-start-insert -horizontal giti/log<CR>
nnoremap <silent>gL :<C-U>Unite -buffer-name=versions_log -no-start-insert -horizontal versions/git/log<CR>
nnoremap <silent>gS :<C-U>Unite -buffer-name=versions_status -no-start-insert -horizontal versions/git/status<CR>
nnoremap <silent>gs :<C-U>Unite -buffer-name=giti_status -no-start-insert -horizontal giti/status<CR>
nnoremap <silent>gh :<C-U>Unite -buffer-name=giti_branchall -no-start-insert giti/branch_all<CR>

function! s:unite_with_same_syntax(cmd) "{{{
  let file_syntax=&syntax
  " let rails_root = exists('b:rails_root')? b:rails_root : ''
  " let rails_buffer = rails#buffer()

  " uniteを起動
  execute a:cmd

  if file_syntax != ''
    exe 'setl syntax='.file_syntax
  endif
  " if rails_root != ''
  "   let b:rails_root = rails_root
  "   call rails#set_syntax(rails_buffer)
  " endif
endfunction"}}}

let bundle = NeoBundleGet('unite.vim')
function! bundle.hooks.on_source(bundle) "{{{
  aug MyUniteCmd
    autocmd!
    autocmd FileType unite call <SID>unite_my_settings()
  aug END

  " settings 
  " 入力モードで開始する
  hi UniteCursorLine ctermbg=236   cterm=none
  let g:unite_cursor_line_highlight='UniteCursorLine'
  let g:unite_data_directory=g:my.dir.unite
  let g:unite_enable_split_vertically=1
  let g:unite_update_time=50
  let g:unite_enable_start_insert=1
  let g:unite_source_directory_mru_limit = 200
  let g:unite_source_directory_mru_time_format="(%m-%d %H:%M) "
  let g:unite_winheight=15
  let g:unite_source_file_mru_time_format="(%m-%d %H:%M) "
  let g:unite_source_file_mru_filename_format=":~:."
  let g:unite_source_file_mru_limit = 300
  let g:unite_winheight = 20
  let g:unite_marked_icon = "✓"
  let g:unite_force_overwrite_statusline=1
  let g:unite_source_history_yank_enable = 0
  let s:unite_kuso_hooks = {}
  
  function! s:unite_my_settings() 
    aug MyUniteBufferCmd
      autocmd!
      autocmd BufEnter <buffer> if winnr('$') == 1 |quit| endif
    aug END

    setl nolist
    setl cursorline
    highlight link uniteMarkedLine Identifier
    highlight link uniteCandidateInputKeyword Statement

    inoremap <silent><buffer><C-J> <Plug>(unite_loop_cursor_down)
    inoremap <silent><buffer><C-K> <Plug>(unite_loop_cursor_up)
    nmap     <silent><buffer>f <Plug>(unite_toggle_mark_current_candidate)
    xmap     <silent><buffer>f <Plug>(unite_toggle_mark_selected_candidates)
    nmap     <silent><buffer><C-H> <Plug>(unite_toggle_transpose_window)
    nmap     <silent><buffer>p <Plug>(unite_toggle_auto_preview)
    nnoremap <silent><buffer><expr>S unite#do_action('split')
    nnoremap <silent><buffer><expr>V unite#do_action('vsplit')
    nnoremap <silent><buffer><expr>,, unite#do_action('vimfiler')
    nnoremap <silent><buffer>C gg0wC
    nnoremap <expr><buffer>re unite#do_action('replace')

    " hook
    let unite = unite#get_current_unite()
    let buffer_name = unite.buffer_name != '' ? unite.buffer_name : '_'

    " バッファ名に基づいたフックを実行
    if has_key( s:unite_kuso_hooks, buffer_name )
      call s:unite_kuso_hooks[buffer_name]()
    endif
  endfunction 
  function! s:unite_kuso_hooks.file_mru() 
    syntax match uniteSource__FileMru_Dir /.*\// containedin=uniteSource__FileMru contains=uniteSource__FileMru_Time,uniteCandidateInputKeyword nextgroup=uniteSource__FileMru_Dir

    highlight link uniteSource__FileMru_Dir Directory
    highlight link uniteSource__FileMru_Time Comment
  endfunction
  function! s:unite_kuso_hooks.file() 
    inoremap <buffer><Tab> <CR>
    syntax match uniteFileDirectory '.*\/'
    highlight link uniteFileDirectory Directory
  endfunction
  function! s:unite_kuso_hooks.versions_log() 
    nnoremap <silent><buffer><expr>c unite#do_action('changeset')
    nnoremap <silent><buffer><expr>cp unite#do_action('changeset_prev')
    nnoremap <silent><buffer><expr>d unite#do_action('diff')
    nnoremap <silent><buffer><expr>diff_prev unite#do_action('diff_prev')
    nnoremap <silent><buffer><expr>r unite#do_action('yank_revision')
    nnoremap <silent><buffer><expr>rv unite#do_action('revert')
    nnoremap <silent><buffer><expr>rsh unite#do_action('reset_hard')
    nnoremap <silent><buffer><expr>rss unite#do_action('reset_soft')
  endfunction
  " command menu
  let g:unite_source_menu_menus = {}
  let g:unite_source_menu_menus.command = {
        \ 'description' : 'command alias',
        \ }
  let g:unite_source_menu_menus.command.command_candidates = {
        \ 'gitignore'  : 'Unite file_rec:' . neobundle#get_neobundle_dir() . "/gitignore",
        \ }
  function! s:unite_kuso_hooks.line_fast() 
    autocmd WinLeave <buffer> call <SID>buffer_auto_fold(1)
    autocmd WinEnter <buffer> call <SID>buffer_auto_fold(0)
  endfunction

  call unite#custom_source('line', 'max_candidates', 5000)
  call unite#custom_source('file_rec', 'max_candidates', 5000)
  call unite#custom_source('file_rec/async', 'max_candidates', 5000)
  call unite#custom_source('giti/log', 'max_candidates', 5000)
  let g:giti_log_default_line_count = 500
  call unite#custom_source('giti/branch_all', 'max_candidates', 5000)
  call unite#custom_source('line/fast', 'max_candidates', 5000)

  "------------------------------------
  " vim-version
  let g:versions#type#git#log#first_parent=1
  let g:versions#source#git#log#revision_length=0
  let g:versions#type#git#branch#merge#ignore_all_space=1

  "------------------------------------
  " unite-history
  function! s:unite_kuso_hooks.history_command()
    setl syntax=vim
  endfunction

  "------------------------------------
  " Unite-grep.vim
  if executable("ag")
    let g:unite_source_grep_command =  "ag"
    let g:unite_source_grep_default_opts = "--nocolor --nogroup"
    let g:unite_source_grep_recursive_opt = ""
  else
    let g:unite_source_grep_command =  "grep"
    let g:unite_source_grep_recursive_opt = "-R"
  endif
  " let g:unite_source_grep_ignore_pattern = ''
  function! s:unite_kuso_hooks.grep()
    nnoremap <expr><buffer>re unite#do_action('replace')
  endfunction

  "------------------------------------
  " Unite-outline
  " let g:unite_source_outline_filetype_options
  " let g:unite_source_outline_info
  " let g:unite_source_outline_indent_width
  " let g:unite_source_outline_max_headings
  " let g:unite_source_outline_cache_limit
  " let g:unite_source_outline_highlight
  function! s:unite_kuso_hooks.outline()
    nnoremap <buffer><C-J> gj
  endfunction

  "------------------------------------
  " Unite-reek, Unite-rails_best_practices
  "------------------------------------

  "----------------------------------------
  " unite-giti / vim-versions
  "----------------------------------------
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
endfunction"}}}
unlet bundle
"}}}

"----------------------------------------
" Dash"{{{
function! s:dash(...) 
  let ft = <SID>filetype()
  if ft == 'python' |let ft = ft.'2'| endif

  let ft = ft.':'

  let word = len(a:000) == 0 ? ft.join('<cword>') : join(a:000, ' ')
  call system(printf("open dash://'%s'", word))
endfunction
command! -nargs=* Dash call <SID>dash(<f-args>)

nnoremap <C-K><C-K> :Dash <C-R><C-W><CR>
augroup MyAutoCmd
  au User Rails nnoremap <buffer><C-K><C-K><C-K> :Dash rails:<C-R><C-W><CR>
augroup END
"}}}

"----------------------------------------
let bundle = NeoBundleGet('vim-ruby')
function bundle.hooks.on_source(bundle) "{{{
  let g:rubycomplete_buffer_loading = 1
  let g:rubycomplete_classes_in_global = 1
  let g:rubycomplete_rails = 1
endfunction "}}}
unlet bundle
"}}}

"----------------------------------------
let bundle = NeoBundleGet('eclim')
function! bundle.hooks.on_source(bundle)
  let g:EclimCompletionMethod = 'omnifunc'
endfunction

"----------------------------------------
function! s:update_ruby_ctags() 
  echo vimproc#system("rbenv ctags")
  echo vimproc#system("gem ctags")
endfunction 
command! UpdateRubyTags call <SID>update_ruby_ctags()

function! s:set_tmux_env() 
  if !executable("tmux") | return -1 |endif

  if exists("$TMUX") && exists("$PWD")
    call system("tmux setenv TMUXPWD_$(tmux display -p '#D' | tr -d %) " . $PWD)
  endif
endfunction

augroup TmuxSetPwd
  autocmd!
  autocmd FileReadPre,BufNewFile * call <SID>set_tmux_env()
augroup END

function! s:IDE() 
  silent!

  TagbarOpen
  VimFilerExplorerGit
endfunction
command! -bar IDE call <SID>IDE()

" ----------------------------------------
" for eclim
function! s:kill_eclimd() "{{{
  " s:eclimd_process
  let answer = input('Kill eclimd? y/n ') 
  if answer =~ 'y'
    call system('kill -QUIT '. s:eclimd_process.pid) 
    call system('pkill -f eclimd') 
    call system('pkill -f eclipse') 
    break
  endif
endfunction "}}}

function! s:load_eclim(...) "{{{
  let git_root = s:current_git()
  if filereadable(git_root . '/.project') || !empty(a:000)
    let eclimd = $ECLIPSE_HOME . "/eclimd"
    if executable(eclimd)
      let s:eclimd_process = vimproc#popen2(eclimd)
      autocmd VimLeave * call <SID>kill_eclimd()
    endif

    NeoBundleSource eclim
    autocmd! EclimLoader
  endif
endfunction"}}}
command! EclimLoader call <SID>load_eclim(1)

augroup EclimLoader
  autocmd BufEnter,FileReadPost * call s:load_eclim()
augroup END

" ----------------------------------------
" clean memory
function! s:clear_memory() "{{{
  if executable('NeoCompleteClean')
    NeoCompleteClean
    NeoCompleteDisable
    NeoCompleteEnable
  endif
  " execute 'bwipeout' join(s:buffer_nr_list(), ' ')
  " execute 'bunload' join(s:buffer_nr_list(), ' ')
  execute 'bdelete' join(s:buffer_nr_list(), ' ')
endfunction "}}}
command! Clean call <SID>clear_memory()

" ----------------------------------------
" for lang-8"{{{
function! s:do_lang8_autocmd() "{{{
  let pwd = getcwd()
  if pwd =~ 'lang-8'
    call s:lang8_settings()
  else
    let g:rspec_command = 'Dispatch rspec {spec}'
  endif
endfunction"}}}
function! s:lang8_settings()
  let g:syntastic_ruby_checkers = ['mri', 'rubocop']
  let g:rspec_command = 'Dispatch spec {spec}'

  nnoremap <buffer>[plug]c           :<C-U>UniteGit config<CR>
  nnoremap <buffer>[plug]j           :<C-U>UniteGit public/static/javascripts<CR>
  nnoremap <buffer>[plug]a           :<C-U>UniteGit public/static/sass<CR>
  nnoremap <buffer>[plug]m           :<C-U>UniteGit app/models/mailer<CR>
endfunction
augroup MyAutoCmd
  autocmd User Rails call <SID>do_lang8_autocmd()
  autocmd FileType ruby let g:syntastic_ruby_checkers = ['mri']
augroup END
command! -nargs=? L8SendPullRequest call alpaca#function#send_pullrequest(<args>)
"}}}

if !has('vim_starting')
  " Call on_source hook when reloading .vimrc.
  call neobundle#call_hook('on_source')
endif

set secure
