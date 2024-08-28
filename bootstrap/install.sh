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
# set static-ip for wlan0 in dhcpcd
sudo cp ./templates/dhcpcd.conf /etc/

# set dhcp lease range for wlan0 and disable gateway
sudo cp ./templates/dnsmasq.conf /etc/

# create accesspoint on wlan0
envsubst < ./templates/hostapd.conf > hostapd.tmp
sudo mv hostapd.tmp /etc/hostapd/hostapd.conf

# bind 'uplink' to wlan1 interface
sudo cp ./templates/wlan1 /etc/network/interfaces.d/wlan1
sudo mv /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan1.conf

# chrony
sudo cp ./templates/chrony.conf /etc/chrony/

# gpsd
sudo cp ./templates/gpsd /etc/default/

# X11 config output driver
sudo cp ./templates/99-vc4.conf /etc/X11/xorg.conf.d/

# autostart config for gui, loading the chromium browser in kiosk mode
sudo cp ./templates/autostart /etc/xdg/openbox/autostart

# enable auto start profile
cp ./templates/bash_profile /home/$USER/.bash_profile

# add self to docker group
sudo usermod -a -G docker $USER

# create named pipe to relay container commands to host
mkfifo ~/containerpipe

# add namedpipe eval script to boot via cron
(crontab -l 2>/dev/null; echo "@reboot $HOME/.homeassistant/bootstrap/templates/named_pipe.sh") | crontab -

# enable services
sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl enable systemd-time-wait-sync
sudo systemctl disable userconfig

# file needs to exist for x to start
touch ~/.Xauthority

# dir has to exist on boot, populate it with screensaver images.
mkdir ~/.homeassistant/media

echo "System installed succesfully!"
echo "Run \"cd ~/.homeassistant && docker compose up -d\" after reboot."
echo "Press any key to reboot..."
read
sudo reboot

# to perform after reboot
# start esphome and docker
cd ~/.homeassistant && docker compose up -d