let s:save_cpo = &cpo
set cpo&vim

" For gf.
let &l:path = join(map(split(&runtimepath, ','), 'v:val."/autoload"'), ',')
let &l:path = join(map(split(&runtimepath, ','), 'v:val.""'), ',')
setl suffixesadd=.vim
setl includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')
let &keywordprg=':help'

" colorschemeの編集時は自動で読み込む
if expand("%:p:h") =~ '.vim/colors'
  augroup MySyntaxCmd
    autocmd!
    autocmd FileWritePost,InsertLeave <buffer> write | source `=expand("%")`
  augroup END
endif

function! s:evaluate_text_selected() "{{{
  if &previewwindow
    return
  endif

  let current_file = expand('%:p')
  let sid = 's:'

  if filereadable(current_file)
    redir => script_names
      silent scriptnames
    redir END

    for line in split(script_names, '\n')
      let sid_and_filepath = split(line, ': ')
      if fnamemodify(sid_and_filepath[1], ':p') =~ current_file . '$'
        let sid = sid_and_filepath[0]
      endif
    endfor
  endif

  let text_selected = @*
  let text_selected = substitute(text_selected, 's:', '<SNR>' . sid . '_', 'g')
  sandbox let result = eval(text_selected)
  let result_as_string = string(result)
  let result_as_array = split(result_as_string, '\n')

  let temp_path = tempname()
  call writefile(result_as_array, temp_path)

  silent pedit `=temp_path`
endfunction"}}}
vmap <buffer><C-L><C-L> :<C-U>call <SID>evaluate_text_selected()<CR>

let &cpo = s:save_cpo
