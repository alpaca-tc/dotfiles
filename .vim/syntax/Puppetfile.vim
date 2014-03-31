" Vim Syntax File
runtime syntax/ruby.vim

syntax case match

" Normal oneliners
syntax keyword PuppetfileKeywords github
highlight link PuppetfileKeywords Function

" " Things that accept a block (because that will create a clearer color
" " distinction)
" syntax keyword PuppetfileBlockKeywords ruby source path bundle_path group platforms git env
" highlight link PuppetfileBlockKeywords Keyword

" Make commenting plugin work
if exists("*TCommentDefineType")
  call TCommentDefineType('Puppetfile', '# %s')
endif
