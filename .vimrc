syntax on
set backspace=2     " backspace back up a line
set ts=4            " each tab is four spaces
set background=dark " dark background, light foreground
set ls=2            " always show status line
set expandtab       " always expand tabs
set shiftwidth=4    " numbers of spaces to (auto)indent
set scrolloff=3     " keep 3 lines when scrolling
set showcmd         " display incomplete commands
set hlsearch        " highlight searches
set incsearch       " do incremental searching
set ruler           " show the cursor position all the time
set number          " show line numbers
set ignorecase      " ignore case when searching 
set title           " show title in console title bar
set ttyfast         " smoother changes
set cursorline      " highlight current line
set splitright      " Open new vertical split windows to the right of the current one, not the left.
set splitbelow      " See above description. Opens new windows below, not above.
set visualbell      " flashing bell instead of beep
set history=1000    " 1000 previous commands remembered
set laststatus=2
set list
set listchars=tab:▸\ ,eol:¬,extends:❯,precedes:❮


colorscheme tir_black " Set colorscheme to a black/grey theme


"ruby
let g:ruby_path = '/usr/bin/ruby'
if has('autocmd')
    autocmd filetype ruby set omnifunc=rubycomplete#Complete
    autocmd filetype ruby let g:rubycomplete_buffer_loading = 1
    autocmd filetype ruby let g:rubycomplete_classes_in_global = 1
    autocmd filetype ruby let g:RCT_ri_cmd = "ri -T -f plain "
    autocmd filetype text colorscheme endif
endif

"Installed plugins

" Supertab
" http://www.vim.org/scripts/script.php?script_id=1643
" Supertab allows you to use <Tab> for all your insert completion needs 
" (:help ins-completion). 

" <tab> to autocomplete
" control-N to cycle through autocomplete popup downwards
" control-P to cycle through autocomplete popup upwards

":retab is a useful command to fix tabs, changes them into spaces..

