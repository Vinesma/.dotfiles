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

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

if !exists('g:vscode')
    " Plugin start
    call plug#begin('~/.local/share/nvim/plugged')

    " Declare the list of plugins.
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'vim-airline/vim-airline'

    " List ends here. Plugins become visible to Vim after this call.
    call plug#end()
endif

" Functions

" Used for groff documents
" Calls compile
" Open the PDF from /tmp/
function! GroffPreview()
    :call Compile()<CR><CR>
    execute "! zathura /tmp/op.pdf &"
endfunction

" [1] Get the extension of the file
" [2] Apply appropriate compilation command
" [3] Save PDF as /tmp/op.pdf
function! Compile()
        let extension = expand('%:e')
        if extension == "ms"
                execute "! groff -ms -t % -T pdf > /tmp/op.pdf"
        elseif extension == "tex"
                execute "! pandoc -f latex -t latex % -o /tmp/op.pdf"
        elseif extension == "md"
                execute "! pandoc % -s -o /tmp/op.pdf"
        endif
endfunction
