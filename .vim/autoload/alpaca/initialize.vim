function! alpaca#initialize#directory()
  " initialize directory
  " create directory
  if exists('g:my.dir')
    let keys =  keys( g:my.dir )
    for key in keys
      let directory = g:my.dir[key]

      if !isdirectory(directory)
        call mkdir(directory, 'p')
        echomsg "create directory : " . directory
      endif
    endfor
  endif
endfunction
