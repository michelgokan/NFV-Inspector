#!/bin/bash

add-apt-repository cloud-archive:pike
apt update
apt-get install -y gawk python-openstackclient

echo "Checking if sshpass command installed"

if [ $(dpkg-query -W -f='${Status}' sshpass 2>/dev/null | grep -c "ok installed") -eq 0 ];
then
    echo "Nope, installing sshpass!"
    apt-get install -y sshpass;
else
    echo "sshpass installed!"
fi
