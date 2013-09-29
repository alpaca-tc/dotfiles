let s:source = {
      \ 'name' : 'geeknote/notebooks',
      \ 'hooks' : {}
      \ }

function! s:source.gather_candidates(args, content) "{{{
  let notebook_list = geeknote#system('notebook-list')
  ruby << CODE
  notebook_list = VIM.get('notebook_list').split('\n')
  notebooks = notebook_list.each_with_object({}) do |line, memo|
    memo[number] = notebook_name if /^\s*(?<number>\d+) : (?<notebook_name>.*)\s*$/ =~ str
  end

  candidates = []
  memo.each do |number, notebook_name|
    candidate = { word: notebook_name, abbr: "#{number} #{notebook_name}"}
    candidates << candidate
  end

  VIM.let('candidates', candidates)
CODE

  return candidates
endfunction"}}}

function! s:source.hooks.on_init(args, context) "{{{
  call geeknote#initialize()
  call alpaca#initialize#ruby_initialize()
endfunction"}}}

function! unite#sources#geeknote#notebooks#define() "{{{
  return s:source
endfunction"}}}
