function! rails_locale#open_locale_file_from_path(path)
  let file_type = s:file_type(a:path)
  let root = s:detect_rails_root(a:path)
  let filename = 'ja.yml'

  if file_type == 'view'
    let locale_path = join([s:locale_path(a:path), filename], '/')
    return s:open_locale_path(locale_path)
  elseif file_type == 'model' || file_type == 'form' || file_type == 'validation'
    let model_name = fnamemodify(expand('%:p'), ':t:r')
    let locale_path = join([s:locale_path(a:path), model_name, filename], '/')
    return s:open_locale_path(locale_path)
  else
    errmsg 'Can not detect locale path from ' . a:path
  endif
endfunction

function! s:detect_rails_root(path)
  let paths = split(a:path, '/')
  let path = ''

  for part in split(a:path, '/')
    let path .= '/' . part

    if filereadable(path . '/config/application.rb')
      return path
    endif
  endfor
endfunction

function! s:ask(message)
  echo a:message . ' '
  let answer = nr2char(getchar())

  if answer ==? 'y'
    return 1
  elseif answer ==? 'n'
    return 0
  else
    echo 'Please enter "y" or "n"'
    return s:ask(a:message)
  endif
endfunction

function! s:open_locale_path(path)
  if filereadable(a:path)
    edit `=a:path`
    return
  endif

  if s:ask('Create ' . a:path . '?')
    let locale_directory = fnamemodify(a:path, ':h')

    if !isdirectory(locale_directory)
      call mkdir(locale_directory, 'p')
    endif

    edit `=a:path`
  endif
endfunction

function! s:locale_path(path)
  let root = s:detect_rails_root(a:path)
  let base_path = fnamemodify(a:path, ':h')
  let without_prefix = substitute(base_path, root . '/app/', '', '')

  return root . '/config/locales/' . without_prefix
endfunction

function! s:file_type(path)
  if a:path =~ 'app/views'
    return 'view'
  elseif a:path =~ 'app/models'
    return 'model'
  elseif a:path =~ 'app/forms'
    return 'form'
  elseif a:path =~ 'app/validations'
    return 'validation'
  else
    return 'unknown'
  endif
endfunction
