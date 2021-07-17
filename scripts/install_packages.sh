#!/bin/bash

sudo=""
packageManager=""
flags=""

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

    packageManager="brew"

else # Linux

    sudo="sudo"
    flags="-y"

    # get the package manager for different linux distributions
    distribution=`cat /etc/issue | head -1 | cut -d" " -f1`
    if [[ $distribution == "Ubuntu" ]]; then
        packageManager="apt-get"
    else
        packageManager="dnf"
    fi
fi

# update the list of available packages and there versions (doesn't install anything)
$sudo $packageManager $flags update
# install new versions of packages from the last updated list
$sudo $packageManager $flags upgrade

# install the packages
for p in ${packages[*]} ; do
    $sudo $packageManager $flags install $p || failedPackages+=($p)
done

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
