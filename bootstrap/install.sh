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

# install home assistant prereqs
sudo apt-get install -y python3 python3-dev python3-venv python3-pip bluez libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata

# for gps time sync and local wifi and gpsd service
sudo apt-get install -y chrony hostapd dnsmasq gpsd

# parse and write config files
# set static-ip for wlan1 in dhcpcd
cp ./templates/dhcpcd.conf /etc/

# set dhcp lease range for wlan1 and disable gateway
sudo cp ./templates/dnsmasq.conf /etc/

# create accesspoint on wlan1
sudo envsubst < ./templates/hostapd.conf > /etc/hostapd/hostapd.conf

# bind 'uplink' to wlan0 interface
sudo cp ./templates/wlan0 /etc/network/interfaces.d/wlan0
sudo /etc/wpa_supplicant/wpa_supplicant.conf /etc/wpa_supplicant/wpa_supplicant-wlan0.conf

# chrony
sudo cp ./templates/chrony.conf /etc/chrony/

# gpsd
sudo cp ./templates/gpsd /etc/default/

# install homeassistant in venv
# https://www.home-assistant.io/installation/raspberrypi#install-home-assistant-core
sudo mkdir /srv/homeassistant
sudo chown pi:pi /srv/homeassistant
python3 -m venv /srv/homeassistant
/srv/homeassistant/bin/python3 -m pip install wheel
/srv/homeassistant/bin/pip3 install homeassistant

# install esphome in venv
sudo mkdir /srv/esphome
sudo chown pi:pi /srv/esphome
python3 -m venv /srv/esphome
/srv/esphome/bin/pip3 install esphome

# Create services
# https://community.home-assistant.io/t/autostart-using-systemd/199497
sudo cp ./templates/*.service /etc/systemd/system/
sudo systemctl --system daemon-reload

# enable services
sudo systemctl enable home-assistant@pi
sudo systemctl enable esphome@pi
sudo systemctl unmask hostapd
sudo systemctl enable hostapd

# TODO chrony gpsd? waitsync
# reboot