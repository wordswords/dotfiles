" monokai256.vim
"
" Maintainer: Shanon Moeller <me@shannonmoeller.com>
" Last Change: 2012-04-04
"
" Note: Based on the molokai theme for gVim by Tomas Restrepo
"       and the monokai theme for TextMate by Wimer Hazenberg
"       and its darker variant by Hamish Stuart Macpherson
"
" vim:set ts=4 sw=4 noet:

set background=dark
highlight clear

if exists("syntax_on")
    syntax reset
endif

let g:colors_name="monokai256"

hi Boolean          ctermfg=135
hi Character        ctermfg=144
hi ColorColumn                   ctermbg=232
hi Comment          ctermfg=59
hi Conditional      ctermfg=161               cterm=bold
hi Constant         ctermfg=135               cterm=bold
hi Cursor           ctermfg=16   ctermbg=253
hi CursorColumn                  ctermbg=232
hi CursorLine                    ctermbg=232  cterm=none
hi Debug            ctermfg=225               cterm=bold
hi Define           ctermfg=81
hi Delimiter        ctermfg=241
hi DiffAdd                       ctermbg=24
hi DiffChange       ctermfg=181  ctermbg=239
hi DiffDelete       ctermfg=162  ctermbg=53
hi DiffText                      ctermbg=102  cterm=bold
hi Directory        ctermfg=81
hi Error                         ctermbg=52
hi ErrorMsg         ctermfg=199  ctermbg=16   cterm=bold
hi Exception        ctermfg=118               cterm=bold
hi Float            ctermfg=135
hi FoldColumn       ctermfg=67   ctermbg=16
hi Folded           ctermfg=67   ctermbg=16
hi Function         ctermfg=118
hi Identifier       ctermfg=208               cterm=none
hi Ignore           ctermfg=244  ctermbg=232
hi IncSearch        ctermfg=193  ctermbg=16
hi IndentGuidesEven              ctermbg=235
hi IndentGuidesOdd               ctermbg=234
hi Keyword          ctermfg=161               cterm=bold
hi Label            ctermfg=229               cterm=none
hi LineNr           ctermfg=243  ctermbg=none
hi Macro            ctermfg=193
hi MatchParen       ctermfg=16   ctermbg=208  cterm=bold
hi ModeMsg          ctermfg=229
hi MoreMsg          ctermfg=229
hi NonText          ctermfg=59
hi Normal           ctermfg=252  ctermbg=none
hi Number           ctermfg=135
hi Operator         ctermfg=161
hi Pmenu            ctermfg=59   ctermbg=232
hi PmenuSbar                     ctermbg=232
hi PmenuSel                      ctermbg=161
hi PmenuThumb       ctermfg=81
hi PreCondit        ctermfg=118               cterm=bold
hi PreProc          ctermfg=118
hi Question         ctermfg=81
hi Repeat           ctermfg=161               cterm=bold
hi Search           ctermfg=253  ctermbg=66
hi SignColumn       ctermfg=118  ctermbg=235
hi Special          ctermfg=81   ctermbg=232
hi SpecialChar      ctermfg=161               cterm=bold
hi SpecialComment   ctermfg=245               cterm=bold
hi SpecialKey       ctermfg=59
hi SpecialKey       ctermfg=81
hi SpellBad                      ctermbg=52
hi Statement        ctermfg=161               cterm=bold
hi StatusLine       ctermfg=252  ctermbg=238  cterm=none
hi StatusLineNC     ctermfg=59   ctermbg=238  cterm=none
hi StorageClass     ctermfg=208
hi String           ctermfg=144
hi Structure        ctermfg=81
hi Tag              ctermfg=118
hi Title            ctermfg=118
hi TrailingSpace                 ctermbg=199
hi Todo             ctermfg=231  ctermbg=232  cterm=bold
hi Type             ctermfg=81                cterm=none
hi Typedef          ctermfg=81
hi Underlined       ctermfg=244               cterm=underline
hi VertSplit        ctermfg=238  ctermbg=238  cterm=bold
hi Visual                        ctermbg=235
hi VisualNOS                     ctermbg=238
hi WarningMsg       ctermfg=231  ctermbg=238  cterm=bold
hi WildMenu         ctermfg=252    ctermbg=161

hi def link jsFlowDefinition         Comment
hi def link jsFlowClassDef           Type
hi def link jsFlowArgumentDef        Type
hi def link jsFlowType               Constant
hi def link jsFlowTypeCustom         Type
hi def link jsFlowTypeof             Type
hi def link jsFlowArray              Label
hi def link jsFlowObject             Normal
hi def link jsFlowExactObject        Normal
hi def link jsFlowParens             Operator
hi def link jsFlowGroup              Type
hi def link jsFlowReturn             Type
hi def link jsFlowParenAnnotation    Comment
hi def link jsFlowReturnObject       Type
hi def link jsFlowReturnArray        Type
hi def link jsFlowReturnParens       Operator
hi def link jsFlowReturnGroup        Type
hi def link jsFlowFunctionGroup      Type
hi def link jsFlowClassGroup         Type
hi def link jsFlowClassFunctionGroup Type
hi def link jsFlowArrowArguments     Type
hi def link jsFlowArrow              Operator
hi def link jsFlowReturnArrow        Operator
hi def link jsFlowTypeStatement      StorageClass
hi def link jsFlowTypeKeyword        StorageClass
hi def link jsFlowTypeOperator       StorageClass
hi def link jsFlowMaybe              Operator
hi def link jsFlowReturnMaybe        Operator
hi def link jsFlowClassProperty      Normal
hi def link jsFlowDeclare            Include
hi def link jsFlowModule             Include
hi def link jsFlowInterface          Include
hi def link jsFlowNoise              Normal
hi def link jsFlowObjectKey          Normal
hi def link jsFlowOrOperator         Operator
hi def link jsFlowReturnOrOp         Operator
hi def link jsFlowWildcard           Operator
hi def link jsFlowWildcardReturn     Operator
hi def link jsFlowImportType         StorageClass
hi def link jsFlowTypeValue          Type

hi def link xmlTag    Tag
hi def link xmlEndTag Tag
