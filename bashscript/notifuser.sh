#!/bin/bash
############################################################################
#Author: Hafid                                                             #
#Purpose: This script for checking user account expires then sending email #
#you can edit and modify as you like, dont forget credit                   #
#contact: hafid.dave@gmail.com                                             #
#please consider to change variable acc to username want to check          #
############################################################################

log="action.log"
acc="testing"
to="hafid.hafid@korelasipersada.com"
Subject="Password expires"
datenow=$(date +%s)
hostname=$(hostname -s)
ipadd=$(ip -o addr show | awk '/inet/ {print $2, $3, $4}' | cut -d ' ' -sf 1,3 | grep -v "lo" | grep -E "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
os_type=$(cat /etc/*release | grep -E '^NAME' | cut -d= -f2 | tr -d '"')
os_version=$(cat /etc/*release | grep -E VERSION_ID | cut -d= -f2 | tr -d '"')
account=$(chage -l $acc | grep 'Password expires' | cut -d : -f2)
if [[ $(id -u) -ne 0 ]]; then
        echo "please run as root user"
    exit
fi

    if [[ $account != never ]]; then
        accexp=$(date -d "$account" "+%s")
        (( exp=$accexp - $datenow ))
        (( expdays=$exp / 86400 ))

            if [[ $expdays -le 7 ]]; then
                cat << EOF | mailx -a "Content-type: text/html" -r cnbx -s "$Subject $(date)" $to
<html>
<head>
</head>
<body>
<table border="2">
        <tr>
            <th colspan="2" bgcolor="#00ff80">Server Status</th>
        </tr>
        <tr>
            <td bgcolor="#00ff80"> <b> Hostname <b/></td>
			<td> $hostname </td>
        </tr>
        <tr>
            <td bgcolor="#00ff80"> <b> OS_type <b/></td>
			<td> $os_type </td>
        </tr>
        <tr>
            <td bgcolor="#00ff80"> <b> OS_Version <b/></td>
			<td> $os_version </td>
        </tr>
		<tr>
            <td bgcolor="#00ff80"><b> Ip Address <b/></td>
			<td> $ipadd </td>
        </tr>
        <tr>
            <td bgcolor="#00ff80"><b> User <b/></td>
			<td> $(whoami) </td>
        </tr>
		<tr>
            <td bgcolor="#00ff80"><b> Uptime <b/></td>
			<td> $(uptime) </td>
        </tr>
        <tr>
            <td bgcolor="#00ff80"><b> Account name <b/></td>
			<td> $acc </td>
        </tr>
		<tr>
            <td bgcolor="#00ff80"><b> Account expires <b/></td>
			<td> $account </td>
        </tr>
        <tr>
            <td bgcolor="#00ff80"><b> days left <b/></td>
			<td> $expdays days </td>
        </tr>
		<tr>
            <td bgcolor="#00ff80"><b> Script Send <b/></td>
			<td> $(date) </td>
        </tr>
    </table>
</body>
</html>
EOF
                else
                exit
            fi
    fi