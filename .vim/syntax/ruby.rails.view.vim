" view-partial
syn keyword rubyRailsMethod local_assigns

" helper
syn keyword rubyRailsViewMethod polymorphic_path polymorphic_url
syn match rubyRailsHelperMethod '\<select\>\%(\s*{\|\s*do\>\|\s*(\=\s*&\)\@!'
syn match rubyRailsHelperMethod '\<\%(content_for?\=\|current_page?\)'
syn match rubyRailsViewMethod '\.\@<!\<\(h\|html_escape\|u\|url_encode\)\>'
