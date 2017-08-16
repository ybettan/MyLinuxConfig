#!/bin/bash 
       

# creates soft links to all file 
ln -s -i ~/.my_dotfiles/.bashrc ~/.bashrc 
ln -s -i ~/.my_dotfiles/.aliases ~/.aliases 
ln -s -i ~/.my_dotfiles/.vimrc ~/.vimrc 
ln -s -i ~/.my_dotfiles/.launchers ~/.launchers 
ln -s -i ~/.my_dotfiles/.tmux.conf ~/.tmux.conf 
	       

# source .bashrc file
if [ -e ~/.bashrc ] ; then
    echo source ~/.bashrc...
    source ~/.bashrc 
fi
