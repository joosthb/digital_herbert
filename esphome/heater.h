#include "esphome.h"

class HeaterComponent : public Component, public UARTDevice {
  public:
    HeaterComponent(UARTComponent *parent) : UARTDevice(parent) {}
    //TODO refactor to polling component
  
    void setup() override {
      // nothing to do here
    }
  
    void loop() override {
      // Use Arduino API to read data, for example
      // String line = readString();
      // int i = parseInt();
      char df[22];
  
      while (available()) {
        // char c = read();
        // Find startbytes, 0x76 followed by 0x16
        if (read() != 0x76) {
          continue;
        }else{
          if (read() != 0x16) {
            continue;
          }else{
            // dataframe length is 24, 2 startbytes are skipped
            // so read 22 bytes.
            for (int i = 0; i < 22; i++) {
              df[i] = read();
            }	
            //TODO implement protocol
            // byte 18 (byte 16 in frame) should distinct controller fram from heater frame.
            if (df[16] == 0x00) {
              ESP_LOGD("Heater", "received df from heater.");
            }else{
              ESP_LOGD("Heater", "received df from controller.");
            }
            // dump dataframe
            // ESP_LOG_BUFFER_HEXDUMP("Heater", df, len(df), level)
            ESP_LOG_BUFFER_HEX_LEVEL("Heater", df, sizeof(df), ESP_LOG_INFO);
  
            for (int j = 0 ; j < 22; j++ )
            {
              ESP_LOGD("%02x", df);
              //ESP_LOGD("%d: %02x", j, df[j]);
            }
          }
        }
      }
    }
};
