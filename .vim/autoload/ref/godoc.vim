" A ref source for godoc.
" Version: 0.0.1
" Author : mattn <mattn.jp@gmail.com>
" License: Creative Commons Attribution 2.1 Japan License
"          <http://creativecommons.org/licenses/by/2.1/jp/deed.en>

let s:save_cpo = &cpo
set cpo&vim

" options. {{{1
if !exists('g:ref_godoc_cmd')  " {{{2
  let g:ref_godoc_cmd = executable('godoc') ? 'godoc' : ''
endif



let s:source = {'name': 'godoc'}  " {{{1

function! s:source.available()  " {{{2
  return !empty(g:ref_godoc_cmd)
endfunction



function! s:source.get_body(query)  " {{{2
  return ref#system(ref#to_list(g:ref_godoc_cmd, len(a:query) ? a:query : '/')).stdout
endfunction



function! s:source.opened(query)  " {{{2
  call s:syntax()
endfunction



if globpath(&rtp, 'autoload/go/complete.vim') != ''  " {{{2
  function! s:source.complete(query)
    return go#complete#Package(a:query, "", "")
  endfunction
endif



function! s:syntax()  " {{{2
  if exists('b:current_syntax') && b:current_syntax ==# 'ref-godoc'
    return
  endif

  syntax clear


  syntax match refGodocHeader '^[[:upper:][:space:]]\+$'
  syntax match refGodocMethod /^func \w\+(/hs=s+5,he=e-1
  syntax match refGodocType /^type \w\+ /hs=s+5,he=e-1
  syntax match refGodocConst /^const \w\+ /hs=s+6,he=e-1

  highlight default link refGodocHeader Type
  highlight default link refGodocMethod Function
  highlight default link refGodocType Structure
  highlight default link refGodocConst Constant

  let b:current_syntax = 'ref-godoc'
endfunction



function! s:head(list, query)  " {{{2
  let pat = '^\V' . a:query . '\v\w*(\.)?\zs.*$'
  return ref#uniq(map(filter(copy(a:list), 'v:val =~# pat'),
  \             'substitute(v:val, pat, "", "")'))
endfunction



function! ref#godoc#define()  " {{{2
  return copy(s:source)
endfunction

call ref#register_detection('go', 'godoc')



let &cpo = s:save_cpo
unlet s:save_cpo
