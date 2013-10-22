let s:save_cpo = &cpo
set cpo&vim

setl suffixesadd=.vim includeexpr=fnamemodify(substitute(v:fname,'#','/','g'),':h')
let &l:path = join(map(split(&runtimepath, ','), 'v:val."/autoload"'), ',')
let &l:path = join(map(split(&runtimepath, ','), 'v:val.""'), ',')
let &keywordprg=':help'

if expand('%:p:h') =~ '.vim/colors'
  augroup MySyntaxCmd
    autocmd!
    autocmd FileWritePost <buffer> write | source `=expand('%')`
    autocmd FileType <buffer> autocmd! MySyntaxCmd
  augroup END
endif

function! s:evaluate_text_selected() "{{{
  if &previewwindow
    return
  endif

  let current_file = expand('%:p')
  let s:sid = ''

  " Get SID
  if filereadable(current_file) "{{{
    redir => script_names
      silent scriptnames
    redir END

    for line in split(script_names, '\n')
      let [sid, filepath] = split(line, ': ')
      if fnamemodify(filepath, ':p') =~ current_file . '$'
        let s:sid = matchstr(sid, '\d\+')
      endif
    endfor
  endif"}}}

  let text_selected = @*

  try
  " Replace script variable to raw value"{{{
  let script_variables_function = '<SNR>' . s:sid . '_get_script_variables'

  if !empty(s:sid) && text_selected =~ 's:\S\+()'
    let function_full_name = substitute(matchstr(text_selected, 's:\S\+()'), '()', '', 'g')
    let function_name = split(function_full_name, ':')[-1]
    let function_scope = '<SNR>' . s:sid . '_' . function_name
    let function_result = {function_scope}()

    let result = function_result
  elseif !empty(s:sid) && text_selected =~ 's:' && exists('*' . script_variables_function . '()')
    let script_variables = {script_variables_function}()
    let var_full_name = matchstr(text_selected, 's:\S\+')
    let var_name = split(var_full_name, ':')[-1]
    let var_value = get(script_variables, var_name)

    echomsg 'Replaced ' . var_full_name . ' to ' . var_value
    let text_selected = substitute(text_selected, var_full_name, var_value, 'g')

    " evaluate text_selected
    echomsg text_selected
    sandbox let result = eval(text_selected)
  else
    " evaluate text_selected
    echomsg text_selected
    sandbox let result = eval(text_selected)
  endif
  "}}}

  " Write result to tempfile"{{{
  let result_as_string = string(result)
  let result_as_array = split(result_as_string, '\n')

  let temp_path = tempname()
  call writefile(result_as_array, temp_path)
  "}}}

  silent pedit `=temp_path`

  catch /.*/
    echomsg v:errmsg
  endtry
endfunction"}}}
xmap <silent><buffer>\ :<C-U>call <SID>evaluate_text_selected()<CR>

iabbrev ehco echo
iabbrev ecoh echo

let &cpo = s:save_cpo
