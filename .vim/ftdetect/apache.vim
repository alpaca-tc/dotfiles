au BufNewFile,BufRead .htaccess,httpd.conf set filetype=apache
au BufNewFile,BufRead *.conf if expand("%:p")  =~ 'conf.d' |set filetype=apache| endif
