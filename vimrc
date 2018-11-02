" author: asiro
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"自动拉取插件管理工具
if has('nvim')
	let VIMDIR = $HOME."/.config/nvim"
else
	let VIMDIR = $HOME."/.vim"
endif
if !isdirectory(VIMDIR."/autoload")
	execute("silent !curl -fLo ".VIMDIR."/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim")
	execute("silent !curl -fLo ".VIMDIR."/colors/NeoSolarized.vim --create-dirs https://raw.githubusercontent.com/icymind/NeoSolarized/master/colors/NeoSolarized.vim")
	source $MYVIMRC
endif
"基础设置
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set nocompatible
set mouse=a

if !exists("g:syntax_on")
    syntax enable
endif

filetype plugin on
filetype plugin indent on
set autoindent smartindent
set cursorline "高亮当前行
set nu "行号
set switchbuf+=usetab,newtab
set autochdir
set clipboard+=unnamed

if !isdirectory("/tmp/vim")
	execute(mkdir("/tmp/vim", "p", 0777))
endif
"关机前编辑文件恢复
"set undodir=/tmp/vim
"set undofile
set directory=/tmp/vim "swap文件
"主题
if !has("gui_running") && ($TERM == "xterm" || $TERM == "screen")
	let $TERM = "xterm-256color"
	set t_Co=256
endif
set background=dark
let g:neosolarized_termtrans=1
let g:neosolarized_bold = 1
let g:neosolarized_underline = 1
let g:neosolarized_italic = 1
colorscheme NeoSolarized
"自动断行
set wrap
set linebreak
set scrolloff=3 "页边距
"折行
set foldmethod=indent
set foldlevel=2
"缩进
set shiftwidth=4
set tabstop=4
set softtabstop=4
"搜索
set ignorecase smartcase
set incsearch
set hlsearch showmatch
"文件修改自动载入
set autoread
"可删除任意东西
set backspace=indent,eol,start
"不要响铃，更不要闪屏
set visualbell t_vb=
"帮助信息
set langmenu=zh_CN.utf-8
set helplang=cn
"change the terminal's title
set title
"状态栏
set laststatus=1
set ruler
set rulerformat=%55(%#Boolean#%<%t%y\ %#Exception#%m%w%h%r%<%#Title#%=%l/%L:%v\ 0x%02B%#Exception#\ %n/%{bufnr('$')}%)

"Alt 快捷键
set ttimeout
set ttimeoutlen=50
if has('nvim')
	tnoremap	<ESC>	<c-\><c-n>
	noremap		<M-t>	<ESC>:tabedit term://zsh<CR>i
	inoremap	<M-t>	<c-o>:tabedit term://zsh<CR>i
elseif !has('gui_running')
	for key in range(65, 90) + range(97,  122)
		exe "set <M-".nr2char(key).">=\e".nr2char(key)
	endfor
endif

"快捷命令
command		W			w
nnoremap	：			:
nnoremap	U			<c-r> "the reverse of [u]ndo
noremap		<M-w>		<ESC>:x<CR>
noremap		<M-W>		<ESC>:w !sudo tee %<CR>:e!<CR>:x<CR>
noremap		<M-q>		<ESC>:q<CR>
noremap		<M-Q>		<ESC>:q!<CR>
inoremap	<M-O>		<c-o>O
inoremap	<M-o>		<c-o>o
noremap		<M-e>		<ESC>:tabedit %:h<CR>
noremap		<M-]>		<ESC>g,
noremap		<M-[>		<ESC>g;
vnoremap	//			y/\V<C-R>"<CR>

"快捷移动
inoremap	<M-h>		<c-o>b
inoremap	<M-l>		<c-o>w
vnoremap	<M-h>		b
vnoremap	<M-l>		w
nnoremap	<M-h>		:tabprevious<CR>
nnoremap	<M-l>		:tabnext<CR>
inoremap	<expr><M-k>	pumvisible() ? "<c-p>" : "<c-o>gk"
inoremap	<expr><M-j>	pumvisible() ? "<c-n>" : "<c-o>gj"
noremap		<M-k>		<UP>
noremap		<M-j>		<DOWN>

"工具函数，0 为当前光标下字符，-1 为光标左字符
function! Ch(num)
	return getline('.')[col('.')+a:num-1]
endfunction
"快捷输入
inoremap	<expr><CR>	Ch(-1) =~ "[{>]" && Ch(0)=~"[}<]" ? "<CR><ESC>O" : "<CR>"
inoremap	<expr>,		Ch(0) =~ "\\s" ? "," : ", "
inoremap	<expr>;		Ch(-2) =~ ";" && Ch(-1)=~" "? "\<BS>;" :"; "
inoremap	<expr>&		Ch(-2) =~ ";" && Ch(-1)=~" "? "\<BS>&" :"&"
inoremap	<expr>)		Ch(-1) =~ "(" && pumvisible() ? ")<Left>" : ")"

"json 格式化
noremap <M-J> <ESC>:%!python -m json.tool<CR>

"保存与编译
autocmd BufWritePre * :%s/\s\+$//e "保存前去掉行尾空白字符
"autocmd BufWritePost *.go silent !go fmt %
autocmd BufRead,BufNewFile *.cnf setf dosini
autocmd BufRead,BufNewFile *.conf setf dosini

"插件管理
call plug#begin(VIMDIR.'/plugged')
"Plug 'vim-scripts/fcitx.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'embear/vim-foldsearch'
let g:foldsearch_highlight=1
vnoremap <Space> y:Fp <C-r>"<CR>

Plug 'w0rp/ale'
"Plug 'maralla/completor.vim'
"Plug 'SirVer/ultisnips'|Plug 'honza/vim-snippets'

Plug 'chrisbra/vim-sh-indent', {'for':'sh'}
if has("linux")
	Plug 'Matt-Deacalion/vim-systemd-syntax', {'for':'service'}
endif

if executable("go")
	Plug 'fatih/vim-go'
endif
if executable("docker")
	Plug 'ekalinin/Dockerfile.vim'
endif
if executable("dot")
	Plug 'wannesm/wmgraphviz.vim'
endif
call plug#end()
