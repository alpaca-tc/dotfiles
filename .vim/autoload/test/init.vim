function! test#init#test()
  call test#init()
  ruby << EOF
  require 'rspec'
EOF
endfunction
