function! alpaca#function#today() "{{{
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
function! alpaca#function#endtag_comment() "{{{
  let reg_save = @@

  try
    silent normal vaty
  catch
    execute "normal \<Esc>"
    echohl ErrorMsg
    echo 'no match html tags'
    echohl None
    return
  endtry

  let html = @@

  let start_tag = matchstr(html, '\v(\<.{-}\>)')
  let tag_name  = matchstr(start_tag, '\v([a-zA-Z]+)')

  let id = ''
  let id_match = matchlist(start_tag, '\vid\=["'']([^"'']+)["'']')
  if exists('id_match[1]')
    let id = '#' . id_match[1]
  endif

  let class = ''
  let class_match = matchlist(start_tag, '\vclass\=["'']([^"'']+)["'']')
  if exists('class_match[1]')
    let class = '.' . join(split(class_match[1], '\v\s+'), '.')
  endif

  execute "normal `>va<\<Esc>`<"

  if !exists('g:end_tag_commant_format')
    let g:end_tag_commant_format = '<!-- /%tag_name%id%class -->'
  endif
  let comment = g:end_tag_commant_format
  let comment = substitute(comment, '%tag_name', tag_name, 'g')
  let comment = substitute(comment, '%id', id, 'g')
  let comment = substitute(comment, '%class', class, 'g')
  let @@ = comment

  normal $""p

  let @@ = reg_save
endfunction"}}}
function! s:branch_name() "{{{
  return system("git branch | grep '^\*' | cut -b 3-`.chomp")
endfunction "}}}
function! alpaca#function#send_pullrequest(...)
  let repo_name = empty(a:000) ? g:my.info.github : a:1

  if input('May I send pull-request to Github? y/n ') == 'y'
    let branch_name = s:branch_name()

    ruby << EOF
  # 現在のブランチ名を取得
  def branch_name
    VIM.evaluate('branch_name')
  end

  def repos
    VIM.evaluate('repo_name')
  end

  def commit_message
    branch_name.capitalize.gsub('_', ' ')
  end

  def pull_request
    "hub pull-request -m master -h #{repos}:#{branch_name} '#{commit_message}'"
  end

  if branch_name && branch_name.match(/(master|remotes\/origin)/).nil?
    p branch_name.count
    pull_request_id = `#{pull_request}`.split('/')[-1].chomp
    system "hub browse -- pull/#{pull_request_id}"
  else
    VIM::message("You can't send pull-request to master.")
  end
EOF
  endif
endfunction
