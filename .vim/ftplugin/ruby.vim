setl tags+=~/gtags

"****************************************
" Rspec
"****************************************
function! RSpecSyntax()
  hi def link rubyRailsTestMethod Function
  syn keyword rubyRailsTestMethod describe context it its specify shared_examples_for it_should_behave_like before after around subject fixtures controller_name helper_name
  syn match rubyRailsTestMethod '\<let\>!\='
  syn keyword rubyRailsTestMethod violated pending expect double mock mock_model stub_model
  syn match rubyRailsTestMethod '\.\@<!\<stub\>!\@!'
endfunction
aug MyAutoCmd
  autocmd BufReadPost *_spec.rb call RSpecSyntax()
aug END


