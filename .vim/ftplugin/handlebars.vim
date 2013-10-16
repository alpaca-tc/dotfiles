if exists('b:did_ftplugin')
  finish
endif

setl indentexpr=HtmlIndent() omnifunc=htmlcomplete#CompleteTags
runtime! ftplugin/handlebars.vim ftplugin/handlebars*.vim ftplugin/handlebars/*.vim
