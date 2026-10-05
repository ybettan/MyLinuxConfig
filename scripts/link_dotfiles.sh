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
links+=("codex")
[[ $os == "Darwin" ]] && links+=("alacritty.yml")

for l in ${links[*]}; do

    if [[ $l == "ssh.config" ]]; then
        mkdir -p ~/.ssh
        ln -s -f $(pwd)/dotfiles/$l ~/.ssh/config && echo "linked dotfile .$l" || failedLinks+=($l)
    elif [[ $l == "nvim" ]]; then
        mkdir -p ~/.config
        ln -s -f -n $(pwd)/dotfiles/$l ~/.config/nvim && echo "linked dotfile .$l" || failedLinks+=($l)
    elif [[ $l == "claude" ]]; then
        mkdir -p ~/.claude
        ln -s -f $(pwd)/dotfiles/claude/statusline.sh ~/.claude/statusline.sh && echo "linked dotfile claude/statusline.sh" || failedLinks+=($l)
        ln -s -f $(pwd)/dotfiles/claude/settings.json ~/.claude/settings.json && echo "linked dotfile claude/settings.json" || failedLinks+=($l)
    elif [[ $l == "codex" ]]; then
        for codex_home in ~/.codex-corp ~/.codex-priv; do
            mkdir -p "$codex_home"
            ln -s -f $(pwd)/dotfiles/codex/config.toml $codex_home/config.toml && echo "linked dotfile codex/config.toml to $codex_home" || failedLinks+=($l)
            # Codex skips symlinked .rules files; link their directory instead.
            if [[ -d "$codex_home/rules" && ! -L "$codex_home/rules" ]]; then
                codex_rules_backup=$(mktemp -d "$codex_home/rules.backup.XXXXXX") || { failedLinks+=($l); continue; }
                mv "$codex_home/rules" "$codex_rules_backup/rules" || { failedLinks+=($l); continue; }
            fi
            ln -s -f -n "$(pwd)/dotfiles/codex/rules" "$codex_home/rules" && echo "linked dotfile codex/rules to $codex_home/rules" || failedLinks+=($l)
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
