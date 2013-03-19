" Vim color file - dim
" Generated by http://bytefluent.com/vivify 2013-03-17
set background=dark
if version > 580
	hi clear
	if exists("syntax_on")
		syntax reset
	endif
endif

set t_Co=256
let g:colors_name = "dim"

hi IncSearch guifg=#ffff00 guibg=#8db6cd guisp=#8db6cd gui=bold ctermfg=11 ctermbg=110 cterm=bold
"hi WildMenu -- no settings --
"hi SignColumn -- no settings --
hi SpecialComment guifg=#cdc673 guibg=NONE guisp=NONE gui=NONE ctermfg=186 ctermbg=NONE cterm=NONE
hi Typedef guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
"hi Title -- no settings --
hi Folded guifg=#000000 guibg=#8c8c8c guisp=#8c8c8c gui=NONE ctermfg=NONE ctermbg=245 cterm=NONE
hi PreCondit guifg=#cd96cd guibg=NONE guisp=NONE gui=NONE ctermfg=182 ctermbg=NONE cterm=NONE
hi Include guifg=#cd96cd guibg=NONE guisp=NONE gui=NONE ctermfg=182 ctermbg=NONE cterm=NONE
"hi TabLineSel -- no settings --
"hi StatusLineNC -- no settings --
"hi CTagsMember -- no settings --
hi NonText guifg=#8b8b00 guibg=#1a1a1a guisp=#1a1a1a gui=NONE ctermfg=100 ctermbg=234 cterm=NONE
"hi CTagsGlobalConstant -- no settings --
"hi DiffText -- no settings --
"hi ErrorMsg -- no settings --
"hi Ignore -- no settings --
hi Debug guifg=#cdc673 guibg=NONE guisp=NONE gui=NONE ctermfg=186 ctermbg=NONE cterm=NONE
hi PMenuSbar guifg=NONE guibg=#848688 guisp=#848688 gui=NONE ctermfg=NONE ctermbg=102 cterm=NONE
hi Identifier guifg=#559955 guibg=NONE guisp=NONE gui=NONE ctermfg=71 ctermbg=NONE cterm=NONE
hi SpecialChar guifg=#cdc673 guibg=NONE guisp=NONE gui=NONE ctermfg=186 ctermbg=NONE cterm=NONE
hi Conditional guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
hi StorageClass guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
hi Todo guifg=NONE guibg=#cdcd00 guisp=#cdcd00 gui=NONE ctermfg=NONE ctermbg=184 cterm=NONE
hi Special guifg=#cdc673 guibg=NONE guisp=NONE gui=NONE ctermfg=186 ctermbg=NONE cterm=NONE
"hi LineNr -- no settings --
"hi StatusLine -- no settings --
hi Normal guifg=#bfbfbf guibg=#000000 guisp=#000000 gui=NONE ctermfg=7 ctermbg=NONE cterm=NONE
hi Label guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
"hi CTagsImport -- no settings --
hi PMenuSel guifg=#88dd88 guibg=#949698 guisp=#949698 gui=NONE ctermfg=114 ctermbg=246 cterm=NONE
hi Search guifg=#000000 guibg=#607b8b guisp=#607b8b gui=NONE ctermfg=NONE ctermbg=66 cterm=NONE
"hi CTagsGlobalVariable -- no settings --
hi Delimiter guifg=#cdc673 guibg=NONE guisp=NONE gui=NONE ctermfg=186 ctermbg=NONE cterm=NONE
hi Statement guifg=#9B8E76 guibg=NONE guisp=NONE gui=bold ctermfg=144 ctermbg=NONE cterm=bold
"hi SpellRare -- no settings --
"hi EnumerationValue -- no settings --
hi Comment guifg=#6ca6cd guibg=NONE guisp=NONE gui=NONE ctermfg=74 ctermbg=NONE cterm=NONE
hi Character guifg=#7ac5cd guibg=NONE guisp=NONE gui=NONE ctermfg=116 ctermbg=NONE cterm=NONE
"hi Float -- no settings --
hi Number guifg=#cd6889 guibg=NONE guisp=NONE gui=NONE ctermfg=168 ctermbg=NONE cterm=NONE
hi Boolean guifg=#9B8E76 guibg=NONE guisp=NONE gui=bold ctermfg=144 ctermbg=NONE cterm=bold
hi Operator guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
"hi CursorLine -- no settings --
"hi Union -- no settings --
"hi TabLineFill -- no settings --
hi Question guifg=#00cd00 guibg=NONE guisp=NONE gui=NONE ctermfg=40 ctermbg=NONE cterm=NONE
hi WarningMsg guifg=#ff0000 guibg=#f8f8ff guisp=#f8f8ff gui=bold ctermfg=196 ctermbg=189 cterm=bold
"hi VisualNOS -- no settings --
"hi DiffDelete -- no settings --
"hi ModeMsg -- no settings --
"hi CursorColumn -- no settings --
hi Define guifg=#cd96cd guibg=NONE guisp=NONE gui=NONE ctermfg=182 ctermbg=NONE cterm=NONE
hi Function guifg=#559955 guibg=NONE guisp=NONE gui=NONE ctermfg=71 ctermbg=NONE cterm=NONE
"hi FoldColumn -- no settings --
hi PreProc guifg=#cd96cd guibg=NONE guisp=NONE gui=NONE ctermfg=182 ctermbg=NONE cterm=NONE
"hi EnumerationName -- no settings --
hi Visual guifg=#556b2f guibg=#bfbfbf guisp=#bfbfbf gui=NONE ctermfg=101 ctermbg=7 cterm=NONE
"hi MoreMsg -- no settings --
"hi SpellCap -- no settings --
"hi VertSplit -- no settings --
hi Exception guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
hi Keyword guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
hi Type guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
"hi DiffChange -- no settings --
hi Cursor guifg=NONE guibg=#bfbfbf guisp=#bfbfbf gui=NONE ctermfg=NONE ctermbg=7 cterm=NONE
"hi SpellLocal -- no settings --
hi Error guifg=NONE guibg=#cd0000 guisp=#cd0000 gui=NONE ctermfg=NONE ctermbg=160 cterm=NONE
hi PMenu guifg=#dddddd guibg=#545658 guisp=#545658 gui=NONE ctermfg=253 ctermbg=240 cterm=NONE
hi SpecialKey guifg=#7ac5cd guibg=NONE guisp=NONE gui=NONE ctermfg=116 ctermbg=NONE cterm=NONE
hi Constant guifg=#cd6889 guibg=NONE guisp=NONE gui=NONE ctermfg=168 ctermbg=NONE cterm=NONE
"hi DefinedName -- no settings --
hi Tag guifg=#cdc673 guibg=NONE guisp=NONE gui=NONE ctermfg=186 ctermbg=NONE cterm=NONE
hi String guifg=#cd6889 guibg=NONE guisp=NONE gui=NONE ctermfg=168 ctermbg=NONE cterm=NONE
hi PMenuThumb guifg=NONE guibg=#a4a6a8 guisp=#a4a6a8 gui=NONE ctermfg=NONE ctermbg=248 cterm=NONE
"hi MatchParen -- no settings --
"hi LocalVariable -- no settings --
hi Repeat guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
"hi SpellBad -- no settings --
"hi CTagsClass -- no settings --
hi Directory guifg=#6ca6cd guibg=NONE guisp=NONE gui=NONE ctermfg=74 ctermbg=NONE cterm=NONE
hi Structure guifg=#BD7550 guibg=NONE guisp=NONE gui=NONE ctermfg=173 ctermbg=NONE cterm=NONE
hi Macro guifg=#cd96cd guibg=NONE guisp=NONE gui=NONE ctermfg=182 ctermbg=NONE cterm=NONE
"hi Underlined -- no settings --
"hi DiffAdd -- no settings --
"hi TabLine -- no settings --
hi mbenormal guifg=#cfbfad guibg=#2e2e3f guisp=#2e2e3f gui=NONE ctermfg=187 ctermbg=237 cterm=NONE
hi perlspecialstring guifg=#c080d0 guibg=#404040 guisp=#404040 gui=NONE ctermfg=176 ctermbg=238 cterm=NONE
hi doxygenspecial guifg=#fdd090 guibg=NONE guisp=NONE gui=NONE ctermfg=222 ctermbg=NONE cterm=NONE
hi mbechanged guifg=#eeeeee guibg=#2e2e3f guisp=#2e2e3f gui=NONE ctermfg=255 ctermbg=237 cterm=NONE
hi mbevisiblechanged guifg=#eeeeee guibg=#4e4e8f guisp=#4e4e8f gui=NONE ctermfg=255 ctermbg=60 cterm=NONE
hi doxygenparam guifg=#fdd090 guibg=NONE guisp=NONE gui=NONE ctermfg=222 ctermbg=NONE cterm=NONE
hi doxygensmallspecial guifg=#fdd090 guibg=NONE guisp=NONE gui=NONE ctermfg=222 ctermbg=NONE cterm=NONE
hi doxygenprev guifg=#fdd090 guibg=NONE guisp=NONE gui=NONE ctermfg=222 ctermbg=NONE cterm=NONE
hi perlspecialmatch guifg=#c080d0 guibg=#404040 guisp=#404040 gui=NONE ctermfg=176 ctermbg=238 cterm=NONE
hi cformat guifg=#c080d0 guibg=#404040 guisp=#404040 gui=NONE ctermfg=176 ctermbg=238 cterm=NONE
hi lcursor guifg=#404040 guibg=#8fff8b guisp=#8fff8b gui=NONE ctermfg=238 ctermbg=120 cterm=NONE
hi cursorim guifg=#404040 guibg=#8b8bff guisp=#8b8bff gui=NONE ctermfg=238 ctermbg=105 cterm=NONE
hi doxygenspecialmultilinedesc guifg=#ad600b guibg=NONE guisp=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
hi taglisttagname guifg=#808bed guibg=NONE guisp=NONE gui=NONE ctermfg=105 ctermbg=NONE cterm=NONE
hi doxygenbrief guifg=#fdab60 guibg=NONE guisp=NONE gui=NONE ctermfg=215 ctermbg=NONE cterm=NONE
hi mbevisiblenormal guifg=#cfcfcd guibg=#4e4e8f guisp=#4e4e8f gui=NONE ctermfg=252 ctermbg=60 cterm=NONE
hi user2 guifg=#7070a0 guibg=#3e3e5e guisp=#3e3e5e gui=NONE ctermfg=103 ctermbg=60 cterm=NONE
hi user1 guifg=#00ff8b guibg=#3e3e5e guisp=#3e3e5e gui=NONE ctermfg=48 ctermbg=60 cterm=NONE
hi doxygenspecialonelinedesc guifg=#ad600b guibg=NONE guisp=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
hi doxygencomment guifg=#ad7b20 guibg=NONE guisp=NONE gui=NONE ctermfg=130 ctermbg=NONE cterm=NONE
hi cspecialcharacter guifg=#c080d0 guibg=#404040 guisp=#404040 gui=NONE ctermfg=176 ctermbg=238 cterm=NONE
"hi clear -- no settings --
hi underline guifg=#d0a6a6 guibg=NONE guisp=NONE gui=NONE ctermfg=181 ctermbg=NONE cterm=NONE
hi pythonimport guifg=#1515d0 guibg=NONE guisp=NONE gui=NONE ctermfg=20 ctermbg=NONE cterm=NONE
hi pythonexception guifg=#15d015 guibg=NONE guisp=NONE gui=NONE ctermfg=40 ctermbg=NONE cterm=NONE
hi pythonbuiltinfunction guifg=#1515d0 guibg=NONE guisp=NONE gui=NONE ctermfg=20 ctermbg=NONE cterm=NONE
hi pythonoperator guifg=#d0b8be guibg=NONE guisp=NONE gui=NONE ctermfg=181 ctermbg=NONE cterm=NONE
hi pythonexclass guifg=#1515d0 guibg=NONE guisp=NONE gui=NONE ctermfg=20 ctermbg=NONE cterm=NONE
hi gutter guifg=#a111a1 guibg=#be13be guisp=#be13be gui=NONE ctermfg=127 ctermbg=5 cterm=NONE
hi pythonbuiltin guifg=#d0ccd0 guibg=NONE guisp=NONE gui=NONE ctermfg=252 ctermbg=NONE cterm=NONE
hi phpstringdouble guifg=#b30cd0 guibg=NONE guisp=NONE gui=NONE ctermfg=128 ctermbg=NONE cterm=NONE
hi htmltagname guifg=#d015d0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=164 ctermbg=53 cterm=NONE
hi javascriptstrings guifg=#b30cd0 guibg=NONE guisp=NONE gui=NONE ctermfg=128 ctermbg=NONE cterm=NONE
hi htmlstring guifg=#b30cd0 guibg=NONE guisp=NONE gui=NONE ctermfg=128 ctermbg=NONE cterm=NONE
hi phpstringsingle guifg=#b30cd0 guibg=NONE guisp=NONE gui=NONE ctermfg=128 ctermbg=NONE cterm=NONE
hi condtional guifg=#d087d0 guibg=NONE guisp=NONE gui=NONE ctermfg=176 ctermbg=NONE cterm=NONE
hi htmlitalic guifg=NONE guibg=NONE guisp=NONE gui=italic ctermfg=NONE ctermbg=NONE cterm=NONE
hi htmlboldunderlineitalic guifg=NONE guibg=NONE guisp=NONE gui=bold,italic,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
hi htmlbolditalic guifg=NONE guibg=NONE guisp=NONE gui=bold,italic ctermfg=NONE ctermbg=NONE cterm=bold
hi htmlunderlineitalic guifg=NONE guibg=NONE guisp=NONE gui=italic,underline ctermfg=NONE ctermbg=NONE cterm=underline
hi htmlbold guifg=NONE guibg=NONE guisp=NONE gui=bold ctermfg=NONE ctermbg=NONE cterm=bold
hi htmlboldunderline guifg=NONE guibg=NONE guisp=NONE gui=bold,underline ctermfg=NONE ctermbg=NONE cterm=bold,underline
hi htmlunderline guifg=NONE guibg=NONE guisp=NONE gui=underline ctermfg=NONE ctermbg=NONE cterm=underline
hi perlsharpbang guifg=#afcdd0 guibg=#500850 guisp=#500850 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perlfunctionname guifg=#d015d0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=164 ctermbg=53 cterm=NONE
hi perlstatementinclude guifg=#afcdd0 guibg=#023640 guisp=#023640 gui=NONE ctermfg=152 ctermbg=23 cterm=NONE
hi perlcontrol guifg=#afcdd0 guibg=#400940 guisp=#400940 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perlstatement guifg=#afcdd0 guibg=NONE guisp=NONE gui=NONE ctermfg=152 ctermbg=NONE cterm=NONE
hi perllabel guifg=#afcdd0 guibg=#400940 guisp=#400940 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perlmatchstartend guifg=#afcdd0 guibg=#420342 guisp=#420342 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perlrepeat guifg=#afd0cb guibg=#340734 guisp=#340734 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perlshellcommand guifg=NONE guibg=#420342 guisp=#420342 gui=NONE ctermfg=NONE ctermbg=53 cterm=NONE
hi perlstatementfiledesc guifg=#afbbd0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=146 ctermbg=53 cterm=NONE
hi perlstatementsub guifg=#afcdd0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perloperator guifg=#afcdd0 guibg=#400940 guisp=#400940 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi mytaglistfilename guifg=#d015d0 guibg=#400940 guisp=#400940 gui=underline ctermfg=164 ctermbg=53 cterm=underline
hi perlvarsimplemembername guifg=#d015d0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=164 ctermbg=53 cterm=NONE
hi perlnumber guifg=#a6add0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=146 ctermbg=53 cterm=NONE
hi perlvarnotinmatches guifg=#8ed08e guibg=#340734 guisp=#340734 gui=NONE ctermfg=114 ctermbg=53 cterm=NONE
hi perlqq guifg=#d015d0 guibg=#390339 guisp=#390339 gui=NONE ctermfg=164 ctermbg=53 cterm=NONE
hi perlstatementcontrol guifg=#7cd0d0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=116 ctermbg=53 cterm=NONE
hi perlstatementhash guifg=#afcdd0 guibg=#400940 guisp=#400940 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perlvarsimplemember guifg=#afcdd0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perlidentifier guifg=#d0afcd guibg=NONE guisp=NONE gui=NONE ctermfg=182 ctermbg=NONE cterm=NONE
hi perlstringstartend guifg=#72d096 guibg=#350835 guisp=#350835 gui=NONE ctermfg=115 ctermbg=53 cterm=NONE
hi perlspecialbeom guifg=#d015d0 guibg=#400940 guisp=#400940 gui=NONE ctermfg=164 ctermbg=53 cterm=NONE
hi perlvarplain guifg=#d090d0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=176 ctermbg=53 cterm=NONE
hi perlstatementnew guifg=#afcdd0 guibg=#420342 guisp=#420342 gui=NONE ctermfg=152 ctermbg=53 cterm=NONE
hi perlpackagedecl guifg=#a6add0 guibg=#400940 guisp=#400940 gui=NONE ctermfg=146 ctermbg=53 cterm=NONE
hi perlvarplain2 guifg=#b190d0 guibg=#340734 guisp=#340734 gui=NONE ctermfg=140 ctermbg=53 cterm=NONE