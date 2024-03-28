#!/bin/bash

set -x

function enable_repositories {

    if [[ $distribution == "fedora" ]]; then

        if [[ $p == "brave-browser" ]]; then
            # package needed for enabling repositories
            sudo dnf -y install dnf-plugins-core
            sudo dnf config-manager --add-repo https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
            sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        fi

        if [[ $p == "google-chrome-stable" ]]; then
            sudo dnf -y install fedora-workstation-repositories
            sudo dnf config-manager --set-enabled google-chrome
        fi

    elif [[ $distribution == "ubuntu" ]]; then

        if [[ $p == "alacritty" ]]; then
            # package needed for enabling repositories
            sudo apt-get -y install software-properties-common
            sudo add-apt-repository ppa:aslatter/ppa -y
        fi

        if [[ $p == "brave-browser" ]]; then
            sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
                https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
            echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
                sudo tee /etc/apt/sources.list.d/brave-browser-release.list
            sudo apt -y update
        fi

    fi

}

packages=()
failedPackages=()

packages+=(alacritty)
packages+=(vim)
packages+=(tmux)
packages+=(ctags)
packages+=(curl)    # needed to install vim-plug
packages+=(maven)   # needed to build vim-javautocomplete2 plugin
packages+=(golang)
packages+=(xclip)   # needed for integrating system clipboard into tmux clipboard
packages+=(pip)     # needed to install bugwarrior
packages+=(task)
packages+=(bugwarrior)
packages+=(cronie)  # needed for running 'crontab'
packages+=(brave-browser)
packages+=(google-chrome-stable)
packages+=(insync)
packages+=(slack)
packages+=(kubectl)
packages+=(oc)
packages+=(kind)
packages+=(yq)
packages+=(thunderbird)
packages+=(gnome-tweaks)
packages+=(cmake libevdev-devel glib2-devel systemd-devel libconfig-devel gcc-c++)   # needed for building 'logiops'
packages+=(vim-plug)
packages+=(xclip)   # Needed for ruanyl/vim-gh-line plugin
[[ ${OS} == "Darwin" ]] && packages+=(coreutils)   # linux terminal commands

if [[ ${OS} == "Linux" ]]; then

    # get the package manager for different linux distributions
    distribution=`cat /etc/os-release | grep ^ID= | cut -d"=" -f2`

    #TODO: use appImages instead?
    # https://appimage.org/
    packageManager=""
    if [[ $distribution == "ubuntu" ]]; then
        packageManager="apt-get"
    else
        packageManager="dnf"
    fi

    # install new versions of packages
    sudo $packageManager -y upgrade

    # install the packages
    for p in ${packages[*]} ; do
        enable_repositories
        if [[ $p == bugwarrior ]]; then
            pip install $p || failedPackages+=($p)
        elif [[ $p == ctags ]] && [[ $distribution == ubuntu ]]; then
            sudo apt-get -y install universal-ctags || failedPackages+=($p)
        elif [[ $p == task ]] && [[ $distribution == ubuntu ]]; then
            sudo apt-get -y install taskwarrior || failedPackages+=($p)
        elif [[ $p == cronie ]] && [[ $distribution == ubuntu ]]; then
            sudo apt-get -y install cron || failedPackages+=($p)
        elif [[ $p == google-chrome-stable ]] && [[ $distribution == ubuntu ]]; then
            curl https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome-stable_current_amd64.deb
            sudo dpkg -i /tmp/google-chrome-stable_current_amd64.deb || failedPackages+=($p)
        elif [[ $p == insync ]]; then
            if [[ $distribution == fedora ]]; then
                # no latest RPM exist - update for other fedora versions
                sudo dnf -y install https://cdn.insynchq.com/builds/linux/insync-3.8.6.50504-fc39.x86_64.rpm || failedPackages+=($p)
            elif [[ $distribution == ubuntu ]]; then
                # no latest deb exit - update for other ubuntu versions - this is for 22.04
                curl https://cdn.insynchq.com/builds/linux/insync_3.8.6.50504-jammy_amd64.deb -o /tmp/insync_3.8.6.50504-jammy_amd64.deb
                sudo apt-get -y install /tmp/insync_3.8.6.50504-jammy_amd64.deb || failedPackages+=($p)
            fi
        elif [[ $p == slack ]]; then
            if [[ $distribution == fedora ]]; then
                # no latest RPM exist - update if a newer version exists
                sudo dnf -y install https://downloads.slack-edge.com/releases/linux/4.35.126/prod/x64/slack-4.35.126-0.1.el8.x86_64.rpm \
                    || failedPackages+=($p)
            elif [[ $distribution == ubuntu ]]; then
                # no latest deb exist - update if a newer version exists
                curl https://downloads.slack-edge.com/releases/linux/4.31.155/prod/x64/slack-desktop-4.31.155-amd64.deb \
                    -o /tmp/slack-desktop-4.31.155-amd64.deb
                sudo apt-get -y install /tmp/slack-desktop-4.31.155-amd64.deb || failedPackages+=($p)
            fi
        elif [[ $p == kubectl ]]; then
            # Download the binary
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
            # Download the checksum file
            curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
            # Validate the binary
            isOK=$(echo "$(cat kubectl.sha256)  kubectl" | sha256sum --check | cut -d':' -f2 | tr -d ' ')
            if [[ $isOK != "OK" ]]; then
                failedPackages+=($p)
                break
            fi
            sudo install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl || failedPackages+=($p)
        elif [[ $p == oc ]]; then
            mkdir /tmp/oc
            cd /tmp/oc
            curl -L https://mirror.openshift.com/pub/openshift-v4/clients/oc/latest/linux/oc.tar.gz -o oc.tar.gz
            tar zxvf oc.tar.gz
            sudo mv oc /usr/local/bin/ || failedPackages+=($p)
            cd -
            rm -rf /tmp/oc
        elif [[ $p == kind ]]; then
            # no latest binary exist - update if a newer version exists
            curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
            chmod +x ./kind
            sudo mv ./kind /usr/local/bin/kind || failedPackages+=($p)
        elif [[ $p == yq ]]; then
            curl -Lo /usr/local/bin/yq https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64
            chmod +x /usr/local/bin/yq || failedPackages+=($p)
        elif [[ $p == gnome-tweaks ]] && [[ $distribution == ubuntu ]]; then
            continue
        elif [[ $p == libevdev-devel ]] && [[ $distribution == ubuntu ]]; then
                sudo apt-get -y install libevdev-dev || failedPackages+=($p)
        elif [[ $p == glib2-devel ]] && [[ $distribution == ubuntu ]]; then
                sudo apt-get -y install libglib2.0-dev || failedPackages+=($p)
        elif [[ $p == systemd-devel ]] && [[ $distribution == ubuntu ]]; then
                sudo apt-get -y install libudev-dev || failedPackages+=($p)
        elif [[ $p == libconfig-devel ]] && [[ $distribution == ubuntu ]]; then
                sudo apt-get -y install libconfig++-dev || failedPackages+=($p)
        elif [[ $p == gcc-c++ ]] && [[ $distribution == ubuntu ]]; then
                sudo apt-get -y install build-essential || failedPackages+=($p)
                sudo apt-get -y install pkg-config || failedPackages+=($p)
        elif [[ $p == vim-plug ]]; then
            # curl is a dependency and already installed
            curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim || \
                failedPackages+=(vim-plug)
        else
            sudo $packageManager -y install $p || failedPackages+=($p)
        fi
    done

else # Darwin (OSX)

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
fi

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
