function! alpaca#function#get_sid(file_path) "{{{
  if filereadable(a:file_path)
    redir => script_names
      silent scriptnames
    redir END

    for line in split(script_names, '\n')
      let [sid, filepath] = split(line, ': ')
      if fnamemodify(filepath, ':p') =~ a:file_path . '$'
        return matchstr(sid, '\d\+')
      endif
    endfor
  endif

  return 0
endfunction"}}}
