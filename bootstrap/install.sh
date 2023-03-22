#!/bin/bash
# Script to setup digital herbert raspberry pi os

# load env

set -e
set -u

if [ -f .env ]; then
    export $(cat .env | xargs)
else
    echo ".env file not found"
fi

# install docker
curl -sSL https://get.docker.com | sh

# for gps time sync and local wifi and gpsd service
sudo apt-get install -y chrony hostapd dnsmasq gpsd

# graphical interface for driving the touch screen 
sudo apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox

# browser for showing gui
sudo apt-get install -y --no-install-recommends chromium-browser

# parse and write config files
# set static-ip for wlan1 in dhcpcd
cp ./templates/dhcpcd.conf /etc/

# set dhcp lease range for wlan1 and disable gateway
sudo cp ./templates/dnsmasq.conf /etc/

# create accesspoint on wlan1
envsubst < ./templates/hostapd.conf > hostapd.tmp
sudo mv hostapd.tmp /etc/hostapd/hostapd.conf

# bind 'uplink' to wlan0 interface
sudo cp ./templates/wlan0 /etc/network/interfaces.d/wlan0
sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

# chrony
sudo cp ./templates/chrony.conf /etc/chrony/

# gpsd
sudo cp ./templates/gpsd /etc/default/

# autostart config for gui, loading the chromium browser in kiosk mode
sudo cp ./templates/autostart /etc/xdg/openbox/autostart

# enable auto start profile
cp ./templates/bash_profile /home/$USER/.bash_profile

# start docker compose file
cd ~/.homeassistant && docker compose up -d

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl enable systemd-time-wait-sync
sudo systemctl disable userconfig


echo "System installed succesfully! Press any key to reboot..."
read
sudo reboot
