#!/bin/bash 
       

flag=$1
if [[ $flag == "--help" ]]; then

    echo "usage: $0 [--no-sudo]"
    exit

# if --no-sudo flag is on then skip the commands that require sudo
elif [[ $flag != "--no-sudo" ]]; then

    # install basic programs
    version=`cat /etc/issue | head -1 | cut -d" " -f1`
    if [[ $version == "Ubuntu" ]]; then
    # ubuntu install
        sudo apt install vim
        sudo apt install tmux
        sudo apt install ctags
        sudo apt install cscope
        sudo apt install figlet # needed for scripts/git_check_status.sh output
    else
    # fedora install
        sudo dnf install curl
        sudo dnf install vim
        sudo dnf install tmux
        sudo dnf install ctags
        sudo dnf install cscope
        sudo dnf install figlet # needed for scripts/git_check_status.sh output
    fi

fi


# install vim-plug for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# creates soft links to all file 
ln -s -f ~/MyLinuxConfig/dotfiles/bashrc ~/.bashrc
ln -s -f ~/MyLinuxConfig/dotfiles/aliases ~/.aliases
ln -s -f ~/MyLinuxConfig/dotfiles/vimrc ~/.vimrc
ln -s -f ~/MyLinuxConfig/dotfiles/tmux.conf ~/.tmux.conf
ln -s -f ~/MyLinuxConfig/dotfiles/launchers ~/.launchers
if ! [[ -d ~/.ssh ]]; then
    mkdir ~/.ssh
fi
ln -s ~/MyLinuxConfig/dotfiles/ssh.config ~/.ssh/config

# without this sometimes ssh command doesn't work
chmod 600 ~/.ssh/config


# install power-line fonts to make air-vim plugin's shapes look nicer
git clone https://github.com/powerline/fonts.git --depth=1
cd fonts
./install.sh
cd ..
rm -rf fonts


# set git configuration
git config --global user.name "Yoni Bettan"
git config --global user.email "ybettan@redhat.com"
git config --global core.editor "$(which vim)"


# source .bashrc file
if [ -e ~/.bashrc ] ; then
    echo source ~/.bashrc...
    source ~/.bashrc 
fi


