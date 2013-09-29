function! unite#sources#geeknote#define() "{{{
  let source_list = split(globpath(&runtimepath, 'autoload/unite/sources/geeknote/*.vim'), '\n')
  let source_names = map(source_list, 'fnamemodify(v:val, ":t:r")')
  let sources = []

  for source_name in source_list
    let source = unite#sources#geeknote#{source_name}#define()
    if !empty(source) && type(source) == type({})
      call add(sources, source)
    elseif
      call extend(sources, source)
    endif
  endfor

  return sources
endfunction"}}}
