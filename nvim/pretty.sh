#!/usr/bin/bash

# Copyright (c) 2021 ansimita
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

sed -i -e '41,49d;59,60d' ~/.config/nvim/init.vim
sed -i -e '/dracula/s/^" //' ~/.config/nvim/plug.vim
sed -i -e '/nvim-treesitter/s/^" //' ~/.config/nvim/plug.vim

nvim --headless +PlugInstall +qa

cat << PLUG_EOF >> ~/.config/nvim/plug.vim

" Added by ansimita/dotfiles/pretty.sh for Dracula theme.
let g:dracula_colorterm = 0
colo dracula

" Added by ansimita/dotfiles/pretty.sh for nvim-treesitter.
lua << EOF
require('nvim-treesitter.configs').setup {
  ensure_installed = { 'bash',
                       'c',
		       'cpp',
		       'go',
		       'lua',
		       'python',
		       'ruby',
		       'rust' },
  highlight = { enable = true },
}
EOF
PLUG_EOF

BASEPATH=$(basename "$PWD")
if test "$BASEPATH" = dotfiles; then
	WHERE="$PWD/nvim/dracula.patch"
elif test "$BASEPATH" = nvim; then
	WHERE="$PWD/dracula.patch"
fi
git -C ~/.local/share/nvim/plugged/dracula apply "$WHERE"
