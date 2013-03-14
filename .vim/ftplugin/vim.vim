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

autocmd BufWritePost,FileWritePost <buffer> source <afile> | echo 'source ' . bufname('%')

let &cpo = s:save_cpo
