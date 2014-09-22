let s:source = {
      \ 'name' : 'emoji',
      \ 'kind' : 'manual',
      \ 'mark' : '[emoji]',
      \ }
function! neocomplete#sources#emoji#define() "{{{
  return s:source
endfunction"}}}

function! s:get_candidates() "{{{
  if !exists('s:candidates')
    let s:candidates = []

    for [keyword, emoji] in items(emoji#definition#get_all())
      call add(s:candidates, {
            \ 'word': printf(':%s:', keyword),
            \ 'abbr': printf(':%s: %s', keyword, emoji),
            \ })
    endfor
  endif

  return copy(s:candidates)
endfunction"}}}

function! s:source.gather_candidates(context) "{{{
  return s:get_candidates()
endfunction"}}}
