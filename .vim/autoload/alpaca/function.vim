function! alpaca#function#today()"{{{
  return strftime("%Y-%m-%d")
endfunction"}}}
function! alpaca#function#convert_haml_to_html(fileType) "{{{
  " 同じディレクトリに、pathというファイルを作り
  " `cat path` -> `../`
  " となっていれば、その相対パスディレクトリに保存する

  " 設定ファイルを読み込む
  let dir_name = expand("%:p:h")
  let save_path = ''
  if filereadable(dir_name . '/path')
    let save_path = readfile("path")[0]
  endif

  " 2html
  let current_file = expand("%")
  let target_file  = substitute(current_file, '.html', '', 'g')
  let target_file  = dir_name.'/'.save_path.substitute(target_file, '.'.expand("%:e").'$', '.html', 'g')

  " コマンドの分岐
  if a:fileType == 'eruby'
    " exec ":call vimproc#system('rm " .target_file"')"
    let convert_cmd  = 'erb ' . current_file . ' > ' . target_file
  elseif a:fileType == 'haml'
    " let convert_cmd  = 'haml_with_ruby2html ' . current_file . ' > ' . target_file
    let convert_cmd  = 'haml --format html4 ' . current_file . ' > ' . target_file
  endif

  echo "convert " . a:fileType . ' to ' . target_file
  exec ":call vimproc#system('" . convert_cmd . "')"
endfunction"}}}
