syntax on
set backspace=2		" backspace back up a line
set ts=4			" each tab is four spaces
set background=dark	" dark background, light foreground
set ls=2            " always show status line
set shiftwidth=4    " numbers of spaces to (auto)indent
set scrolloff=3     " keep 3 lines when scrolling
set showcmd         " display incomplete commands
set hlsearch        " highlight searches
set incsearch       " do incremental searching
set ruler           " show the cursor position all the time
set number			" show line numbers
set ignorecase		" ignore case when searching 
set title			" show title in console title bar
set ttyfast			" smoother changes
set cursorline		" highlight current line

"ruby
let g:ruby_path = '/usr/bin/ruby'
if has('autocmd')
    autocmd filetype ruby set omnifunc=rubycomplete#Complete
    autocmd filetype ruby let g:rubycomplete_buffer_loading = 1
    autocmd filetype ruby let g:rubycomplete_classes_in_global = 1
	autocmd filetype ruby let g:RCT_ri_cmd = "ri -T -f plain "
    autocmd filetype text colorscheme endif
endif

