#!/bin/bash

# this script checks if all my git directorys are up to date




# function checkPath <path>
function checkPath {

    local normal expected_result="On branch master
Your branch is up-to-date with 'origin/master'.

nothing to commit (use -u to show untracked files)";
    to_be_checked=$1;
    cd $to_be_checked
    git remote update > /dev/null 2>&1 
    result=`git status -uno`;
    if [[ $result != $expected_result ]]; then
        flag=false;
        files+=" $to_be_checked";
    fi
} 


original_dir=`pwd`;
flag=true;
files=();
 
# check directories
checkPath "/home/$USER/MyLinuxConfig";
checkPath "/home/$USER/inSync/HW_backup/semester_7/ProgrammingLanguages"
checkPath "/home/$USER/inSync/HW_backup/semester_7/ArtificialIntelligence"
checkPath "/home/$USER/inSync/HW_backup/semester_7/ProjectA"
checkPath "/home/$USER/inSync/HW_backup/semester_7/ParallelProgramming"

# return to original dir
cd $original_dir

if [[ $flag = true ]]; then
    figlet up to date;
else
    echo Not up to date:
    for path in $files; do
        echo "  ~`echo $path | cut -d"/" -f4-`"; 
    done
fi
