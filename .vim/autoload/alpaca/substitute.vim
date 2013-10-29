function! s:substitute(dict) "{{{
  for [zen, half] in items(a:dict)
    let zen = substitute(zen, '!', '\\!', 'ge')
    let half = substitute(half, '!', '\\!', 'ge')
    silent execute join(['%substitute', zen, half, 'ge'], '!')
  endfor
endfunction"}}}

function! alpaca#substitute#number() "{{{
  let converter_table = {
        \ '０': '0' ,
        \ '１': '1' ,
        \ '２': '2' ,
        \ '３': '3' ,
        \ '４': '4' ,
        \ '５': '5' ,
        \ '６': '6' ,
        \ '７': '7' ,
        \ '８': '8' ,
        \ '９': '9' ,
        \ '①': 1,
        \ '②': 2,
        \ '③': 3,
        \ '④': 4,
        \ '⑤': 5,
        \ '⑥': 6,
        \ '⑦': 7,
        \ '⑧': 8,
        \ '⑨': 9,
        \ '⑩': 10,
        \ '⑪': 11,
        \ '⑫': 12,
        \ '⑬': 13,
        \ '⑭': 14,
        \ '⑮': 15,
        \ '⑯': 16,
        \ '⑰': 17,
        \ '⑱': 18,
        \ '⑲': 19,
        \ '⑳': 20,
        \ }
  call s:substitute(converter_table)
endfunction"}}}

function! alpaca#substitute#bracket() "{{{
  let converter_table = {
        \ '（': '(',
        \ '）': ')',
        \ '【': '[',
        \ '】': ']',
        \ '『': '[',
        \ '』': ']',
        \ '［': '[',
        \ '］': ']',
        \ '〈': '<',
        \ '〉': '>',
        \ '《': '<',
        \ '》': '>',
        \ '〔': '[',
        \ '〕': ']',
        \ '‘': "'",
        \ '’': "'",
        \ '“': '"',
        \ '”': '"',
        \ '〝': '"',
        \ '〟': '"',
        \ '「': '[',
        \ '」': ']',
        \ '｛': '{',
        \ '｝': '}',
        \ }
  call s:substitute(converter_table)
endfunction"}}}

function! alpaca#substitute#invisible()
  let converter_table = {
        \ '\t' : &tabstop,
        \ '　' : ' ',
        \ 'ː' : ':',
        \ }
  call s:substitute(converter_table)
endfunction

function! alpaca#substitute#mark() "{{{
  let converter_table = {
        \ '。' : '.',
        \ '、' : ',',
        \ '・' : '- ',
        \ '＋' : '+',
        \ 'ー' : '-',
        \ '＝' : '=',
        \ '〜' : '~',
        \ '～' : '~',
        \ '｜' : '|',
        \ '＾' : '^',
        \ '％' : '%',
        \ '＆' : '&',
        \ '＄' : '$',
        \ '＃' : '#',
        \ '＿' : '_',
        \ '￥' : '\\',
        \ '？' : '?',
        \ '！' : '!',
        \ '＊' : '*',
        \ '→' : '->',
        \ '←' : '<-',
        \ '⇒' : '->',
        \ '⇦' : '<-',
        \ '•' : '- ',
        \ '◆' : ' - ',
        \ '…' : '...',
        \ '＠' : '@',
        \ '►' : '>',
        \ }

  call s:substitute(converter_table)
endfunction"}}}

function! alpaca#substitute#all() "{{{
  let current_position = getpos('.')

  call alpaca#substitute#number()
  call alpaca#substitute#bracket()
  call alpaca#substitute#mark()
  call alpaca#substitute#invisible()

  call cursor(current_position[1], current_position[2])
  redraw
endfunction"}}}
