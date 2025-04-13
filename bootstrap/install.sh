#!/bin/bash
# Script to setup digital herbert raspberry pi os

# load env
source .env

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
sudo apt-get install -y chrony gpsd

# graphical interface for driving the touch screen 
sudo apt-get install -y --no-install-recommends xserver-xorg x11-xserver-utils xinit openbox

# browser for showing gui
sudo apt-get install -y --no-install-recommends chromium-browser

# Create local network
sudo nmcli connection add type wifi ifname wlan0 con-name $AP_SSID autoconnect no ssid $AP_SSID
sudo nmcli connection modify $AP_SSID 802-11-wireless.mode ap 802-11-wireless.band bg ipv4.method shared
sudo nmcli connection modify $AP_SSID wifi-sec.key-mgmt wpa-psk
sudo nmcli connection modify $AP_SSID wifi-sec.psk "$AP_WPA_PASSPHRASE"

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
# add backup script hourly
(crontab -l 2>/dev/null; echo "@hourly $HOME/.homeassistant/backup.sh") | crontab -

# enable services
sudo systemctl enable systemd-time-wait-sync
sudo systemctl disable userconfig

# file needs to exist for x to start
touch ~/.Xauthority

echo "System installed succesfully!"
echo "Use sudo raspi-config tool to config autologin: select \“Console Autologin\”."
echo "Run \"cd ~/.homeassistant && docker compose up -d\" after reboot."
echo "After restore, reboot"
