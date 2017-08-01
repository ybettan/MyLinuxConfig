"=============================================================================
"                            show line number
"=============================================================================

" show line number
set number

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
"                            search settings
"=============================================================================

" ignore CASE in search
set ignorecase
