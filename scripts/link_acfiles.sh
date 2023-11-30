#!/bin/bash

source scripts/print_summary.sh

links=()
failedLinks=()

links+=("ssh")

dstDir=/usr/local/etc/bash_completion.d
sudo mkdir -p $dstDir

for l in ${links[*]}; do
    sudo ln -s -f $(pwd)/acfiles/$l $dstDir/$l && echo "linked acfile $l" || failedLinks+=($l)
done

print_summary "acfiles" ${failedLinks[*]}
