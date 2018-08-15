#!/bin/bash

# start tmux if not running
tmux

# set macOS window
tmux rename-window macOS
tmux split-window -h

# set fedora window
tmux new-window
tmux select-window -t 1
tmux rename-window fedora
tmux split-window -h

# set fedoraNested window
tmux new-window
tmux select-window -t 2
tmux rename-window fedoraNested
tmux split-window -h

# return to macOS window
tmux select-window -t 0
