"=============================================================================
" FILE: git.vim
" AUTHOR:  Shougo Matsushita <Shougo.Matsu@gmail.com>
" Last Modified: 18 Aug 2012.
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}
"=============================================================================

let s:save_cpo = &cpo
set cpo&vim

function! neobundle#types#git#define()"{{{
  return executable('git') ? s:type : {}
endfunction"}}}

let s:type = {
      \ 'name' : 'git',
      \ }

function! s:type.detect(path)"{{{
  let type = ''

  if a:path =~# '\<\(gh\|github\):\S\+\|'.
        \'^\w[[:alnum:]-]*/[^/]\+$\|://github.com/'
    let uri = (a:path =~# '://github.com/') ? a:path :
          \ g:neobundle_default_git_protocol .
          \   '://github.com/'.substitute(split(a:path, ':')[-1],
          \   '^//github.com/', '', '')
    if uri !~ '\.git\s*$'
      " Add .git suffix.
      let uri .= '.git'
    endif

    let name = substitute(split(uri, '/')[-1], '\.git\s*$','','i')
    let type = 'git'
  elseif a:path =~# '\<\%(git@\|git://\)\S\+'
        \ || a:path =~# '\.git\s*$'
    let uri = a:path
    let name = split(substitute(uri, '/\?\.git\s*$','','i'), '/')[-1]

    let type = 'git'
  elseif a:path !~ '/'
    " www.vim.org Vim scripts.
    let name = a:path
    let uri  = g:neobundle_default_git_protocol .
          \ '://github.com/vim-scripts/'.name.'.git'
    let type = 'git'
  endif

  return type == '' ?  {} :
        \ { 'name': name, 'uri': uri, 'type' : type }
endfunction"}}}
function! s:type.get_sync_command(bundle)"{{{
  if !isdirectory(a:bundle.path)
    let cmd = 'git clone'
    let cmd .= printf(' %s "%s"', a:bundle.uri, a:bundle.path)
  else
    let cmd = 'git pull --rebase'

    if get(a:bundle, 'rev', '') != ''
      " Restore revision.
      let cmd = 'git checkout master && ' . cmd
    endif
  endif
  return cmd
endfunction"}}}
function! s:type.get_revision_number_command(bundle)"{{{
  return 'git rev-parse HEAD'
endfunction"}}}
function! s:type.get_revision_lock_command(bundle)"{{{
  return 'git checkout ' . a:bundle.rev
endfunction"}}}

let &cpo = s:save_cpo
unlet s:save_cpo

" vim: foldmethod=marker
