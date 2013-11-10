if has('gui_running') && !has('gui_win32')
  setlocal keywordprg=ri\ -T
else
  setlocal keywordprg=ri
endif

" Matchit support
if exists('loaded_matchit') && !exists('b:match_words')
  let b:match_ignorecase = 0

  let b:match_words =
        \ '\<\%(if\|unless\|case\|while\|until\|for\|do\|task\|class\|module\|def\|begin\)\>=\@!' .
        \ ':' .
        \ '\<\%(else\|elsif\|ensure\|when\|rescue\|break\|redo\|next\|retry\)\>' .
        \ ':' .
        \ '\<end\>' .
        \ ',{:},\[:\],(:)'

  let b:match_skip =
        \ "synIDattr(synID(line('.'),col('.'),0),'name') =~ '" .
        \ "\\<ruby\\%(String\\|StringDelimiter\\|ASCIICode\\|Escape\\|" .
        \ "Interpolation\\|NoInterpolation\\|Comment\\|Documentation\\|" .
        \ "ConditionalModifier\\|RepeatModifier\\|OptionalDo\\|" .
        \ "Function\\|BlockArgument\\|KeywordAsMethod\\|ClassVariable\\|" .
        \ "InstanceVariable\\|GlobalVariable\\|Symbol\\)\\>'"
endif

" To activate, :set ballooneval
if has('balloon_eval') && exists('+balloonexpr')
  setlocal balloonexpr=RubyBalloonexpr()
endif
setlocal comments=:#
setlocal commentstring=#\ %s

setlocal formatoptions-=t formatoptions+=croql
setlocal include=^\\s*\\<\\(load\\\|\w*require\\)\\>
setlocal includeexpr=substitute(substitute(v:fname,'::','/','g'),'$','.rb','')

if !exists('b:loaded_rubysnip') && exists(':NeoSnippetSource') && filereadable('~/.vim/snippet/ruby.snip')
  let b:loaded_rubysnip = 1
  NeoBundleSource ~/.vim/snippet/ruby.snip
endif
