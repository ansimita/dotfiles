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

# When leaving the console clear the screen to increase privacy.

test "$SHLVL" = 1 && test -x /usr/bin/clear_console && /usr/bin/clear_console -q

# Leave no trace.

remove_if_exists() {
	test -f "$1" && rm "$1"
}

remove_if_exists "$HOME/.bash_history"
remove_if_exists "$HOME/.lesshst"
remove_if_exists "$HOME/.python_history"
remove_if_exists "$HOME/.vim/.netrwhist"
remove_if_exists "$HOME/.viminfo"
remove_if_exists "$HOME/.wget-hsts"