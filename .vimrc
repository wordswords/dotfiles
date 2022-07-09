" /- - - - - - - - - - - - - - - - - - - - - -\
" |     David Craddock's VIM Config           |
" |                                           |
" |  https://github.com/wordswords/dotfiles   |
" \- - - - - - - - - - - - - - - - - - - - - -/
"
" vim: spell indent
"
syntax enable

set autoindent                     " Automatically indent code
set background=dark                " Dark background, light foreground
set backspace=2                    " Backspace back up a line
set backupdir=~/.backup/vim        " Directory to drop backup files
set bk                             " Drop backup files
set colorcolumn=+1                 " Enable coloured column after textwidth line
set cursorline                     " Highlight current line
set dir=~/.backup/vim/swap         " Directory to drop swap files
set encoding=utf8                  " Enforce UTF8 encoding
set expandtab                      " Always expand tabs
set expandtab                      " Convert all tabs to spaces
set history=1000                   " 1000 previous commands remembered
set hlsearch                       " Highlight searches
set ignorecase                     " Ignore case when searching
set incsearch                      " Do incremental searching
set laststatus=2                   " Show non-printable characters e.g. tab, \n
set list                           " Use the following list characters:
set listchars=tab:»\ ,extends:›,precedes:‹,nbsp:·,trail:·
set ls=2                           " Always show status line
set noerrorbells                   " Turn off all bells
set number                         " Show line numbers
set relativenumber                 " Set numbering from current line
set ruler                          " Show the cursor position all the time
set scrolloff=3                    " Keep 3 lines when scrolling
set shiftwidth=4                   " With indentation shifts, use 4 space tabs 
set showcmd                        " Display incomplete commands
set softtabstop=4                  " With tab key, use 4 space tabs
set spelllang=en_gb                " Set dictionary to be UK spelling
set splitbelow                     " Opens new windows below, not above
set splitright                     " Open new vertical split windows to the right
set t_Co=256                       " Force 256 colour mode
set t_vb=                          " Visual bell off
set textwidth=80                   " Force line wrapping after the 80th char
set ts=4                           " Each tab is four spaces
set ttyfast                        " Smoother changes
set undodir=~/.backup/vim/undos    " Directory to drop undo files
set undofile                       " Drop undo files
set wildmenu                       " Allow for menu based file navigation
set wildmode=list:longest,full

" GUI config
autocmd GUIEnter * set visualbell t_vb= " Turn off visual and audio bell for GUI 
let g:prettier#autoformat = 1 " Prettier code formatter automatically files
let g:rehash256 = 1 " Ensure 256 colour mode

" Default colourscheme
colorscheme monokai256
hi SpecialKey ctermfg=grey guifg=grey70
hi NonText ctermfg=grey guifg=grey70

" Disable modelines, use securemodelines.vim instead
set nomodeline
let g:secure_modelines_verbose = 0
let g:secure_modelines_modelines = 15

" Stop <> marks being inserted on all filetypes from lh-brackets plugin
let g:cb_no_default_brackets = 1

" Turn off macro recording
noremap q <Nop>

" Disable F1 help launcher
noremap <F1> :echo<CR>
inoremap <F1> <c-o>:echo<CR>

" Vim fonts for gVIM
set guifont=Droid\ Sans\ Mono\ For\ Powerline\ Nerd\ Font\ Complete:h18

" Highlighted ruler for extra focus
highlight CursorLine term=bold cterm=bold guibg=Grey40
highlight CursorColumn term=bold cterm=bold guibg=Grey40
set cursorline cursorcolumn

"""
""" vim-airline CONFIG
"""
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t' " Show just the filename
let g:airline_powerline_fonts = 1
"let g:airline_section_x = '%{PencilMode()}'
let g:powerline_symbols = 'fancy'
"""
""" END of vim-airline CONFIG
"""

"""
""" NERDTree CONFIG
"""
" Startup NerdTree when vim is started
if (expand("%"))
  autocmd VimEnter * silent NERDTree %
else
  autocmd VimEnter * silent NERDTree
endif

autocmd VimEnter * wincmd p

" stop NERDTree buffers being lost by disabling buffer next and buffer previous
autocmd FileType nerdtree noremap <buffer> <c-h> <nop>
autocmd FileType nerdtree noremap <buffer> <c-l> <nop>

" if NERDTree is the last window present, i.e: when you've closed all other 
" windows, then close vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")) | q | endif

" make NERDTree look nicer
let NERDTreeMinimalUI = 1
let NERDTreeDirArrows = 1

" make sure NERDTree shows hidden files/dirs
let NERDTreeShowHidden = 1
"
" Pressing <UP> cursor toggles NerdTree
noremap <UP> :NERDTreeToggle<CR>
""
"" END OF Nerdtree CONFIG
""

""
"" Filetype formats/autocmd CONFIG
""
function SetRestructuredTextOptions()
  au BufRead,BufNewFile *.rst setlocal textwidth=80
  setlocal spell
endfunction

function SetTextAndMarkdownOptions()
  autocmd FileType text,markdown,mkd call pencil#init()
                            \ | call lexical#init()
                            \ | call textobj#quote#init()
                            \ | call textobj#sentence#init()
  let g:pencil#joinspaces = 1     " 0=one_space (def), 1=two_spaces
  let g:pencil#cursorwrap = 1     " 0=disable, 1=enable (def)
  colorscheme evening
  setlocal spell
  setlocal wrap
  nmap <Leader>l <Plug>Ysurroundiw]%a(<C-R>*)<Esc>
  "" scroll through spelling/grammar errors
  noremap <silent> <LEFT> ]s
  noremap <silent> <RIGHT> [s
  noremap <DOWN> :Goyo<CR> " this toggles distraction-free mode
  noremap <UP> :LanguageToolCheck<CR>
endfunction

function SetMakefileOptions()
  setlocal noexpandtab
  setlocal tabstop=4
  setlocal shiftwidth=4
  setlocal softtabstop=0
endfunction

function SetPythonFileOptions()
  setlocal expandtab
  setlocal tabstop=4
  setlocal shiftwidth=4
  setlocal softtabstop=4
  setlocal textwidth=79
  setlocal autoindent
  setlocal fileformat=unix
endfunction

function SetGitCommitFileOptions()
  setlocal colorcolumn+=51 " set additional marker for line wrap
  setlocal wrap " Enable word wrap 
  setlocal textwidth=70
  setlocal spell " highlight spelling mistakes
endfunction

autocmd BufRead,BufNewFile *.f90 set filetype=Fortran
autocmd BufRead,BufNewFile *.robot setlocal noexpandtab
autocmd BufRead,BufNewFile Jenkinsfile set filetype=groovy
autocmd FileType Makefile call SetMakefileOptions()
autocmd FileType gitcommit call SetGitCommitFileOptions()
autocmd FileType plugin indent on " for writing plugins
autocmd FileType python call SetPythonFileOptions()
autocmd FileType text,markdown call SetTextAndMarkdownOptions()
""
"" END of Filetype formats/autocmd CONFIG
""

""
"" Goyo CONFIG
""
noremap <F12> :Goyo<CR> " this toggles distraction-free mode
""
"" END of Goyo CONFIG
""

""
"" Wordy CONFIG
""
" Wordy is only activated when editing text files
let g:wordy#ring = [
  \ 'weak',
  \ ['being', 'passive-voice', ],
  \ 'business-jargon',
  \ 'weasel',
  \ 'puffery',
  \ ['problematic', 'redundant', ],
  \ ['colloquial', 'idiomatic', 'similies', ],
  \ 'art-jargon',
  \ ['contractions', 'opinion', 'vague-time', 'said-synonyms', ],
  \ 'adjectives',
  \ 'adverbs',
  \ ]
""
"" END of Wordy CONFIG
""

""
"" START OF COC.vim CONFIG
""
set hidden

" Give more space for displaying messages.
set cmdheight=2

" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
" delays and poor user experience.
set updatetime=300

" Don't pass messages to |ins-completion-menu|.
set shortmess+=c

" Always show the signcolumn, otherwise it would shift the text each time
" diagnostics appear/become resolved.
if has("patch-8.1.1564")
  " Recently vim can merge signcolumn and number column into one
  set signcolumn=number
else
  set signcolumn=yes
endif

" Use tab for trigger completion with characters ahead and navigate.
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config.
inoremap <silent><expr> <TAB>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<TAB>" :
      \ coc#refresh()
inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

" Make <CR> auto-select the first completion item and notify coc.nvim to
" format on enter, <cr> could be remapped by other vim plugin
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Use `[g` and `]g` to navigate diagnostics
" Use `:CocDiagnostics` to get all diagnostics of current buffer in location 
" list.
nmap <silent> <LEFT> <Plug>(coc-diagnostic-prev)
nmap <silent> <RIGHT> <Plug>(coc-diagnostic-next)

" GoTo code navigation.
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Use K to show documentation in preview window.
nnoremap <silent> K :call <SID>show_documentation()<CR>

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

" Symbol renaming.
nmap <Leader>rn <Plug>(coc-rename)

" Formatting selected code.
xmap <Leader>f  <Plug>(coc-format-selected)
nmap <Leader>f  <Plug>(coc-format-selected)

augroup mygroup
  autocmd!
  " Setup formatexpr specified filetype(s).
  autocmd FileType typescript,json setl formatexpr=CocAction('formatSelected')
  " Update signature help on jump placeholder.
  autocmd User CocJumpPlaceholder call CocActionAsync('showSignatureHelp')
augroup end

" Applying codeAction to the selected region.
" Example: `<Leader>aap` for current paragraph
xmap <Leader>a  <Plug>(coc-codeaction-selected)
nmap <Leader>a  <Plug>(coc-codeaction-selected)

" Remap keys for applying codeAction to the current buffer.
nmap <Leader>ac  <Plug>(coc-codeaction)
" Apply AutoFix to problem on the current line.
nmap <Leader>qf  <Plug>(coc-fix-current)

" Map function and class text objects
" NOTE: Requires 'textDocument.documentSymbol' support from the language server
xmap if <Plug>(coc-funcobj-i)
omap if <Plug>(coc-funcobj-i)
xmap af <Plug>(coc-funcobj-a)
omap af <Plug>(coc-funcobj-a)
xmap ic <Plug>(coc-classobj-i)
omap ic <Plug>(coc-classobj-i)
xmap ac <Plug>(coc-classobj-a)
omap ac <Plug>(coc-classobj-a)

" Add `:Format` command to format current buffer.
command! -nargs=0 Format :call CocAction('format')

" Add `:Fold` command to fold current buffer.
command! -nargs=? Fold :call CocAction('fold', <f-args>)

" Add `:OR` command for organize imports of the current buffer.
command! -nargs=0 OR   :call CocAction('runCommand', 'editor.action.organizeImport')

" Add (Neo)Vim's native statusline support.
" NOTE: Please see `:h coc-status` for integrations with external plugins that
" provide custom statusline: lightline.vim, vim-airline.
set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

" Mappings for CoCList
" Show all diagnostics.
" Manage extensions.
nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
" Show commands.
nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
" Find symbol of current document.
nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
" Search workspace symbols.
nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
" Do default action for next item.
nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
" Do default action for previous item.
nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
" Resume latest coc list.
nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
""
"" END OF COC.vim CONFIG
""

"" 
"" nerdtree-git-plugin CONFIG
"" 
let g:NERDTreeGitStatusUseNerdFonts = 1 "default: 0
let g:NERDTreeGitStatusShowClean = 1 "default: 0
let g:NERDTreeGitStatusUntrackedFilesMode = 'all' "heavy feature default:normal
let g:NERDTreeGitStatusShowIgnored = 1 "heavy feature may cost time. default: 0
let g:NERDTreeGitStatusIndicatorMapCustom = {
                \ 'Modified'  :'✹',
                \ 'Staged'    :'✚',
                \ 'Untracked' :'✭',
                \ 'Renamed'   :'➜',
                \ 'Unmerged'  :'═',
                \ 'Deleted'   :'✖',
                \ 'Dirty'     :'✗',
                \ 'Ignored'   :'☒',
                \ 'Clean'     :'✔︎',
                \ 'Unknown'   :'?',
                \ }
"""
""" END of nerdtree-git-plugin CONFIG
"""

"""
""" START of bash-language-server CONFIG
"""
if executable('bash-language-server')
  au User lsp_setup call lsp#register_server({
        \ 'name': 'bash-language-server',
        \ 'cmd': {server_info->[&shell, &shellcmdflag, 'bash-language-server start']},
        \ 'allowlist': ['sh'],
        \ })
endif
"""
""" END of bash-language-server CONFIG
"""

""""
"""" START of LanguageTool grammar checker plugin CONFIG
""""
let g:languagetool_jar="~/.dotfiles/LanguageTool-5.2/languagetool-commandline.jar"
let g:languagetool_lang="en-GB"
hi LanguageToolGrammarError  guisp=blue gui=undercurl guifg=NONE guibg=NONE ctermfg=white ctermbg=blue term=underline cterm=none
hi LanguageToolSpellingError guisp=red  gui=undercurl guifg=NONE guibg=NONE ctermfg=white ctermbg=red  term=underline cterm=none
""""
"""" END of LanguageTool grammar checker plugin CONFIG
""""
