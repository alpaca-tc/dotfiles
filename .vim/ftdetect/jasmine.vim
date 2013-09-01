augroup MyFtDetect
  autocmd BufNewFile,BufRead *Helper.js,*Spec.js  setl filetype=jasmine.javascript
  autocmd BufNewFile,BufRead *Helper.coffee,*Spec.coffee  setl filetype=jasmine.coffee
augroup END
