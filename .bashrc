# .bashrc


# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi


# Source aliases definitions
if [ -f ~/.aliases ]; then
	source ~/.aliases
fi


# Source lunchers definitions
if [ -f ~/.lunchers ]; then
	source ~/.lunchers
fi

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

