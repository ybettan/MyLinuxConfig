#!/bin/bash

function start_cronjobs {
    cronjob="*/5 * * * * /home/ybettan/MyLinuxConfig/scripts/bugwarrior-pull.sh"
    (sudo crontab -u $(whoami) -l; echo "$cronjob" ) | sudo crontab -u $(whoami) -
}

function start_insync {
    if [[ ${OS} == "Linux" ]]; then
        insync start
    fi
}

function source_tmux_conf_file {
    # Source tmux config file - only needed to be apply once.
    tmux source-file ~/.tmux.conf
}

function define_gnome_tweaks {
    # In order to define more tweaks we can
    # 1. run `dconf watch /`
    #   - we can also run `dconf dump /` to dump all the tweaks
    # 2. make changes in the tweaks GUI and check the output of the DB openned by `dconf watch /`
    # 3. write the new tweaks using the required command
    # for more info check: https://askubuntu.com/questions/971067/how-can-i-script-the-settings-made-by-gnome-tweak-tool

    distribution=`cat /etc/os-release | grep ^ID= | cut -d"=" -f2`
    if [[ ${OS} == "Linux" ]] && [[ $distribution == "fedora" ]]; then
        # Remap CapsLock to Ctrl
        dconf write /org/gnome/desktop/input-sources/xkb-options "['ctrl:nocaps']"
        # Remap `<` to PrintScreen
        dconf write /org/gnome/shell/keybindings/show-screenshot-ui "['less']"
    fi
}

function start_logitech_mouse {
    git clone https://github.com/PixlOne/logiops.git /tmp/logiops
    mkdir /tmp/logiops/build
    cd /tmp/logiops/build
    cmake -DCMAKE_BUILD_TYPE=Release ..
    make
    sudo make install
    sudo systemctl enable --now logid
    cd -
}

start_cronjobs
start_insync
source_tmux_conf_file
define_gnome_tweaks
start_logitech_mouse
