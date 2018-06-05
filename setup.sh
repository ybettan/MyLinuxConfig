#!/bin/bash 
       

flag=$1
if [[ $flag == "--help" ]]; then

    echo "usage: $0 [--no-sudo]"
    exit

# if --no-sudo flag is on then skip the commands that require sudo
elif [[ $flag != "--no-sudo" ]]; then

    # install basic programs
    version=`cat /etc/issue | head -1 | cut -d" " -f1`
    package_manager=""
    if [[ $version == "Ubuntu" ]]; then
        package_manager="apt-get"

        # ubuntu uniq installs

    else
        package_manager="dnf"

        # fedora uniq installs
        sudo $package_manager install curl
    fi

    # commun install
    sudo $package_manager install vim
    sudo $package_manager install tmux
    sudo $package_manager install ctags
    sudo $package_manager install cscope
    sudo $package_manager install valgrind
    sudo $package_manager install figlet # needed for scripts/git_check_status.sh output
    sudo $package_manager install maven # needed to build vim-javautocomplete2 plugin

    # this is done last
    sudo $package_manager update

fi


# install vim-plug for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# creates soft links to all file 
GIT_DIR_NAME="MyLinuxConfig"
clonedDir=`find ~ -name $GIT_DIR_NAME`
ln -s -f $clonedDir/dotfiles/bashrc ~/.bashrc && \
    echo "copy bashrc..." || echo "ERROR: cannot copy $GIT_DIR_NAME/dotfiles/bashrc"
ln -s -f $clonedDir/dotfiles/aliases ~/.aliases && \
    echo "copy aliases..." || echo "ERROR: cannot copy $GIT_DIR_NAME/dotfiles/aliases"
ln -s -f $clonedDir/dotfiles/vimrc ~/.vimrc && \
    echo "copy vimrc..." || echo "ERROR: cannot copy $GIT_DIR_NAME/dotfiles/vimrc"
ln -s -f $clonedDir/dotfiles/tmux.conf ~/.tmux.conf && \
    echo "copy tmux.conf..." || echo "ERROR: cannot copy $GIT_DIR_NAME/dotfiles/tmux.conf"
ln -s -f $clonedDir/dotfiles/launchers ~/.launchers && \
    echo "copy launchers..." || echo "ERROR: cannot copy $GIT_DIR_NAME/dotfiles/launchers"
ln -s -f $clonedDir/dotfiles/gitconfig ~/.gitconfig && \
    echo "copy gitconfig..." || echo "ERROR: cannot copy $GIT_DIR_NAME/dotfiles/gitconfig"
if ! [[ -d ~/.ssh ]]; then
    mkdir ~/.ssh
fi
ln -s -f $clonedDir/dotfiles/ssh.config ~/.ssh/config && \
    echo "copy ssh.config..." || echo "ERROR: cannot copy $GIT_DIR_NAME/dotfiles/ssh.config"

# without this sometimes ssh command doesn't work
chmod 600 ~/.ssh/config


# install power-line fonts to make air-vim plugin's shapes look nicer
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts


# source .bashrc file
if [ -e ~/.bashrc ] ; then
    echo source ~/.bashrc...
    source ~/.bashrc 
fi


