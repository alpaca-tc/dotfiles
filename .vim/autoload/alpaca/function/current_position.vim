function! alpaca#function#current_position#percent() "{{{
  let current = str2float(line(".") - 1)
  if current == 0
    return 0
  endif
  let last = str2float(line("$") - 1)
  let one_line = 100.0 / last

  return float2nr(floor((one_line * current)))
endfunction"}}}
