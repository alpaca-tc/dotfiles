aug MyFtDetect
  au BufNewFile,BufRead Gemfile setl filetype=Gemfile
  au BufWritePost Gemfile call vimproc#system('rbenv ctags')
aug END
