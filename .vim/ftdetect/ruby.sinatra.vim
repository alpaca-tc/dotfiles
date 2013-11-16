autocmd BufNewFile,BufRead *.rb
  \ let lines  = getline(1).getline(2).getline(3).getline(3).getline(4).getline(5)
  \|if lines =~? '[Ss]inatra'
  \|  setl filetype=ruby.sinatra
  \|endif
