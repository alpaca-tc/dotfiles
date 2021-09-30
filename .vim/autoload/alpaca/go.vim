function! alpaca#go#prevStruct()
  let currentLine = line(".")

  for lineNumber in reverse(range(0, currentLine))
    let content = getline(lineNumber)
    let structName = matchstr(content, '^\(type\s*\)\zs\k\+\ze\s\+struct')

    if !empty(structName)
      return structName
    endif
  endfor

  return ""
endfunction

function! alpaca#go#prevStructVariableName()
  let prevStruct = alpaca#go#prevStruct()

  if empty(prevStruct)
    return ""
  endif

  let currentLine = line(".")

  for lineNumber in reverse(range(0, currentLine))
    let content = getline(lineNumber)
    let structVariableName = matchstr(content, '^func\s*(\zs\k\+\ze\s*\(\*\)\?'.prevStruct.')\s*\k\+(')

    if !empty(structVariableName)
      return structVariableName
    endif
  endfor

  return ""
endfunction
