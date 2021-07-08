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

# Reference: https://github.com/neovim/neovim/wiki/Building-Neovim

sudo apt-get install -y \
	ninja-build \
	gettext \
	libtool \
	libtool-bin \
	autoconf \
	automake \
	cmake \
	g++ \
	pkg-config \
	unzip

wget -q -P /tmp \
	https://github.com/neovim/neovim/archive/refs/tags/v0.5.0.tar.gz

cd /tmp || exit 1

tar xzf v0.5.0.tar.gz

cd neovim-0.5.0 || exit 1

make CMAKE_BUILD_TYPE=MinSizeRel \
	CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/.local"
make install
