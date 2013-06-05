"=============================================================================
" FILE: git_ls_files.vim
" Last Modified: 29 Jun 2011.
" Description: A source that invokes 'git grep' from :Unite
" Usage: :Unite git_ls_files<Return>
" Notes:
"=============================================================================

call unite#util#set_default('g:unite_source_ls_files_ignore_pattern',
      \'\%(^\|/\)\.\.\?$\|\~$\|\.\%(o|exe|dll|bak|DS_Store|pyc|zwc|sw[po]\)$')

let s:source = {
      \ 'name'           : 'git/ls_files',
      \ 'hooks'    : {},
      \ }
      " \ 'ignore_pattern' : g:unite_source_ls_files_ignore_pattern,
      " \ 'default_kind' : 'file',
      " \ 'max_candidates' : 30,
      " \ 'is_volatile' : 1,

function! s:enable() "{{{
  return unite#util#system('git rev-parse --is-inside-work-tree') == "true\n"
endfunction"}}}

function! s:source.hooks.on_init(args, context) "{{{
  " extend if_ruby VIM module
endfunction"}}}

function! s:source.change_candidates(args, context) "{{{
  return unite#sources#git_ls_files#grep(a:context.input)
endfunction"}}}

function! s:source.gather_candidates(args, context) "{{{
  if s:enable()
    return unite#sources#git_ls_files#grep(a:context.input)
  else
    return [{ "word": "Not a git repository (or any of the parent directories): .git", "is_dummy": 1}]
  endif
endfunction"}}}

function! unite#sources#git_ls_files#grep(input) "{{{
  call unite#util#extend_vim#load()
  ruby << EOF
    require "json"
    input = EX_VIM.get("a:input")
    input_list = input.split(/\s+/)
    lsfiles = `git ls-files`
    limit = 100

    file_list =lsfiles.split(/\n|\r|\r\n/)
    candidates = file_list.select { |val|
      # 検索
      input_list.map { |str| val.match(str) }.all?
    }.map { |val|
      # convert to candidates
      {
        word: val,
        kind: "jump_list",
        action__path: val,
        action__text: val,
      }
    }

    EX_VIM.let("candidates", candidates)
EOF
  let g:hoge = candidates
  return candidates
endfunction "}}}

function! unite#sources#git_ls_files#define() "{{{
  return s:source
endfunction"}}}

" vim: foldmethod=marker
