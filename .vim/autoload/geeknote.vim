let g:geeknote#bin = get(g:, 'geeknote#bin', 'geeknote')

function! geeknote#active()
  return 1
endfunction

function! geeknote#system(args) "{{{
  let command = 'python ' . g:geeknote#bin . ' ' . a:args
  echo command
  return system(command)
endfunction"}}}

function! geeknote#initialize() "{{{
  call geeknote#system('login')
endfunction"}}}
