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

mkdest() {
	DESTPATH="$1"
	test -d "$DESTPATH" || mkdir -p "$DESTPATH"
}

# https://github.com/neovim/neovim/releases/tag/v0.5.0
CHECKSUM=6305a1cab22433bf7871cbfcdb76f0013314f4a6c04e56e1547a6925df17240b

# Install dependencies.

sudo apt-get install -y fuse

# Download nvim.appimage to $DESTPATH as nvim.

mkdest "$HOME/.local/bin"
wget -q -P "$DESTPATH" \
	https://github.com/neovim/neovim/releases/download/v0.5.0/nvim.appimage

APPIMAGE="$DESTPATH/nvim.appimage"
MUSKCEHC=$(shasum -a 256 "$APPIMAGE" | awk '{ print $1 }')
if test "$CHECKSUM" != "$MUSKCEHC"; then
	printf '           File: %s\n' "$APPIMAGE" 1>&2
	printf '         SHA256: %s\n' "$MUSKCEHC" 1>&2
	printf 'Expected SHA256: %s\n' "$CHECKSUM" 1>&2
	exit 1
fi
chmod u+x "$APPIMAGE"
mv "$APPIMAGE" "$DESTPATH/nvim"

# Set up the neovim configuration file.

mkdest "$HOME/.config/nvim"
BASEPATH=$(basename "$PWD")
if test "$BASEPATH" = dotfiles; then
	cp nvim/init.vim "$DESTPATH"
	cp nvim/plug.vim "$DESTPATH"
elif test "$BASEPATH" = nvim; then
	cp init.vim "$DESTPATH"
	cp plug.vim "$DESTPATH"
fi

# Download vim-plug.

mkdest "$HOME/.local/share/nvim/site/autoload"
wget -q -P "$DESTPATH" \
	https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
