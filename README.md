# Digital Herbert - Buscamper automation project
In 2019 we bought a van to convert into a buscamper and called him Herbert de Campert 🚐, you can follow the physical build process on [Instagram](https://www.instagram.com/herbertdecampert/). This project describes the work in progress on the automation of our camper.

## Hardware
- Raspberry Pi 3B
- NodeMCU v3
- 100A Shunt
- INA3221
- DHT22
- WS2812 LED strip
- LED Ceiling lights
- 5V 5A Buck converter

### Accu monitor
NodeMCU v3
INA3221 (SDA GPIO4/D2, SCL GPIO5/D1)
DHT22 (Pin 8)


## Software
- [Home Assistant](https://www.home-assistant.io/)
  - [Custom WiFi access point addon](https://github.com/joosthb/hassio-addons)
- [ESPHome](https://esphome.io/)

## Bill of materials
- ["Chinese diesel heater"](https://nl.aliexpress.com/item/32836642933.html)
- [INA3221 I2C Shunt monitor module](https://nl.aliexpress.com/item/32828796768.html)
- [100A Shunt](https://nl.aliexpress.com/item/32879352313.html)
