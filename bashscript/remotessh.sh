#!/bin/bash
############################################################################
#Author: Hafid                                                             #
#Purpose: This script for add user acc expires                             #
#you can edit and modify as you like, dont forget credit                   #
#contact: hafid.dave@gmail.com                                             #
#please consider to change variable you wish                               #
############################################################################
red=$'\033[0;31m'
green=$'\033[0;32m'
yellow=$'\033[0;33m'
blue=$'\033[0;34m'
magenta=$'\033[0;35m'
cyan=$'\033[0;36m'
clear=$'\033[0m'

output="server_target.$(date +'%Y-%m-%d').info.txt"

echo "--------------------------------------------------------------------------------"
echo -e "${green}This Script is for add more days to expire account${clear}"
echo -e "${green}Please make sure target server running root privilage or sudo${clear}"
echo -e "${green}Please remember this script add more days the account expires based on date now${clear}"
echo "--------------------------------------------------------------------------------"

local_chk() {
    local meid=$(id -u)
    if [[ $meid -ne 0 ]]; then
        echo -e "${green}Please Run as Super User Privilage${clear}"
        exit
    fi
}

header() {
    echo "-------------------------------------------------------------" >>$output
    echo "$@" >>$output
    echo "-------------------------------------------------------------" >>$output
}

input_user() {
    if [[ -z $input_user ]]; then
        echo -e "{$yellow}input cannot be blank${clear}"
        exit
    fi
}

input_pass() {
    if [[ -z $input_pass ]]; then
        echo -e "{$yellow}input cannot be blank${clear}"
        
    fi
}

file_validate() {

    if [[ -z $file ]]; then
        echo -e "${yellow}Input cannot be blank${clear}"
    elif ! [[ -f $file ]]; then
        echo -e "${yellow}File does not exist validate file${clear}"
        exit
    fi

}

number_validate() {

    if [[ -z $n_days ]]; then
        echo -e "${yellow}Input cannot be blank${clear}"
    elif ! [[ $n_days =~ ^[0-9]+$ ]] || [[ $n_days =~ ^[A-Za-z]+$ ]]; then
        echo -e "${yellow}Input must be digit Please validate input${clear}"
        exit
    fi

}

string_validate() {

    if [[ -z $acc_name ]]; then
        echo -e "${yellow}Input cannot be blank${clear}"
    elif ! [[ $acc_name =~ ^[A-Za-z]+$ ]] || [[ $acc_name =~ ^[0-9]+$ ]]; then
        echo -e "${yellow}Input must be character please validate input${clear}"
        exit
    fi
}

num_days() {
    local input_user
    read -p "${green}Input user ssh: ${clear}"
    input_user
    local input_pass
    read -p "${green}Input ssh user password: ${clear}"
    input_pass
    local file
    read -e -p "${green}Input Server List File eg /abc/abc/acb.txt: ${clear}" file
    file_validate
    local n_days
    read -p "${green}input number of days: ${clear}" n_days
    number_validate
    local acc_name
    read -p "${green}Input Account Name: ${clear}" acc_name
    string_validate

    local days=days
    local account_ex=$(chage -l $acc_name | grep 'Password expires' | cut -d : -f2)

    for serv_list in $(cat $file)
    do
    echo "======================================"
    echo "Executing command on $serv_list"
        for each_cmd in "sudo -S chage -E $(date -d +$n_days$days +%Y-%m-%d) $acc_name" "chage -l $acc_name | grep 'Password expires' | cut -d : -f2"
        do
        echo "====================================================="
        sshpass -p $input_pass ssh -o StrictHostKeyChecking=No -tt "$input_user"@$serv_list "$each_cmd" <<< $(cat pass.txt)
    done
done 2>&1 >>$output

}


date_formate() {
    local input_user
    read -p "${green}Input user ssh${clear}"
    input_user
    local input_pass
    read -p "${green}Input ssh user password${clear}"
    input_pass
    local file
    read -e -p "${green}Input Server List File eg /abc/abc/acb.txt: ${clear}" file
    file_validate
    local d_formate
    read -p "${green}Input Formate Date eg YYYY-MM-DD: ${clear}" d_formate
    date -d $d_formate 2>&1 >/dev/null
        if [[ $? -ne 0 ]]; then
            echo "${yellow}Date formate is not valid${clear}"
            exit
        fi
        
    local acc_name
    read -p "${green}Input Account Name: ${clear}" acc_name
    string_validate
        
    local account_ex=$(chage -l $acc_name | grep 'Password expires' | cut -d : -f2)

    for serv_list in $(cat $file)
    do
    echo "======================================"
    echo "Executing command on $serv_list"
        for each_cmd in "sudo -S chage -d $d_formate $acc_name" "chage -l $acc_name | grep 'Password expires' | cut -d : -f2"
        do
        echo "====================================================="
        sshpass -p $input_pass ssh -o StrictHostKeyChecking=No -tt "$input_user"@$serv_list "$each_cmd" <<< $(cat pass.txt)
        done
    done 2>&1 >>$output
}

main_menu() {
    DELAY=.5
while true; do
    clear
	cat << EOF
        ${yellow}Please Select Your Action:${clear}
        1. ${green}Extend Account by number of days${clear}
        2. ${cyan}Extend Account by date formate${clear}
        0. ${yellow}Quit${clear}
EOF
    read -p "${yellow}Enter selection [0-3] > ${clear}"
    case "$REPLY" in
        0)
            break
            ;;
        1)
            num_days
            exit
            ;;
        2)
            date_formate
            exit
            ;;
        *)
            echo "${yellow}Invalid Selection retry.${clear}"
            ;;
    esac
    sleep "$DELAY"
done
echo "${yellow}Program terminated.....!${clear}"

}

local_chk
main_menu