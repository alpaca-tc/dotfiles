function! s:get_autcmd_with_filetype(filetype, cmd) "{{{
  let autcmd = join(["autocmd FileType", a:filetype, a:cmd], " ")
  return join(["augroup AbbrDefine", autcmd, "augroup END"], "|")
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
  " XXX 複雑になるかもしれないので、mapは使わない
  for abbr in a:define
    let abbrev = join(["inoreabbrev", "<buffer>", abbr], " ") " => inoreabbrev <buffer> sh should
    call add(defines, abbrev)
  endfor

  let command = join(defines, "|")
  " a:1 => filetype
  execute a:0 > 0 ? s:get_autcmd_with_filetype(a:1, command) : command
endfunction"}}}
