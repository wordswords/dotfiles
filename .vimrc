"" Pathogen plugin manager

execute pathogen#infect('~/.vim/bundle/nerdtree/{}')
execute pathogen#infect('~/.vim/bundle/vim-airline/{}')
execute pathogen#infect('~/.vim/bundle/vim-devicons/{}')
execute pathogen#infect('~/.vim/bundle/vim-colors-solarized/{}')
execute pathogen#infect()

syntax enable
set encoding=utf8
set backspace=2     " backspace back up a line
set ts=4            " each tab is two spaces
set background=dark " dark background, light foreground
set ls=2            " always show status line
set expandtab       " always expand tabs
set shiftwidth=2    " numbers of spaces to (auto)indent
set scrolloff=3     " keep 3 lines when scrolling
set showcmd         " display incomplete commands
set hlsearch        " highlight searches
set incsearch       " do incremental searching
set ruler           " show the cursor position all the time
set number          " show line numbers
set ignorecase      " ignore case when searching
set ttyfast         " smoother changes
set cursorline      " highlight current line
set splitright      " Open new vertical split windows to the right of the current one, not the left.
set splitbelow      " See above description. Opens new windows below, not above.
set history=1000    " 1000 previous commands remembered
set laststatus=2    " show nonprintable characters such as tab and newlines
set list            " .. and use these characters to display them
set t_Co=256        " force 256 colour mode
set noswapfile      " Don't drop swap files
set noerrorbells visualbell t_vb= "turn off all bells
set listchars=eol:$,tab:^T,trail:␠,nbsp:⎵
hi SpecialKey ctermfg=grey guifg=grey70
filetype plugin indent on         " for writing plugins

let g:solarized_termcolors=256
colorscheme desert                " Set colorscheme to a black/grey theme
hi SpecialKey ctermfg=grey guifg=grey70
hi NonText ctermfg=grey guifg=grey70
set macligatures

"" Turn off visual and audio bell
autocmd GUIEnter * set visualbell t_vb=

"" Turn off recording
map q <Nop>

"" Vim fonts
set guifont=Droid\ Sans\ Mono\ For\ Powerline\ Nerd\ Font\ Complete:h18
let g:airline_powerline_fonts = 1
let g:powerline_symbols = 'fancy'

"" This is necessary under crunchbang/debian
set t_Sf=[3%dm
set t_Sb=[4%dm
highlight CursorLine term=bold cterm=bold guibg=Grey40
highlight CursorColumn term=bold cterm=bold guibg=Grey40
set cursorline cursorcolumn

"" ConqueTerm plugin
" Activate with :ConqueTermSplit or :ConqueTerm (current buffer)

"" Buffers

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

"" NERDtree plugin

" start NERDTree up when starting up VIM
" if a file to open is provided, open that as well in NERDTree
if (expand("%"))
  autocmd VimEnter * silent NERDTree %
else
  autocmd VimEnter * silent NERDTree
endif

autocmd VimEnter * wincmd p

" stop NERDTree buffers being lost by disabling buffer next and buffer previous
autocmd FileType nerdtree noremap <buffer> <c-h> <nop>
autocmd FileType nerdtree noremap <buffer> <c-l> <nop>

" if NERDTree is the last window present, i.e: when you've closed all other windows, then close vim

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree")) | q | endif

"" Syntaxic settings
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_python_checkers = ['flake8']
let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" Removes trailing spaces
function! TrimWhiteSpace()
    %s/\s\+$//e
endfunction

" Tab stopped file use
au BufRead,BufNewFile *.robot setlocal noexpandtab

nnoremap <silent> <Leader>rts :call TrimWhiteSpace()<CR>
autocmd FileWritePre    * :call TrimWhiteSpace()
autocmd FileAppendPre   * :call TrimWhiteSpace()
autocmd FilterWritePre  * :call TrimWhiteSpace()
autocmd BufWritePre     * :call TrimWhiteSpace()

" Arrow keys map to cnext cprev for :grep
let &grepprg='grep -n -R --exclude=' . shellescape(&wildignore) . ' $*'
noremap <silent> <Right> :cnext <CR>
noremap <silent> <Left> :cprev <CR>
noremap <silent> <Up> :clist <CR>
map <Down> :grep <REGEX> <PATH>

" vim-pencil configuration
augroup pencil
  autocmd!
  " Apply for Markdown and reStructuredText
  autocmd FileType markdown,mkd,md,rst,text,asciidoc call pencil#init({'wrap': 'soft'}) | call lexical#init() | call litecorrect#init() | call textobj#quote#init() | call textobj#sentence#init()
  autocmd FileType markdown,mkd,md call SetMarkdownOptions()
  autocmd FileType rst,text call SetRestructuredTextOptions()

  autocmd FileType c,h call SetCOptions()
  autocmd FileType Makefile call SetMakefileOptions()

  " Highlight words to avoid in tech writing
  " =======================================
  "
  "   obviously, basically, simply, of course, clearly,
  "   just, everyone knows, However, So, easy

  "   http://css-tricks.com/words-avoid-educational-writing/

  highlight TechWordsToAvoid ctermbg=red ctermfg=white
  function! MatchTechWordsToAvoid()
      match TechWordsToAvoid /\c\<\(obviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however\|so,\|easy\)\>/
  endfunction
  autocmd BufWinEnter * match TechWordsToAvoid /\cobviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however,\|so,\|easy/
  autocmd InsertEnter * match TechWordsToAvoid /\cobviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however,\|so,\|easy/
  autocmd InsertLeave * match TechWordsToAvoid /\cobviously\|basically\|simply\|of\scourse\|clearly\|just\|everyone\sknows\|however,\|so,\|easy/
  autocmd BufWinLeave * call clearmatches()
augroup END

function SetRestructuredTextOptions()
  au BufRead,BufNewFile *.rst setlocal textwidth=80
  autocmd FileType gitcommit setlocal spell
  setlocal spell spelllang=en_gb
endfunction

function SetMarkdownOptions()
  setlocal spell spelllang=en_gb
  nmap <leader>l <Plug>Ysurroundiw]%a(<C-R>*)<Esc>
endfunction

function SetMakefileOptions()
  colorscheme Tomorrow-Night
  set noexpandtab tabstop=4 shiftwidth=4 softtabstop=0
endfunction

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

