function! s:set_rspec_syntax()
  hi def link rubyRailsTestMethod Function
  " syn keyword rubyRailsTestMethod describe context it its specify shared_examples_for it_should_behave_like before after around subject fixtures controller_name helper_name
  syn keyword rubyRailsTestMethod describe context it its specify shared_examples_for it_should_behave_like before after around subject fixtures controller_name helper_name
  syn match rubyRailsTestMethod '\<let\>!\='
  syn keyword rubyRailsTestMethod violated pending expect double mock mock_model stub_model
  syn match rubyRailsTestMethod '\.\@<!\<stub\>!\@!'
endfunction

if expand("%:t") =~ '_spec\.rb'
  call s:set_rspec_syntax()
endif
