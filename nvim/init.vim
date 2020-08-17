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

if !exists('g:vscode')
    " Plugin start
    call plug#begin('~/.local/share/nvim/plugged')

    " Declare the list of plugins.
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'vim-airline/vim-airline'

    " List ends here. Plugins become visible to Vim after this call.
    call plug#end()
endif
