function! rust_helper#recent_struct()
  let line_number = line('.')
  let content = getline(1, line_number)

  for line in reverse(content)
    let matched = matchlist(line, 'struct\s*\(\w\+\)\(<.\+>\)\?')

    if !empty(matched)
      let name = matched[1]
      let generics = matched[2]

      return [name, generics]
    endif
  endfor

  return []
endfunction

function! rust_helper#recent_struct_and_generics_for_impl(...)
  let recent = rust#recent_struct()
  let generics = get(recent, 1, "")
  let name = get(recent, 0, "")

  if len(a:000) == 0
    return generics . " " . name . generics
  else
    let for = a:000[0]
    return generics . " " . for . " " . name . generics
  endif
endfunction
