#!/bin/bash

/home/ybettan/.local/bin/bugwarrior-pull > tmp.txt 2>&1

new_tasks=$(grep "Adding task" tmp.txt)
updated_tasks=$(grep "Updating task" tmp.txt | cut -d"," -f1 | cut -d" " -f3)

if [[ ! -z $new_tasks ]]; then
    while read -r line; do
        if [[ $line == *"Adding task"* ]]; then
            line=$(echo $line | cut -d" " -f3-)
            # remove [*] from the titles as it is interpreted as a characters range by the task command
            # regex clarification:
            # \[ - match [
            # [^]] - match any non ] char
            # ' *' - match any trailing spaces
            # \] - match ]
            line=$(echo $line | sed 's/\[[^]]*\] *//g')
            # double quotes are interpreted as &dquot; in the task description for some reason
            line=$(echo $line | sed 's/"/\&dquot;/g')
            # escaping '/' in the task's name
            line=$(echo $line | sed 's/\//\\\//g')
            # replacing '(' and ')' chars with the wildcard char '.' as () have a special meaning like []
            line=$(echo $line | sed 's/(/./g')
            line=$(echo $line | sed 's/)/./g')
            # escape '+' char as + have a special meaning like () and []
            line=$(echo $line | sed 's/+/\\+/g')
            line=/\"$line\"/
            task "$line" mod +n > /dev/null 2>&1
        fi
    done < tmp.txt
fi

if [[ ! -z $updated_tasks ]]; then
    echo all | task "$updated_tasks" mod +u > /dev/null 2>&1
fi

mkdir -p /tmp/bugwarrior
cp tmp.txt "/tmp/bugwarrior/$(date).txt"
rm tmp.txt
