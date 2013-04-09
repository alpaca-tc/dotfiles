" initialize
augroup AbbrDefine
augroup END

function! s:get_autcmd_with_filetype(filetype, cmd) "{{{
  return join(["autocmd AbbrDefine FileType", a:filetype, a:cmd], " ")
endfunction"}}}

function! alpaca#initialize#directory(array) "{{{
  " initialize directory
  " create directory
  for dir_path in a:array
    if !isdirectory(dir_path)
      call mkdir(dir_path, 'p')
      echomsg "create directory : " . dir_path
    endif
  endfor
endfunction"}}}
function! alpaca#initialize#define_abbrev(define, ...) "{{{
  " a:1 => filetype

  let defines = []
  call map(copy(a:define), 'add(defines, join(["inoreabbrev", "<buffer>", v:val], " "))')

  let command = join(defines, "|")

  execute a:0 > 0 ? s:get_autcmd_with_filetype(a:1, command) : command
endfunction"}}}
