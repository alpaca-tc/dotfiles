" cclose
"
" if !empty(getqflist())
"   Unite -buffer-name=quickfix -no-start-insert quickfix
" elseif !empty(getloclist("%"))
"   " Unite -buffer-name=location_list -no-start-insert location_list
" endif
