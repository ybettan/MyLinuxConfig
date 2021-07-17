#!/bin/bash

set -e

# make sure all VMs are accessible via SSH
if [[ ${OS} == "Linux" ]]; then

    # without this sometimes ssh command doesn't work
    chmod 600 ~/.ssh/config

    distribution=`cat /etc/issue | head -1 | cut -d" " -f1`
    packageManager=""
    if [[ $distribution == "Ubuntu" ]]; then
        packageManager="apt-get"
    else
        packageManager="dnf"
    fi

    sudo $packageManager -y install openssh-server

    systemctl restart ssh.service
    systemctl enable ssh.service
fi
