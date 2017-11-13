#!/bin/bash

# set all folders needed for qemu project and clone it



# make sure i am not erasing all my chnges in accident
if [[ -e ~/Work/Qemu/qemu || -e ~/Work/Qemu/qemu_drivers ]]; then
    echo '~'/Work/Qemu/qemu or '~'/Work/Qemu/qemu_drivers aren\'t empty!
    exit
fi

if [[ $USER != ybettan && -e ~/Work/Qemu/qemu_drivers ]]; then
    echo '~'/Work/Qemu/qemu_drivers aren\'t empty!
    exit
fi



# remove all folder if existed and was backed up
if [[ -e ~/Work/Qemu ]]; then
    rm -rf ~/Work/Qemu
fi



# so that script don't change the current directory
original_dir=`pwd`;



# create DIRs
mkdir -p ~/Work/Qemu/qemu_bin/x86_64

if [[ $USER != ybettan  ]]; then
    mkdir  ~/Work/Qemu/qemu_bin/full
    mkdir  ~/Work/Qemu/qemu_drivers
fi
    
mkdir  ~/Work/Qemu/patches


# clone the Linux src files
cd ~/Work
git clone https://github.com/torvalds/linux.git

# clone the Qemu project
cd ~/Work/Qemu
git clone git://git.qemu-project.org/qemu.git



# set some project configuration
cd qemu/

# make patches more readable
git config diff.renames true            
git config diff.algorithm patience

# connect to the mail server to be able to send mails
git config sendemail.smtpServer smtp.corp.redhat.com

# automatically CC the maintainer of the patch
git config sendemail.cccmd 'scripts/get_maintainer.pl --nogit-fallback' 

cd ../



# preparation for compilation
cd qemu_bin/x86_64
../../qemu/configure --target-list=x86_64-softmmu --enable-debug

# in every machine that isn't host create also a full version
if [[ $USER != ybettan  ]]; then
    cd ../full
    ../../qemu/configure --enable-debug
fi



# return to original dir
cd $original_dir



