#!/bin/bash 
       

# creates soft links to all file 
ln -s -i ~/MyLinuxConfig/dotfiles/bashrc ~/.bashrc 
ln -s -i ~/MyLinuxConfig/dotfiles/aliases ~/.aliases 
ln -s -i ~/MyLinuxConfig/dotfiles/vimrc ~/.vimrc
ln -s -i ~/MyLinuxConfig/dotfiles/tmux.conf ~/.tmux.conf
ln -s -i ~/MyLinuxConfig/dotfiles/launchers ~/.launchers

### remove
#ln -s -i ~/.my_dotfiles/.bashrc ~/.bashrc 
#ln -s -i ~/.my_dotfiles/.aliases ~/.aliases 
#ln -s -i ~/.my_dotfiles/.vimrc ~/.vimrc 
#ln -s -i ~/.my_dotfiles/.launchers ~/.launchers 
#ln -s -i ~/.my_dotfiles/.tmux.conf ~/.tmux.conf 


	       

# source .bashrc file
if [ -e ~/.bashrc ] ; then
    echo source ~/.bashrc...
    source ~/.bashrc 
fi
