if exists("b:current_syntax")
  finish
endif

let b:current_syntax = 'fugitiveblame'
let conceal = has('conceal') ? ' conceal' : ''
let arg = ''
syn match FugitiveblameBoundary "^\^"
syn match FugitiveblameBlank                      "^\s\+\s\@=" nextgroup=FugitiveblameAnnotation,fugitiveblameOriginalFile,FugitiveblameOriginalLineNumber skipwhite
syn match FugitiveblameHash       "\%(^\^\=\)\@<=\x\{7,40\}\>" nextgroup=FugitiveblameAnnotation,FugitiveblameOriginalLineNumber,fugitiveblameOriginalFile skipwhite
syn match FugitiveblameUncommitted "\%(^\^\=\)\@<=0\{7,40\}\>" nextgroup=FugitiveblameAnnotation,FugitiveblameOriginalLineNumber,fugitiveblameOriginalFile skipwhite
syn region FugitiveblameAnnotation matchgroup=FugitiveblameDelimiter start="(" end="\%( \d\+\)\@<=)" contained keepend oneline
syn match FugitiveblameTime "[0-9:/+-][0-9:/+ -]*[0-9:/+-]\%( \+\d\+)\)\@=" contained containedin=FugitiveblameAnnotation
exec 'syn match FugitiveblameLineNumber         " *\d\+)\@=" contained containedin=FugitiveblameAnnotation'.conceal
exec 'syn match FugitiveblameOriginalFile       " \%(\f\+\D\@<=\|\D\@=\f\+\)\%(\%(\s\+\d\+\)\=\s\%((\|\s*\d\+)\)\)\@=" contained nextgroup=FugitiveblameOriginalLineNumber,FugitiveblameAnnotation skipwhite'.(arg =~# 'f' ? '' : conceal)
exec 'syn match FugitiveblameOriginalLineNumber " *\d\+\%(\s(\)\@=" contained nextgroup=FugitiveblameAnnotation skipwhite'.(arg =~# 'n' ? '' : conceal)
exec 'syn match FugitiveblameOriginalLineNumber " *\d\+\%(\s\+\d\+)\)\@=" contained nextgroup=FugitiveblameShort skipwhite'.(arg =~# 'n' ? '' : conceal)
syn match FugitiveblameShort              " \d\+)" contained contains=FugitiveblameLineNumber
syn match FugitiveblameNotCommittedYet "(\@<=Not Committed Yet\>" contained containedin=FugitiveblameAnnotation
hi def link FugitiveblameBoundary           Keyword
hi def link FugitiveblameHash               Identifier
hi def link FugitiveblameUncommitted        Function
hi def link FugitiveblameTime               PreProc
hi def link FugitiveblameLineNumber         Number
hi def link FugitiveblameOriginalFile       String
hi def link FugitiveblameOriginalLineNumber Float
hi def link FugitiveblameShort              FugitiveblameDelimiter
hi def link FugitiveblameDelimiter          Delimiter
hi def link FugitiveblameNotCommittedYet    Comment

