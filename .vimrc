" Pathogen plugin manager
execute pathogen#infect()

syntax on
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
set title           " show title in console title bar
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

colorscheme tir_black " Set colorscheme to a black/grey theme

"" Turn off visual and audio bell
set noerrorbells visualbell t_vb=
autocmd GUIEnter * set visualbell t_vb=

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
"" Shell command to display output of shell commands in new window
"" http://vim.wikia.com/wiki/Display_output_of_shell_commands_in_new_window
"" activate with :Shell
command! -complete=shellcmd -nargs=+ Shell call s:RunShellCommand(<q-args>)
function! s:RunShellCommand(cmdline)
  let isfirst = 1
  let words = []
  for word in split(a:cmdline)
    if isfirst
      let isfirst = 0  " don't change first word (shell command)
    else
      if word[0] =~ '\v[%#<]'
        let word = expand(word)
      endif
      let word = shellescape(word, 1)
    endif
    call add(words, word)
  endfor
  let expanded_cmdline = join(words)
  botright new
  setlocal buftype=nofile bufhidden=wipe nobuflisted noswapfile nowrap
  call setline(1, 'You entered:  ' . a:cmdline)
  call setline(2, 'Expanded to:  ' . expanded_cmdline)
  call append(line('$'), substitute(getline(2), '.', '=', 'g'))
  silent execute '$read !'. expanded_cmdline
  1
endfunction

"" NERDtree plugin
"" activate with :NERDTree !

"" start NERDTree up when starting up VIM
autocmd VimEnter * NERDTree
autocmd BufEnter * NERDTreeMirror
autocmd VimEnter * wincmd w

"" if NERDTree is the last window present, i.e: when you've closed all other windows, then close vim
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"" ConqueTerm plugin
"" activate with :ConqueTermSplit or :ConqueTerm (current buffer)

autocmd VimEnter * ConqueTermSplit bash

