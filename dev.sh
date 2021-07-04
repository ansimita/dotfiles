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

# Usage: dev.sh [c|go|lua|py|rb|rs|sh]

_bash() {
	_shellcheck
}

_black() {
	sudo apt-get install -y black
}

_build_essential() {
	sudo apt-get install -y build-essential
}

_c() {
	_build_essential
	_clang_format
	_gdb
}

_clang_format() {
	sudo apt-get install -y clang-format

	test -f ~/.vimrc || return
	grep -q ClangFormatOnSave ~/.vimrc || cat <<- EOF >> ~/.vimrc

	" Added by ansimita/dotfiles/dev.sh for C.
	au BufWritePre *.h,*.c,*.cc,*.cpp call ClangFormatOnSave()
	fu! ClangFormatOnSave()
		let l:formatdiff=1
		py3f /usr/share/vim/addons/syntax/clang-format-7.py
	endfu
	EOF
}

_gdb() {
	sudo apt-get install -y gdb
}

_go() {
	local local_version gz upstream_version
	upstream_version=$(wget -qO - https://golang.org/VERSION?m=text)
	if test -d /usr/local/go; then
		local_version=$(go version | awk '{ print $3 }')
		test "$local_version" = "$upstream_version" && return
		sudo rm -rf /usr/local/go
	fi

	gz="$upstream_version.linux-amd64.tar.gz"
	wget -q -P /tmp "https://golang.org/dl/$gz"
	sudo tar -C /usr/local -xzf "/tmp/$gz"

	test "$local_version" && return

	cat <<- EOF >> ~/.profile

	# set PATH so it includes go's bin if it exists
	if [ -d /usr/local/go/bin ] ; then
	    PATH="/usr/local/go/bin:\$PATH"
	fi
	EOF
	cat <<- EOF >> ~/.bashrc

	# Added by ansimita/dotfiles/dev.sh for Go.
	export GOBIN="\$HOME/.local/bin" GOPATH="\$HOME/Code/go"
	EOF

	export PATH="/usr/local/go/bin:$PATH"
}

_golang() {
	_go
	_godoc
	_vim_go
}

_godoc() {
	test -d /usr/local/go || return

	export GOBIN="$HOME/.local/bin"
	test -d "$GOBIN" || mkdir -p "$GOBIN"
	export GOPATH="$HOME/Code/go"
	test -d "$GOPATH" || mkdir -p "$GOPATH"

	local godoc
	godoc=golang.org/x/tools/cmd/godoc
	if test -x "$GOBIN/godoc"; then
		go get -u "$godoc"
		return
	else
		go get "$godoc"
	fi

	cat <<- EOF > /tmp/godoc.service
	[Unit]
	Description=godoc

	[Service]
	Environment="GOPATH=$GOPATH"
	ExecStart=$GOBIN/godoc
	User=$USER

	[Install]
	WantedBy=default.target
	EOF
	sudo mv /tmp/godoc.service /etc/systemd/system
	sudo chown root:root /etc/systemd/system/godoc.service
	sudo systemctl daemon-reload
	sudo systemctl enable godoc.service
	sudo systemctl start godoc.service
}

_irb() {
	test -f ~/.irbrc && return
	printf 'IRB.conf[:PROMPT_MODE] = :SIMPLE\n' > ~/.irbrc
}

_lua() {
	sudo apt-get install -y lua5.3
}

_mypy() {
	sudo apt-get install -y mypy
}

_python3() {
	_black
	_mypy
	_python3_doc
}

_python3_doc() {
	sudo apt-get install -y python3-doc
}

_rubocop() {
	sudo apt-get install -y rubocop
}

_ruby() {
	_irb
	_rubocop
}

_rust() {
	_build_essential
	_rustup
	_rust_vim
}

_rust_vim() {
	test -d ~/.vim/pack/plugins/start/rust.vim && return
	git clone https://github.com/rust-lang/rust.vim \
		~/.vim/pack/plugins/start/rust.vim
}

_rustup() {
	test -d ~/.rustup && return

	wget -qO - https://sh.rustup.rs | sh -s -- --no-modify-path -y

	cat <<- EOF >> ~/.profile

	# set PATH so it includes cargo's bin if it exists
	if [ -d "\$HOME/.cargo/bin" ] ; then
	    PATH="\$HOME/.cargo/bin:\$PATH"
	fi
	EOF

	export PATH="$HOME/.cargo/bin:$PATH"

	test -d ~/.local/share/bash-completion/completions || \
		mkdir -p ~/.local/share/bash-completion/completions
	rustup completions bash > \
		~/.local/share/bash-completion/completions/rustup
}

_shellcheck() {
	sudo apt-get install -y shellcheck
}

_vim_go() {
	test -d ~/.vim/pack/plugins/start/vim-go && return
	git clone https://github.com/fatih/vim-go.git \
		~/.vim/pack/plugins/start/vim-go
}

case "$1" in
	c) _c ;;
	go) _golang ;;
	lua) _lua ;;
	py) _python3 ;;
	rb) _ruby ;;
	rs) _rust ;;
	sh) _bash ;;
	*) printf '%s [c|go|lua|py|rb|rs|sh]\n' "$0" 1>&2 && exit 1 ;;
esac

sudo apt-get install -y \
	ripgrep \
	tree \
	universal-ctags
