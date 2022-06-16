function! alpaca#initialize#directory(directories) "{{{
  for dir_path in a:directories
    if !isdirectory(dir_path)
      call mkdir(dir_path, 'p')
      echomsg 'create directory : ' . dir_path
    endif
  endfor
endfunction"}}}

function! alpaca#initialize#redefine_dict_to_each_filetype(difinitions, type) "{{{
  let result = {}

  for [filetypes, value] in items(a:difinitions)
    for ft in split(filetypes, ',')
      let result[ft] = get(result, ft, copy(a:type))
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
