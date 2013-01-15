
" Vim indent file
" Language:             apache-style configs
" Maintainor:           Alexey Panchenko
" Last Modified:        $Date: 2006/03/21 09:58:39 $

" Only load this indent file when no other was loaded.
if exists("b:did_indent")
  finish
endif

let b:did_indent = 1

setl sw=4 sts=4 ts=4 et
setlocal indentexpr=ApacheGetIndent()
" setlocal indentkeys+=e,0=end,0=endsw,*<return> indentkeys-=0{,0},0),:,0#

" Only define the function once.
if exists("*ApacheGetIndent")
  finish
endif

"#set cpoptions-=C

function ApacheGetIndent()
  " Find a non-blank line above the current line.
  let lnum = prevnonblank(v:lnum - 1)

  " Hit the start of the file, use zero indent.
  if lnum == 0
    return 0
  endif

  let ind = indent(lnum)
  let line = getline(lnum)

  " Add indent if previous line is with <directive>
  if line =~ '^\s*<\a'
    let ind = ind + &sw
    echo 'add'
  endif

  " Sub indent if previous line is with </directive>
  "if line =~ '^\s*<\/\a'
  "  let ind = ind - &sw
  "  echo 'sub'
  "endif

  " Subtract indent if current line is </directive>
  let line = getline(v:lnum)
  if line =~ '^\s*<\/\a'
    let ind = ind - &sw
  endif

  return ind
endfunction
