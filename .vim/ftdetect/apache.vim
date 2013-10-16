augroup MyFtapache
  autocmd!
  au BufNewFile,BufRead .htaccess,httpd.conf set filetype=apache
  if expand("%:p")  =~ 'conf.d'
    au BufNewFile,BufRead *.conf set filetype=apache
  endif
augroup END
