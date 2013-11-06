autocmd BufNewFile,BufRead *.liquid set ft=liquid
autocmd BufNewFile,BufRead */_layouts/*.html,*/_includes/*.html set ft=liquid
autocmd BufNewFile,BufRead *.{html,xml,textile} if getline(1) == '---' | set ft=liquid | endif
autocmd BufNewFile,BufRead *.{markdown,mkd,mkdn,md}
      \ if getline(1) == '---' |
      \   let b:liquid_subtype = 'markdown' |
      \   set ft=liquid |
      \ endif
