# .bashrc


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# Source aliases definitions
if [ -e ~/.aliases ]; then
	source ~/.aliases
fi


# Source lunchers definitions
if [ -e ~/.lunchers ]; then
	source ~/.lunchers
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

