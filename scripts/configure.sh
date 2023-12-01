#!/bin/bash

function start_cronjobs {
    mkdir -p /tmp/bugwarrior
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
start_logitech_mouse
