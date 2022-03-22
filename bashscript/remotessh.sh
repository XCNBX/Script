#!/bin/bash
############################################################################
#Author: Hafid                                                             #
#contact: hafid.dave@gmail.com                                             #
############################################################################

red=$'\033[0;31m'
green=$'\033[0;32m'
yellow=$'\033[0;33m'
blue=$'\033[0;34m'
magenta=$'\033[0;35m'
cyan=$'\033[0;36m'
clear=$'\033[0m'

output="server_target.$(date +'%Y-%m-%d').info.txt"

banner(){
echo
echo "
 __    __  _______  ______ 
|  \  /  \|       \|      \
| $$ /  $$| $$$$$$$\\$$$$$$
| $$/  $$ | $$__/ $$ | $$  
| $$  $$  | $$    $$ | $$  
| $$$$$\  | $$$$$$$  | $$  
| $$ \$$\ | $$      _| $$_ 
| $$  \$$\| $$     |   $$ \
 \$$   \$$ \$$      \$$$$$$

Develop By Hafid"
}

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

date_validate(){
    date "+%Y-%m-%d" -d $d_format
    if [[ $? -ne 0 ]]; then
        echo -e "${yellow}Please Input valid date format retry${clear}"
        exit
    fi
}

user_validate() {
    if [[ -z $input_user ]]; then
        echo -e "{$yellow}input cannot be blank retry${clear}"
        exit
    fi
}

pass_validate() {
    if [[ -z $input_pass ]]; then
        echo -e "{$yellow}input cannot be blank retry${clear}"
        exit
        
    fi
}

file_validate() {

    if [[ -z $file ]]; then
        echo -e "${yellow}Input cannot be blank retry${clear}"
    elif ! [[ -f $file ]]; then
        echo -e "${yellow}File does not exist validate file retry${clear}"
        exit
    fi

}

number_validate() {

    if [[ -z $n_days ]]; then
        echo -e "${yellow}Input cannot be blank retry${clear}"
    elif ! [[ $n_days =~ ^[0-9]+$ ]] || [[ $n_days =~ ^[A-Za-z]+$ ]]; then
        echo -e "${yellow}Input must be digit Please validate input retry${clear}"
        exit
    fi

}

string_validate() {

    if [[ -z $acc_name ]]; then
        echo -e "${yellow}Input cannot be blank retry${clear}"
    elif ! [[ $acc_name =~ ^[A-Za-z]+$ ]] || [[ $acc_name =~ ^[0-9]+$ ]]; then
        echo -e "${yellow}Input must be character please validate input retry${clear}"
        exit
    fi
}

pass_ex() {
    local input_user
    read -p "${green}Input user ssh: ${clear}" input_user
    user_validate
    local input_pass
    read -e -s -p "${green}Input ssh user password: ${clear}" input_pass
    pass_validate
    local file
    read -e -p "${green}Input Server List File eg /abc/abc/acb.txt: ${clear}" file
    file_validate
    local n_days
    read -p "${green}input number of days: ${clear}" n_days
    number_validate
    local acc_name
    read -p "${green}Input Account Name: ${clear}" acc_name
    string_validate

    local account_ex=$(chage -l $acc_name | grep 'Password expires' | cut -d : -f2)

    for serv_list in $(cat $file)
    do
    echo "======================================"
    echo "Executing command on $serv_list"
        for each_cmd in "sudo -S chage -M $n_days $acc_name" "chage -l $acc_name | grep 'Password expires' | cut -d : -f2"
        do
        echo "====================================================="
        sshpass -p $input_pass ssh -o StrictHostKeyChecking=No -q -tt "$input_user"@$serv_list "$each_cmd" <<< $(cat pass.txt)
    done
done 2>&1 >>$output

}

acc_ex() {
    local input_user
    read -p "${green}Input user ssh: ${clear}" input_user
    user_validate
    local input_pass
    read -e -s -p "${green}Input ssh user password: ${clear}" input_pass
    pass_validate
    local file
    read -e -p "${green}Input Server List File eg /abc/abc/acb.txt: ${clear}" file
    file_validate
    local d_format
    read -p "${green}input date format (YYY-MM-DD): ${clear}" d_format
    date_validate
    local acc_name
    read -p "${green}Input Account Name: ${clear}" acc_name
    string_validate

    local account_ex=$(chage -l $acc_name | grep 'Password expires' | cut -d : -f2)

    for serv_list in $(cat $file)
    do
    echo "======================================"
    echo "Executing command on $serv_list"
        for each_cmd in "sudo -S chage -E $d_format $acc_name" "chage -l $acc_name | grep 'Account expires' | cut -d : -f2"
        do
        echo "====================================================="
        sshpass -p $input_pass ssh -o StrictHostKeyChecking=No -q -tt "$input_user"@$serv_list "$each_cmd" <<< $(cat pass.txt)
    done
done 2>&1 >>$output

}

pass_date() {
    local input_user
    read -p "${green}Input user ssh: ${clear}" input_user
    user_validate
    local input_pass
    read -e -s -p "${green}Input ssh user password: ${clear}" input_pass
    pass_validate
    local file
    read -e -p "${green}Input Server List File eg /abc/abc/acb.txt: ${clear}" file
    file_validate
    local d_format
    read -p "${green}input date format (YYYY-MM-DD): ${clear}" d_format
    date_validate
    local acc_name
    read -p "${green}Input Account Name: ${clear}" acc_name
    string_validate

    local account_ex=$(chage -l $acc_name | grep 'Password expires' | cut -d : -f2)

    for serv_list in $(cat $file)
    do
    echo "======================================"
    echo "Executing command on $serv_list"
        for each_cmd in "sudo -S chage -d $d_format $acc_name" "chage -l $acc_name | grep 'Last password chage' | cut -d : -f2"
        do
        echo "====================================================="
        sshpass -p $input_pass ssh -o StrictHostKeyChecking=No -q -tt "$input_user"@$serv_list "$each_cmd" <<< $(cat pass.txt)
    done
done 2>&1 >>$output

}

main_menu() {
    DELAY=.5
while true; do
    clear
    banner
	cat << EOF
        ${yellow}Please Select Your Action:${clear}
        1. Extend Password expires
        2. Extend Account expires
        3. change "Last password change" date
        0. ${yellow}Quit${clear}
EOF
    read -p "${yellow}Enter selection [0-3] > ${clear}"
    case "$REPLY" in
        0)
            break
            ;;
        1)
            pass_ex
            exit
            ;;
        2)
            acc_ex
            exit
            ;;
        3)
            pass_date
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