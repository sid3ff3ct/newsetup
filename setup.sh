#!/bin/bash

# 1. Check if the script is being run with root privileges.
# The script needs to modify system files, which requires root access.
if [[ "$(id -u)" -ne 0 ]]; then
   echo "This script must be run as root. Please use 'sudo'." >&2
   exit 1
fi

# update repos
apt update
apt upgrade -y
apt install git -y
apt install openssh-server -y
apt install curl -y

# enable and start openssh-server
systemctl enable ssh
systemctl start ssh

# pull script and execute
git clone https://github.com/sid3ff3ct/useradd.git
cd useradd
chmod +x adduser.sh
./adduser.sh

# add ssh info
mkdir -p /home/daniel/.ssh
chown daniel:daniel /home/daniel/.ssh
chmod 700 /home/daniel/.ssh

echo "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL3PDiq+HkCOQMqTxNZds0PO+qVLuCq3nuDEyjMQe7b/" > /home/daniel/.ssh/authorized_keys
chown daniel:daniel /home/daniel/.ssh/authorized_keys
chmod 600 /home/daniel/.ssh/authorized_keys

rm -r useradd/

curl -d "Finished Setup Script" https://notify.thebrowns.dev/work

echo "finished running script"
