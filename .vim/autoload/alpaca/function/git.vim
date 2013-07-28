function! alpaca#function#git#send_pullrequest(...) "{{{
  let repo_names = s:current_remote_names()

  if empty(repo_names)
    let from_account = 
  elseif len(repo_names) == 1
    let from_account = items(repo_names)[0][0]
  else
  endif
  let repo_origin = 
  let from_account = 
  let repo_name = empty(a:000) ? g:my.info.github : a:1
  let branch_name = s:branch_name()

  if input('Pull-request '.repo_name.':'.branch_name.'? y/n ') == 'y'
    ruby << EOF
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
      cmd = %Q!hub pull-request -b master -h #{repos}:#{branch_name} '#{commit_message}'!
      system(cmd)
      cmd
    end

    if branch_name && branch_name.match(/(master|remotes\/origin)/).nil?
      pull_request_id = `#{pull_request}`.split('/')[-1].chomp
      system "hub browse -- pull/#{pull_request_id}"
    else
      VIM::message("You can't send pull-request to master.")
    end
EOF
  endif
endfunction"}}}

function! s:branch_name() "{{{
  return fugitive#head()
endfunction "}}}

function! s:current_remote_names() "{{{
  if !exists('s:current_remote') |let s:current_remote = {}| endif

  let current_dir = s:current_git()
  
  if has_key(s:current_remote, current_dir)
    return s:current_remote[current_dir]
  endif

  let git_remotes = system('git remote -v')
  if git_remotes =~ "fatal: Not a git repository"
    " throw "No a git repository."
    return ""
  endif

  let remotes = split(git_remotes, '\n')
  if empty(remotes)
    return ''
  endif

  let remote_list = []
  for remote in remotes
    let remote_name = matchstr(remote, '^[^\t]\+')
    let repo = substitute(remote, '\v[^\t]+\t.*[:\/]([^\/:@]+/[^\/]+)\.git\s\((fetch|push)\)$', '\1', 'g')
    let [account_name, repo_name] = split(repo, '/')
    call add(limote_list, { 'account': account_name, 'repo_name': repo_name })
  endfor

  return remote_list
endfunction"}}}

function! s:current_git() "{{{
  let current_dir = getcwd()
  if !exists("s:git_root_cache") | let s:git_root_cache = {} | endif
  if has_key(s:git_root_cache, current_dir)
    return s:git_root_cache[current_dir]
  endif

  let git_root = system('git rev-parse --show-toplevel')
  if git_root =~ "fatal: Not a git repository"
    " throw "No a git repository."
    return ""
  endif

  let s:git_root_cache[current_dir] = substitute(git_root, '\n', '', 'g')

  return s:git_root_cache[current_dir]
endfunction"}}}

function! alpaca#function#git#complete(arglead, cmdline, cursorpos) "{{{
  let arglead = a:arglead
  if empty(arglead)
    return s:options_cache
  endif

  return filter(copy(s:options_cache), 'v:val =~ "^' . arglead . '"')
endfunction"}}}
