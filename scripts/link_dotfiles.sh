#!/bin/bash

source scripts/print_summary.sh

links=()
failedLinks=()

links+=("bashrc")
links+=("bash_profile")
links+=("aliases")
links+=("vimrc")
links+=("init.vim")
links+=("tmux.conf")
links+=("launchers")
links+=("gitconfig")
links+=("ssh.config")
links+=("taskrc")
links+=("bugwarriorrc")
links+=("logid.cfg")
[[ $os == "Darwin" ]] && links+=("alacritty.yml")

for l in ${links[*]}; do

    if [[ $l == "ssh.config" ]]; then
        if ! [[ -d ~/.ssh ]]; then
            mkdir ~/.ssh
        fi
        ln -s -f $(pwd)/dotfiles/$l ~/.ssh/config && echo "linked dotfile .$l" || failedLinks+=($l)
    elif [[ $l == "init.vim" ]]; then
        if ! [[ -d ~/.config/nvim ]]; then
            mkdir -p ~/.config/nvim
        fi
        ln -s -f $(pwd)/dotfiles/$l ~/.config/nvim/init.vim && echo "linked dotfile .$l" || failedLinks+=($l)
    elif [[ $l == "logid.cfg" ]]; then
        sudo ln -s -f $(pwd)/dotfiles/logid.cfg /etc/logid.cfg
    else
        ln -s -f $(pwd)/dotfiles/$l ~/.$l && echo "linked dotfile .$l" || failedLinks+=($l)
    fi
done

# without this sometimes ssh command doesn't work
chmod 600 ~/.ssh/config

# macOS terminal source .bash_profile and linux terminal source .bashrc, so
# this solution covers both cases since this .bash_profile sources .bashrc
echo source ~/.bash_profile...
source ~/.bash_profile

print_summary "dotfiles" ${failedLinks[*]}
