#!/bin/bash 



# install all the packages received in arguments and update failedPackages array.
function install_packages {

    packageManager=""
    sudo=""
    flags=""

    # MacOS
    if [[ $os == "Darwin" ]]; then

        # instal Brew package manager
        /usr/bin/ruby -e \
            "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)" || \
            err=$?

        packageManager="brew"
        packageManagerExtention="cask"

    # Linux distribution
    else

        # get the package manager for different linux distributions
        version=`cat /etc/issue | head -1 | cut -d" " -f1`
        sudo="sudo"
        if [[ $version == "Ubuntu" ]]; then
            packageManager="apt-get"
        else
            packageManager="dnf"
        fi
        flags="-y"
    fi

    $sudo $packageManager update || err=$?

    # install the packages
    for p in $@ ; do

        # alacritty is installed using "brew cask" (an extention of "brew").
        # the installation is downloading the defauld .alacritty.yml file to
        # ~/.config/alacritty/alacritty.yml therefore it needs to be removed
        # since I use my ~/.alacritty.yml.
        if [[ $p == "alacritty" ]]; then
            $sudo $packageManager $packageManagerExtention install $p || \
                failedPackages+=($p) && err=$?
            rm -r ~/.config
        else
            $sudo $packageManager install $p || failedPackages+=($p) && err=$?
        fi
    done

    # install vim-plug for vim, curl is a dependency and already installed
    curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || \
        (failedPackages+=(vim-plug) && err=$?)
}


# create soft links for all dotfiles
function create_dotfiles_soft_links {

    for l in $@; do

        # ssh.config need a special repo in ~
        if [[ $l == "ssh.config" ]]; then
            if ! [[ -d ~/.ssh ]]; then
                mkdir ~/.ssh
            fi
            ln -s -f $(pwd)/dotfiles/$l ~/.ssh/config && echo "copy .$l..." || err=$?
        else
            ln -s -f $(pwd)/dotfiles/$l ~/.$l && echo "copy .$l..." || err=$?
        fi
    done
}


# create soft links for all acfiles (auto-completion files)
function create_acfiles_soft_links {

    for l in $@; do
        ln -s -f $(pwd)/acfiles/$l /usr/local/etc/bash_completion.d/$l \
            && echo "copy /usr/local/etc/bash_completion.d/$l..." \
            || err=$?
    done
}

# get script parameters
flag=$1
err=0

# determine which OS is running, "Linux" for linux and "Darwin" for macOS
os=`uname -s`
if [[ $os != "Darwin" && $os != "Linux" ]];then
    echo ------------------------
    echo "Cannot determine OS!"
    echo ------------------------
    exit 1
fi

if [[ $flag == "--help" ]]; then
    echo "usage: $0 [--no-sudo]"
    exit
fi


# if --no-sudo flag is on then skip the commands that require sudo
if [[ $flag != "--no-sudo" ]]; then

    # create a list of packages and install them
    packages=()
    failedPackages=()
    packages+=(git)
    packages+=(vim)
    packages+=(tmux)
    packages+=(ctags)
    packages+=(cscope)
    packages+=(valgrind)
    packages+=(curl)    # needed to install vim-plug
    packages+=(maven)   # needed to build vim-javautocomplete2 plugin
    packages+=(golang)
    [[ $os == "Darwin" ]] && packages+=(coreutils)   # linux terminal commands
    [[ $os == "Darwin" ]] && packages+=(alacritty)   # OSX best terminal
    [[ $os == "Linux" ]] && packages+=(openssh-server)
    [[ $os == "Linux" ]] && packages+=(git-email)    # not bundled with git on linux
    install_packages ${packages[*]}

fi


# creates soft links to all dotfile
links=()
failedLinks=()
links+=("bashrc")
links+=("bash_profile")
links+=("aliases")
links+=("vimrc")
links+=("tmux.conf")
links+=("launchers")
links+=("gitconfig")
links+=("ssh.config")
[[ $os == "Darwin" ]] && links+=("alacritty.yml")
create_dotfiles_soft_links ${links[*]}


# creates soft links to all acfile
links=()
failedLinks=()
links+=("ssh")
[[ $os == "Darwin" ]] && create_acfiles_soft_links ${links[*]}


# without this sometimes ssh command doesn't work
chmod 600 ~/.ssh/config || err=$?


# make sure all VMs are accessible via SSH
if [[ $os == "Linux" ]]; then
    systemctl restart sshd || err=$?
    systemctl enable sshd || err=$?
fi


# those repositories are needed for Golang and vim-go to work properly
mkdir -p ~/go/{bin,src}


# macOS terminal source .bash_profile and linux terminal source .bashrc, so
# this solution covers both cases since .bash_profile source .bashrc
if [ -e ~/.bash_profile ] ; then
    echo source ~/.bash_profile...
    source ~/.bash_profile
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

exit $err


