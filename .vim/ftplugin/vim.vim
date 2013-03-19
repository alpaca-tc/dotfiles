let s:save_cpo = &cpo
set cpo&vim

if exists('b:undo_ftplugin')
  let b:undo_ftplugin .= ' | '
else
  let b:undo_ftplugin = ''
endif
let b:undo_ftplugin .= 'setl modeline<'

" For gf.
let &l:path = join(map(split(&runtimepath, ','), 'v:val."/autoload"'), ',')
setl suffixesadd=.vim
setl includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')
let &keywordprg=':help'

" colorschemeの編集時は自動で読み込む
if expand("%:p:h") =~ 'colors'
  augroup MyAutoCmd
    autocmd FileWritePost,InsertLeave <buffer> write | source `=expand("%")`
  augroup END
endif

let &cpo = s:save_cpo
