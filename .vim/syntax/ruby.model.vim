" Vim syntax file
" Language:         RoR Syntax
" Maintainer:       Ishii Hiroyuki
" Latest Revision:  2013-02-14
" Version:      0.1
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

if !exists("main_syntax")
  let main_syntax = 'rails'
endif

if version < 600
  so <sfile>:p:h/ruby.vim
else
  runtime syntax/ruby.vim
  " syn cluster phpClFunction  add=wpFunction
  unlet b:current_syntax
endif

syn keyword wpFunction get_adjacent_post get_boundary_post get_children get_extended  get_next_post get_permalink get_post get_post_ancestors get_post_mime_type get_post_status  get_post_type get_previous_post get_posts is_post is_single is_sticky  register_post_type wp_get_recent_posts wp_get_single_post contained

hi link wpFunction Function
" hi link wpFunction Number
" hi def link wpFunction Type

let b:current_syntax = "wordpress"

if main_syntax == 'wordpress'
  unlet main_syntax
endif

" vim: ts=2 sts=2 sw=2 expandtab
