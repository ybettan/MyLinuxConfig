#!/bin/bash 
       

# creates soft links to all file 
ln -s -i ~/MyLinuxConfig/dotfiles/bashrc ~/.bashrc 
ln -s -i ~/MyLinuxConfig/dotfiles/aliases ~/.aliases 
ln -s -i ~/MyLinuxConfig/dotfiles/vimrc ~/.vimrc
ln -s -i ~/MyLinuxConfig/dotfiles/tmux.conf ~/.tmux.conf
ln -s -i ~/MyLinuxConfig/dotfiles/launchers ~/.launchers


# source .bashrc file
if [ -e ~/.bashrc ] ; then
    echo source ~/.bashrc...
    source ~/.bashrc 
fi


# install basic programs
sudo dnf install vim
sudo dnf install tmux
sudo dnf install ctags
sudo dnf install cscope

# install vim-plug for vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
