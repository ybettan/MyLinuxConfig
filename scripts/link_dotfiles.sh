#!/bin/bash

source scripts/print_summary.sh

links=()
failedLinks=()

links+=("bashrc")
links+=("bash_profile")
links+=("aliases")
links+=("nvim")
links+=("tmux.conf")
links+=("launchers")
links+=("gitconfig")
links+=("ssh.config")
links+=("taskrc")
links+=("bugwarriorrc")
links+=("logid.cfg")
links+=("claude")
links+=("cursor")
links+=("codex")
[[ $os == "Darwin" ]] && links+=("alacritty.yml")

for l in ${links[*]}; do

    if [[ $l == "ssh.config" ]]; then
        if ! [[ -d ~/.ssh ]]; then
            mkdir ~/.ssh
        fi
        ln -s -f $(pwd)/dotfiles/$l ~/.ssh/config && echo "linked dotfile .$l" || failedLinks+=($l)
    elif [[ $l == "nvim" ]]; then
        if ! [[ -d ~/.config ]]; then
            mkdir -p ~/.config
        fi
        ln -s -f $(pwd)/dotfiles/$l ~/.config/nvim && echo "linked dotfile .$l" || failedLinks+=($l)
    elif [[ $l == "claude" ]]; then
        if ! [[ -d ~/.claude ]]; then
            mkdir -p ~/.claude
        fi
        ln -s -f $(pwd)/dotfiles/claude/statusline.sh ~/.claude/statusline.sh && echo "linked dotfile claude/statusline.sh" || failedLinks+=($l)
        ln -s -f $(pwd)/dotfiles/claude/settings.json ~/.claude/settings.json && echo "linked dotfile claude/settings.json" || failedLinks+=($l)
        # Link skills individually to not override existing skills (e.g. find-skills)
        mkdir -p ~/.claude/skills
        for skill in $(pwd)/dotfiles/claude/skills/*/; do
            skill_name=$(basename $skill)
            ln -s -f $skill ~/.claude/skills/$skill_name && echo "linked skill claude/skills/$skill_name" || failedLinks+=($l)
        done
    elif [[ $l == "cursor" ]]; then
        if ! [[ -d ~/.cursor ]]; then
            mkdir -p ~/.cursor
        fi
        ln -s -f $(pwd)/dotfiles/cursor/statusline.sh ~/.cursor/statusline.sh && echo "linked dotfile cursor/statusline.sh" || failedLinks+=($l)
        ln -s -f $(pwd)/dotfiles/cursor/statusline-usage.py ~/.cursor/statusline-usage.py && echo "linked dotfile cursor/statusline-usage.py" || failedLinks+=($l)
    elif [[ $l == "codex" ]]; then
        for codex_home in ~/.codex-corp ~/.codex-priv; do
            if ! [[ -d $codex_home ]]; then
                mkdir -p $codex_home
            fi
            ln -s -f $(pwd)/dotfiles/codex/config.toml $codex_home/config.toml && echo "linked dotfile codex/config.toml to $codex_home" || failedLinks+=($l)
        done
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
