#!/bin/bash 


# install all the packages received in arguments and update failedPackages array.
function install_packages {

    # get the package manager for different OSs
    version=`cat /etc/issue | head -1 | cut -d" " -f1`
    packageManager=""
    if [[ $version == "Ubuntu" ]]; then
        packageManager="apt-get"

        # ubuntu uniq installs

    else
        packageManager="dnf"

        # fedora uniq installs
    fi

    for p in $@ ; do
        sudo $packageManager install $p || failedPackages+=($p)
    done

    # install vim-plug for vim
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || \
        failedPackages+=(vim-plug)

    # this is done last
    sudo $packageManager update
}


# create soft links for all dotfiles
function create_soft_links {

    for l in $@; do

        # ssh.config need a special repo in ~
        if [[ $l == "ssh.config" ]]; then
            if ! [[ -d ~/.ssh ]]; then
                mkdir ~/.ssh
            fi
            ln -s -f $clonedDir/dotfiles/$l ~/.ssh/config && echo "copy .$l..."
        else
            ln -s -f $clonedDir/dotfiles/$l ~/.$l && echo "copy .$l..."
        fi
    done
}


flag=$1
if [[ $flag == "--help" ]]; then

    echo "usage: $0 [--no-sudo]"
    exit

# if --no-sudo flag is on then skip the commands that require sudo
elif [[ $flag != "--no-sudo" ]]; then

    # create a list of packages and install them
    packages=()
    failedPackages=()
    packages+=(vim)
    packages+=(tmux)
    packages+=(ctags)
    packages+=(cscope)
    packages+=(valgrind)
    packages+=(curl)    # needed to install vim-plug
    packages+=(figlet)  # needed for scripts/git_check_status.sh output
    packages+=(maven)   # needed to build vim-javautocomplete2 plugin
    install_packages ${packages[*]}

fi


# creates soft links to all file 
links=()
failedLinks=()
GIT_DIR_NAME="MyLinuxConfig"
clonedDir=`find ~ -name $GIT_DIR_NAME`
links+=("bashrc")
links+=("aliases")
links+=("vimrc")
links+=("tmux.conf")
links+=("launchers")
links+=("gitconfig")
links+=("ssh.config")
create_soft_links ${links[*]}


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


# print summary
echo --------------------------------------------------------
echo "SUMMARY:"
if (( ${#failedPackages[*]} > 0)); then
    echo -e "\n\tCannot install:"
    for up in ${failedPackages[*]}; do
        echo -e "\t\t-$up"
    done
else
    echo -e "\n\tAll packages were installed successfully"
fi
echo --------------------------------------------------------

