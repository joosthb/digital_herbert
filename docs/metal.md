Raspberry pi bootstrapping

TODO; ansible this.

- Flash [Raspberry Pi OS Lite 64 bit](https://www.raspberrypi.org/downloads/raspberry-pi-os/) to SD card
- Enable ssh (touch boot/ssh on sd card)


install packages
```
# home assistant packages
sudo apt-get install -y python3 python3-dev python3-venv python3-pip libffi-dev libssl-dev libjpeg-dev zlib1g-dev autoconf build-essential libopenjp2-7 libtiff5 libturbojpeg0-dev tzdata

# for gps time sync and local wifi and gpsd service

sudo apt-get install -y chrony hostapd dnsmasq gpsd git

sudo systemctl unmask hostapd
sudo systemctl enable hostapd
sudo systemctl start hostapd



```
config files

/etc/network/interfaces.d/wlan0
wireless networks;
/etc/wpa_supplicant/wpa_supplicant-wlan0.conf

/etc/dhcpcd.conf - static ip for internal herbert net
/etc/dnsmasq.conf  - dhcp for wlan1


 [install hass](https://www.home-assistant.io/installation/raspberrypi#install-home-assistant-core)

 install esphome, same way ^^ but in seperate venv.



clone this repo to /etc/homeassistant/.homeassistant

fix secrets.yaml

[systemd config](https://community.home-assistant.io/t/autostart-using-systemd/199497)

secrets in password vault.
