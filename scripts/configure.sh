#!/bin/bash

function set_cronjobs {

    mkdir -p /tmp/bugwarrior
    cronjob="*/5 * * * * /home/ybettan/MyLinuxConfig/scripts/bugwarrior-pull.sh"
    (sudo crontab -u $(whoami) -l; echo "$cronjob" ) | sudo crontab -u $(whoami) -
}


function set_logitech_mouse {

    git clone https://github.com/PixlOne/logiops.git /tmp/logiops
    mkdir /tmp/logiops/build
    cd /tmp/logiops/build
    cmake -DCMAKE_BUILD_TYPE=Release ..
    make
    sudo make install
    sudo systemctl enable --now logid
    cd -
}

set_cronjobs
set_logitech_mouse
