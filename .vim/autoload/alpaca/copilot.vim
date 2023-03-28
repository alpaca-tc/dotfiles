function! alpaca#copilot#is_displayed()
  let suggestion = copilot#GetDisplayedSuggestion()
  return !empty(suggestion.text)
endfunction
