#!/bin/bash

###
# Setup correct NetworkManager connection
#   Use this for the Host-Only or Bridge interface
###
dev_conn=$(nmcli --get-values GENERAL.CONNECTION dev show $1)
if [ "${dev_conn}" != "$1" ]
then
  # Do not delete conn if it does not exists
  if [ -n "$dev_conn" ]
  then
    nmcli con del $dev_conn
  fi
  nmcli con add connection.id $1 \
                connection.interface-name $1 \
                type ethernet \
                ipv4.method manual \
                ipv4.addresses ${2}/24
  nmcli con up $1
fi
