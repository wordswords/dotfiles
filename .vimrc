" Pathogen plugin manager
execute pathogen#infect('~/.vim/bundle/nerdtree/{}')
execute pathogen#infect('~/.vim/bundle/vim-airline/{}')
execute pathogen#infect('~/.vim/bundle/vim-devicons/{}')
execute pathogen#infect('~/.vim/bundle/vim-colors-solarized/{}')
execute pathogen#infect()

set encoding=utf8
syntax enable
set backspace=2     " backspace back up a line
set ts=2            " each tab is four spaces
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
set laststatus=2
" show nonprintable characters such as tab and newlines
set list
" .. and use these characters to display them
set t_Co=256        " force 256 colour mode
set noswapfile      " Don't drop swap files 

let g:solarized_termcolors=256
colorscheme solarized " Set colorscheme to a black/grey theme

"" Turn off visual and audio bell
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

"" Turn off recording
map q <Nop>

"" Vim fonts
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Plus\ Nerd\ File\ Types:h11
let g:airline_powerline_fonts = 1
let g:powerline_symbols = 'fancy'
""" Installed plugins

"" Supertab
"" http://www.vim.org/scripts/script.php?script_id=1643
"" Supertab allows you to use <Tab> for all your insert completion needs 
" (:help ins-completion). 

"" <tab> to autocomplete
"" control-N to cycle through autocomplete popup downwards
"" control-P to cycle through autocomplete popup upwards

"" :retab is a useful command to fix tabs, changes them into spaces..

"" This is necessary under crunchbang/debian
set t_Sf=[3%dm
set t_Sb=[4%dm
highlight CursorLine term=bold cterm=bold guibg=Grey40
highlight CursorColumn term=bold cterm=bold guibg=Grey40
set cursorline cursorcolumn

"" ConqueTerm plugin
"" activate with :ConqueTermSplit or :ConqueTerm (current buffer)

"" Buffers

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" This allows buffers to be hidden if you've modified a buffer.
" This is almost a must if you wish to use buffers in this way.
set hidden

" To open a new empty buffer
" This replaces :tabnew which I used to bind to this mapping
nmap <C-T> :enew<cr>

" Move to the next buffer
nmap <C-l> :bnext<CR>

" Move to the previous buffer
nmap <C-h> :bprevious<CR>

" Close the current buffer and move to the previous one
" This replicates the idea of closing a tab
nmap <Space>bq :bp <BAR> bd #<CR>

" Show all open buffers and their status
nmap <Space>bl :ls<CR>

"" NERDtree plugin
"" activate with :NERDTree !

"" start NERDTree up when starting up VIM
"" if a file to open is provided, open that as well in NERDTree
if (expand("%")) 
  autocmd VimEnter * NERDTree % 
else
  autocmd VimEnter * NERDTree
endif

autocmd VimEnter * wincmd p

autocmd FileType nerdtree noremap <buffer> <c-h> <nop>
autocmd FileType nerdtree noremap <buffer> <c-l> <nop>

"" if NERDTree is the last window present, i.e: when you've closed all other windows, then close vim
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

let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

