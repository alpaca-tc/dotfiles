setl omnifunc=xmlcomplete#CompleteTags

function! XmlSitempRootUrl() "{{{
  let current_line = getpos('.')
  let match_line_number = search('<loc>\(https\{,1}://\)\([^/]\+\).*</loc>')
  call setpos('.', current_line)
  let match_line = getline(match_line_number, match_line_number)[0]
  return substitute(match_line, '^\s*<loc>\(https\{,1}://\)\([^/]\+\).*</loc>$', '\1\2/', 'g')
endfunction"}}}

