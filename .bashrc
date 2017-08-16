# .bashrc


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# Source aliases definitions
if [ -e ~/.aliases ]; then
    echo source ~/.aliases...
	source ~/.aliases
fi


# Source launchers definitions
if [ -e ~/.launchers ]; then
    echo source ~/.launchers...
	source ~/.launchers
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

