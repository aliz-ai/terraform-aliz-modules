#!/usr/bin/env bash

# Crawl the directory tree and get all environment

# Store the list of files in a variable
get_file_list() {
    IFS=$'\n' file_list=($(find ./project-factory -name main.tf | grep -v modules | sed 's/main.tf//g'))
}

crawl_dir() {
    get_file_list
    pwd=$(pwd)
    for i in "${file_list[@]}"; do
        cd $i
        echo $i
        python3 $pwd/import-plan.py
        cd $pwd
    done
}
crawl_dir
