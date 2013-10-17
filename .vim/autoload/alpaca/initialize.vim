function! s:get_autcmd_with_filetype(filetype, cmd) "{{{
  return join(['autocmd AbbrDefine FileType', a:filetype, a:cmd], ' ')
endfunction"}}}

function! alpaca#initialize#directory(array) "{{{
  for dir_path in a:array
    if !isdirectory(dir_path)
      call mkdir(dir_path, 'p')
      echomsg 'create directory : ' . dir_path
    endif
  endfor
endfunction"}}}

function! alpaca#initialize#define_abbreviations(definition, filetype) "{{{
  let definition = a:definition
  if empty(definition)
    return
  endif

  call map(definition, '"inoreabbrev <buffer> " . v:val')
  let command = join(definition, '|')
  execute 'autocmd Abbreviations FileType' a:filetype command
endfunction"}}}

function! alpaca#initialize#redefine_dict_to_each_filetypes(difinitions, type) "{{{
  let result = {}

  for [filetypes, value] in items(a:difinitions)
    for ft in split(filetypes, ',')
      let result[ft] = get(result, ft, a:type)
      call extend(result[ft], copy(value))
    endfor
  endfor

  return result
endfunction"}}}

function! alpaca#initialize#ruby_initialize() "{{{
  ruby << CODE
  module VIM
    class << self
      def encode
        evaluate('&encoding')
      end

      def let(name, value)
        parsed = value.to_json.to_s.force_encoding(encode)
        command("let #{name} = #{parsed}")
      end

      def get(name)
        value = evaluate(name)
        if value.is_a? String
          value.force_encoding(encode)
        else
          value
        end
      end
    end
  end
CODE
endfunction"}}}
