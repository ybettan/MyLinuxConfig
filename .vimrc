"==============================================================================
"                               line number
"==============================================================================

" set relative number on visual mode and absolute number on insert mode
set relativenumber
autocmd InsertEnter * :set number norelativenumber
autocmd InsertLeave * :set nonumber relativenumber

" set backgrond and font color of line number
highlight LineNr ctermfg=grey ctermbg=black

" without this vim in tmux recive diffrent colors
set background=dark

"==============================================================================
"                           autoclose braces
"==============================================================================

inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}
 
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()

"==============================================================================
"                              TAB settings
"==============================================================================

filetype plugin indent on

" show existing tab with 4 spaces width
set tabstop=4

" when indenting with '>', use 4 spaces width
set shiftwidth=4

" On pressing tab, insert 4 spaces
set expandtab

"==============================================================================
"                               set column
"==============================================================================

" set coding style limit at 80 chars
set colorcolumn=80

"==============================================================================
"                            mouse settings
"==============================================================================

" enable mouse
set mouse=a

"==============================================================================
"                              file title
"==============================================================================

" always show current file title
set title

"==============================================================================
"                           insert mode mapping
"==============================================================================

" map jj to exit insert mode
inoremap jj  <ESC>

"==============================================================================
"                           normal mode mapping
"==============================================================================

" mapping capsLock to ctrl
map CapsLock Ctrl

" enable ci( of all sorts to work from outside the parenthese
nnoremap ci( %ci(
nnoremap ci[ %ci[
nnoremap ci{ %ci{

" enable di( of all sorts to work from outside the parenthese
nnoremap di( %di(
nnoremap di[ %di[
nnoremap di{ %di{

" easy navigation on split screen
nnoremap <C-J> <C-W><C-J>
nnoremap <C-K> <C-W><C-K>
nnoremap <C-L> <C-W><C-L>
nnoremap <C-H> <C-W><C-H>

"==============================================================================
"                            search settings
"==============================================================================

" ignore CASE in search
set ignorecase

" Move faster - this won't work on vim in tmux
map <C-j> <C-d>
map <C-k> <C-u>

"==============================================================================
"                                vim && tmux 
"==============================================================================

" makes split-navigation act differently when in vim\tmux
" in both cases navigation will be done with ctr + hjkl (without tmux prefix)
if exists('$TMUX')
    function! TmuxOrSplitSwitch(wincmd, tmuxdir)
        let previous_winnr = winnr()
        silent! execute "wincmd " . a:wincmd
        if previous_winnr == winnr()
            call system("tmux select-pane -" . a:tmuxdir)
            redraw!
        endif
    endfunction
                                            
    let previous_title = substitute(system("tmux display-message -p '#{pane_title}'"), '\n', '', '')
    let &t_ti = "\<Esc>]2;vim\<Esc>\\" . &t_ti
    let &t_te = "\<Esc>]2;". previous_title . "\<Esc>\\" . &t_te
                                                  
    nnoremap <silent> <C-h> :call TmuxOrSplitSwitch('h', 'L')<cr>
    nnoremap <silent> <C-j> :call TmuxOrSplitSwitch('j', 'D')<cr>
    nnoremap <silent> <C-k> :call TmuxOrSplitSwitch('k', 'U')<cr>
    nnoremap <silent> <C-l> :call TmuxOrSplitSwitch('l', 'R')<cr>
else
    map <C-h> <C-w>h
    map <C-j> <C-w>j
    map <C-k> <C-w>k
    map <C-l> <C-w>l
endif


"==============================================================================
"                           auto complition
"==============================================================================

" set auto complition with tab key, if is a new line then tab act normaly
function! Tab_Or_Complete()
  if col('.')>1 && strpart( getline('.'), col('.')-2, 3 ) =~ '^\w'
    return "\<C-N>"
  else
    return "\<Tab>"
  endif
endfunction
":inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
":set dictionary="/usr/dict/words"
inoremap <Tab> <C-R>=Tab_Or_Complete()<CR>
set dictionary="/usr/dict/words"
set complete-=i
