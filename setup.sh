#!/bin/bash 
       

# creates soft links to all file 
ln -s -f ~/.my_dotfiles/.bashrc ~/.bashrc 
ln -s  ~/.my_dotfiles/.aliases ~/.aliases 
ln -s  ~/.my_dotfiles/.vimrc ~/.vimrc 
ln -s  ~/.my_dotfiles/.launchers ~/.launchers 
ln -s  ~/.my_dotfiles/.tmux.conf ~/.tmux.conf 
	       

# source .bashrc file
source ~/.bashrc 
