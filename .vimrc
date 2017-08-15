"=============================================================================
"                            show line number
"=============================================================================

" set relative number on visual mode and absolute number on insert mode
set relativenumber
autocmd InsertEnter * :set number norelativenumber
autocmd InsertLeave * :set nonumber relativenumber

" set backgrond and font color of line number
highlight LineNr ctermfg=grey ctermbg=black

"=============================================================================
"                           autoclose braces
"=============================================================================

inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}
 
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()

"=============================================================================
"                              TAB settings
"=============================================================================

filetype plugin indent on

" show existing tab with 4 spaces width
set tabstop=4

" when indenting with '>', use 4 spaces width
set shiftwidth=4

" On pressing tab, insert 4 spaces
set expandtab

"=============================================================================
"                               set column
"=============================================================================

" set coding style limit at 80 chars
set colorcolumn=80

"=============================================================================
"                            mouse settings
"=============================================================================

" enable mouse
set mouse=a

"=============================================================================
"                              file title
"=============================================================================

" always show current file title
set title

"=============================================================================
"                           insert mode mapping
"=============================================================================

" map jj to exit insert mode
inoremap jj  <ESC>

"=============================================================================
"                           insert mode mapping
"=============================================================================

" map ci( to %ci( - means we can now use "ci(" even from outside the ()
nnoremap ci( %ci(

"=============================================================================
"                            search settings
"=============================================================================

" ignore CASE in search
set ignorecase





