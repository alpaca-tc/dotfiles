autocmd BufNewFile,BufRead *.json setl
      \ filetype=json
      \ shiftwidth=2 softtabstop=2 tabstop=2
      \ expandtab foldmethod=syntax
autocmd FileType json autocmd! TernAutoCmd * <buffer>
