#!/bin/bash
############################################################################
#Author: Hafid                                                             #
#contact: hafid.dave@gmail.com                                             #
############################################################################

#color
red=$'\033[0;31m'
green=$'\033[0;32m'
yellow=$'\033[0;33m'
blue=$'\033[0;34m'
magenta=$'\033[0;35m'
cyan=$'\033[0;36m'
clear=$'\033[0m'

chk_root() {
    if [[ $(id -u) -ne 0]]; then
        echo -e "${yellow}Please Running as SuperUser PRivilage${clear}"
        echo -e "${yellow}Terminated....!!${clear}"
        exit
}

debain_base() {
    which postfix
    if [[ $? -eq 0 ]]; then
        apt-get remove --purge -y postfix
    else
        apt-get -y install sendmail sendmail-bin libsasl2-modules
    

}