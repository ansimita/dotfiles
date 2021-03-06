" Copyright (c) 2021 ansimita
"
" Permission is hereby granted, free of charge, to any person obtaining a copy
" of this software and associated documentation files (the "Software"), to deal
" in the Software without restriction, including without limitation the rights
" to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
" copies of the Software, and to permit persons to whom the Software is
" furnished to do so, subject to the following conditions:
"
" The above copyright notice and this permission notice shall be included in all
" copies or substantial portions of the Software.
"
" THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
" IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
" FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
" AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
" LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
" OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
" SOFTWARE.

let g:netrw_banner=0
let g:netrw_hide=1
let g:netrw_home=''
let g:netrw_list_hide=netrw_gitignore#Hide()
let g:netrw_liststyle=3

filetype indent plugin on

" https://www.vi-improved.org/recommendations/#better-whitespace
au BufWrite * :cal StripTrailingWhitespace()
fu! StripTrailingWhitespace()
	if !&bin && &filetype != 'diff'
		norm mz
		norm Hmy
		%s/\s\+$//e
		norm 'yz<CR>
		norm `z
	en
endfu

hi folded       none ctermfg=04
hi linenr       none ctermfg=15
hi statusline   none ctermfg=15
hi statuslinenc none ctermfg=07
hi tabline      none ctermfg=07
hi tablinefill  none ctermfg=07
hi tablinesel   none ctermfg=00 ctermbg=07
hi vertsplit    none ctermfg=00

nn K <Nop>

se ai ar bs=indent,eol,start mls=1 mouse=nvi noswf nowrap ru sb spr vi=
