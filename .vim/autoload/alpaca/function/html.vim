function! alpaca#function#html#endtag_comment() "{{{
  let reg_save = @@

  try
    silent normal vaty
  catch
    execute "normal \<Esc>"
    echohl ErrorMsg
    echo 'no match html tags'
    echohl None

    return
  endtry

  let html = @@

  let start_tag = matchstr(html, '\v(\<.{-}\>)')
  let tag_name  = matchstr(start_tag, '\v([a-zA-Z]+)')

  let id = ''
  let id_match = matchlist(start_tag, '\vid\=["'']([^"'']+)["'']')
  if exists('id_match[1]')
    let id = '#' . id_match[1]
  endif

  let class = ''
  let class_match = matchlist(start_tag, '\vclass\=["'']([^"'']+)["'']')
  if exists('class_match[1]')
    let class = '.' . join(split(class_match[1], '\v\s+'), '.')
  endif

  execute "normal `>va<\<Esc>`<"

  if !exists('g:end_tag_commant_format')
    let g:end_tag_commant_format = '<!-- /%tag_name%id%class -->'
  endif
  let comment = g:end_tag_commant_format
  let comment = substitute(comment, '%tag_name', tag_name, 'g')
  let comment = substitute(comment, '%id', id, 'g')
  let comment = substitute(comment, '%class', class, 'g')
  let @@ = comment

  normal $""p

  let @@ = reg_save
endfunction"}}}
