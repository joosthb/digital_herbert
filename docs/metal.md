# Raspberry pi bootstrapping

TODO; ansible this.

- Flash SD card with [Raspberry Pi OS Lite 64 bit](https://www.raspberrypi.org/downloads/raspberry-pi-os/) to SD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and use the preferences button to set; enable ssh, uplink wifi network, hostname, authentication and locales.

## Install packages

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

```
# set up git access (eg deployment keys)
git config --global user.email "you@example.com"
git config --global user.name "Your Name"

git clone git@github.com:joosthb/digital_herbert.git

```

Fill secrets.yaml

[systemd config](https://community.home-assistant.io/t/autostart-using-systemd/199497)

secrets in password vault.


# /etc/default/gpsd
Change config to get GPS working
```
# Devices gpsd should collect to at boot time.
# They need to be read/writeable, either by user gpsd or the group dialout.
DEVICES="/dev/gps0"

# Other options you want to pass to gpsd
GPSD_OPTIONS="-n"

# Automatically hot add/remove USB GPS devices via gpsdctl
# USBAUTO="true"
USBAUTO="false"
```


# /etc/chrony/chrony.conf
```
# Welcome to the chrony configuration file. See chrony.conf(5) for more
# information about usuable directives.
pool 2.debian.pool.ntp.org iburst offline

# This directive specify the location of the file containing ID/key pairs for
# NTP authentication.
keyfile /etc/chrony/chrony.keys

# This directive specify the file into which chronyd will store the rate
# information.
driftfile /var/lib/chrony/chrony.drift

# Log files location.
logdir /var/log/chrony

# Uncomment the following line to turn logging on.
#log tracking measurements statistics

# Stop bad estimates upsetting machine clock.
# maxupdateskew 100.0

## This directive enables kernel synchronisation (every 11 minutes) of the
## real-time clock. Note that it can’t be used along with the 'rtcfile' directive.
rtcsync

## Step the system clock instead of slewing it if the adjustment is larger than
## one second, but only in the first three clock updates.
makestep 1 3


## GPS source
#refclock SHM 0  delay 0.5 refid NEMA
#
##pps is included in this
#refclock SOCK /var/run/chrony.ttyS1.sock delay 0.0 refid SOCK

allow

# set larger delay to allow the NMEA source to overlap with
# the other sources and avoid the falseticker status
refclock SHM 0 refid GPS precision 1e-1 offset 0.9999 delay 0.2
refclock SHM 1 refid PPS precision 1e-7

```
