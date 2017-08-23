# .bashrc 

# Uncomment the following line if you don't like systemctl's auto-paging feature:
# export SYSTEMD_PAGER=

#==============================================================================
#                           source other dotfiles
#==============================================================================

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


#==============================================================================
#                                other config
#==============================================================================

# adding ~/Work/my_scripts to $PATH
PATH+=":~/Work/my_scripts";

# show the branch name when the current repo is gitted
parse_git_branch() {
    git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* \(.*\)/ (\1)/'
}
export PS1="\u@\h \[\033[32m\]\W\[\033[33m\]\$(parse_git_branch)\[\033[00m\] $ "


# repair command not found bug (get stuck and need to be killed)
unset command_not_found_handle
