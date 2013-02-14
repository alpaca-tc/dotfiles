" spec
syn keyword rubyRailsTestMethod describe context it its specify shared_context shared_examples_for it_should_behave_like before after around subject fixtures controller_name helper_name scenario feature background
syn match rubyRailsTestMethod '\<let\>!\='
syn keyword rubyRailsTestMethod violated pending expect double mock mock_model stub_model
syn match rubyRailsTestMethod '\.\@<!\<stub\>!\@!'

" spec-model
syn match   rubyRailsTestControllerMethod  '\.\@<!\<\%(get\|post\|put\|delete\|head\|process\|assigns\)\>'
syn keyword rubyRailsTestControllerMethod  integrate_views render_views
syn keyword rubyRailsMethod params request response session flash
syn keyword rubyRailsMethod polymorphic_path polymorphic_url

