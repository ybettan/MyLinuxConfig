#/bin/bash

function print_summary {

    category=$1

    echo --------------------------------------------------------
    echo "                     SUMMARY - $1"
    echo --------------------------------------------------------
    if [[ ${#failedLinks[*]} -eq 0 ]]; then
        echo "    All files were linked successfully"
    else
        echo "Cannot link:"
        for fl in ${failedLinks[*]}; do
            echo -e "\t- $fl"
        done
        exit 1
    fi
    echo -e "--------------------------------------------------------\n\n"
}
