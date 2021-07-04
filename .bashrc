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

# If not running interactively, don't do anything.

test "$PS1" || return

# PS1 prompt: Prints git branch only if in git repository.

__branch() {
	branch=$(git rev-parse --abbrev-ref HEAD)
	test "$branch" && printf ' %s' "$branch"
} 2> /dev/null

# PS1 prompt: Prints exit status only if most recent command failed.

__exit() {
	code="$?"
	if test "$code" -ne 0; then
		if test "$code" -gt 128; then
			# Determine the signal number used to terminate the
			# previous command.
			printf '128+%d ' "$(( code - 128 ))"
		else
			printf '%d ' "$code"
		fi
	fi
}

# Go back to the top-level directory of the working tree.

cg() {
	cd "$(git rev-parse --show-toplevel)" || return
}

# Create or reattach dev environment.

dev() {
	local path session
	path="${1:-$PWD}"
	session=$(basename "${path//.}")
	if tmux has -t "$session" 2> /dev/null; then
		tmux attach -t "$session"
	else
		tmux new -d -c "$path" -s "$session" "$EDITOR" '+se nu' +Ex \
			\; splitw -h -c "$1" \
			\; lastp \
			\; attach
	fi
}

# Extract common archive formats.
# Based on https://github.com/xvoland/Extract [MIT].

extract() {
	case "$1" in
		*.cbt|*.tar.bz2|*.tar.gz|*.tar.xz|*.tbz2|*.tgz|*.txz|*.tar)
			tar xvf "$1"
		;;
		*.lzma)
			unlzma ./"$1"
		;;
		*.bz2)
			bunzip2 ./"$1"
		;;
		*.cbr|*.rar)
			unrar x -ad ./"$1"
		;;
		*.gz)
			gunzip ./"$1"
		;;
		*.cbz|*.epub|*.zip)
			unzip ./"$1"
		;;
		*.z)
			uncompress ./"$1"
		;;
		*.7z|*.apk|*.arj|*.cab|*.cb7|*.chm|*.deb|*.dmg)	;&
		*.iso|*.lzh|*.msi|*.pkg|*.rpm|*.udf|*.wim|*.xar)
			7z x ./"$1"
		;;
		*.xz)
			unxz ./"$1"
		;;
		*.exe)
			cabextract ./"$1"
		;;
		*.cpio)
			cpio -id < ./"$1"
		;;
		*.cba|*.ace)
			unace x ./"$1"
		;;
		*.zpaq)
			zpaq x ./"$1"
		;;
		*.arc)
			arc e ./"$1"
		;;
		*.cso)
			ciso 0 ./"$1" ./"$1.iso"
			extract "$1".iso
			rm -f "$1"
		;;
		*)
			printf 'Unknown archive format.\n' 1>&2
			return 1
		;;
	esac
}

# Create specified directory if missing and change into it.

mcd() {
	test -d "$1" || mkdir -p "$1"
	cd "$1" || return
}

# Access to a temporary file.

scratchpad() {
	if test "$TMUX"; then
		"$EDITOR" "$SCRATCHPAD"
	else
		# Workaround for VIM colorscheme.
		TERM=screen "$EDITOR" "$SCRATCHPAD"
	fi
}

EDITOR=vim
HISTCONTROL='erasedups:ignoreboth'
LESSHISTFILE=-
MANWIDTH=80
SCRATCHPAD=/tmp/scratchpad
PS1="\$(__exit)\u \h \w\$(__branch)\n\$ "

alias ll='ls -hAlp' serve='python3 -m http.server'

export EDITOR LESSHISTFILE MANWIDTH SCRATCHPAD

shopt -s cdspell checkjobs

# shellcheck disable=SC1091
test -f /etc/bash_completion && source /etc/bash_completion

if test ! "$TMUX"; then
	# Workaround for VIM colorscheme.
	alias vi='TERM=screen "$EDITOR"'
	alias vim='TERM=screen "$EDITOR"'
fi

unset HISTFILE
