# Raspberry pi bootstrapping
## Flash SD card
with [Raspberry Pi OS Lite 64 bit](https://www.raspberrypi.org/downloads/raspberry-pi-os/) to SD card using [Raspberry Pi Imager](https://www.raspberrypi.com/software/) and use the preferences button to set; enable ssh, uplink wifi network, hostname, authentication and locales/TZ.

## Git setup
- Boot device
- Login (SSH)

## Deploy
- populate secrets.yaml and .env, see example.
```
scp .env herbert:/home/$USER/.homeassistant/bootstrap/
scp ../secrets.yaml herbert:/home/$USER/.homeassistant/
 ```
- store above files in your personal password manager
- Execute bootstrap script


## GPS time sync trouble
Since raspi doesn't have a RTC it depends on GPS for timesync. Home-assistant depends on a synced datetime so:

```
# To enable wait for timesync;
sudo systemctl enable systemd-time-wait-sync

# manual timesync
sudo chronyc waitsync

# Confirm syncing
sudo timedatectl status
```
