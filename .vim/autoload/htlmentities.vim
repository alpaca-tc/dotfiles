function! htlmentities#encode(str) "{{{
  call s:initialize()

  ruby << EOS
  str = VIM.evaluate('a:str')
  res = HTMLEntities.new.encode str
  VIM.command("let result =  '#{str}'")
EOS

  return result
endfunction"}}}

function! htlmentities#decode(decode) "{{{
  call s:initialize()

  ruby << EOS
  # str = VIM.evaluate('a:str')
  str = '%E5%A4%A7%E5%A5%BD%E3%81%8D%E3%81%AA%E3%82%93%E3%81%A0%E3%83%BC'
  res = HTMLEntities.new.encode str
  VIM.command("let result =  '#{str}'")
EOS

  return result
endfunction"}}}

function! s:initialize() "{{{
  if exists('s:loaded_html_intities') || !has('ruby')
    return
  endif
  let s:loaded_html_intities = 1

  ruby << EOS
  require 'htmlentities'
EOS
endfunction"}}}
