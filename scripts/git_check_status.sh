#!/bin/bash

# this script checks if all my git directorys are up to date




# function checkPath <path>
function checkPath {

    local normal expected_result="On branch master
Your branch is up-to-date with 'origin/master'.

nothing to commit (use -u to show untracked files)";
    to_be_checked=$1;
    cd $to_be_checked
    is_master=`git branch | grep master | cut -c1`
    if [[ $is_master != '*' ]]; then
        echo "  ~`echo $to_be_checked | cut -d"/" -f4-` is not on 'master' brance"; 
        is_all_on_master=false
        return
    fi
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
is_all_on_master=true;
 
# check directories
checkPath "/home/$USER/MyLinuxConfig";
checkPath "/home/$USER/inSync/HW_backup/semester_7/ProgrammingLanguages"
checkPath "/home/$USER/inSync/HW_backup/semester_7/ArtificialIntelligence"
checkPath "/home/$USER/inSync/HW_backup/semester_7/ParallelProgramming"

checkPath "/home/$USER/inSync/HW_backup/semester_8/ProjectA"
checkPath "/home/$USER/inSync/HW_backup/semester_8/ProjectB"
checkPath "/home/$USER/inSync/HW_backup/semester_8/Oop"

# return to original dir
cd $original_dir

if [[ $is_all_on_master == true ]]; then
    if [[ $flag = true ]]; then
        figlet up to date;
    else
        echo Not up to date:
        for path in $files; do
            echo "  ~`echo $path | cut -d"/" -f4-`"; 
        done
    fi
fi
