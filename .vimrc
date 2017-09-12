" ========= Setup ========

set nocompatible

if &shell == "/usr/bin/sudosh"
  set shell=/bin/bash
endif

" Install vim plugins
if filereadable(expand("~/.vimrc.bundles"))
  source ~/.vimrc.bundles
endif


" ========= Options ========

if !exists("g:syntax_on")
  syntax enable
endif

set hlsearch
set number
set showmatch
set incsearch
set hidden
set backspace=indent,eol,start
set textwidth=0 nosmartindent tabstop=2 shiftwidth=2 softtabstop=2 expandtab
set ruler
set wrap
set dir=/tmp//
set scrolloff=5
set ignorecase
set smartcase
set wildignore+=*.pyc,*.o,*.class,*.lo,.git,vendor/*,node_modules/**,bower_components/**
set tags+=gems.tags
set cursorline
set cursorcolumn
set lazyredraw
set colorcolumn=100

if version >= 703
  set undodir=~/.vim/undodir
  set undofile
  set undoreload=10000
endif
set undolevels=1000


" ========= Colors ========

colorscheme molokai

au FileType diff colorscheme desert
au FileType git colorscheme desert
au BufWinLeave * colorscheme molokai

" Set color for color column for too-long lines
highlight ColorColumn ctermbg=95

" Highlight trailing whitespace
highlight ExtraWhitespace ctermbg=red guibg=red
autocmd ColorScheme * highlight ExtraWhitespace ctermbg=red guibg=red
augroup WhitespaceMatch
  " Remove ALL autocommands for the WhitespaceMatch group.
  autocmd!
  autocmd BufWinEnter * let w:whitespace_match_number =
        \ matchadd('ExtraWhitespace', '\s\+$')
  autocmd InsertEnter * call s:ToggleWhitespaceMatch('i')
  autocmd InsertLeave * call s:ToggleWhitespaceMatch('n')
augroup END
function! s:ToggleWhitespaceMatch(mode)
  let pattern = (a:mode == 'i') ? '\s\+\%#\@<!$' : '\s\+$'
  if exists('w:whitespace_match_number')
    call matchdelete(w:whitespace_match_number)
    call matchadd('ExtraWhitespace', pattern, 10, w:whitespace_match_number)
  else
    " Something went wrong, try to be graceful.
    let w:whitespace_match_number =  matchadd('ExtraWhitespace', pattern)
  endif
endfunction

" Autoremove trailing spaces when saving the buffer
autocmd FileType c,cpp,elixir,eruby,html,java,javascript,php,ruby autocmd BufWritePre <buffer> :%s/\s\+$//e


" ========= Filetypes========

augroup markdown
  au!
  au BufNewFile,BufRead *.md,*.markdown setlocal filetype=ghmarkdown
augroup END

autocmd FileType php setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType java setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd FileType cs setlocal tabstop=4 shiftwidth=4 softtabstop=4
autocmd Filetype javascript setlocal tabstop=2 shiftwidth=2 softtabstop=2
autocmd FileType tex setlocal textwidth=78
autocmd BufNewFile,BufRead *.txt setlocal textwidth=78

filetype plugin on

if version >= 700
    autocmd BufNewFile,BufRead *.txt setlocal spell spelllang=en_us
    autocmd FileType tex setlocal spell spelllang=en_us
endif


" ========= Shortcuts ========

" Refresh ctags
map <silent> <LocalLeader>rt :!ctags -R --exclude=".git\|.svn\|log\|tmp\|db\|pkg" --extra=+f --langmap=Lisp:+.clj<CR>

" Open git diff
map <silent> <LocalLeader>gd :e product_diff.diff<CR>:%!git diff<CR>:setlocal buftype=nowrite<CR>

" Turn off trailing whitespace highlighting
map <silent> <LocalLeader>ws :highlight clear ExtraWhitespace<CR>

cnoremap <Tab> <C-L><C-D>
nnoremap <silent> k gk
nnoremap <silent> j gj
nnoremap <silent> Y y$

" Pasting over a selection does not replace the clipboard
xnoremap <expr> p 'pgv"'.v:register.'y'

" Navigation
map <C-H> <C-W>h
map <C-J> <C-W>j
map <C-K> <C-W>k
map <C-L> <C-W>l

" NOP on arrow kets
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Insert rocket in insert mode
imap <C-L> <SPACE>=><SPACE>


" ========= Plugin Options ========

" TComment
map <silent> <LocalLeader>cc :TComment<CR>

" Vimux
map <silent> <LocalLeader>rl :wa<CR> :VimuxRunLastCommand<CR>
map <silent> <LocalLeader>vi :wa<CR> :VimuxInspectRunner<CR>
map <silent> <LocalLeader>vk :wa<CR> :VimuxInterruptRunner<CR>
map <silent> <LocalLeader>vx :wa<CR> :VimuxClosePanes<CR>
map <silent> <LocalLeader>vp :VimuxPromptCommand<CR>
vmap <silent> <LocalLeader>vs "vy :call VimuxRunCommand(@v)<CR>
nmap <silent> <LocalLeader>vs vip<LocalLeader>vs<CR>
map <silent> <LocalLeader>ds :call VimuxRunCommand('clear; grep -E "^ *describe[ \(]\|^ *context[ \(]\|^ *it[ \(]" ' . bufname("%"))<CR>

" NERDTree
map <silent> <LocalLeader>nt :NERDTreeToggle<CR>
map <silent> <LocalLeader>nr :NERDTree<CR>
map <silent> <LocalLeader>nf :NERDTreeFind<CR>

let NERDTreeIgnore=['\.pyc', '\.o', '\.class', '\.lo']
let NERDTreeHijackNetrw = 0

" netrw
let g:netrw_banner = 0

" fzf.vim
nmap <C-p> :FZF<CR>
let g:fzf_colors =
      \ { 'fg':      ['fg', 'Normal'],
  \ 'bg':      ['bg', 'Normal'],
  \ 'hl':      ['fg', 'Comment'],
  \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
  \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
  \ 'hl+':     ['fg', 'Statement'],
  \ 'info':    ['fg', 'PreProc'],
  \ 'prompt':  ['fg', 'Conditional'],
  \ 'pointer': ['fg', 'Exception'],
  \ 'marker':  ['fg', 'Keyword'],
  \ 'spinner': ['fg', 'Label'],
  \ 'header':  ['fg', 'Comment'] }

let g:AckAllFiles = 0
let g:AckCmd = 'ack --type-add ruby=.feature --ignore-dir=tmp 2> /dev/null'

let html_use_css=1
let html_number_lines=0
let html_no_pre=1

let vimclojure#WantNailgun = 0
let vimclojure#HighlightBuiltins = 1
let vimclojure#ParenRainbow = 1

let g:gist_clip_command = 'pbcopy'
let g:gist_detect_filetype = 1

let g:rubycomplete_buffer_loading = 1

let g:no_html_toolbar = 'yes'

let coffee_no_trailing_space_error = 1

let g:VimuxUseNearestPane = 1

let g:vim_markdown_folding_disabled = 1

let g:jsx_ext_required = 0

" airline
let g:airline_theme = 'wombat'


"""
""" ALE syntax checking
"""

let g:ale_enabled = 1

" visual options
let g:ale_sign_column_always = 1
let g:ale_sign_warning = '✋'
let g:ale_sign_error = '🚫'
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'

" Linting options
let g:ale_linters = {
\   'javascript': ['eslint', 'flow'],
\   'jsx': ['eslint', 'flow'],
\   'python': ['flake8'],
\   'ruby': ['ruby', 'rubocop'],
\   'hcl': [],
\}
" Only lint on save or when switching back to normal mode, not every keystroke in insert mode
let g:ale_lint_on_text_changed = 'normal'

" Fixer options
let g:ale_fixers = {
\   'javascript': ['prettier', 'remove_trailing_lines'],
\   'ruby': ['rubocop', 'remove_trailing_lines'],
\}
let g:ale_fix_on_save = 1

" language-specific options
let g:ale_javascript_prettier_options = ' --parser babylon --single-quote --jsx-bracket-same-line --trailing-comma es5 --print-width 100'
let g:ale_javascript_flow_executable = './dev-scripts/flow-proxy.sh'

" CamelCaseMotion
map <silent> w <Plug>CamelCaseMotion_w
map <silent> b <Plug>CamelCaseMotion_b
map <silent> e <Plug>CamelCaseMotion_e
map <silent> ge <Plug>CamelCaseMotion_ge
sunmap w
sunmap b
sunmap e
sunmap ge


" ========= Functions ========

command! SudoW w !sudo tee %

" http://techspeak.plainlystated.com/2009/08/vim-tohtml-customization.html
function! DivHtml(line1, line2)
  exec a:line1.','.a:line2.'TOhtml'
  %g/<style/normal $dgg
  %s/<\/style>\n<\/head>\n//
  %s/body {/.vim_block {/
  %s/<body\(.*\)>\n/<div class="vim_block"\1>/
  %s/<\/body>\n<\/html>/<\/div>
  "%s/\n/<br \/>\r/g

  set nonu
endfunction
command! -range=% DivHtml :call DivHtml(<line1>,<line2>)

function! GitGrepWord()
  cgetexpr system("git grep -n '" . expand("<cword>") . "'")
  cwin
  echo 'Number of matches: ' . len(getqflist())
endfunction
command! -nargs=0 GitGrepWord :call GitGrepWord()
nnoremap <silent> <LocalLeader>gw :GitGrepWord<CR>

function! Trim()
  %s/\s*$//
endfunction
command! -nargs=0 Trim :call Trim()
nnoremap <silent> <LocalLeader>cw :Trim<CR>

function! StartInferiorSlimeServer()
  let g:__InferiorSlimeRunning = 1
  call VimuxRunCommand("inferior-slime")
endfunction
command! -nargs=0 StartInferiorSlimeServer :call StartInferiorSlimeServer()

function! __Edge()
  colorscheme Tomorrow-Night
  au BufWinLeave * colorscheme Tomorrow-Night

  set ttyfast

  map <LocalLeader>nf :e%:h<CR>
  map <C-p> :CommandT<CR>

  let g:VimuxOrientation = "h"
  let g:VimuxHeight = "40"
endfunction

function! __HardMode()
  nmap h <nop>
  nmap j <nop>
  nmap k <nop>
  nmap l <nop>
endfunction


" ========= Local Overrides ========
if filereadable(expand('~/.vimrc.local'))
  source ~/.vimrc.local
end
