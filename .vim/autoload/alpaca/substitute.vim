function! s:substitute(dict) "{{{
  for [zen, half] in items(a:dict)
    let zen = substitute(zen, '!', '\\!', 'ge')
    let half = substitute(half, '!', '\\!', 'ge')
    execute join(['%substitute', zen, half, 'ge'], '!')
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

function! alpaca#substitute#mark() "{{{
  let converter_table = {
        \ '。' : '.',
        \ '、' : ',',
        \ '・' : ', ',
        \ '＋' : '+',
        \ 'ー' : '-',
        \ '＝' : '=',
        \ '〜' : '~',
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
        \ '　' : ' ',
        \ '→' : '->',
        \ '←' : '<-',
        \ }

  call s:substitute(converter_table)
endfunction"}}}

function! alpaca#substitute#all() "{{{
  call alpaca#substitute#number()
  call alpaca#substitute#bracket()
  call alpaca#substitute#mark()
endfunction"}}}
