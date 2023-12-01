#!/bin/bash

mkdir -p /tmp/bugwarrior

cronjob="*/5 * * * * /home/ybettan/MyLinuxConfig/scripts/bugwarrior-pull.sh"
(sudo crontab -u $(whoami) -l; echo "$cronjob" ) | sudo crontab -u $(whoami) -
