#!/bin/bash

source scripts/print_summary.sh

links=()
failedLinks=()

links+=("bashrc")
links+=("bash_profile")
links+=("aliases")
links+=("vimrc")
links+=("tmux.conf")
links+=("launchers")
links+=("gitconfig")
links+=("ssh.config")
links+=("taskrc")
links+=("bugwarriorrc")
[[ $os == "Darwin" ]] && links+=("alacritty.yml")

for l in ${links[*]}; do

    # ssh.config need a special repo in ~
    if [[ $l == "ssh.config" ]]; then
        if ! [[ -d ~/.ssh ]]; then
            mkdir ~/.ssh
        fi
        ln -s -f $(pwd)/dotfiles/$l ~/.ssh/config && echo "linked dotfile .$l" || failedLinks+=($l)
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
