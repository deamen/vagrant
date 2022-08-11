#!/bin/bash

###
# Setup correct NetworkManager connection
#   Use this for the Host-Only or Bridge interface
###
if [ "$(nmcli --get-values GENERAL.CONNECTION dev show $1)" != "$1" ]
then
  nmcli con del "$(nmcli --get-values GENERAL.CONNECTION dev show $1)"
  nmcli con add connection.id $1 connection.interface-name $1 type ethernet ipv4.method manual ipv4.addresses ${2}/24
  nmcli con up $1
fi