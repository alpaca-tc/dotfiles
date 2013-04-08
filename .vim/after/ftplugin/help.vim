if &l:buftype !=# 'help'
  setlocal nolist tabstop=8 shiftwidth=8 softtabstop=8 noexpandtab textwidth=80
  if exists('+colorcolumn')
    setlocal colorcolumn=+1
  endif
  if has('conceal')
    setlocal conceallevel=0
  endif
endif
