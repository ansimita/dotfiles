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

DRACULA='https://github.com/dracula'

# Shell.

sed -i -e '24,25d' ~/.gitconfig

sed -i -e '/^PS1/d;/^unset/d' ~/.bashrc

cat << EOF >> ~/.bashrc
# Added by ansimita/dotfiles/pretty.sh for Dracula theme.

CYAN="\[\$(tput setaf 6)\]"
GREEN="\[\$(tput setaf 2)\]"
MAGENTA="\[\$(tput setaf 5)\]"
RED="\[\$(tput setaf 1)\]"
RESET="\[\$(tput sgr0)\]"
YELLOW="\[\$(tput setaf 3)\]"
PS1="\${RED}\\\$(__exit)\${RESET}"
PS1+="\${CYAN}\\u "
PS1+="\${MAGENTA}\\h "
PS1+="\${YELLOW}\\w"
PS1+="\${GREEN}\\\$(__branch)\${RESET}\\n"
PS1+="\\$ "

unset HISTFILE CYAN GREEN MAGENTA RED RESET YELLOW
EOF

# Editor.

git clone https://github.com/dracula/vim.git ~/.vim/pack/themes/start/dracula

cat << EOF >> ~/.vimrc

" Added by ansimita/dotfiles/pretty.sh for Dracula theme.
pa! dracula
syntax enable
colo dracula
EOF

sed -i -e '/hi linenr/s/^/" /' ~/.vimrc  # disable 'hi linenr'
sed -n -e '40,48p' ~/.vimrc > /tmp/vimrc # cut
cat /tmp/vimrc >> ~/.vimrc               # paste
sed -i -e '40,48d' ~/.vimrc              # delete

# Exit early if running without a desktop.

test "$XDG_CURRENT_DESKTOP" || exit

# Font.

sudo apt-get install -y fonts-ibm-plex

# Terminal.

DESTINATION="$HOME/Code/dracula_terminal"
test -d "$DESTINATION" || git clone "$DRACULA/gnome-terminal" "$DESTINATION"
cd "$DESTINATION" || exit

./install.sh -s Dracula --skip-dircolors # Manual entry required.

DCONFDIR='/org/gnome/terminal/legacy/profiles:'
PROFILE=$(dconf list "$DCONFDIR/" | grep ^: | sed 's/\///g')
PROFILE_PATH="$DCONFDIR/$PROFILE"

dconf write "$PROFILE_PATH/cell-height-scale" 1.2
dconf write "$PROFILE_PATH/use-system-font" false
dconf write "$PROFILE_PATH/font" "'IBM Plex Mono 13'"
dconf write "$PROFILE_PATH/scrollbar-policy" "'never'"
