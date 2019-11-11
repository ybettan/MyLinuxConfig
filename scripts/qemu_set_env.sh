#!/bin/bash

# set all folders needed for qemu project and clone it



flag=$1
if [[ $flag == "--help" ]]; then
    echo "usage: $0 [--no-sudo]"
    exit
fi

# make sure i am not erasing all my chnges in accident
if [[ -e ~/Work/Qemu/qemu ]]; then
    echo '~'/Work/Qemu/qemu isn\'t empty!
    exit
fi



# remove all folder if existed and was backed up
if [[ -e ~/Work/Qemu ]]; then
    rm -rf ~/Work/Qemu
fi



# so that script don't change the current directory
original_dir=`pwd`;



# If we have sudo access, install required packages for developing Qemu
if [[ $flag != "--no-sudo" ]]; then
    sudo dnf install git glib2-devel libfdt-devel pixman-devel zlib-devel
    sudo dnf install libaio-devel libcap-devel libiscsi-devel gtk3-devel
fi



# create DIRs
mkdir -p ~/Work/Qemu/qemu_bin
mkdir  ~/Work/Qemu/qemu_bin/x86_64
mkdir  ~/Work/Qemu/qemu_bin/full
mkdir  ~/Work/patches
    


# clone the Qemu project
cd ~/Work/Qemu
# clone my fork
git clone https://github.com/ybettan/qemu.git
cd ~/Work/Qemu/qemu
# add upstream remote for master branch
git remote add upstream https://github.com/qemu/qemu.git
# pull last upstream updated
git pull upstream master
# sync origin (my fork) with upstream
git push origin master
# create branches
git branch pci
git branch virtio
# add origin remote for branches
git branch --set-upstream-to=origin/pci pci
git branch --set-upstream-to=origin/virtio virtio
# pull branches from origin
git checkout pci
git pull
git checkout virtio
git pull
# rebase branches on top of updated master
git checkout pci
git rebase master
git push
git checkout virtio
git rebase master
git push
# checkout master
git checkout master





# set some project configuration

# make patches more readable
git config diff.renames true            
git config diff.algorithm patience

# connect to the mail server to be able to send mails
git config sendemail.smtpServer smtp.corp.redhat.com

# automatically CC the maintainer of the patch
git config sendemail.cccmd 'scripts/get_maintainer.pl --nogit-fallback' 

# automatically create a coverletter for patches series in which (#patches > 1)
git config format.coverletter auto

cd ../



# preparation for compilation
cd qemu_bin/x86_64
../../qemu/configure --target-list=x86_64-softmmu --enable-debug
../../qemu/configure --enable-gtk # needed for GUI in nested VMs

cd ../full
../../qemu/configure --enable-debug



# clone the Linux project
cd ~/Work
# clone my fork
git clone https://github.com/ybettan/linux.git
cd ~/Work/linux
# add upstream remote for master branch
git remote add upstream https://github.com/torvalds/linux.git
# pull last upstream updated
git pull upstream master
# sync origin (my fork) with upstream
git push origin master
# create branches
git branch virtio
# add origin remote for branches
git branch --set-upstream-to=origin/virtio virtio
# pull branches from origin
git checkout virtio
git pull
# rebase branches on top of updated master
git rebase master
git push
# checkout master
git checkout master



# clone the oasis virtio-spec
cd ~/Work
# clone my fork
git clone https://github.com/ybettan/virtio-spec.git
cd ~/Work/virtio-spec
# add upstream remote for master branch
git remote add upstream https://github.com/oasis-tcs/virtio-spec.git
# pull last upstream updated
git pull upstream master
# sync origin (my fork) with upstream
git push origin master
# create branches
git branch increment-edu
git branch documeqntation
# add origin remote for branches
git branch --set-upstream-to=origin/increment-edu increment-edu
git branch --set-upstream-to=origin/documeqntation documeqntation
# pull branches from origin
git checkout increment-edu
git pull
git checkout documeqntation
git pull
# rebase branches on top of updated master
git checkout increment-edu
git rebase master
git push
git checkout documeqntation
git rebase master
git push
# checkout master
git checkout master



# return to original dir
cd $original_dir





