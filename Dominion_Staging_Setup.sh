#!/bin/bash

# run a list of commands to set up staging environment

DOMINION_HOST=wsg0dsdasdasdasd.com

sudo apt-get update
sudo apt-get -y upgrade
sudo apt-get -y dist-upgrade

sudo hostname "${DOMINION_HOST}"
echo "${DOMINION_HOST}" | sudo tee /etc/hostname
echo -e "127.0.0.2 $(hostname) $(hostname -s)" | sudo tee -a /etc/hosts

curl -L https://www.opscode.com/chef/install.sh | sudo bash

sudo -s <<EOF
mkdir /etc/chef


echo 'log_level          :info
log_location       STDOUT
ssl_verify_mode    :verify_none
chef_server_url "https://54.200.14.233"
file_cache_path    "/var/cache/chef"
file_backup_path   "/var/lib/chef/backup"
pid_file           "/var/run/chef/client.pid"
cache_options({ :path => "/var/cache/chef/checksums", :skip_expires => true})
signing_ca_user "chef"
Mixlib::Log::Formatter.show_time = true' > /etc/chef/client.rb


echo '-----BEGIN RSA PRIVATE KEY-----
MIIEpQIBAAKCAQEAuG2cvQZaRGrth3XnWDJtO8X1AYujqKG9s5uPUMvoNCTAFo3S
ioeFNTeij7L+bXExGbjKcyfrG2p6hIlMvnRMHpO+GZ/Z26JW0RopP2jiGq4x9uSc
Sc1AzcdFZur92yZKwYkVbAy1Ed0zD4YKJCrt/y4cyYXdd1WaJPgSfrq/Zp+7klSv
759G/hUbIbyV3uxjABXsEtmg4t6I1AV5xTVjG1WRVzspBjUfXw54xGPxdctciTUZ
xx/Vme+h9vV0fBvx8XsotA4EzeS28y667KxVw4NM0IA/3QRw2xhMMSo=
-----END RSA PRIVATE KEY-----' > /etc/chef/validation.pem

chmod 600 /etc/chef/validation.pem

reboot

EOF
