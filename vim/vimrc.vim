" Change block and pipe cursor on insert and command mode
let &t_SI = "\<esc>[5 q"
let &t_SR = "\<esc>[5 q"
let &t_EI = "\<esc>[1 q"

" Enable filetype based syntax highlighting and other behaviour
syntax on
filetype plugin on
filetype indent on

" Enable linenumbers and make them relative
set number 
set relativenumber  

" Enable mouse
set mouse=a

" Set theme
colo desert

" Set wrapping of lines (has no effect on the file itself)
set lbr

" Set unix style slash expansion for filenames
set shellslash

" When using grep include filenames and linenumbers in the results
set grepprg=grep\ -nH\ $*

" Make special characters like <TAB> visible
set list
set listchars=tab:>\ ,trail:-,nbsp:+

" Convert tabs as 4 spaces
set tabstop=4
set shiftwidth=4
set expandtab

" When pressing the cursor keys in insert mode, leave insert mode
inoremap <Left> <Esc>
inoremap <Up> <Esc>`^<Up>
inoremap <Down> <Esc>`^<Down>
inoremap <Right> <Esc>`^<Right>

" Various settings to create a more informational statusline
" For terminal color codes see: https://vim.fandom.com/wiki/Xterm256_color_names_for_console_Vim
set ruler
set laststatus=2
set showcmd

function! InsertStatuslineColor(mode)
  if a:mode == 'i'
    hi statusline guibg=Orange ctermfg=214 guifg=Black ctermbg=0
  elseif a:mode == 'r'
    hi statusline guibg=Purple ctermfg=5 guifg=Black ctermbg=0
  else
    hi statusline guibg=DarkRed ctermfg=1 guifg=Black ctermbg=0
  endif
endfunction

au InsertEnter * call InsertStatuslineColor(v:insertmode)
au InsertLeave * hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" default the statusline to green when entering Vim
hi statusline guibg=DarkGrey ctermfg=8 guifg=White ctermbg=15

" Formats the statusline
set statusline=%f                           " file name
set statusline+=[%{strlen(&fenc)?&fenc:'none'}, "file encoding
set statusline+=%{&ff}] "file format
set statusline+=%y      "filetype
set statusline+=%h      "help file flag
set statusline+=%m      "modified flag
set statusline+=%r      "read only flag
set statusline+=\ %=                        " align left
set statusline+=Line:%l/%L[%p%%]            " line X of Y [percent of file]
set statusline+=\ Col:%c                    " current column
set statusline+=\ Buf:%n                    " Buffer number




" Various unused settings
let g:tex_flavor='latex'