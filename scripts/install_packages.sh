#!/bin/bash

packages=()
failedPackages=()

packages+=(git)
packages+=(vim)
packages+=(tmux)
packages+=(ctags)
packages+=(curl)    # needed to install vim-plug
packages+=(maven)   # needed to build vim-javautocomplete2 plugin
packages+=(golang)
packages+=(xclip)   # needed for integrating system clipboard into tmux clipboard
[[ ${OS} == "Darwin" ]] && packages+=(coreutils)   # linux terminal commands
[[ ${OS} == "Darwin" ]] && packages+=(alacritty)   # OSX best terminal

if [[ ${OS} == "Darwin" ]]; then

    # instal Brew package manager
    /bin/bash -c \
        "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

    # update the list of available packages and there versions (doesn't install anything)
    brew update
    # install new versions of packages from the last updated list
    brew upgrade

    # install the packages
    for p in ${packages[*]} ; do

        # if the package already exist on the machine but wasn't install using brew
        # we need to make sure brew override the binary symlink to the latest package
        # installed by brew.
        # we may fail on other errors rather than bad linking but this should
        # handle some errors
        brew install $p || { brew link --overwrite $p || failedPackages+=($p); }
    done

else # Linux

    # get the package manager for different linux distributions
    distribution=`cat /etc/issue | head -1 | cut -d" " -f1`

    packageManager=""
    if [[ $distribution == "Ubuntu" ]]; then
        packageManager="apt-get"
    else
        packageManager="dnf"
    fi

    # install new versions of packages
    sudo $packageManager -y upgrade

    # install the packages
    for p in ${packages[*]} ; do
        sudo $packageManager -y install $p || failedPackages+=($p)
    done
fi

# install vim-plug for vim, curl is a dependency and already installed
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || \
    failedPackages+=(vim-plug)

# those repositories are needed for Golang and vim-go to work properly
mkdir -p ~/go/{bin,src}

echo --------------------------------------------------------
echo "                     SUMMARY"
echo --------------------------------------------------------
if [[ ${#failedPackages[*]} -eq 0 ]]; then
    echo "    All packages were installed successfully"
else
    echo "Cannot install:"
    for fp in ${failedPackages[*]}; do
        echo -e "\t- $fp"
    done
    exit 1
fi
echo --------------------------------------------------------
