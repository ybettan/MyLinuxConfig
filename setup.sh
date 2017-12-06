#!/bin/bash 
       

# install basic programs
version=`cat /etc/issue | head -1 | cut -d" " -f1`
if [[ $version == "Ubuntu" ]]; then
# ubuntu install
    sudo apt install vim
    sudo apt install tmux
    sudo apt install ctags
    sudo apt install cscope
    sudo apt install figlet # neede for scripts/git_check_status.sh output
else
# fedora install
    sudo dnf install curl
    sudo dnf install vim
    sudo dnf install tmux
    sudo dnf install ctags
    sudo dnf install cscope
    sudo dnf install figlet # neede for scripts/git_check_status.sh output
fi


# install vim-plug for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim


# creates soft links to all file 
ln -s -i ~/MyLinuxConfig/dotfiles/bashrc ~/.bashrc 
ln -s -i ~/MyLinuxConfig/dotfiles/aliases ~/.aliases 
ln -s -i ~/MyLinuxConfig/dotfiles/vimrc ~/.vimrc
ln -s -i ~/MyLinuxConfig/dotfiles/tmux.conf ~/.tmux.conf
ln -s -i ~/MyLinuxConfig/dotfiles/launchers ~/.launchers
if ! [[ -d ~/.ssh ]]; then
    mkdir ~/.ssh
fi
ln -s -i ~/MyLinuxConfig/dotfiles/ssh.config ~/.ssh/config

# without this somtime ssh command doesn't work
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


