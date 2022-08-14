#!/bin/bash

export PACKER_LOG=1
export PACKER_LOG_PATH=./packer_log.txt
export WINRMCP_DEBUG=1

export VAULT_ADDR="https://vault1.yib.me"
source ./creds.sh

if [ $# -ne 1 ]
then
  echo "Usage $0 <folder>"
else
  cp ./common_vars.pkr.hcl ${1}/variables.pkr.hcl
  ./bin/packer build -force $1
fi
