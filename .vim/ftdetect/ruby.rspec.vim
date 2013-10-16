augroup MyFtrubyRspec
  autocmd!
  autocmd BufNewFile,BufRead *_spec.rb setl filetype=ruby.rspec
  autocmd FileType ruby.rspec NeoSnippetSource ~/.vim/snippet/ruby.rails.rspec.snip
augroup END
