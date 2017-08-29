#!/bin/bash

# set all folders needed for qemu project and clone it



if [[ -e ~/Work/Qemu/qemu ]]; then
    echo '~'/Work/Qemu/qemu is\'t empty!
    exit
fi

if [[ -e ~/Work/Qemu ]]; then
    rm -rf ~/Work/Qemu
fi

original_dir=`pwd`;

# create DIRs
mkdir -p ~/Work/Qemu/qemu_bin/x86_64

if [[ $USER != ybettan  ]]; then
    mkdir  ~/Work/Qemu/qemu_bin/full
fi
    
# clone the project
cd ~/Work/Qemu
git clone git://git.qemu-project.org/qemu.git

# preparation for compilation
cd qemu_bin/x86_64
../../qemu/configure --target-list=x86_64-softmmu --enable-debug

if [[ $USER != ybettan  ]]; then
    cd ../full
    ../../qemu/configure --enable-debug
fi

# return to original dir
cd $original_dir
