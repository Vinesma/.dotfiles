" set leader
let mapleader = ","

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

" enable all Python syntax highlighting features
let python_highlight_all = 1

" Autocomplete
set wildmode=longest,list,full

" Fix splits
set splitbelow splitright

" Use clipboard as unnamed buffer
set clipboard=unnamedplus

" Preview substitution command
set inccommand=nosplit

" Airline
" Powerline symbols
let g:airline_powerline_fonts = 1
" Tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_min_count = 2
let g:airline#extensions#tabline#tab_min_count = 2
let g:airline#extensions#tabline#buffer_nr_show = 1

if !exists('g:vscode')
    " Plugin start
    call plug#begin('~/.local/share/nvim/plugged')

    " Declare the list of plugins.
    Plug 'neoclide/coc.nvim', {'branch': 'release'}
    Plug 'tpope/vim-fugitive'
    Plug 'vim-airline/vim-airline'
    Plug 'mkitt/tabline.vim'
    Plug 'ap/vim-css-color'

    " List ends here. Plugins become visible to Vim after this call.
    call plug#end()

    " Netrw file explorer
    let g:netrw_banner = 0
    let g:netrw_liststyle = 3
    let g:netrw_browse_split = 4
    let g:netrw_altv = 1
    let g:netrw_winsize = 25
   " augroup ProjectDrawer
   "   autocmd!
   "   autocmd VimEnter * :Vexplore
   " augroup END
endif

" Custom mappings
"
" Edit this file in a split
nnoremap <leader>ev :vsplit $MYVIMRC<cr>/Custom mappings<cr>:nohlsearch<cr>
" Source this file
nnoremap <leader>sv :source $MYVIMRC<cr>
" Run a substitute command on this line
nnoremap S :s///g<Left><Left><Left>
" Run a substitute command over the entire file
nnoremap <leader>s :%s///g<Left><Left><Left>
" Uppercase the entire word over the cursor.
nnoremap <leader>u viwU
inoremap <leader>u <esc>viwUi
" Flip current line with the next line.
nnoremap <leader>f ddp
inoremap <leader>f <esc>ddpi
" Duplicate current line
nnoremap <leader>d yyp
" Surround a word in double-quote
nnoremap <leader>" viw<esc>a"<esc>bi"<esc>lel
" Surround the visual selection in double-quotes
vnoremap <leader>" <esc>`<<esc>i"<esc>`>la"<esc>
" Surround a word in single-quote
nnoremap <leader>' viw<esc>a'<esc>bi'<esc>lel
" Surround the visual selection in single-quotes
vnoremap <leader>' <esc>`<<esc>i'<esc>`>la'<esc>
" Comment lines with leader+c depending on what language is detected.
augroup AutoComment
    autocmd!
    autocmd FileType javascript nnoremap <buffer> <leader>c I// <esc>
    autocmd FileType python     nnoremap <buffer> <leader>c I# <esc>
    autocmd FileType sh         nnoremap <buffer> <leader>c I# <esc>
    autocmd FileType vim        nnoremap <buffer> <leader>c I" <esc>
augroup END
" Open file browser
nnoremap <c-b> :Vexplore<cr>
" Alternate between buffers
nnoremap <Tab> :bn<cr>

" Autocmds
"
" Remove trailing whitespace on save
augroup RemWhitespace
    autocmd BufWritePre * %s/\s\+$//e
augroup END

" Toggle spellcheck for some filetypes
augroup SpellCheck
    autocmd!
    autocmd FileType markdown setlocal spell spelllang=en_us
augroup END

" Functions
"
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
