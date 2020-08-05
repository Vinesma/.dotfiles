" enable syntax highlighting
syntax on

" show line numbers (relative)
set number relativenumber

" set tabs to have 4 spaces
set ts=4

" indent when moving to the next line while writing code
set autoindent

" expand tabs into spaces
set expandtab

" when using the >> or << commands, shift lines by 4 spaces
set shiftwidth=4

" show the matching part of the pair for [] {} and ()
set showmatch

" enable all Python syntax highlighting features
let python_highlight_all = 1

" Alias replace inline: S
nnoremap S :s///g<Left><Left><Left>

" Autocomplete
set wildmode=longest,list,full

" Fix splits
set splitbelow splitright
