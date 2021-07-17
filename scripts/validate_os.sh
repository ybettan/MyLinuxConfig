#!/bin/bash

if [[ $OS != "Darwin" && $OS != "Linux" ]];then
    echo ------------------------
    echo "Cannot determine OS!"
    echo ------------------------
    exit 1
fi
